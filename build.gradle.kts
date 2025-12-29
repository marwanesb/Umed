buildscript {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://chaquo.com/maven") } // Ensure Chaquopy is accessible
    }
    dependencies {
        classpath("com.chaquo.python:gradle:15.0.1")
    }
}

plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.jetbrains.kotlin.android) apply false
    alias(libs.plugins.google.gms.google.services) apply false
}
