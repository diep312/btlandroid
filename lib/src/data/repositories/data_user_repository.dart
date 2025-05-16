import 'dart:io';
import 'package:chit_chat/src/domain/entities/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:chit_chat/src/domain/entities/user.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataUserRepository implements UserRepository {
  static DataUserRepository? _instance;
  DataUserRepository._();
  factory DataUserRepository() {
    _instance ??= DataUserRepository._();

    return _instance!;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
      // 1. Query posts for this user
      final postsQuery = await _firestore
          .collection('posts')
          .where('publisherId', isEqualTo: userId)
          .get();
      int totalLikes = 0;
      for (var doc in postsQuery.docs) {
        final data = doc.data();
        if (data.containsKey('numberOfLikes') && data['numberOfLikes'] is int) {
          totalLikes += data['numberOfLikes'] as int;
        }
      }
      // 2. Update likesCount in user_profiles
      await _firestore.collection('user_profiles').doc(userId).set({
        'likesCount': totalLikes,
      }, SetOptions(merge: true));

      // 3. Fetch the user profile as before
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

  @override
  Future<void> updateProfile({
    required String description,
    String? avatarUrl,
  }) async {
    try {
      final userId = auth.FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      print('Updating profile for user: $userId');
      print('Avatar URL received: $avatarUrl');

      String? finalAvatarUrl = avatarUrl;

      // If avatarUrl is a file path (starts with 'file://'), upload it to Firebase Storage
      if (avatarUrl != null && avatarUrl.startsWith('file://')) {
        final filePath = avatarUrl.replaceFirst('file://', '');
        print('Processing local file: $filePath');

        final file = File(filePath);
        if (!await file.exists()) {
          throw Exception('Image file does not exist at path: $filePath');
        }

        finalAvatarUrl = await uploadImage(file);
        print('New avatar URL after upload: $finalAvatarUrl');
      }

      final updates = <String, dynamic>{
        'description': description,
      };

      if (finalAvatarUrl != null) {
        updates['avatarUrl'] = finalAvatarUrl;
      }

      print('Updating Firestore with data: $updates');
      await _firestore.collection('user_profiles').doc(userId).set(
            updates,
            SetOptions(merge: true),
          );
      print('Profile update completed successfully');

      // Update all posts with the new avatar URL if it was changed
      if (finalAvatarUrl != null) {
        final postsQuery = await _firestore
            .collection('posts')
            .where('publisherId', isEqualTo: userId)
            .get();
        for (var doc in postsQuery.docs) {
          await doc.reference.update({'publisherLogoUrl': finalAvatarUrl});
        }
        print('Updated publisherLogoUrl in posts for user: $userId');
      }
    } catch (e, st) {
      print('Error updating profile: $e');
      print('Stack trace: $st');
      rethrow;
    }
  }

  @override
  Future<void> followUser(String userId) async {
    try {
      // Add the user to current user's following list
      await _firestore.collection('user_profiles').doc(currentUser.id).update({
        'following': FieldValue.arrayUnion([userId])
      });

      // Add current user to the target user's followers list
      await _firestore.collection('user_profiles').doc(userId).update({
        'followers': FieldValue.arrayUnion([currentUser.id])
      });
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> unfollowUser(String userId) async {
    try {
      // Remove the user from current user's following list
      await _firestore.collection('user_profiles').doc(currentUser.id).update({
        'following': FieldValue.arrayRemove([userId])
      });

      // Remove current user from the target user's followers list
      await _firestore.collection('user_profiles').doc(userId).update({
        'followers': FieldValue.arrayRemove([currentUser.id])
      });
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      final userId = auth.FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      print('Starting image upload for user: $userId');
      print('Image file path: ${imageFile.path}');
      print('Image file exists: ${await imageFile.exists()}');

      final ref = _storage.ref().child('users/$userId/profile.jpg');
      print('Storage reference path: ${ref.fullPath}');

      final uploadTask = await ref.putFile(imageFile);
      print('Upload task completed: ${uploadTask.state}');

      final downloadUrl = await ref.getDownloadURL();
      print('Download URL obtained: $downloadUrl');

      return downloadUrl;
    } catch (e, st) {
      print('Error uploading image: $e');
      print('Stack trace: $st');
      rethrow;
    }
  }

  @override
  Future<User?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      return User(
        id: doc.id,
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        phoneNumber: data['phone'] as String?,
        email: data['email'] as String?,
        likedPostIds: Set<String>.from(data['likedPostIds'] ?? {}),
        seenStoryItemIds: Set<String>.from(data['seenStoryItemIds'] ?? {}),
        favoritedPostIds: Set<String>.from(data['favoritedPostIds'] ?? {}),
      );
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }
}
