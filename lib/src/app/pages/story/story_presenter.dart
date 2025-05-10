import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/repositories/story_repository.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:chit_chat/src/domain/usecases/set_story_item_as_seen.dart';

class StoryPresenter extends Presenter {
  
  StoryPresenter(
    StoryRepository storyRepository,
    UserRepository userRepository,
  );

  @override
  void dispose() {

  }
}
