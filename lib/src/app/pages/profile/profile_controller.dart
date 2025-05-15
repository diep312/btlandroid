import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/user_profile.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:chit_chat/src/app/pages/profile/profile_presenter.dart';
import 'package:chit_chat/src/domain/entities/user.dart';

class ProfileController extends Controller {
  final String userId;
  final String currentUserId;
  final ProfilePresenter _presenter;

  User? user;
  UserProfile? userProfile;
  bool get isCurrentUser => userId == currentUserId;

  ProfileController({
    required this.userId,
    required this.currentUserId,
    required UserRepository userRepository,
  }) : _presenter = ProfilePresenter(userRepository);

  @override
  void onInitState() {
    _presenter.getCurrentUser();
    _presenter.getUserProfile(userId);
    super.onInitState();
  }

  @override
  void initListeners() {
    _presenter.getCurrentUserOnNext = (User? user) {
      this.user = user;
      refreshUI();
    };
    _presenter.getCurrentUserOnError = (e) {
      // TODO: handle error
    };
    _presenter.getUserProfileOnNext = (UserProfile? profile) {
      userProfile = profile;
      refreshUI();
    };
    _presenter.getUserProfileOnError = (e) {
      // TODO: handle error
    };
  }

  void _fetchUserProfile() {
    _presenter.getUserProfile(userId);
  }

  void onFollowPressed() {
    // TODO: Implement follow logic
  }

  void onMessagePressed() {
    // TODO: Implement message navigation
  }

  void onEditProfilePressed() {
    // TODO: Implement edit profile navigation
  }
}
