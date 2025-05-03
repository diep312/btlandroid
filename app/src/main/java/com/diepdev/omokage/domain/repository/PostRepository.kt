package com.diepdev.omokage.domain.repository

import com.diepdev.omokage.domain.model.GeoLocation
import com.diepdev.omokage.domain.model.Post
import kotlinx.coroutines.flow.Flow

interface PostRepository {
    suspend fun createNote(post: Post): Result<String>
    suspend fun getNoteById(postId: String): Result<Post>
    suspend fun getNotesNearLocation(location: GeoLocation, radius: Double): Result<List<Post>>
    suspend fun collectNote(postId: String, userId: String): Result<Unit>
    suspend fun getCollectedNotes(userId: String): Result<List<Post>>
    fun observeNearbyNotes(location: GeoLocation): Flow<List<Post>>
}