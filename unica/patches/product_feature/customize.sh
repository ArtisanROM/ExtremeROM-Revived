# [
APPLY_PATCH()
{
    local PATCH
    local OUT

    DECODE_APK "$1"

    cd "$APKTOOL_DIR/$1"
    PATCH="$SRC_DIR/unica/patches/product_feature/$2"
    OUT="$(patch -p1 -s -t -N --dry-run < "$PATCH")" \
        || echo "$OUT" | grep -q "Skipping patch" || false
    patch -p1 -s -t -N --no-backup-if-mismatch < "$PATCH" &> /dev/null || true
    cd - &> /dev/null
}

GET_FP_SENSOR_TYPE()
{
    if [[ "$1" == *"ultrasonic"* ]]; then
        echo "ultrasonic"
    elif [[ "$1" == *"optical"* ]]; then
        echo "optical"
    elif [[ "$1" == *"side"* ]]; then
        echo "side"
    else
        echo "Unsupported type: $1"
        exit 1
    fi
}
# ]

MODEL=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 1)
REGION=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 2)

if $SOURCE_AUDIO_SUPPORT_ACH_RINGTONE; then
    if ! $TARGET_AUDIO_SUPPORT_ACH_RINGTONE; then
        echo "Applying ACH ringtone patches"
        APPLY_PATCH "system/framework/framework.jar" "audio/ach/framework.jar/0001-Disable-ACH-ringtone-support.patch"
    fi
else
    if $TARGET_AUDIO_SUPPORT_ACH_RINGTONE; then
        # TODO: won't be necessary anyway
        true
    fi
fi

if $SOURCE_AUDIO_SUPPORT_DUAL_SPEAKER; then
    if ! $TARGET_AUDIO_SUPPORT_DUAL_SPEAKER; then
        echo "Applying dual speaker patches"
        APPLY_PATCH "system/framework/framework.jar" "audio/dual_speaker/framework.jar/0001-Disable-dual-speaker-support.patch"
        APPLY_PATCH "system/framework/services.jar" "audio/dual_speaker/services.jar/0001-Disable-dual-speaker-support.patch"
    fi
else
    if $TARGET_AUDIO_SUPPORT_DUAL_SPEAKER; then
        # TODO: won't be necessary anyway
        true
    fi
fi

if $SOURCE_AUDIO_SUPPORT_VIRTUAL_VIBRATION; then
    if ! $TARGET_AUDIO_SUPPORT_VIRTUAL_VIBRATION; then
        echo "Applying virtual vibration patches"
        APPLY_PATCH "system/framework/framework.jar" "audio/virtual_vib/framework.jar/0001-Disable-virtual-vibration-support.patch"
        APPLY_PATCH "system/framework/services.jar" "audio/virtual_vib/services.jar/0001-Disable-virtual-vibration-support.patch"
        APPLY_PATCH "system/priv-app/SecSettings/SecSettings.apk" "audio/virtual_vib/SecSettings.apk/0001-Disable-virtual-vibration-support.patch"
        APPLY_PATCH "system/priv-app/SettingsProvider/SettingsProvider.apk" "audio/virtual_vib/SettingsProvider.apk/0001-Disable-virtual-vibration-support.patch"
    fi
else
    if $TARGET_AUDIO_SUPPORT_VIRTUAL_VIBRATION; then
        # TODO: won't be necessary anyway
        true
    fi
fi

if [[ "$SOURCE_AUTO_BRIGHTNESS_TYPE" != "$TARGET_AUTO_BRIGHTNESS_TYPE" ]]; then
    echo "Applying auto brightness type patches"

    DECODE_APK "system/framework/services.jar"
    DECODE_APK "system/framework/ssrm.jar"
    DECODE_APK "system/priv-app/SecSettings/SecSettings.apk"

    FTP="
    system/framework/services.jar/smali_classes2/com/android/server/power/PowerManagerUtil.smali
    system/framework/ssrm.jar/smali/com/android/server/ssrm/PreMonitor.smali
    system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/Rune.smali
    "
    for f in $FTP; do
        sed -i "s/\"$SOURCE_AUTO_BRIGHTNESS_TYPE\"/\"$TARGET_AUTO_BRIGHTNESS_TYPE\"/g" "$APKTOOL_DIR/$f"
    done
