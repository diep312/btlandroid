import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';

class DeletePostParams {
  final String postId;

  DeletePostParams(this.postId);
}

class DeletePost extends UseCase<void, DeletePostParams> {
  final PostRepository _postRepository;

  DeletePost(this._postRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(DeletePostParams? params) async {
    if (params == null) {
      return Stream.error('Params cannot be null');
    }
    try {
      await _postRepository.deletePost(params.postId);
      return Stream.value(null);
    } catch (error, stackTrace) {
      return Stream.error(error, stackTrace);
    }
  }
}
