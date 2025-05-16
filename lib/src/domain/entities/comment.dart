import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String authorId;
  final String authorName;
  final String targetId;
  final String text;
  final DateTime sharedOn;
  final String authorAvatarUrl;
  int commentLikesCount;
  final List<String> likedByUsers;

  Comment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.targetId,
    required this.text,
    required this.sharedOn,
    this.authorAvatarUrl = '',
    this.commentLikesCount = 0,
    this.likedByUsers = const [],
  });

  Comment.fromJson(DocumentSnapshot<Map<String, dynamic>> json)
      : id = json.id,
        authorId = json['authorId'],
        authorName = json['authorName'],
        targetId = json['targetId'],
        text = json['text'],
        sharedOn = DateTime.fromMillisecondsSinceEpoch(json['sharedOn']),
        authorAvatarUrl = json['authorAvatarUrl'] ?? '',
        commentLikesCount = json['commentLikesCount'] ?? 0,
        likedByUsers = List<String>.from(json['likedByUsers'] ?? []);

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'targetId': targetId,
      'text': text,
      'sharedOn': sharedOn.millisecondsSinceEpoch,
      'authorAvatarUrl': authorAvatarUrl,
      'commentLikesCount': commentLikesCount,
      'likedByUsers': likedByUsers,
    };
  }

  bool isLikedByUser(String userId) {
    return likedByUsers.contains(userId);
  }
}
