MODEL=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 1)
REGION=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 2)

if [ ! -d "$FW_DIR/${MODEL}_${REGION}/system/system/app/UwbUci" ]; then
    echo "Removing UWB blobs..."
    DELETE_FROM_WORK_DIR "system" "system/app/UwbUci"
    DELETE_FROM_WORK_DIR "system" "system/app/UwbTest"
    DELETE_FROM_WORK_DIR "system" "system/etc/init/init.system.uwb.rc"
    DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.samsung.android.uwb_extras.xml"
    DELETE_FROM_WORK_DIR "system" "system/etc/permissions/samsung.uwb.xml"
    DELETE_FROM_WORK_DIR "system" "system/framework/com.samsung.android.uwb_extras.jar"
    DELETE_FROM_WORK_DIR "system" "system/framework/samsung.uwb.jar"
    DELETE_FROM_WORK_DIR "system" "system/lib/libtflite_uwb_jni.so"
    DELETE_FROM_WORK_DIR "system" "system/lib/libuwb_uci_jni_rust.so"
    DELETE_FROM_WORK_DIR "system" "system/lib64/libtflite_uwb_jni.so"
    DELETE_FROM_WORK_DIR "system" "system/lib64/libuwb_uci_jni_rust.so"
else
    echo "Target has UWB. Ignoring."
fi
