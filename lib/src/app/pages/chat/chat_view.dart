import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/pages/chat/chat_controller.dart';
import 'package:chit_chat/src/app/widgets/message_container.dart';
import 'package:chit_chat/src/data/repositories/data_chat_repository.dart';
import 'package:chit_chat/src/data/repositories/data_user_repository.dart';
import 'package:chit_chat/src/domain/entities/user.dart';

class ChatView extends View {
  final User peerUser;

  ChatView(this.peerUser);

  @override
  State<StatefulWidget> createState() => _ChatViewState(
        ChatController(
          DataUserRepository(),
          DataChatRepository(),
          peerUser,
        ),
      );
}

class _ChatViewState extends ViewState<ChatView, ChatController> {
  _ChatViewState(ChatController controller) : super(controller);

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      body: ControlledWidgetBuilder<ChatController>(
        builder: (context, controller) {
          Size size = MediaQuery.of(context).size;
          EdgeInsets padding = MediaQuery.of(context).padding;
          bool isKeyboardClosed =
              MediaQuery.of(context).viewInsets.bottom == 0.0;
          return Container(
            width: size.width,
            height: size.height,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Header
                Padding(
                  padding: EdgeInsets.only(
                      top: padding.top, left: 16, right: 16, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF5A7A),
                            shape: BoxShape.circle,
                          ),
                          child:
                              Icon(Icons.close, color: Colors.white, size: 22),
                        ),
                      ),
                      SizedBox(width: 12),
                      CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            AssetImage('assets/icons/png/default_user.png'),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.peerUser.displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '@' + widget.peerUser.displayName,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(32),
                        topLeft: Radius.circular(32),
                      ),
                    ),
                    child: controller.messages == null
                        ? Center(
                            child: CircularProgressIndicator(color: kPrimary))
                        : GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Column(
                              children: [
                                Expanded(
                                  child: controller.messages!.isEmpty
                                      ? Center(
                                          child: Text(
                                            'No message history. Lets start a conversation',
                                            textAlign: TextAlign.center,
                                            style: k14w400AxiBlackGeneralText(
                                                color: kBlack.withOpacity(0.4)),
                                          ),
                                        )
                                      : ListView(
                                          controller:
                                              controller.scrollController,
                                          keyboardDismissBehavior:
                                              ScrollViewKeyboardDismissBehavior
                                                  .manual,
                                          physics:
                                              AlwaysScrollableScrollPhysics(
                                                  parent:
                                                      BouncingScrollPhysics()),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 18),
                                          children: [
                                            for (int i = 0;
                                                i < controller.messages!.length;
                                                i++)
                                              MessageContainer(
                                                  controller.messages![i]),
                                            if (!isKeyboardClosed)
                                              SizedBox(height: 200),
                                          ],
                                        ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      bottom: padding.bottom + 16,
                                      top: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.camera_alt_outlined,
                                              color: Color(0xFF648FD9)),
                                          onPressed: () {},
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: controller
                                                .textEditingController,
                                            onChanged: (text) {
                                              controller
                                                  .onMessageWrite(text.trim());
                                            },
                                            minLines: 1,
                                            maxLines: 3,
                                            style: k14w400AxiBlackGeneralText(
                                                color: kBlack.withOpacity(0.8)),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              border: InputBorder.none,
                                              hintStyle:
                                                  k13w300AxiWhiteProfileHeaderText(
                                                      color: kDot),
                                              hintText: 'Viết tin nhắn...',
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF648FD9),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.send,
                                              color: Colors.white),
                                          onPressed:
                                              controller.userMessage.length < 2
                                                  ? null
                                                  : controller.sendMessage,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
