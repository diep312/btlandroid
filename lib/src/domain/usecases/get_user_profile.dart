import 'dart:async';

import 'package:chit_chat/src/domain/entities/user_profile.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetUserProfileParams {
  final String userId;

  GetUserProfileParams({required this.userId});
}

class GetUserProfile extends UseCase<UserProfile?, GetUserProfileParams> {
  final UserRepository _userRepository;

  GetUserProfile(this._userRepository);

  @override
  Future<Stream<UserProfile?>> buildUseCaseStream(
      GetUserProfileParams? params) async {
    final streamController = StreamController<UserProfile?>();
    try {
      final profile = await _userRepository.getUserProfile(params!.userId);
      streamController.add(profile);
      streamController.close();
    } catch (e) {
      streamController.addError(e);
    }
    return streamController.stream;
  }
}
