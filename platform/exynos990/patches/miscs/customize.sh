echo "Setting casefold props"
SET_PROP "vendor" "external_storage.projid.enabled" "1"
SET_PROP "vendor" "external_storage.casefold.enabled" "1"
SET_PROP "vendor" "external_storage.sdcardfs.enabled" "0"
SET_PROP "vendor" "persist.sys.fuse.passthrough.enable" "true"

echo "Enabling IncrementalFS"
SET_PROP "vendor" "ro.incremental.enable" "yes"

echo "Setting SF flags"
SET_PROP "vendor" "debug.sf.latch_unsignaled" "1"
SET_PROP "vendor" "debug.sf.high_fps_late_app_phase_offset_ns" "0"
SET_PROP "vendor" "debug.sf.high_fps_late_sf_phase_offset_ns" "0"

echo "Setting Adaptive HFR flags"
if [[ "$MODEL" != "c1s" && "$MODEL" != "c2s" && "$MODEL" != "r8s" ]]; then
    SET_PROP "vendor" "debug.sf.show_refresh_rate_overlay_render_rate" "true"
    SET_PROP "vendor" "ro.surface_flinger.game_default_frame_rate_override" "60"
    SET_PROP "vendor" "ro.surface_flinger.use_content_detection_for_refresh_rate" "true"
    SET_PROP "vendor" "ro.surface_flinger.set_touch_timer_ms" "300"
    SET_PROP "vendor" "ro.surface_flinger.set_idle_timer_ms" "600"
    SET_PROP "vendor" "ro.surface_flinger.enable_frame_rate_override" "true"
elif [[ "$MODEL" == "c1s" || "$MODEL" == "r8s" ]]; then
    SET_PROP "vendor" "debug.sf.show_refresh_rate_overlay_render_rate" "true"
    SET_PROP "vendor" "ro.surface_flinger.game_default_frame_rate_override" "60"
    SET_PROP "vendor" "ro.surface_flinger.use_content_detection_for_refresh_rate" "false"
    SET_PROP "vendor" "ro.surface_flinger.enable_frame_rate_override" "false"
elif [[ "$MODEL" == "c2s" ]]; then
    SET_PROP "vendor" "debug.sf.show_refresh_rate_overlay_render_rate" "true"
    SET_PROP "vendor" "ro.surface_flinger.game_default_frame_rate_override" "60"
fi

echo "Enable Vulkan"
SET_PROP "vendor" "ro.hwui.use_vulkan" "true"
SET_PROP "vendor" "debug.hwui.use_hint_manager" "true"

# Encryption
LINE="$(sed -n "/^\/dev\/block\/by-name\/userdata/=" "$WORK_DIR/vendor/etc/fstab.exynos990")"

echo "Switching to FBE v2"
FBE_V1="fileencryption=ice"
FBE_V2="fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized,metadata_encryption=aes-256-xts,keydirectory=/metadata/vold/metadata_encryption"
sed -i "${LINE}s|resgid=5678|resgid=5678,inlinecrypt|g" "$WORK_DIR/vendor/etc/fstab.exynos990" \
    && sed -i "${LINE}s|$FBE_V1|$FBE_V2|g" "$WORK_DIR/vendor/etc/fstab.exynos990"

# Samsung ODE
ENTRIES="
ODE
keydata
keyrefuge
"
for e in $ENTRIES; do
    sed -i "/${e}/d" "$WORK_DIR/vendor/etc/fstab.exynos990"
done

# For some reason we are missing 2 permissions here: android.hardware.security.model.compatible and android.software.controls
# First one is related to encryption and second one to SmartThings Device Control
echo "Patching vendor permissions"
sed -i '$d' "$WORK_DIR/vendor/etc/permissions/handheld_core_hardware.xml"
{
    echo ""
    echo "    <!-- Indicate support for the Android security model per the CDD. -->"
    echo "    <feature name=\"android.hardware.security.model.compatible\"/>"
    echo ""
    echo "    <!--  Feature to specify if the device supports controls.  -->"
    echo "    <feature name=\"android.software.controls\"/>"
    echo "</permissions>"
} >> "$WORK_DIR/vendor/etc/permissions/handheld_core_hardware.xml"
