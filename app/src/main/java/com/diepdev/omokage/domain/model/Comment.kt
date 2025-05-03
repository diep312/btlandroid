package com.diepdev.omokage.domain.model

data class Comment(
    val id: String,
    val noteId: String,
    val userId: String,
    val username: String,
    val userProfilePic: String?,
    val text: String,
    val timestamp: Long,
    val parentCommentId: String? = null
)
