package com.diepdev.omokage.data.repository

import android.net.Uri
import com.diepdev.omokage.domain.model.UserProfile
import com.diepdev.omokage.domain.model.UserStat
import com.diepdev.omokage.domain.model.SocialLink
import com.diepdev.omokage.domain.repository.UserProfileRepository
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.storage.StorageReference
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.tasks.await
import javax.inject.Inject

class FirebaseUserProfileRepository @Inject constructor() : BaseFirebaseRepository(), UserProfileRepository {

    private val profileCollection = firestore.collection("user_profiles")
    private val storageProfilePictures: StorageReference = storage.reference.child("profile_pictures")
    private val storageCoverPhotos: StorageReference = storage.reference.child("cover_photos")

    override suspend fun getUserProfile(userId: String): Result<UserProfile> {
        return try {
            val snapshot = profileCollection.document(userId).get().await()
            snapshot.toUserProfile()?.let { Result.success(it) }
                ?: Result.failure(Exception("Profile not found"))
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun updateUserProfile(profile: UserProfile): Result<Unit> {
        return try {
            val profileData = hashMapOf<String, Any>(
                "user_id" to profile.userId,
                "display_name" to profile.displayName,
                "bio" to profile.bio,
                "stats" to hashMapOf<String, Any>(
                    "notes_created" to profile.stats.notesCreated,
                    "notes_collected" to profile.stats.notesCollected,
                    "hotspots_discovered" to profile.stats.hotspotsDiscovered,
                    "followers" to profile.stats.followers,
                    "following" to profile.stats.following,
                    "total_likes" to profile.stats.totalLikes,
                    "total_views" to profile.stats.totalViews
                ),
                "social_links" to profile.socialLinks.map { link ->
                    hashMapOf<String, String>(
                        "platform" to link.platform,
                        "url" to link.url
                    )
                }
            )

            profile.profilePictureUrl?.let {
                profileData["profile_picture_url"] = it
            }

            profileCollection.document(profile.userId)
                .set(profileData)
                .await()

            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun uploadProfilePicture(userId: String, imageUri: Uri): Result<String> {
        return try {
            // Delete old picture if exists
            try {
                storageProfilePictures.child("$userId.jpg").delete().await()
            } catch (e: Exception) {
                // Ignore if file doesn't exist
            }

            // Upload new picture
            val uploadTask = storageProfilePictures.child("$userId.jpg")
                .putFile(imageUri)
                .await()

            // Get download URL
            val downloadUrl = uploadTask.storage.downloadUrl.await().toString()

            // Update profile with new URL
            profileCollection.document(userId)
                .update("profile_picture_url", downloadUrl)
                .await()

            Result.success(downloadUrl)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }


    override suspend fun observeUserProfile(userId: String): Flow<UserProfile> = callbackFlow {
        val listener = profileCollection.document(userId)
            .addSnapshotListener { snapshot, error ->
                if (error != null) {
                    close(error)
                    return@addSnapshotListener
                }

                if (snapshot != null && snapshot.exists()) {
                    snapshot.toUserProfile()?.let { profile ->
                        trySend(profile)
                    } ?: close(Exception("Invalid profile data"))
                } else {
                    close(Exception("Profile not found"))
                }
            }

        awaitClose { listener.remove() }
    }

    private fun DocumentSnapshot.toUserProfile(): UserProfile? {
        return try {
            val statsMap = get("stats") as? Map<String, Any> ?: emptyMap()

            UserProfile(
                userId = getString("user_id") ?: return null,
                displayName = getString("display_name") ?: "",
                bio = getString("bio") ?: "",
                profilePictureUrl = getString("profile_picture_url"),
                coverPhotoUrl = getString("cover_photo_url"),
                stats = UserStat(
                    notesCreated = (statsMap["notes_created"] as? Long)?.toInt() ?: 0,
                    notesCollected = (statsMap["notes_collected"] as? Long)?.toInt() ?: 0,
                    hotspotsDiscovered = (statsMap["hotspots_discovered"] as? Long)?.toInt() ?: 0,
                    followers = (statsMap["followers"] as? Long)?.toInt() ?: 0,
                    following = (statsMap["following"] as? Long)?.toInt() ?: 0,
                    totalLikes = (statsMap["total_likes"] as? Long)?.toInt() ?: 0,
                    totalViews = (statsMap["total_views"] as? Long)?.toInt() ?: 0
                ),
                socialLinks = (get("social_links") as? List<Map<String, String>>)?.map {
                    SocialLink(
                        platform = it["platform"] ?: "",
                        url = it["url"] ?: ""
                    )
                } ?: emptyList()
            )
        } catch (e: Exception) {
            null
        }
    }
}