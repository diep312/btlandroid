import 'dart:collection';

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
}
