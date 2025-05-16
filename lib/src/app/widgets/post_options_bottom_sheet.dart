import 'package:flutter/material.dart';
import 'package:chit_chat/src/domain/entities/post.dart';
import 'package:chit_chat/src/app/widgets/k_draggable_bottom_sheet.dart';
import 'package:chit_chat/src/app/constants/texts.dart';

class PostOptionsBottomSheet extends StatelessWidget {
  final Post post;
  final Function(Post post) onEdit;
  final Function(Post post) onDelete;
  final Function(Post post) onToggleFavorite;
  final bool isCurrentUserPost;

  const PostOptionsBottomSheet({
    Key? key,
    required this.post,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleFavorite,
    required this.isCurrentUserPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KDraggableBottomSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 0.4,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              post.isFavorited ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            title: Text(post.isFavorited
                ? DefaultTexts.removeFromFavorites
                : DefaultTexts.addToFavorites),
            onTap: () {
              Navigator.pop(context);
              onToggleFavorite(post);
            },
          ),
          if (isCurrentUserPost) ...[
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text(DefaultTexts.editPost),
              onTap: () {
                Navigator.pop(context);
                onEdit(post);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text(DefaultTexts.deletePost),
              onTap: () {
                Navigator.pop(context);
                onDelete(post);
              },
            ),
          ],
        ],
      ),
    );
  }
}
