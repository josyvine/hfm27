# ===================================================================
# 1. Existing PDFBox Rules (Preserved)
# ===================================================================

# Rule 1: Prevents the PDF library's code from being altered or removed by the build process.
-keep class com.tom_roush.pdfbox.** { *; }

# Note: Java resources (e.g. com/tom_roush/pdfbox/resources/**) are preserved automatically
# by Android packaging; -keepresources is unsupported in R8 and was removed.

# ===================================================================
# 2. Log Stripping, Package Flattening & Bytecode Hardening (Txtify Style)
# ===================================================================

# Strip all Android Logcat calls (d, v, i, w, e, wtf, println) from release bytecode
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
    public static *** wtf(...);
    public static *** println(...);
}

# Flatten internal classes into package 'o' and sanitize source metadata
-repackageclasses 'o'
-allowaccessmodification
-renamesourcefileattribute 'SourceFile'
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod

# ===================================================================
# 3. Native JNI Bridge & Native Methods
# ===================================================================

# Keep NativeBridge and all native methods intact for C++ JNI resolution
-keep class com.vineyard.hfm.app.utils.NativeBridge { *; }
-keepclasseswithmembernames class * {
    native <methods>;
}

# ===================================================================
# 4. WebView JavaScript Interface (Critical for webview-app.html)
# ===================================================================

# Protect all @JavascriptInterface methods from being stripped or renamed by R8
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepclassmembers class com.vineyard.hfm.app.MainActivity$WebAppInterface {
    <methods>;
}

# ===================================================================
# 5. App Components & UI Inflation
# ===================================================================

-keep class * extends android.app.Activity
-keep class * extends android.app.Application
-keep class * extends android.app.Service
-keep class * extends android.content.BroadcastReceiver
-keep class * extends androidx.fragment.app.Fragment

-keep public class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

-keepclassmembers class * extends androidx.recyclerview.widget.RecyclerView$ViewHolder {
    public <init>(...);
}

# ===================================================================
# 6. Third-Party Libraries (Firebase, Google Play, Drive, Biometrics, LZ4)
# ===================================================================

# Firebase & Google Play Services / Drive API
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**
-keep class com.google.api.services.drive.** { *; }
-dontwarn com.google.api.services.drive.**

# AndroidX BiometricPrompt
-keep class androidx.biometric.** { *; }

# LZ4 Compression library (app/libs/lz4-java-1.5.0.jar)
-keep class net.jpountz.** { *; }
-dontwarn net.jpountz.**

# Optional runtime dependencies referenced by PDFBox, OkHttp, and SLF4J
-dontwarn com.gemalto.jp2.**
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
-dontwarn org.slf4j.impl.**