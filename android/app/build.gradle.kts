plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.zaika.user"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.zaika.user"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled=true
    }

   buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
          signingConfig = signingConfigs.getByName("debug")
        }
    }

   /// signingConfigs {
    //    release {
    //        keyAlias keystoreProperties['keyAlias']
    //        keyPassword keystoreProperties['keyPassword']
    //        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
    //        storePassword keystoreProperties['storePassword']
    //    }
    //}

    //buildTypes {
    //    release {
    //        // TODO: Add your own signing config for the release build.
    //        // Signing with the debug keys for now, so `flutter run --release` works.
    //        signingConfig signingConfigs.release
    //        minifyEnabled false
    //        shrinkResources false
    //        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'

    //    }
    //}
    
}

flutter {
    source = "../.."
}
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("com.google.firebase:firebase-messaging:23.4.1")
    implementation("com.facebook.android:facebook-android-sdk:latest.release")
}
