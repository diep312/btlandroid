
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/pages/add_post/add_post_presenter.dart';
import 'package:chit_chat/src/domain/entities/user.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';

class AddPostController extends Controller {
  final AddPostPresenter _presenter;

  AddPostController(
      PostRepository postRepository,
      UserRepository userRepository,
  ) : _presenter = AddPostPresenter(
    postRepository,
    userRepository,
  );

  User? currentUser;
  String description = '';

  @override
  void onInitState() {
    super.onInitState();
  }

  @override
  void initListeners() {

  }

  void pickImage(bool isGallery, double size) async {

  }

  void onDescriptionTyped(String text) {
    description = text;
    refreshUI();
  }

  void onAddButtonPressed() async {

  }
}
