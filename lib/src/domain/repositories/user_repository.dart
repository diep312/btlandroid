import 'package:chit_chat/src/domain/entities/user.dart';
import 'package:chit_chat/src/domain/entities/user_profile.dart';

abstract class UserRepository {
  User get currentUser;
  void killInstance();
  Future<void> initializeRepository();

  Future<void> updatePhoneNumber({
    required String uid,
    required String phoneNumber,
  });

  Future<void> updateEmail({
    required String uid,
    required String email,
  });

  Future<void> updateUsername({
    required String uid,
    required String firstName,
    required String lastName,
  });

  Future<List<User>> getUsers();

  Future<UserProfile?> getUserProfile(String userId);
  Future<void> updateUserProfile(UserProfile userProfile);
  Future<void> deleteUserProfile(String userId);

  Future<void> updateProfile({
    required String description,
    String? avatarUrl,
  });

  Future<void> followUser(String userId);
  Future<void> unfollowUser(String userId);
  Future<void> updateUser(User user);

  Future<User?> getUserById(String userId);
}
