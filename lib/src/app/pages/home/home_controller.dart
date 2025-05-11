import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/pages/home/home_presenter.dart';
import 'package:chit_chat/src/domain/entities/post.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';

class HomeController extends Controller {
  final HomePresenter _presenter;

  HomeController(
    PostRepository postRepository,
    UserRepository userRepository,
  ) : _presenter = HomePresenter(
          postRepository,
          userRepository,
        );

  UnmodifiableListView<Post> posts = UnmodifiableListView([]);
  List<String>? watchlist;

  String lastLikedPost = "";

  int page = 1;
  bool isAllPostsFetched = false;
  bool postsInitialized = false;
  ScrollController scrollController = ScrollController();

  StreamController<bool?> refreshStreamController =
      StreamController.broadcast();

  @override
  void onInitState() {
    _presenter.getPosts();

    super.onInitState();
  }

  @override
  void initListeners() {

  }

  void changePostLike(Post post) async {

  }

  void getNextPosts() {

  }

  void togglePostFavoriteState(Post post) {

  }

  void getPosts() {

  }
}
