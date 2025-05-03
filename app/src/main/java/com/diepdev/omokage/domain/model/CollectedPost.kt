package com.diepdev.omokage.domain.model

enum class NoteContentType { TEXT, IMAGE, VIDEO, MIXED }

data class CollectedPost(
    val postId: String,
    val userId: String,
    val collectionTimestamp: Long,
    val interactionCount: Int = 0
)
