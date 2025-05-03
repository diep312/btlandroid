package com.diepdev.omokage.domain.model

data class GeoLocation(
    val latitude: Double,
    val longitude: Double,
    val geoHash: String, // For spatial queries
    val placeName: String? = null,
    val address: String? = null
)

