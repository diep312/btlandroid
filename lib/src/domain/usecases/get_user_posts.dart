import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/post.dart';
import 'package:chit_chat/src/domain/entities/user.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';

class GetUserPosts extends UseCase<List<Post>?, GetUserPostsParams> {
  final PostRepository _postRepository;

  GetUserPosts(this._postRepository);

  @override
  Future<Stream<List<Post>?>> buildUseCaseStream(
      GetUserPostsParams? params) async {
    final streamController = StreamController<List<Post>?>();
    try {
      final posts = await _postRepository.getUserPost(params!.user.id).first;
      streamController.add(posts);
      streamController.close();
    } catch (e) {
      print('Error in GetUserPosts: $e');
      streamController.addError(e);
    }
    return streamController.stream;
  }
}

class GetUserPostsParams {
  final User user;

  GetUserPostsParams(this.user);
}
