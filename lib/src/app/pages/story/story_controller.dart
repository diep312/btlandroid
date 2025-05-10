import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/pages/story/story_presenter.dart';
import 'package:chit_chat/src/domain/entities/story.dart';
import 'package:chit_chat/src/domain/entities/story_item.dart';
import 'package:chit_chat/src/domain/repositories/story_repository.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';

import 'package:story_view/story_view.dart' as sw;

class StoryController extends Controller {
  final StoryPresenter _presenter;

  StoryController(
    StoryRepository storyRepository,
    UserRepository userRepository,
    this.story,
  )   : _presenter = StoryPresenter(
          storyRepository,
          userRepository,
        ),
        initialIndex = story.items.indexWhere((item) => !item.isSeen);

  sw.StoryController storyController = sw.StoryController();

  Story story;
  int initialIndex;

  bool isPopped = false;

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  @override
  void initListeners() {}

  void setStoryAsSeen(String storyId, String storyItemId) {}

  void closePage() {
    if (!isPopped) Navigator.of(getContext()).pop();
    isPopped = true;
  }

  void refreshScreen() {
    refreshUI();
  }
}
