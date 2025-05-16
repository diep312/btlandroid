import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/navigator/navigator.dart';
import 'package:chit_chat/src/app/pages/favorites/favorites_presenter.dart';
import 'package:chit_chat/src/app/pages/profile/profile_view.dart';
import 'package:chit_chat/src/domain/entities/post.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesController extends Controller {
  final FavoritesPresenter _presenter;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  FavoritesController(
      PostRepository postRepository, UserRepository userRepository)
      : _presenter = FavoritesPresenter(postRepository, userRepository);

  UnmodifiableListView<Post>? posts;
  String lastLikedPost = "";
  ScrollController scrollController = ScrollController();

  @override
  void onInitState() {
    Future.delayed(Duration.zero).then((value) {
      KNavigator.changeLoadingStatus(true);
    });

    _presenter.getFavoritedPosts();
    super.onInitState();
  }

  @override
  void initListeners() {
    _presenter.getFavoritedPostsOnNext =
        (UnmodifiableListView<Post>? response) async {
      if (response == null) return;

      posts = response;
      refreshUI();

      Future.delayed(Duration.zero).then((value) {
        KNavigator.changeLoadingStatus(false);
      });
    };

    _presenter.getFavoritedPostsOnError = (e) {};

    _presenter.likePostOnComplete = () {};

    _presenter.likePostOnError = (e) {};

    _presenter.cancelPostLikeOnComplete = () {};

    _presenter.cancelPostLikeOnError = (e) {};

    _presenter.removeFromFavoriteOnComplete = () {};

    _presenter.removeFromFavoriteOnError = (e) {};

    _presenter.deletePostOnComplete = () {
      _presenter.getFavoritedPosts(); // Refresh posts after deletion
    };

    _presenter.deletePostOnError = (e) {};
  }

  void changePostLike(Post post) {
    if (post.isLiked) {
      _presenter.cancelPostLike(post.id);
    } else {
      kVibrateLight();
      _presenter.likePost(post.id);

      lastLikedPost = post.id;
      refreshUI();

      Future.delayed(Duration(milliseconds: 1000)).then((_) {
        lastLikedPost = "";
        refreshUI();
      });
    }
  }

  void removeFromFavorite(Post post) {
    _presenter.toggleFavoriteState(post.id);
  }

  void editPost(Post post) {
    // Navigate to edit post page
    KNavigator.navigateToEditPost(getContext(), post);
  }

  void deletePost(Post post) {
    // Show confirmation dialog
    showDialog(
      context: getContext(),
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _presenter.deletePost(post.id);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void onAvatarTap(String userId) {
    Navigator.push(
      getContext(),
      MaterialPageRoute(
        builder: (context) => ProfileView(
          userId: userId,
          currentUserId: currentUserId,
        ),
      ),
    );
  }
}
