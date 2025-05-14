import 'dart:async';
import 'package:chit_chat/src/domain/entities/user_profile.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class UpdateUserProfile extends UseCase<void, UserProfile> {
  final UserRepository _userRepository;
  UpdateUserProfile(this._userRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(UserProfile? params) async {
    final controller = StreamController<void>();
    try {
      if (params == null) throw ArgumentError('UserProfile cannot be null');
      await _userRepository.updateUserProfile(params);
      controller.close();
    } catch (e, st) {
      controller.addError(e, st);
    }
    return controller.stream;
  }
}
