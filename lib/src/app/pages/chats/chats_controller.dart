import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/pages/chats/chats_presenter.dart';
import 'package:chit_chat/src/domain/entities/message.dart';
import 'package:chit_chat/src/domain/entities/user_profile.dart';
import 'package:chit_chat/src/domain/repositories/chat_repository.dart';
import 'package:chit_chat/src/domain/repositories/user_repository.dart';

class ChatsController extends Controller {
  final ChatsPresenter _presenter;

  ChatsController(UserRepository userReposistory, ChatRepository chatRepository)
      : _presenter = ChatsPresenter(userReposistory, chatRepository);

  List<Message>? lastMessages;
  Map<String, UserProfile> userProfiles = {};

  @override
  void onInitState() {
    _presenter.getLastMessagesOfUser();
    super.onInitState();
  }

  @override
  void initListeners() {
    _presenter.getLastMessagesOfUserOnError = (error) {};

    _presenter.getLastMessagesOfUserOnNext = (List<Message>? response) {
      if (response == null) return;
      lastMessages = response;

      // Fetch profiles for all users in messages
      for (var message in response) {
        if (!userProfiles.containsKey(message.from.id)) {
          _presenter.getUserProfile(message.from.id);
        }
        if (!userProfiles.containsKey(message.to.id)) {
          _presenter.getUserProfile(message.to.id);
        }
      }

      refreshUI();
    };

    _presenter.getUserProfileOnError = (error) {};

    _presenter.getUserProfileOnNext = (UserProfile? profile) {
      if (profile != null) {
        userProfiles[profile.userId] = profile;
        refreshUI();
      }
    };
  }

  String? getAvatarUrl(String userId) {
    return userProfiles[userId]?.avatarUrl;
  }
}
