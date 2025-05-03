package com.diepdev.omokage.domain.model


data class UserProfile(
    val userId: String,
    val displayName: String,
    val bio: String,
    val profilePictureUrl: String?,
    val coverPhotoUrl: String?,
    val stats: UserStat,
    val socialLinks: List<SocialLink>
)
