BLOBS_LIST="
system/lib64/libpic_best.arcsoft.so
system/lib64/libdualcam_portraitlighting_gallery_360.so
system/lib64/libarcsoft_dualcam_portraitlighting.so
system/lib64/libdualcam_refocus_gallery_54.so
system/lib64/libdualcam_refocus_gallery_50.so
system/lib64/libsuper_fusion.arcsoft.so
system/lib64/libdualcam_refocus_image_lite.so
system/lib64/libhybrid_high_dynamic_range.arcsoft.so
system/lib64/libae_bracket_hdr.arcsoft.so
system/lib64/libface_recognition.arcsoft.so
system/lib64/libmf_bayer_enhance.arcsoft.so
system/lib64/libDualCamBokehCapture.camera.samsung.so
system/lib64/libai_fusion_high_resolution.arcsoft.so
system/lib64/libai_fusion_high_resolution_base_v1.arcsoft.so
system/lib64/libai_fusion_high_resolution_base_v2.arcsoft.so
system/lib64/libBayerAIPhoto.camera.samsung.so
system/lib64/libbayeraiphoto_wrapper_v1.camera.samsung.so
system/lib64/libBayerAIPhotoTuning.camera.samsung.so
system/lib64/libFusionAIPhoto.camera.samsung.so
system/lib64/libFusionAIPhoto_wrapper.camera.samsung.so
system/lib64/libFusionAIPhotoTuning.camera.samsung.so
"
for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "system" "$blob"
done

echo "Add stock camera libs"
BLOBS_LIST="
system/lib64/libMultiFrameProcessing20.camera.samsung.so
system/lib64/libMultiFrameProcessing20Core.camera.samsung.so
system/lib64/libMultiFrameProcessing20Day.camera.samsung.so
system/lib64/libMultiFrameProcessing20Tuning.camera.samsung.so
system/lib64/libMultiFrameProcessing30.camera.samsung.so
system/lib64/libMultiFrameProcessing30.snapwrapper.camera.samsung.so
system/lib64/libMultiFrameProcessing30Tuning.camera.samsung.so
system/lib64/libGeoTrans10.so
system/lib64/vendor.samsung_slsi.hardware.geoTransService@1.0.so
system/lib64/libSwIsp_core.camera.samsung.so
system/lib64/libSwIsp_wrapper_v1.camera.samsung.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done

if [[ "$MODEL" == "c1s" || "$MODEL" == "c2s" ]]; then
    BLOBS_LIST="
    system/lib64/libofi_seva.so
    system/lib64/libofi_klm.so
    system/lib64/libofi_plugin.so
    system/lib64/libofi_rt_framework_user.so
    system/lib64/libofi_service_interface.so
    system/lib64/libofi_gc.so
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
    done
fi

# Add libc++_shared.so dependency for __cxa_demangle symbol
patchelf --add-needed "libc++_shared.so" "$WORK_DIR/system/system/lib64/libMultiFrameProcessing20Core.camera.samsung.so"

# Patch libstagefright.so to remove HDR10+ check
HEX_PATCH "$WORK_DIR/system/system/lib64/libstagefright.so" "010140f9cf390594a0500034" "010140f91f2003d51f2003d5"

# Add prebuilt libs from other devices
BLOBS_LIST="
system/lib64/libc++_shared.so
system/lib64/libtensorflowLite.camera.samsung.so
system/lib64/libtensorflowlite_c.camera.samsung.so
system/lib64/libtensorflowlite_inference_api.camera.samsung.so
system/lib64/libtensorflowlite_jni_voicecommand.so
system/lib64/libtensorflowLite2_11_0_dynamic_camera.so
system/lib64/libsaiv_HprFace_cmh_support_jni.camera.samsung.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "e2sxxx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done

BLOBS_LIST="
system/lib64/libeden_wrapper_system.so
system/lib64/libhigh_dynamic_range.arcsoft.so
system/lib64/liblow_light_hdr.arcsoft.so
system/lib64/libhigh_res.arcsoft.so
system/lib64/libsnap_aidl.snap.samsung.so
system/lib64/libsuperresolution.arcsoft.so
system/lib64/libsuperresolution_raw.arcsoft.so
system/lib64/libsuperresolution_wrapper_v2.camera.samsung.so
system/lib64/libsuperresolutionraw_wrapper_v2.camera.samsung.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "p3sxxx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done

# S21 SWISP models
DELETE_FROM_WORK_DIR "vendor" "saiv/swisp_1.0"
ADD_TO_WORK_DIR "p3sxxx" "vendor" "saiv/swisp_1.0"

BLOBS_LIST="
system/lib64/libSwIsp_core.camera.samsung.so
system/lib64/libSwIsp_wrapper_v1.camera.samsung.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "p3sxxx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done

# Polarr SDK
ADD_TO_WORK_DIR "a26xxx" "system" "." 0 0 644 "u:object_r:system_file:s0"
