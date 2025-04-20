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
    done <<< "$CSCFEATURES"
done
