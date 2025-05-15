import 'package:chit_chat/src/domain/entities/user.dart';

abstract class UserRepository {
  void killInstance();

  User get currentUser;
  Future<void> initializeRepository();
}
