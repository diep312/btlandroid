import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/repositories/post_repository.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';

class AddPostPresenter extends Presenter {

  AddPostPresenter(
    PostRepository postRepository,
    UserRepository userRepository,
  );

  @override
  void dispose() {

  }
}
