#!/bin/bash
mkdir -p app/src/main/java/com/lk/esp app/src/main/res/layout .github/workflows
rm -f app/сборка.gradle сборка.gradle настройки.gradle грэдлью build.gradle settings.gradle gradlew

cat << 'EOF' > build.gradle
plugins {
    id 'com.android.application' version '8.5.2' apply false
}
EOF

cat << 'EOF' > settings.gradle
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "PubgEspOverlay"
include ':app'
EOF

cat << 'EOF' > app/build.gradle
plugins {
    id 'com.android.application'
}
android {
    namespace 'com.lk.esp'
    compileSdk 34
    defaultConfig {
        applicationId "com.lk.esp"
        minSdk 26
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }
}
EOF

cat << 'EOF' > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PROJECTION" />
    <application android:label="LK ESP" android:theme="@android:style/Theme.NoTitleBar">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <service android:name=".OverlayService" android:foregroundServiceType="mediaProjection" />
        <service android:name=".CaptureService" android:foregroundServiceType="mediaProjection" />
    </application>
</manifest>
EOF

cat << 'EOF' > .github/workflows/build.yml
name: Build APK
on: workflow_dispatch
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: { distribution: "temurin", java-version: "17" }
      - run: chmod +x gradlew
      - run: ./gradlew assembleRelease
      - uses: actions/upload-artifact@v4
        with: { name: apk, path: app/build/outputs/apk/release/*.apk }
EOF

echo "Done!"
