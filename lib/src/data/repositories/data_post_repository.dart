import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chit_chat/src/domain/entities/post.dart';
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


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Post>? _posts;

  @override
  void killInstance() {
    _instance = null;
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
