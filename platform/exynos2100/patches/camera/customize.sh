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
system/lib64/libMultiFrameProcessing30.camera.samsung.so
system/lib64/libMultiFrameProcessing30.snapwrapper.camera.samsung.so
system/lib64/libMultiFrameProcessing30Tuning.camera.samsung.so
system/lib64/libSwIsp_core.camera.samsung.so
system/lib64/libSwIsp_wrapper_v1.camera.samsung.so
system/lib64/libVideoClassifier.camera.samsung.so
system/lib64/libsecuresnap_aidl.snap.samsung.so
system/lib64/libDocShadowRemoval.arcsoft.so
system/lib64/libHpr_RecFace_dl_v1.0.camera.samsung.so
system/lib64/libImageSegmenter_v1.camera.samsung.so
system/lib64/libObjectDetector_v1.camera.samsung.so
system/lib64/libSceneDetector_v1.camera.samsung.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done

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
