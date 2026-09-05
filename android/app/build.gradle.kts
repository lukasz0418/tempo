import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Dane klucza podpisującego trzymane poza repozytorium (android/key.properties,
// wpisane do .gitignore). Jeśli pliku nie ma — np. na innej maszynie —
// build release'a przełącza się na klucz debugowy, żeby nie wywalać się
// na starcie; jest to wtedy jawnie zgłoszone w logu.
val keystoreProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}
val hasReleaseKey = keystoreProperties.containsKey("storeFile")

android {
    namespace = "com.franek.tempo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Wymagane przez flutter_local_notifications: biblioteka używa
        // java.time, którego nie ma w starszych Androidach. Desugaring
        // dokłada te klasy do pliku APK zamiast podnosić minSdk
        // i odcinać starsze telefony.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.franek.tempo"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Stały klucz release jest tu wymogiem, nie formalnością:
            // Android pozwala zaktualizować aplikację tylko wtedy, gdy nowy
            // plik APK jest podpisany dokładnie tym samym kluczem. Zmiana
            // klucza oznacza konieczność odinstalowania aplikacji —
            // razem ze wszystkimi danymi.
            signingConfig = if (hasReleaseKey) {
                signingConfigs.getByName("release")
            } else {
                logger.warn("UWAGA: brak android/key.properties — release podpisany kluczem debugowym. Aktualizacje OTA nie zadziałają.")
                signingConfigs.getByName("debug")
            }
        }
    }
}

dependencies {
    // FileProvider — potrzebny do przekazania pobranego APK instalatorowi.
    implementation("androidx.core:core-ktx:1.13.1")

    // Zaplecze desugaringu włączonego w compileOptions powyżej.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
