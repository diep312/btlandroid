package com.diepdev.omokage.domain.model

data class UserStat(
    val notesCreated: Int = 0,
    val notesCollected: Int = 0,
    val hotspotsDiscovered: Int = 0,
    val followers: Int = 0,
    val following: Int = 0,
    val totalLikes: Int = 0,
    val totalViews: Int = 0
)
