package com.diepdev.omokage.domain.repository

import android.net.Uri
import com.diepdev.omokage.domain.model.UserProfile
import kotlinx.coroutines.flow.Flow

interface UserProfileRepository {
    suspend fun getUserProfile(userId: String): Result<UserProfile>
    suspend fun updateUserProfile(profile: UserProfile): Result<Unit>
    suspend fun uploadProfilePicture(userId: String, imageUri: Uri): Result<String>
    suspend fun observeUserProfile(userId: String): Flow<UserProfile>
}