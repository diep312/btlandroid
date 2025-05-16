import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/navigator/navigator.dart';
import 'package:chit_chat/src/app/pages/profile/profile_presenter.dart';
import 'package:chit_chat/src/domain/entities/user.dart';
import 'package:chit_chat/src/domain/entities/user_profile.dart';
import 'package:chit_chat/src/domain/entities/post.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';
import 'package:chit_chat/src/app/widgets/edit_profile_dialog.dart';
import 'package:chit_chat/src/domain/usecases/get_user_profile.dart';
import 'package:chit_chat/src/domain/usecases/update_user_profile.dart';
import 'package:chit_chat/src/domain/usecases/get_user.dart';
import 'package:chit_chat/src/domain/usecases/get_user_posts.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:chit_chat/src/app/pages/chat/chat_view.dart';

class ProfileController extends Controller {
  final String userId;
  final String currentUserId;
  final UserRepository userRepository;
  final PostRepository postRepository;
  final ProfilePresenter _presenter;
  BuildContext? _bottomSheetContext;

  UserProfile? _userProfile;
  User? _user;
  List<Post>? _userPosts;
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _profileSubscription;
  StreamSubscription? _updateSubscription;

  UserProfile? get userProfile => _userProfile;
  User? get user => _user;
  List<Post>? get userPosts => _userPosts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isCurrentUser => userId == currentUserId;

  ProfileController({
    required this.userId,
    required this.currentUserId,
    required this.userRepository,
    required this.postRepository,
  }) : _presenter = ProfilePresenter(
          GetUserProfile(userRepository),
          UpdateUserProfile(userRepository),
          GetUser(userRepository),
          GetUserPosts(postRepository),
        );

  @override
  void onInitState() {
    super.onInitState();
    _loadUserProfile();
  }

  @override
  void onDisposed() {
    _profileSubscription?.cancel();
    _updateSubscription?.cancel();
    _presenter.dispose();
    super.onDisposed();
  }

  @override
  void initListeners() {
    print('Initializing profile listeners');
    _presenter.getUserProfileOnNext = (UserProfile? profile) {
      print('Received user profile: ${profile?.toJson()}');
      _userProfile = profile;
      _isLoading = false;
      _error = null;
      refreshUI();
    };

    _presenter.getUserProfileOnComplete = () {
      print('Get user profile completed');
      if (_userProfile == null) {
        _isLoading = false;
        refreshUI();
      }
    };

    _presenter.getUserProfileOnError = (error) {
      print('Error getting user profile: $error');
      _error = error.toString();
      _isLoading = false;
      refreshUI();
    };

    _presenter.updateProfileOnNext = () {
      print('Profile update successful');
      if (_bottomSheetContext != null) {
        Navigator.pop(_bottomSheetContext!);
        _bottomSheetContext = null;
      }
      _loadUserProfile();
    };

    _presenter.updateProfileOnError = (error) {
      print('Error updating profile: $error');
      _error = error.toString();
      _isLoading = false;
      refreshUI();
    };

    _presenter.getUserOnNext = (User? user) {
      print('Received user data: ${user?.toJson()}');
      _user = user;
      _isLoading = false;
      if (user != null) {
        _presenter.getUserPosts(user);
      }
      refreshUI();
    };

    _presenter.getUserOnComplete = () {
      print('Get user completed');
      if (_user == null) {
        _isLoading = false;
        refreshUI();
      }
    };

    _presenter.getUserOnError = (error) {
      print('Error getting user: $error');
      _error = error.toString();
      _isLoading = false;
      refreshUI();
    };

    _presenter.getUserPostsOnNext = (List<Post>? posts) {
      print('Received user posts: ${posts?.length}');
      _userPosts = posts;
      _isLoading = false;
      refreshUI();
    };

    _presenter.getUserPostsOnComplete = () {
      print('Get user posts completed');
      if (_userPosts == null) {
        _isLoading = false;
        refreshUI();
      }
    };

    _presenter.getUserPostsOnError = (error) {
      print('Error getting user posts: $error');
      _error = error.toString();
      _isLoading = false;
      refreshUI();
    };
  }

  void _loadUserProfile() {
    print('Loading user profile for user: $userId');
    _isLoading = true;
    _error = null;
    refreshUI();
    _presenter.getUserProfile(userId);
    _presenter.getUser(userId);
  }

  void onEditProfilePressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        _bottomSheetContext = bottomSheetContext;
        return EditProfileDialog(
          initialDescription: _userProfile?.description ?? '',
          initialAvatarUrl: _userProfile?.avatarUrl,
          onSave: (description, avatarUrl) {
            _isLoading = true;
            refreshUI();
            _presenter.updateProfile(description, avatarUrl);
          },
        );
      },
    );
  }

  void onFollowPressed() {
    // TODO: Implement follow functionality
  }

  void onMessagePressed() {
    if (user == null) return;

    KNavigator.navigateToChat(
      context: getContext(),
      user: user!,
    );
  }

  void onLogoutPressed() async {
    await auth.FirebaseAuth.instance.signOut();
    KNavigator.navigateToSplash(getContext());
  }
}
