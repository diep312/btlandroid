import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:chit_chat/src/domain/entities/user.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';

class DataUserRepository implements UserRepository {
  static DataUserRepository? _instance;
  DataUserRepository._();
  factory DataUserRepository() {
    _instance ??= DataUserRepository._();

    return _instance!;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User _user;

  @override
  void killInstance() {
    _instance = null;
  }

  @override
  User get currentUser {
    try {
      return _user;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> initializeRepository() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('users')
          .doc(auth.FirebaseAuth.instance.currentUser!.uid)
          .get();

      _user = User.fromJson(doc.data()!, doc.id);
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }
}
