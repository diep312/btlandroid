import 'package:chit_chat/src/domain/entities/post.dart';

abstract class PostRepository {
  void killInstance();

  Future<void> addPost(Post post);
}
