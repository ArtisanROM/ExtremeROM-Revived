echo "Removing UWB HAL from vendor"

BLOBS_LIST="
bin/hw/vendor.samsung.hardware.uwb@1.0-service
etc/uwb_key
etc/libuwb-nxp.conf
etc/libuwb-uci.conf
etc/init/init.vendor.uwb.rc
etc/init/nxp-uwb-service.rc
etc/vintf/manifest/uwb-service.xml
"
for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "vendor" "$blob"
done
