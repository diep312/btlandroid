import 'package:chit_chat/src/domain/entities/user_profile.dart';
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
      initUserProfiles();
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> updatePhoneNumber(
      {required String uid, required String phoneNumber}) async {
    try {
      await _firestore.collection('users').doc(uid).set(
        {
          'phone': phoneNumber,
        },
        SetOptions(merge: true),
      );
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> updateUsername(
      {required String uid,
      required String firstName,
      required String lastName}) async {
    try {
      _firestore.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'likedPostIds': [],
      }, SetOptions(merge: true));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<List<User>> getUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection("users").get();

      List<User> users = [];

      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) {
          users.add(User.fromJson(doc.data(), doc.id));
        });
      }

      return users;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> updateEmail({required String uid, required String email}) async {
    try {
      _firestore.collection('users').doc(uid).set({
        'email': email,
      }, SetOptions(merge: true));
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final doc =
          await _firestore.collection('user_profiles').doc(userId).get();
      if (!doc.exists) {
        // Return a default profile if not found
        return UserProfile(userId: userId);
      }
      return UserProfile.fromJson(doc.data()!);
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _firestore.collection('user_profiles').doc(profile.userId).set(
            profile.toJson(),
            SetOptions(merge: true),
          );
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _firestore.collection('user_profiles').doc(userId).delete();
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  Future<void> initUserProfiles() async {
    try {
      // Get all users from the 'users' collection
      final usersSnapshot = await _firestore.collection('users').get();

      for (var doc in usersSnapshot.docs) {
        final userId = doc.id;
        final profileDoc =
            await _firestore.collection('user_profiles').doc(userId).get();

        if (!profileDoc.exists) {
          // Create a default profile for this user
          await _firestore.collection('user_profiles').doc(userId).set(
                UserProfile(userId: userId).toJson(),
                SetOptions(merge: true),
              );
        }
      }
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }
}
