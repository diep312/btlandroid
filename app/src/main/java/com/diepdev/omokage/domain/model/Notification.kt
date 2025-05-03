package com.diepdev.omokage.domain.model

data class Notification(
    val id: String,
    val userId: String,
    val type: NotificationType,
    val content: String,
    val timestamp: Long,
    val isRead: Boolean
)

enum class NotificationType {
    NEW_POST_NEARBY, COMMENT, LIKE, SYSTEM
}
