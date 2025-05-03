package com.diepdev.omokage.data.repository

import com.google.firebase.auth.ktx.auth
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.ktx.storage

abstract class BaseFirebaseRepository {
    protected val firestore = Firebase.firestore
    protected val auth = Firebase.auth
    protected val storage = Firebase.storage

    protected inline fun <reified T> documentToObject(document: DocumentSnapshot): T? {
        return try {
            document.toObject(T::class.java)
        } catch (e: Exception) {
            null
        }
    }
}