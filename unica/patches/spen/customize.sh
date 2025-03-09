SKIPUNZIP=1

# [
REMOVE_FROM_WORK_DIR()
{
    local FILE_PATH="$1"

    if [ -e "$FILE_PATH" ]; then
        local FILE
        local PARTITION
        FILE="$(echo -n "$FILE_PATH" | sed "s.$WORK_DIR/..")"
        PARTITION="$(echo -n "$FILE" | cut -d "/" -f 1)"

        echo "Debloating /$FILE"
        rm -rf "$FILE_PATH"

        [[ "$PARTITION" == "system" ]] && FILE="$(echo "$FILE" | sed 's.^system/system/.system/.')"
        FILE="$(echo -n "$FILE" | sed 's/\//\\\//g')"
        sed -i "/$FILE /d" "$WORK_DIR/configs/fs_config-$PARTITION"

        FILE="$(echo -n "$FILE" | sed 's/\./\\\\\./g')"
        sed -i "/$FILE /d" "$WORK_DIR/configs/file_context-$PARTITION"
    fi
}
# ]

SET_CONFIG()
{
    local CONFIG="$1"
    local VALUE="$2"
    local FILE="$WORK_DIR/system/system/etc/floating_feature.xml"

    if [[ "$2" == "-d" ]] || [[ "$2" == "--delete" ]]; then
        CONFIG="$(echo -n "$CONFIG" | sed 's/=//g')"
        if grep -Fq "$CONFIG" "$FILE"; then
            echo "Deleting \"$CONFIG\" config in /system/system/etc/floating_feature.xml"
            sed -i "/$CONFIG/d" "$FILE"
        fi
    else
        if grep -Fq "<$CONFIG>" "$FILE"; then
            echo "Replacing \"$CONFIG\" config with \"$VALUE\" in /system/system/etc/floating_feature.xml"
            sed -i "$(sed -n "/<${CONFIG}>/=" "$FILE") c\ \ \ \ <${CONFIG}>${VALUE}</${CONFIG}>" "$FILE"
        else
            echo "Adding \"$CONFIG\" config with \"$VALUE\" in /system/system/etc/floating_feature.xml"
            sed -i "/<\/SecFloatingFeatureSet>/d" "$FILE"
            if ! grep -q "Added by unica" "$FILE"; then
                echo "    <!-- Added by unica/patches/floating_feature/customize.sh -->" >> "$FILE"
            fi
            echo "    <${CONFIG}>${VALUE}</${CONFIG}>" >> "$FILE"
            echo "</SecFloatingFeatureSet>" >> "$FILE"
        fi
    fi
}
# ]

MODEL=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 1)
REGION=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 2)

if [ ! -d "$FW_DIR/${MODEL}_${REGION}/system/system/media/audio/pensounds" ]; then
    echo "Debloating SPen Blobs"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/app/AirGlance"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/app/LiveDrawing"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/etc/default-permissions/default-permissions-com.samsung.android.service.aircommand.xml"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.android.app.readingglass.xml"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.android.service.aircommand.xml"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.android.service.airviewdictionary.xml"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/etc/sysconfig/airviewdictionaryservice.xml"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/etc/public.libraries-smps.samsung.txt"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib/libsmpsft.smps.samsung.so"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/lib64/libsmpsft.smps.samsung.so"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/media/audio/pensounds"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/priv-app/AirCommand"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/priv-app/AirReadingGlass"
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/system/priv-app/SmartEye"

    SET_CONFIG "SEC_FLOATING_FEATURE_COMMON_CONFIG_BLE_SPEN_SPEC" --delete
    SET_CONFIG "SEC_FLOATING_FEATURE_COMMON_SUPPORT_BLE_SPEN" --delete
    SET_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_CONFIG_SPEN_GARAGE_SPEC" --delete
    SET_CONFIG "SEC_FLOATING_FEATURE_SETTINGS_CONFIG_SPEN_FCC_ID" --delete
    SET_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_CONFIG_SPEN_VERSION" "0"
else
    echo "SPen support detected in target device. Ignoring."
fi
