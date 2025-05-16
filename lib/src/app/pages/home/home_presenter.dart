import 'dart:collection';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/post.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:chit_chat/src/domain/usecases/cancel_post_like.dart';
import 'package:chit_chat/src/domain/usecases/get_next_posts.dart';
import 'package:chit_chat/src/domain/usecases/get_posts.dart';
import 'package:chit_chat/src/domain/usecases/like_post.dart';
import 'package:chit_chat/src/domain/usecases/toggle_post_favorite_state.dart';
import 'package:chit_chat/src/domain/usecases/delete_post.dart';

class HomePresenter extends Presenter {
  late Function getPostsOnNext;
  late Function getPostsOnError;

  late Function likePostOnComplete;
  late Function likePostOnError;

  late Function cancelPostLikeOnComplete;
  late Function cancelPostLikeOnError;

  late Function getNextPostsOnComplete;
  late Function getNextPostsOnError;

  late Function toggleFavoriteStatusOnComplete;
  late Function toggleFavoriteStatusOnError;

  late Function deletePostOnComplete;
  late Function deletePostOnError;

  final GetPosts _getPosts;
  final CancelPostLike _cancelPostLike;
  final LikePost _likePost;
  final GetNextPosts _getNextPosts;

  final TogglePostFavoriteStatus _togglePostFavoriteStatus;
  final DeletePost _deletePost;

  HomePresenter(PostRepository postRepository, UserRepository userRepository)
      : _getPosts = GetPosts(postRepository, userRepository),
        _likePost = LikePost(postRepository),
        _cancelPostLike = CancelPostLike(postRepository),
        _togglePostFavoriteStatus = TogglePostFavoriteStatus(
          postRepository,
          userRepository,
        ),
        _getNextPosts = GetNextPosts(postRepository),
        _deletePost = DeletePost(postRepository);

  void getPosts() {
    _getPosts.execute(
      _GetPostsObserver(this),
    );
  }

  void likePost(String postId) {
    _likePost.execute(_LikePostObserver(this), LikePostParams(postId));
  }

  void cancelPostLike(String postId) {
    _cancelPostLike.execute(
      _CancelPostLikeObserver(this),
      CancelPostLikeParams(postId),
    );
  }

  void getNextPosts() {
    _getNextPosts.execute(
      _GetNextPostsObserver(this),
    );
  }

  void toggleFavoriteState(Post post) {
    _togglePostFavoriteStatus.execute(
      _TogglePostFavoriteStatusObserver(this),
      TogglePostFavoriteStatusParams(post.id, !post.isFavorited),
    );
  }

  void deletePost(String postId) {
    _deletePost.execute(
      _DeletePostObserver(this),
      DeletePostParams(postId),
    );
  }

  @override
  void dispose() {
    _getPosts.dispose();
    _likePost.dispose();
    _cancelPostLike.dispose();
    _getNextPosts.dispose();
    _togglePostFavoriteStatus.dispose();
    _deletePost.dispose();
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

class _LikePostObserver extends Observer<void> {
  final HomePresenter _presenter;

  _LikePostObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.likePostOnComplete();
  }

  @override
  void onError(e) {
    _presenter.likePostOnError(e);
  }

  @override
  void onNext(_) {}
}

class _CancelPostLikeObserver extends Observer<void> {
  final HomePresenter _presenter;

  _CancelPostLikeObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.cancelPostLikeOnComplete();
  }

  @override
  void onError(e) {
    _presenter.cancelPostLikeOnError(e);
  }

  @override
  void onNext(_) {}
}

class _GetNextPostsObserver extends Observer<void> {
  final HomePresenter _presenter;

  _GetNextPostsObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getNextPostsOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getNextPostsOnError(e);
  }

  @override
  void onNext(_) {}
}

class _TogglePostFavoriteStatusObserver extends Observer<void> {
  final HomePresenter _presenter;

  _TogglePostFavoriteStatusObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.toggleFavoriteStatusOnComplete();
  }

  @override
  void onError(e) {
    _presenter.toggleFavoriteStatusOnError(e);
  }

  @override
  void onNext(_) {}
}

class _DeletePostObserver extends Observer<void> {
  final HomePresenter _presenter;

  _DeletePostObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.deletePostOnComplete();
  }

  @override
  void onError(e) {
    _presenter.deletePostOnError(e);
  }

  @override
  void onNext(_) {}
}
