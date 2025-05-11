import 'dart:collection';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/post.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:chit_chat/src/domain/usecases/get_posts.dart';

class HomePresenter extends Presenter {
  late Function getPostsOnNext;
  late Function getPostsOnError;

  late Function likePostOnComplete;
  late Function likePostOnError;

  late Function getNextPostsOnComplete;
  late Function getNextPostsOnError;

  final GetPosts _getPosts;

  HomePresenter(PostRepository postRepository, UserRepository userRepository)
      : _getPosts = GetPosts(postRepository, userRepository);

  void getPosts() {
    _getPosts.execute(
      _GetPostsObserver(this),
    );
  }

  @override
  void dispose() {
    _getPosts.dispose();
  }
}

class _GetPostsObserver extends Observer<UnmodifiableListView<Post>?> {
  final HomePresenter _presenter;

  _GetPostsObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    _presenter.getPostsOnError(e);
  }

  @override
  void onNext(UnmodifiableListView<Post>? response) {
    _presenter.getPostsOnNext(response);
  }
}
