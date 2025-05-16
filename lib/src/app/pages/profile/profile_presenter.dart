import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/user.dart';
import 'package:chit_chat/src/domain/entities/user_profile.dart';
import 'package:chit_chat/src/domain/entities/post.dart';
import 'package:chit_chat/src/domain/usecases/get_user_profile.dart';
import 'package:chit_chat/src/domain/usecases/update_user_profile.dart';
import 'package:chit_chat/src/domain/usecases/get_user.dart';
import 'package:chit_chat/src/domain/usecases/get_user_posts.dart';

class ProfilePresenter extends Presenter {
  Function? getUserProfileOnNext;
  Function? getUserProfileOnComplete;
  Function? getUserProfileOnError;
  Function? updateProfileOnNext;
  Function? updateProfileOnComplete;
  Function? updateProfileOnError;
  Function? getUserOnNext;
  Function? getUserOnComplete;
  Function? getUserOnError;
  Function? getUserPostsOnNext;
  Function? getUserPostsOnComplete;
  Function? getUserPostsOnError;

  final GetUserProfile _getUserProfile;
  final UpdateUserProfile _updateUserProfile;
  final GetUser _getUser;
  final GetUserPosts _getUserPosts;

  ProfilePresenter(
    this._getUserProfile,
    this._updateUserProfile,
    this._getUser,
    this._getUserPosts,
  );

  void getUserProfile(String userId) {
    _getUserProfile.execute(
      _GetUserProfileObserver(this),
      GetUserProfileParams(userId: userId),
    );
  }

  void updateProfile(String description, String? avatarUrl) {
    _updateUserProfile.execute(
      _UpdateUserProfileObserver(this),
      UpdateUserProfileParams(
        description: description,
        avatarUrl: avatarUrl,
      ),
    );
  }

  void getUser(String userId) {
    _getUser.execute(
      _GetUserObserver(this),
      userId,
    );
  }

  void getUserPosts(User user) {
    _getUserPosts.execute(
      _GetUserPostsObserver(this),
      GetUserPostsParams(user),
    );
  }

  @override
  void dispose() {
    _getUserProfile.dispose();
    _updateUserProfile.dispose();
    _getUser.dispose();
    _getUserPosts.dispose();
  }
}

class _GetUserProfileObserver extends Observer<UserProfile?> {
  final ProfilePresenter _presenter;

  _GetUserProfileObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getUserProfileOnComplete?.call();
  }

  @override
  void onError(e) {
    _presenter.getUserProfileOnError?.call(e);
  }

  @override
  void onNext(UserProfile? response) {
    _presenter.getUserProfileOnNext?.call(response);
  }
}

class _UpdateUserProfileObserver extends Observer<void> {
  final ProfilePresenter _presenter;

  _UpdateUserProfileObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.updateProfileOnComplete?.call();
  }

  @override
  void onError(e) {
    _presenter.updateProfileOnError?.call(e);
  }

  @override
  void onNext(_) {
    _presenter.updateProfileOnNext?.call();
  }
}

class _GetUserObserver extends Observer<User?> {
  final ProfilePresenter _presenter;

  _GetUserObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getUserOnComplete?.call();
  }

  @override
  void onError(e) {
    _presenter.getUserOnError?.call(e);
  }

  @override
  void onNext(User? response) {
    _presenter.getUserOnNext?.call(response);
  }
}

class _GetUserPostsObserver extends Observer<List<Post>?> {
  final ProfilePresenter _presenter;

  _GetUserPostsObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getUserPostsOnComplete?.call();
  }

  @override
  void onError(e) {
    _presenter.getUserPostsOnError?.call(e);
  }

  @override
  void onNext(List<Post>? response) {
    _presenter.getUserPostsOnNext?.call(response);
  }
}
