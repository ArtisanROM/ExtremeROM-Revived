MODEL=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 1)
REGION=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 2)

if [ ! -d "$FW_DIR/${MODEL}_${REGION}/system/system/media/audio/pensounds" ]; then
    echo "Debloating SPen Blobs"
    DELETE_FROM_WORK_DIR "system" "system/app/AirGlance"
    DELETE_FROM_WORK_DIR "system" "system/app/LiveDrawing"
    DELETE_FROM_WORK_DIR "system" "system/etc/default-permissions/default-permissions-com.samsung.android.service.aircommand.xml"
    DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.app.readingglass.xml"
    DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.service.aircommand.xml"
    DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.service.airviewdictionary.xml"
    DELETE_FROM_WORK_DIR "system" "system/etc/sysconfig/airviewdictionaryservice.xml"
    DELETE_FROM_WORK_DIR "system" "system/etc/public.libraries-smps.samsung.txt"
    DELETE_FROM_WORK_DIR "system" "system/lib/libsmpsft.smps.samsung.so"
    DELETE_FROM_WORK_DIR "system" "system/lib64/libsmpsft.smps.samsung.so"
    DELETE_FROM_WORK_DIR "system" "system/media/audio/pensounds"
    DELETE_FROM_WORK_DIR "system" "system/priv-app/AirCommand"
    DELETE_FROM_WORK_DIR "system" "system/priv-app/AirReadingGlass"
    DELETE_FROM_WORK_DIR "system" "system/priv-app/SmartEye"

    SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_COMMON_CONFIG_BLE_SPEN_SPEC" --delete
    SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_COMMON_SUPPORT_BLE_SPEN" --delete
    SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_CONFIG_SPEN_GARAGE_SPEC" --delete
    SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_SETTINGS_CONFIG_SPEN_FCC_ID" --delete
    SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_CONFIG_SPEN_VERSION" "0"
else
    echo "SPen support detected in target device. Ignoring."
fi
