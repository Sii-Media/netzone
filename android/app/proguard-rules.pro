-keep class com.revesoft.revechatsdk.** {*;}
-keep interface com.revesoft.revechatsdk.** { *; }
-keep enum com.revesoft.revechatsdk.** { *; }
-dontwarn com.revesoft.revechatsdk.**

-keep class org.webrtc.** { *; }
-keep class org.webrtc.voiceengine.** { *; }
-dontwarn org.webrtc.**