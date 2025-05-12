import 'dart:async';

import 'package:chit_chat/src/domain/entities/user_profile.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetUserProfile extends UseCase<UserProfile, String> {
  final UserRepository _userRepository;
  GetUserProfile(this._userRepository);
  @override
  Future<Stream<UserProfile?>> buildUseCaseStream(String? userId) async {
    final controller = StreamController<UserProfile?>();
    try {
      if (userId == null) {
        throw ArgumentError('User ID cannot be null');
      }
      final profile = await _userRepository.getUserProfile(userId);
      controller.add(profile);
      controller.close();
    } catch (e, st) {
      controller.addError(e, st);
    }
    return controller.stream;
  }
}