fi

if [[ "$(GET_FP_SENSOR_TYPE "$SOURCE_FP_SENSOR_CONFIG")" != "$(GET_FP_SENSOR_TYPE "$TARGET_FP_SENSOR_CONFIG")" ]]; then
    echo "Applying fingerprint sensor patches"

    DECODE_APK "system/framework/framework.jar"
    DECODE_APK "system/framework/services.jar"
    DECODE_APK "system/priv-app/SecSettings/SecSettings.apk"

    FTP="
    system/framework/framework.jar/smali_classes2/android/hardware/fingerprint/FingerprintManager.smali
    system/framework/framework.jar/smali_classes2/android/hardware/fingerprint/HidlFingerprintSensorConfig.smali
    system/framework/framework.jar/smali_classes5/com/samsung/android/bio/fingerprint/SemFingerprintManager.smali
    system/framework/framework.jar/smali_classes5/com/samsung/android/bio/fingerprint/SemFingerprintManager\$Characteristics.smali
    system/framework/framework.jar/smali_classes6/com/samsung/android/rune/InputRune.smali
    system/framework/services.jar/smali/com/android/server/biometrics/sensors/fingerprint/FingerprintUtils.smali
    system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/biometrics/fingerprint/FingerprintSettingsUtils.smali
    "
    for f in $FTP; do
        sed -i "s/$SOURCE_FP_SENSOR_CONFIG/$TARGET_FP_SENSOR_CONFIG/g" "$APKTOOL_DIR/$f"
    done

    # TODO: handle ultrasonic devices
    if [[ "$(GET_FP_SENSOR_TYPE "$TARGET_FP_SENSOR_CONFIG")" == "optical" ]]; then
        ADD_TO_WORK_DIR "a56xxx" "system" "."
        DELETE_FROM_WORK_DIR "system" "system/priv-app/BiometricSetting/oat"
    elif [[ "$(GET_FP_SENSOR_TYPE "$TARGET_FP_SENSOR_CONFIG")" == "side" ]]; then
        ADD_TO_WORK_DIR "a26xxx" "system" "."
        DELETE_FROM_WORK_DIR "system" "system/priv-app/BiometricSetting/oat"
    fi
fi

if [[ "$SOURCE_MDNIE_SUPPORTED_MODES" != "$TARGET_MDNIE_SUPPORTED_MODES" ]] || \
    [[ "$SOURCE_MDNIE_WEAKNESS_SOLUTION_FUNCTION" != "$TARGET_MDNIE_WEAKNESS_SOLUTION_FUNCTION" ]]; then
    echo "Applying mDNIe features patches"

    DECODE_APK "system/framework/services.jar"

    FTP="
    system/framework/services.jar/smali_classes2/com/samsung/android/hardware/display/SemMdnieManagerService.smali
    "
    for f in $FTP; do
        sed -i "s/\"$SOURCE_MDNIE_SUPPORTED_MODES\"/\"$TARGET_MDNIE_SUPPORTED_MODES\"/g" "$APKTOOL_DIR/$f"
        sed -i "s/\"$SOURCE_MDNIE_WEAKNESS_SOLUTION_FUNCTION\"/\"$TARGET_MDNIE_WEAKNESS_SOLUTION_FUNCTION\"/g" "$APKTOOL_DIR/$f"
    done
fi
if $SOURCE_HAS_HW_MDNIE; then
    if ! $TARGET_HAS_HW_MDNIE; then
        echo "Applying HW mDNIe patches"
        SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_LCD_SUPPORT_MDNIE_HW" --delete
        APPLY_PATCH "system/framework/framework.jar" "mdnie/hw/framework.jar/0001-Disable-HW-mDNIe.patch"
        APPLY_PATCH "system/framework/services.jar" "mdnie/hw/services.jar/0001-Disable-HW-mDNIe.patch"
    fi
else
    if $TARGET_HAS_HW_MDNIE; then
        # TODO: add HW mDNIe support
        true
    fi
