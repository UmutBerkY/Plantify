plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ Uygun şekilde eklendi
}

android {
    namespace = "com.example.plant_care"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13113456"

    defaultConfig {
        applicationId = "com.example.plant_care"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    externalNativeBuild {
        cmake {
            version = "4.0.2"
        }
    }
}

flutter {
    source = "../.."
}
