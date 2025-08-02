LOG_STEP_IN "- Adding target Photo Remaster Service"
DELETE_FROM_WORK_DIR "system" "system/priv-app/PhotoRemasterService/oat"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/priv-app/PhotoRemasterService/PhotoRemasterService.apk"
LOG_STEP_OUT

LOG_STEP_IN "- Adding target MIDAS libraries"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libmidas_core.camera.samsung.so"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libmidas_DNNInterface.camera.samsung.so"
LOG_STEP_OUT

LOG "- Fixing MIDAS model detection"
sed -i "s/ro.product.device/ro.product.vendor.device/g" "$WORK_DIR/vendor/etc/midas/midas_config.json"
