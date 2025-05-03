package com.diepdev.omokage.domain.model

data class User(
    val id: String,
    val displayName: String,
    val username: String,
    val email: String,
    val profilePictureUrl: String?,
    val lastActive: Long,
    val createdAt: Long = System.currentTimeMillis()
) {
    companion object {
        fun fromFirebaseUser(firebaseUser: com.google.firebase.auth.FirebaseUser): User {
            return User(
                id = firebaseUser.uid,
                displayName = firebaseUser.displayName ?: "",
                username = firebaseUser.email?.substringBefore("@") ?: "user_${firebaseUser.uid.take(8)}",
                email = firebaseUser.email ?: "",
                profilePictureUrl = firebaseUser.photoUrl?.toString(),
                lastActive = System.currentTimeMillis()
            )
        }
    }
}