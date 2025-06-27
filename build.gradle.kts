plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.myapp"
    compileSdk = flutter.compileSdkVersion

    // --- FIX 1: Override NDK Version ---
    // line to be changed: ndkVersion = flutter.ndkVersion
    // To the specific version required by your plugins:
    ndkVersion = "27.0.12077973" // <--- IMPORTANT: Use this exact version from your log!

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.myapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.

        // --- FIX 2: Override minSdk Version ---
        // Change this line: minSdk = flutter.minSdkVersion
        // To the minimum required by Firebase (23):
        minSdk = 23 // <--- IMPORTANT: Set minSdk to at least 23!

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode.toInt() // Ensure this is converted to Int if needed by Gradle
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
