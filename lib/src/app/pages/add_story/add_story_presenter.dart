import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/story_item.dart';

class AddStoryPresenter extends Presenter {
  late Function addStoryOnComplete;
  late Function addStoryOnError;

  final AddStory _addStory;

  AddStoryPresenter() : _addStory = AddStory();

  void addStory(StoryItem storyItem) {

  }

  @override
  void dispose() {
    _addStory.dispose();
  }
}
