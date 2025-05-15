import 'package:chit_chat/src/domain/entities/message.dart';

abstract class ChatRepository {
  void killInstance();

  Stream<List<Message>?> getMessages(List<String> userIds);
  Stream<List<Message>?> getLastMessagesOfUser(String userId);
  Future<void> sendMessage(Message message, List<String> userIds);
}