fi
if $SOURCE_MDNIE_SUPPORT_HDR_EFFECT; then
    if ! $TARGET_MDNIE_SUPPORT_HDR_EFFECT; then
        echo "Applying mDNIe HDR effect patches"
        SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_COMMON_SUPPORT_HDR_EFFECT" --delete
        APPLY_PATCH "system/priv-app/SecSettings/SecSettings.apk" "mdnie/hdr/SecSettings.apk/0001-Disable-HDR-Settings.patch"
        APPLY_PATCH "system/priv-app/SettingsProvider/SettingsProvider.apk" "mdnie/hdr/SettingsProvider.apk/0001-Disable-HDR-Settings.patch"
    fi
else
    if $TARGET_MDNIE_SUPPORT_HDR_EFFECT; then
        # TODO: won't be necessary anyway
        true
    fi
fi

if $SOURCE_HAS_QHD_DISPLAY; then
    if ! $TARGET_HAS_QHD_DISPLAY; then
        echo "Applying multi resolution patches"
        ADD_TO_WORK_DIR "e1sxxx" "system" "."
        #APPLY_PATCH "system/framework/framework.jar" "resolution/framework.jar/0001-Enable-dynamic-resolution-control.patch"
        #APPLY_PATCH "system/priv-app/SecSettings/SecSettings.apk" "resolution/SecSettings.apk/0001-Enable-dynamic-resolution-control.patch"
    fi
fi

if [[ "$SOURCE_HFR_MODE" != "$TARGET_HFR_MODE" ]]; then
    echo "Applying HFR_MODE patches"

    DECODE_APK "system/framework/framework.jar"
    DECODE_APK "system/framework/gamemanager.jar"
    DECODE_APK "system/framework/secinputdev-service.jar"
    DECODE_APK "system/priv-app/SecSettings/SecSettings.apk"
    DECODE_APK "system/priv-app/SettingsProvider/SettingsProvider.apk"
    DECODE_APK "system_ext/priv-app/SystemUI/SystemUI.apk"

    FTP="
    system/framework/framework.jar/smali_classes6/com/samsung/android/hardware/display/RefreshRateConfig.smali
    system/framework/framework.jar/smali_classes6/com/samsung/android/rune/CoreRune.smali
    system/framework/gamemanager.jar/smali/com/samsung/android/game/GameManagerService.smali
    system/framework/secinputdev-service.jar/smali/com/samsung/android/hardware/secinputdev/SemInputDeviceManagerService.smali
    system/framework/secinputdev-service.jar/smali/com/samsung/android/hardware/secinputdev/SemInputFeatures.smali
    system/framework/secinputdev-service.jar/smali/com/samsung/android/hardware/secinputdev/SemInputFeaturesExtra.smali
    system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/display/SecDisplayUtils.smali
    system/priv-app/SettingsProvider/SettingsProvider.apk/smali/com/android/providers/settings/DatabaseHelper.smali
    system_ext/priv-app/SystemUI/SystemUI.apk/smali/com/android/systemui/LsRune.smali
    "
    for f in $FTP; do
        sed -i "s/\"$SOURCE_HFR_MODE\"/\"$TARGET_HFR_MODE\"/g" "$APKTOOL_DIR/$f"
    done
fi

if [[ "$SOURCE_HFR_SUPPORTED_REFRESH_RATE" != "$TARGET_HFR_SUPPORTED_REFRESH_RATE" ]]; then
    echo "Applying HFR_SUPPORTED_REFRESH_RATE patches"

    DECODE_APK "system/framework/framework.jar"
    DECODE_APK "system/priv-app/SecSettings/SecSettings.apk"

    FTP="
    system/framework/framework.jar/smali_classes6/com/samsung/android/hardware/display/RefreshRateConfig.smali
    system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/display/SecDisplayUtils.smali
    "
    for f in $FTP; do
        if [[ "$TARGET_HFR_SUPPORTED_REFRESH_RATE" != "none" ]]; then
            sed -i "s/\"$SOURCE_HFR_SUPPORTED_REFRESH_RATE\"/\"$TARGET_HFR_SUPPORTED_REFRESH_RATE\"/g" "$APKTOOL_DIR/$f"
        else
            sed -i "s/\"$SOURCE_HFR_SUPPORTED_REFRESH_RATE\"/\"\"/g" "$APKTOOL_DIR/$f"
        fi
    done
