# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.editing.** { *; }

# Supabase
-keep class io.supabase.** { *; }
-keep class com.google.gson.** { *; }
-keep class org.webrtc.** { *; }
-keep class com.fasterxml.jackson.** { *; }
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keep class org.threeten.** { *; }
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-keep class org.postgresql.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Background Service
-keep class id.flutter.flutter_background_service.** { *; }
-keep class com.dexterous.** { *; }
-keep class androidx.lifecycle.** { *; }
-keep class androidx.work.** { *; }

# Flutter Local Notifications
-keep class com.dexterous.** { *; }
-keep class androidx.core.app.** { *; }

# WebSocket
-keep class org.java_websocket.** { *; }
-keep class com.neovisionaries.** { *; }

# General
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Keep Realtime related classes
-keep class io.flutter.plugins.webviewflutter.** { *; }
-keep class androidx.webkit.** { *; }
-keep class android.webkit.** { *; }

# Debugging
-keepattributes LineNumberTable,SourceFile
-renamesourcefileattribute SourceFile

# Google Play Core
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
