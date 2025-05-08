import 'dart:collection';

import 'package:chit_chat/src/domain/entities/story.dart';
import 'package:chit_chat/src/domain/entities/story_item.dart';
import 'package:chit_chat/src/domain/entities/user.dart';

abstract class StoryRepository {
  void killInstance();

  Stream<UnmodifiableListView<Story>?> getStories(User user);
  bool get allStoriesSeen;
}
