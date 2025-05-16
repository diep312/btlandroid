import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/user.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';

class GetUser extends UseCase<User?, String> {
  final UserRepository _userRepository;

  GetUser(this._userRepository);

  @override
  Future<Stream<User?>> buildUseCaseStream(String? params) async {
    final streamController = StreamController<User?>();
    try {
      final user = await _userRepository.getUserById(params!);
      streamController.add(user);
      streamController.close();
    } catch (e) {
      streamController.addError(e);
    }
    return streamController.stream;
  }
}
