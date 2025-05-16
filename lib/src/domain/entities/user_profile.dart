class UserProfile {
  final String userId;
  final String? description;
  final String? avatarUrl;
  final int followersCount;
  final int likesCount;

  UserProfile({
    required this.userId,
    this.description,
    this.avatarUrl,
    this.followersCount = 0,
    this.likesCount = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] ?? '',
      description: json['description'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      followersCount: json['followersCount'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'description': description,
      'avatarUrl': avatarUrl,
      'followersCount': followersCount,
      'likesCount': likesCount,
    };
  }
}
