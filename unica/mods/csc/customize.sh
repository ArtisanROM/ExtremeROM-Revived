CSCFEATURES="
<CscFeature_VoiceCall_ConfigRecording>RecordingAllowed</CscFeature_VoiceCall_ConfigRecording>
<CscFeature_Setting_SupportRealTimeNetworkSpeed>TRUE</CscFeature_Setting_SupportRealTimeNetworkSpeed>
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
