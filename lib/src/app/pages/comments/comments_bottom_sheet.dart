import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/constants/texts.dart';
import 'package:chit_chat/src/app/pages/comments/comments_controller.dart';
import 'package:chit_chat/src/app/widgets/k_button.dart';
import 'package:chit_chat/src/app/widgets/k_draggable_bottom_sheet.dart';
import 'package:chit_chat/src/data/repositories/data_post_repository.dart';
import 'package:chit_chat/src/data/repositories/data_user_repository.dart';
import 'package:chit_chat/src/data/utils/string_utils.dart';
import 'package:chit_chat/src/domain/entities/comment.dart';

class CommentsBottomSheet extends View {
  final String postId;

  CommentsBottomSheet(this.postId);

  @override
  State<StatefulWidget> createState() => _CommentsBottomSheetState(
        CommentsController(
          DataPostRepository(),
          DataUserRepository(),
          postId,
        ),
      );
}

class _CommentsBottomSheetState
    extends ViewState<CommentsBottomSheet, CommentsController> {
  final TextEditingController _commentController = TextEditingController();

  _CommentsBottomSheetState(super.controller);

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;

    return KDraggableBottomSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      child: ControlledWidgetBuilder<CommentsController>(
        builder: (context, controller) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FB), // light blue background
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Header with centered, large title
                Padding(
                  padding:
                      EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Text(
                          DefaultTexts.comments,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: kBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Comments list
                Expanded(
                  child: controller.commentsInitializedFirstTime
                      ? (controller.comments.isEmpty
                          ? Center(
                              child: Text(
                                'No comments to show',
                                style: k14w400AxiBlackGeneralText(
                                    color: kBlack.withOpacity(0.4)),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              physics: kPhysics,
                              itemCount: controller.comments.length,
                              itemBuilder: (context, i) {
                                return _Comment(
                                  comment: controller.comments[i],
                                  removeComment: controller.removeComment,
                                );
                              },
                            ))
                      : Container(),
                ),
                // Input field and send button
                Padding(
                  padding: EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                    top: 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: "Viết bình luận...",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF1976D2), // blue send button
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            if (_commentController.text.trim().isNotEmpty) {
                              controller
                                  .addComment(_commentController.text.trim());
                              _commentController.clear();
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      ),
                    ],
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

class _Comment extends StatelessWidget {
  final Comment comment;
  final Function(String commentId) removeComment;
  const _Comment({Key? key, required this.comment, required this.removeComment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(
              'assets/icons/png/current_user.png', // You can use comment.authorId to select avatar
            ),
          ),
          SizedBox(width: 12),
          // Name, time, text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.authorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: kBlack,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      StringUtils.getDateInMinSecFormat(comment.sharedOn),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  comment.text,
                  style: TextStyle(fontSize: 14, color: kBlack),
                ),
              ],
            ),
          ),
          // Heart icon and count (placeholder)
          Column(
            children: [
              Icon(Icons.favorite_border, color: Colors.grey[400], size: 20),
              SizedBox(height: 2),
              Text('200',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
}
