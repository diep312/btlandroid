import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/comment.dart';
import 'package:chit_chat/src/domain/entities/user.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';

class AddComment extends UseCase<void, AddCommentParams> {
  final PostRepository _postRepository;
  final UserRepository _userRepository;

  AddComment(this._postRepository, this._userRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(AddCommentParams? params) async {
    StreamController<void> controller = StreamController();
    try {
      User currentUser = _userRepository.currentUser;

      // Fetch user profile to get avatarUrl
      final userProfile = await _userRepository.getUserProfile(currentUser.id);

      Comment comment = Comment(
        id: '',
        authorId: currentUser.id,
        authorName: currentUser.displayName,
        targetId: params!.comment.targetId,
        text: params.comment.text,
        sharedOn: params.comment.sharedOn,
        authorAvatarUrl: userProfile?.avatarUrl ?? '',
        commentLikesCount: 0,
        likedByUsers: [],
      );

      await _postRepository.addComment(comment);

      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}

class AddCommentParams {
  final Comment comment;

  AddCommentParams(this.comment);
}
