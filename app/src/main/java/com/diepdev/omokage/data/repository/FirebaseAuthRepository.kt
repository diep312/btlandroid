package com.diepdev.omokage.data.repository

import com.diepdev.omokage.domain.model.User
import com.diepdev.omokage.domain.repository.AuthRepository
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import kotlinx.coroutines.tasks.await
import javax.inject.Inject

class FirebaseAuthRepository @Inject constructor() : AuthRepository {

    private val auth: FirebaseAuth = Firebase.auth

    override suspend fun signInWithEmail(email: String, password: String): Result<User> {
        return try {
            val result = auth.signInWithEmailAndPassword(email, password).await()
            result.user?.let { firebaseUser ->
                Result.success(User.fromFirebaseUser(firebaseUser))
            } ?: Result.failure(Exception("Authentication failed"))
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun signUpWithEmail(
        email: String,
        password: String,
        displayName: String
    ): Result<User> {
        return try {
            // Create user
            val result = auth.createUserWithEmailAndPassword(email, password).await()

            // Update profile with display name
            result.user?.let { firebaseUser ->
                val profileUpdates = com.google.firebase.auth.UserProfileChangeRequest.Builder()
                    .setDisplayName(displayName)
                    .build()

                firebaseUser.updateProfile(profileUpdates).await()

                Result.success(User.fromFirebaseUser(firebaseUser))
            } ?: Result.failure(Exception("Registration failed"))
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun getCurrentUser(): User? {
        return auth.currentUser?.let { User.fromFirebaseUser(it) }
    }

    override suspend fun signOut() {
        auth.signOut()
    }

    override suspend fun updateEmail(newEmail: String): Result<Unit> {
        TODO("Not yet implemented")
    }

    override suspend fun updatePassword(newPassword: String): Result<Unit> {
        TODO("Not yet implemented")
    }
}