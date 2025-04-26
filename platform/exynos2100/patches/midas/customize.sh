# Fix MIDAS model detection
sed -i "s/$SOURCE_CODENAME/dummy/g" "$WORK_DIR/vendor/etc/midas/midas_config.json"
sed -i "s/p3s/$SOURCE_CODENAME/g" "$WORK_DIR/vendor/etc/midas/midas_config.json"

# Add S21 Photo Remaster Service
DELETE_FROM_WORK_DIR "system" "system/priv-app/PhotoRemasterService/oat"
ADD_TO_WORK_DIR "p3sxxx" "system" "system/priv-app/PhotoRemasterService/PhotoRemasterService.apk"

# Add S21 MIDAS libraries
ADD_TO_WORK_DIR "p3sxxx" "system" "system/lib64/libmidas_core.camera.samsung.so"
ADD_TO_WORK_DIR "p3sxxx" "system" "system/lib64/libmidas_DNNInterface.camera.samsung.so"
