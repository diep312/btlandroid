import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/domain/entities/message.dart';
import 'package:chit_chat/src/domain/entities/user_profile.dart';
import 'package:chit_chat/src/domain/repositories/chat_repository.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';
import 'package:chit_chat/src/domain/usecases/get_all_messages_of_user.dart';

class ChatsPresenter extends Presenter {
  late Function getLastMessagesOfUserOnNext;
  late Function getLastMessagesOfUserOnError;
  late Function getUserProfileOnNext;
  late Function getUserProfileOnError;

  final GetLastMessagesOfUser _getLastMessagesOfUser;
  final UserRepository _userRepository;

  ChatsPresenter(UserRepository userRepository, ChatRepository chatRepository)
      : _getLastMessagesOfUser =
            GetLastMessagesOfUser(chatRepository, userRepository),
        _userRepository = userRepository;

  void getLastMessagesOfUser() {
    _getLastMessagesOfUser.execute(_GetLastMessagesOfUserObserver(this));
  }

  void getUserProfile(String userId) {
    _userRepository.getUserProfile(userId).then((profile) {
      getUserProfileOnNext(profile);
    }).catchError((error) {
      getUserProfileOnError(error);
    });
  }

  @override
  void dispose() {
    _getLastMessagesOfUser.dispose();
  }
}

class _GetLastMessagesOfUserObserver extends Observer<List<Message>?> {
  final ChatsPresenter _presenter;

  _GetLastMessagesOfUserObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(error) {
    _presenter.getLastMessagesOfUserOnError(error);
  }

  @override
  void onNext(List<Message>? messages) {
    _presenter.getLastMessagesOfUserOnNext(messages);
  }
}
