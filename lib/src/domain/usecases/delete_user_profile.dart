import 'dart:async';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class DeleteUserProfile extends UseCase<void, String> {
  final UserRepository _userRepository;
  DeleteUserProfile(this._userRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(String? userId) async {
    final controller = StreamController<void>();
    try {
      if (userId == null) throw ArgumentError('UserId cannot be null');
      await _userRepository.deleteUserProfile(userId);
      controller.close();
    } catch (e, st) {
      controller.addError(e, st);
    }
    return controller.stream;
  }
}
