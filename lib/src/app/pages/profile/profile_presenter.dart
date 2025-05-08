import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/user_profile.dart';
import 'package:chit_chat/src/domain/entities/user.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:chit_chat/src/domain/usecases/get_user_profile.dart';
import 'package:chit_chat/src/domain/usecases/get_current_user.dart';

class ProfilePresenter extends Presenter {
  late Function getUserProfileOnNext;
  late Function getUserProfileOnError;
  late Function getCurrentUserOnNext;
  late Function getCurrentUserOnError;

  final GetUserProfile _getUserProfile;
  final GetCurrentUser _getCurrentUser;

  ProfilePresenter(UserRepository userRepository)
      : _getUserProfile = GetUserProfile(userRepository),
        _getCurrentUser = GetCurrentUser(userRepository);

  void getUserProfile(String userId) {
    _getUserProfile.execute(_GetUserProfileObserver(this), userId);
  }

  void getCurrentUser() {
    _getCurrentUser.execute(_GetCurrentUserObserver(this));
  }

  @override
  void dispose() {
    _getUserProfile.dispose();
    _getCurrentUser.dispose();
  }
}

class _GetUserProfileObserver extends Observer<UserProfile> {
  final ProfilePresenter _presenter;

  _GetUserProfileObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.getUserProfileOnError(e);
  }

  @override
  void onNext(UserProfile? profile) {
    _presenter.getUserProfileOnNext(profile);
  }
}

class _GetCurrentUserObserver extends Observer<User> {
  final ProfilePresenter _presenter;

  _GetCurrentUserObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(error) {
    _presenter.getCurrentUserOnError(error);
  }

  @override
  void onNext(User? user) {
    _presenter.getCurrentUserOnNext(user);
  }
}
