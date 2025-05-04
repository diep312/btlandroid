class UserProfile {
  final String userId;
  final String? description;
  final String? avatarUrl;
  final int followersCount;
  final int likesCount;
  // Add more fields as needed

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
      description: json['description'],
      avatarUrl: json['avatarUrl'],
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
