import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/post.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:chit_chat/src/domain/usecases/add_post.dart';
import 'package:chit_chat/src/domain/usecases/get_current_user.dart';
import 'package:chit_chat/src/domain/entities/user.dart';

class AddPostPresenter extends Presenter {
  late Function addPostOnComplete;
  late Function addPostOnError;

  late Function getCurrentUserOnNext;
  late Function getCurrentUserOnError;

  final AddPost _addPost;
  final GetCurrentUser _getCurrentUser;
  final UserRepository userRepository;

  AddPostPresenter(
    PostRepository postRepository,
    UserRepository userRepository,
  )   : _addPost = AddPost(postRepository, userRepository),
        _getCurrentUser = GetCurrentUser(userRepository),
        userRepository = userRepository;

  void addPost(Post post) {
    _addPost.execute(
      _AddPostObserver(this),
      AddPostParams(post),
    );
  }

  void getCurrentUser() {
    _getCurrentUser.execute(_GetCurrentUserObserver(this));
  }

  @override
  void dispose() {
    _addPost.dispose();
    _getCurrentUser.dispose();
  }
}

class _GetCurrentUserObserver extends Observer<User> {
  final AddPostPresenter _presenter;

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

class _AddPostObserver extends Observer<void> {
  final AddPostPresenter _presenter;

  _AddPostObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.addPostOnComplete();
  }

  @override
  void onError(e) {
    _presenter.addPostOnError(e);
  }

  @override
  void onNext(_) {}
}
