package com.diepdev.omokage.domain.model

data class Post(
    val id: String,
    val author: User,
    val title: String?,
    val content: String?,
    val mediaUrls: List<String>,
    val location: GeoLocation,
    val createdAt: Long,
    val likes: Int,
    val views: Int,
    val isLocked: Boolean
)

