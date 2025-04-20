CSCFEATURES="
<CscFeature_VoiceCall_ConfigRecording>RecordingAllowed</CscFeature_VoiceCall_ConfigRecording>
<CscFeature_Setting_SupportRealTimeNetworkSpeed>TRUE</CscFeature_Setting_SupportRealTimeNetworkSpeed>
<CscFeature_Common_DisableBixby>FALSE</CscFeature_Common_DisableBixby>
<CscFeature_Setting_EnableHwVersionDisplay>TRUE</CscFeature_Setting_EnableHwVersionDisplay>
<CscFeature_Setting_SupportMenuSmartTutor>FALSE</CscFeature_Setting_SupportMenuSmartTutor>
"

echo "Adding CSCFeatures..."
find "$WORK_DIR/optics" -type f -name "cscfeature.xml" | while read -r file; do
    $TOOLS_DIR/cscdecoder --decode --in-place $file
    while IFS= read -r feature; do
        [ -z "$feature" ] && continue
        escaped_feature=$(echo "$feature" | sed 's/[&/\]/\\&/g')
        sed -i "/$escaped_feature/d" "$file"
        sed -i "/<\/FeatureSet>/i\\
    $escaped_feature
    " "$file"
        $TOOLS_DIR/cscdecoder --encode --in-place $file
    done <<< "$CSCFEATURES"
done

echo "Patching APKs for network speed monitoring..."

DECODE_APK "system/priv-app/SecSettings/SecSettings.apk"
DECODE_APK "system_ext/priv-app/SystemUI/SystemUI.apk"

FTP="
system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/eternal/provider/items/NotificationsItem.smali
system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/notification/ConfigureNotificationMoreSettings\$1.smali
system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/notification/StatusBarNetworkSpeedController.smali
system_ext/priv-app/SystemUI/SystemUI.apk/smali/com/android/systemui/Rune.smali
system_ext/priv-app/SystemUI/SystemUI.apk/smali/com/android/systemui/QpRune.smali
"
for f in $FTP; do
    sed -i "s/CscFeature_Common_SupportZProjectFunctionInGlobal/CscFeature_Setting_SupportRealTimeNetworkSpeed/g" "$APKTOOL_DIR/$f"
done
