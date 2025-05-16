import 'dart:collection';
import 'dart:async';

import 'package:chit_chat/src/domain/entities/comment.dart';
import 'package:chit_chat/src/domain/entities/post.dart';
import 'package:chit_chat/src/domain/entities/user.dart';

abstract class PostRepository {
  void killInstance();

  Future<void> addPost(Post post);
  Future<void> likePost(String postId);
  Future<void> cancelPostLike(
    String postId,
  );
  Future<void> getNextPosts();
  Stream<UnmodifiableListView<Post>?> getPosts(User user);

  Future<void> addComment(Comment comment);
  Stream<UnmodifiableListView<Comment>?> getComments(String targetId);
  Future<void> removeComment(String postId, String commentId);
  Future<bool> getNextComments(String targetId);
  Future<void> toggleFavoriteState({
    required String uid,
    required String postId,
    required bool favorite,
  });
  Stream<UnmodifiableListView<Post>?> getFavoritedPosts(User user);
  Future<void> deletePost(String postId);
  Future<void> toggleCommentLike(
    String postId,
    String commentId,
    String userId,
    bool isLiked,
  );
  Stream<List<Post>?> getUserPost(String userId);
}
