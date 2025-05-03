package com.diepdev.omokage.domain.model

data class Hotspot(
    val centerLocation: GeoLocation,
    val radius: Int,
    val noteCount: Int,
    val popularityScore: Double
)
