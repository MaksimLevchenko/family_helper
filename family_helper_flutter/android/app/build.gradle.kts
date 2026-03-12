plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseKeystorePath = providers.gradleProperty("ANDROID_KEYSTORE_PATH")
    .orElse(providers.environmentVariable("ANDROID_KEYSTORE_PATH"))
val releaseKeystorePassword = providers.gradleProperty("ANDROID_KEYSTORE_PASSWORD")
    .orElse(providers.environmentVariable("ANDROID_KEYSTORE_PASSWORD"))
val releaseKeyAlias = providers.gradleProperty("ANDROID_KEY_ALIAS")
    .orElse(providers.environmentVariable("ANDROID_KEY_ALIAS"))
val releaseKeyPassword = providers.gradleProperty("ANDROID_KEY_PASSWORD")
    .orElse(providers.environmentVariable("ANDROID_KEY_PASSWORD"))
val hasReleaseSigningConfig =
    listOf(
        releaseKeystorePath.orNull,
        releaseKeystorePassword.orNull,
        releaseKeyAlias.orNull,
        releaseKeyPassword.orNull,
    ).all { !it.isNullOrBlank() }
val isReleaseTaskRequested =
    gradle.startParameter.taskNames.any { taskName ->
        taskName.contains("release", ignoreCase = true)
    }

android {
    namespace = "com.example.family_helper_flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.familyhelper.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigningConfig) {
            create("release") {
                storeFile = file(releaseKeystorePath.get())
                storePassword = releaseKeystorePassword.get()
                keyAlias = releaseKeyAlias.get()
                keyPassword = releaseKeyPassword.get()
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseSigningConfig) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

if (!hasReleaseSigningConfig && isReleaseTaskRequested) {
    throw GradleException(
        "Release signing is not configured. Set ANDROID_KEYSTORE_PATH, " +
            "ANDROID_KEYSTORE_PASSWORD, ANDROID_KEY_ALIAS, ANDROID_KEY_PASSWORD.",
    )
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
