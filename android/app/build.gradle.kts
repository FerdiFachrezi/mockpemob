plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    
    // --- WAJIB: Plugin Google Services agar Firebase terbaca ---
    id("com.google.gms.google-services") 
}

android {
    namespace = "com.example.mockpemob"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // ID ini harus sama persis dengan package_name di google-services.json
        applicationId = "com.example.mockpemob"
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// --- WAJIB: Dependencies Firebase ---
dependencies {
    // Import BoM untuk mengatur versi Firebase secara otomatis
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))

    // Tambahkan library Firebase yang digunakan
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
}