fi
if [[ "$SOURCE_HFR_DEFAULT_REFRESH_RATE" != "$TARGET_HFR_DEFAULT_REFRESH_RATE" ]]; then
    echo "Applying HFR_DEFAULT_REFRESH_RATE patches"

    DECODE_APK "system/framework/framework.jar"
    DECODE_APK "system/priv-app/SecSettings/SecSettings.apk"
    DECODE_APK "system/priv-app/SettingsProvider/SettingsProvider.apk"

    FTP="
    system/framework/framework.jar/smali_classes6/com/samsung/android/hardware/display/RefreshRateConfig.smali
    system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/display/SecDisplayUtils.smali
    system/priv-app/SettingsProvider/SettingsProvider.apk/smali/com/android/providers/settings/DatabaseHelper.smali
    "
    for f in $FTP; do
        sed -i "s/\"$SOURCE_HFR_DEFAULT_REFRESH_RATE\"/\"$TARGET_HFR_DEFAULT_REFRESH_RATE\"/g" "$APKTOOL_DIR/$f"
    done
fi

if [[ "$TARGET_DISPLAY_CUTOUT_TYPE" == "right" ]]; then
    echo "Applying right cutout patch"
    APPLY_PATCH "system_ext/priv-app/SystemUI/SystemUI.apk" "cutout/SystemUI.apk/0001-Add-right-cutout-support.patch"
fi

if [[ "$SOURCE_MULTI_MIC_MANAGER_VERSION" != "$TARGET_MULTI_MIC_MANAGER_VERSION" ]]; then
    echo "Applying SemMultiMicManager patches"

    DECODE_APK "system/framework/framework.jar"

    FTP="
    system/framework/framework.jar/smali_classes5/com/samsung/android/camera/mic/SemMultiMicManager.smali
    "
    for f in $FTP; do
        sed -i "s/$SOURCE_MULTI_MIC_MANAGER_VERSION/$TARGET_MULTI_MIC_MANAGER_VERSION/g" "$APKTOOL_DIR/$f"
    done
fi

if [[ "$SOURCE_SSRM_CONFIG_NAME" != "$TARGET_SSRM_CONFIG_NAME" ]]; then
    echo "Applying SSRM patches"

    DECODE_APK "system/framework/ssrm.jar"

    FTP="
    system/framework/ssrm.jar/smali/com/android/server/ssrm/Feature.smali
    "
    for f in $FTP; do
        sed -i "s/$SOURCE_SSRM_CONFIG_NAME/$TARGET_SSRM_CONFIG_NAME/g" "$APKTOOL_DIR/$f"
    done
fi
if [[ "$SOURCE_DVFS_CONFIG_NAME" != "$TARGET_DVFS_CONFIG_NAME" ]]; then
    echo "Applying DVFS patches"

    DECODE_APK "system/framework/ssrm.jar"

    FTP="
    system/framework/ssrm.jar/smali/com/android/server/ssrm/Feature.smali
    "
    for f in $FTP; do
        sed -i "s/$SOURCE_DVFS_CONFIG_NAME/$TARGET_DVFS_CONFIG_NAME/g" "$APKTOOL_DIR/$f"
    done
fi

if $SOURCE_IS_ESIM_SUPPORTED; then
    if ! $TARGET_IS_ESIM_SUPPORTED; then
        SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_COMMON_CONFIG_EMBEDDED_SIM_SLOTSWITCH" --delete
        SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_COMMON_SUPPORT_EMBEDDED_SIM" --delete
    fi
fi

if [ ! -f "$FW_DIR/${MODEL}_${REGION}/vendor/etc/permissions/android.hardware.strongbox_keystore.xml" ]; then
    echo "Applying strongbox patches"
    APPLY_PATCH "system/framework/framework.jar" "strongbox/framework.jar/0001-Disable-StrongBox-in-DevRootKeyATCmd.patch"
fi
