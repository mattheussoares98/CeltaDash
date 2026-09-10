# Flutter wrapper keep rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Preserve line numbers and source files for Crashlytics stack trace deobfuscation
-keepattributes SourceFile,LineNumberTable
-keepattributes *Annotation*

# Preserve native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve custom views and XML-referenced classes
-keeppublicclass * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(...);
}
