import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';

class ToggleCommentLike extends UseCase<void, ToggleCommentLikeParams> {
  final PostRepository _postRepository;

  ToggleCommentLike(this._postRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      ToggleCommentLikeParams? params) async {
    if (params == null) throw Exception('Params cannot be null');

    final streamController = StreamController<void>();
    try {
      await _postRepository.toggleCommentLike(
        params.postId,
        params.commentId,
        params.userId,
        params.isLiked,
      );
      streamController.add(null);
      streamController.close();
    } catch (e) {
      streamController.addError(e);
    }
    return streamController.stream;
  }
}

class ToggleCommentLikeParams {
  final String postId;
  final String commentId;
  final String userId;
  final bool isLiked;

  ToggleCommentLikeParams({
    required this.postId,
    required this.commentId,
    required this.userId,
    required this.isLiked,
  });
}
