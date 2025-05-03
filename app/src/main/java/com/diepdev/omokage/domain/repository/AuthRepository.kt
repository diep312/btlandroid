package com.diepdev.omokage.domain.repository

import com.diepdev.omokage.domain.model.User

interface AuthRepository {
    suspend fun signInWithEmail(email: String, password: String): Result<User>
    suspend fun signUpWithEmail(email: String, password: String, username: String): Result<User>
    suspend fun getCurrentUser(): User?
    suspend fun signOut()
    suspend fun updateEmail(newEmail: String): Result<Unit>
    suspend fun updatePassword(newPassword: String): Result<Unit>
}