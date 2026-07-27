-keep class com.google.android.gms.auth.api.credentials.** { *; }
-dontwarn com.google.android.gms.auth.api.credentials.**

# ---------------------------------------------------------------------------
# device_calendar
# The plugin serializes its Kotlin model classes (Calendar, Event, Attendee,
# Reminder, RecurrenceRule, ...) to JSON with Gson, which reflects on the FIELD
# NAMES to build the JSON keys sent across the platform channel to Dart.
# If R8 obfuscates/removes those fields, the JSON keys no longer match and every
# Calendar/Event field arrives null in release builds (works fine in debug).
# Keep the model classes and their members intact.
# ---------------------------------------------------------------------------
-keep class com.builttoroam.devicecalendar.** { *; }
-keepclassmembers class com.builttoroam.devicecalendar.** { *; }

# ---------------------------------------------------------------------------
# Gson (used by device_calendar and potentially other plugins)
# ---------------------------------------------------------------------------
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
-dontwarn com.google.gson.**
