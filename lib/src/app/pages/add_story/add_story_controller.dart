import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/pages/add_story/add_story_presenter.dart';

class AddStoryController extends Controller {
  final AddStoryPresenter _presenter;

  AddStoryController() : _presenter = AddStoryPresenter();

  @override
  void onInitState() {
    openCamera();
    super.onInitState();
  }

  @override
  void initListeners() {

  }

  void openCamera() async {

  }

  void addStory() async {

  }
}
