import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/data/utils/string_utils.dart';
import 'package:chit_chat/src/domain/entities/message.dart';

class MessageContainer extends StatefulWidget {
  final Message message;

  MessageContainer(this.message)
      : isCurrentUser =
            message.from.id == FirebaseAuth.instance.currentUser!.uid;

  final bool isCurrentUser;

  @override
  State<MessageContainer> createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
        });
      },
      child: Column(
        crossAxisAlignment: widget.isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (isTapped)
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0, left: 6, right: 6),
              child: Text(
                StringUtils.getPublishDateLong(widget.message.time),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ),
          Row(
            mainAxisAlignment: widget.isCurrentUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  constraints: BoxConstraints(minHeight: 20),
                  decoration: BoxDecoration(
                    color:
                        widget.isCurrentUser ? Color(0xFF648FD9) : Colors.white,
                    borderRadius: widget.isCurrentUser
                        ? BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                          )
                        : BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(vertical: 2),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    widget.message.text,
                    style: TextStyle(
                      color: widget.isCurrentUser ? Colors.white : Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
