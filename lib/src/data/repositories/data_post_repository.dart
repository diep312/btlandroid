import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:chit_chat/src/domain/entities/post.dart';
import 'package:chit_chat/src/domain/entities/user.dart';
import 'package:collection/collection.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';

class DataPostRepository implements PostRepository {
  static DataPostRepository? _instance;
  DataPostRepository._();
  factory DataPostRepository() {
    _instance ??= DataPostRepository._();

    return _instance!;
  }

  StreamController<UnmodifiableListView<Post>?> _postsStreamController =
  StreamController.broadcast();

  StreamController<UnmodifiableListView<Post>?>
  _favoritedPostsStreamController = StreamController.broadcast();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  QueryDocumentSnapshot<Map<String, dynamic>>? _lastPostDocument;

  List<Post>? _posts;
  List<Post> _favoritedPosts = [];
  Set<String> likedPostIds = {};
  Set<String> favoritesPostIds = {};

  @override
  void killInstance() {
    _instance = null;
  }

  @override
  Future<void> likePost(String postId) async {
    try {
      if (likedPostIds.contains(postId)) return;

      final doc = await _firestore.collection('posts').doc(postId).get();

      _firestore.collection('posts').doc(postId).update({
        'numberOfLikes': doc.data()!['numberOfLikes'] + 1,
      });

      _firestore
          .collection('users')
          .doc(auth.FirebaseAuth.instance.currentUser!.uid)
          .update({
        'likedPostIds': FieldValue.arrayUnion([postId])
      });

      likedPostIds.add(postId);
      Post? post = _posts!.firstWhereOrNull((post) => post.id == postId);
      if (post != null) {
        post.numberOfLikes++;
        post.isLiked = true;
      }

      Post? favoritePost =
      _favoritedPosts.firstWhereOrNull((post) => post.id == postId);

      if (favoritePost != null) {
        favoritePost.numberOfLikes++;
        favoritePost.isLiked = true;
      }

      _posts!.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));
      _favoritedPosts.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));

      _postsStreamController.add(UnmodifiableListView(_posts!));
      _favoritedPostsStreamController
          .add(UnmodifiableListView(_favoritedPosts));

      final postOwnerId = doc.data()!['authorId'];
      await _firestore
          .collection('user_profiles')
          .doc(postOwnerId)
          .update({'numberOfLikes': FieldValue.increment(1)});
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> cancelPostLike(String postId) async {
    try {
      if (!likedPostIds.contains(postId)) return;

      final doc = await _firestore.collection('posts').doc(postId).get();

      _firestore.collection('posts').doc(postId).update({
        'numberOfLikes': doc.data()!['numberOfLikes'] - 1,
      });

      _firestore
          .collection('users')
          .doc(auth.FirebaseAuth.instance.currentUser!.uid)
          .update({
        'likedPostIds': FieldValue.arrayRemove([postId])
      });

      likedPostIds.remove(postId);
      Post? post = _posts!.firstWhereOrNull((post) => post.id == postId);
      if (post != null) {
        post.numberOfLikes--;
        post.isLiked = false;
      }

      Post? favoritePost =
      _favoritedPosts.firstWhereOrNull((post) => post.id == postId);

      if (favoritePost != null) {
        favoritePost.numberOfLikes--;
        favoritePost.isLiked = false;
      }

      _posts!.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));
      _favoritedPosts.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));

      _postsStreamController.add(UnmodifiableListView(_posts!));
      _favoritedPostsStreamController
          .add(UnmodifiableListView(_favoritedPosts));

      final postOwnerId = doc.data()!['authorId'];
      await _firestore
          .collection('user_profiles')
          .doc(postOwnerId)
          .collection('posts')
          .doc(postId)
          .update({'numberOfLikes': FieldValue.increment(-1)});
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> getNextPosts() async {
    try {
      if (_lastPostDocument == null) {
        _postsStreamController.add(UnmodifiableListView([]));

        return;
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('posts')
          .limit(5)
          .orderBy('publishedOn', descending: true)
          .startAfterDocument(_lastPostDocument!)
          .get();

      _posts ??= [];

      if (querySnapshot.docs.isNotEmpty) {
        _lastPostDocument = querySnapshot.docs.last;

        await Future.forEach(querySnapshot.docs,
                (QueryDocumentSnapshot<Map<String, dynamic>> element) async {
              Post post = Post.fromJson(element.data(), element.id);

              final snapshot = await _firestore
                  .collection('commentCounts')
                  .doc(element.id)
                  .get();

              if (snapshot.data() != null) {
                post.numberOfComments = snapshot.data()!['total'];
              }

              if (likedPostIds.contains(element.id)) {
                post.isLiked = true;
              }

              if (favoritesPostIds.contains(element.id)) {
                post.isFavorited = true;
              }
              _posts!.add(post);
            });
      }

      _posts!.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));
      _postsStreamController.add(UnmodifiableListView(_posts!));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Stream<UnmodifiableListView<Post>?> getPosts(User user) {
    try {
      likedPostIds = user.likedPostIds;
      favoritesPostIds = user.favoritedPostIds;

      _posts = null;
      _lastPostDocument = null;

      _initPosts();

      Future.delayed(Duration.zero).then((_) {
        if (_posts == null) {
          _postsStreamController.add(null);
        } else {
          _posts!.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));

          _postsStreamController.add(UnmodifiableListView(_posts!));
        }
      });

      return _postsStreamController.stream;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  void _initPosts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('posts')
          .orderBy('publishedOn', descending: true)
          .limit(5)
          .get();

      _posts ??= [];

      if (querySnapshot.docs.isNotEmpty) {
        _lastPostDocument = querySnapshot.docs.last;

        await Future.forEach(querySnapshot.docs,
                (QueryDocumentSnapshot<Map<String, dynamic>> element) async {
              Post post = Post.fromJson(element.data(), element.id);

              final snapshot = await _firestore
                  .collection('commentCounts')
                  .doc(element.id)
                  .get();

              if (snapshot.data() != null) {
                post.numberOfComments = snapshot.data()!['total'];
              }

              if (likedPostIds.contains(element.id)) {
                post.isLiked = true;
              }

              if (favoritesPostIds.contains(element.id)) {
                post.isFavorited = true;
              }
              _posts!.add(post);
            });
      }

      _posts!.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));

      _postsStreamController.add(UnmodifiableListView(_posts!));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> addPost(Post post) async {
    try {
      final doc = await _firestore.collection('posts').add(post.toJson());
      if (_posts == null) {
        _posts = [];
      }
      post.id = doc.id;

      _posts!.add(post);
      _posts!.sort((a, b) => b.publishedOn.compareTo(a.publishedOn));

      _postsStreamController.add(UnmodifiableListView(_posts!));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }
}
