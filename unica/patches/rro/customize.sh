if [[ -d "$SRC_DIR/target/$TARGET_CODENAME/overlay" ]]; then
    DECODE_APK "/product/overlay/framework-res__pa3qxxx__auto_generated_rro_product.apk"

    echo "Applying stock overlay configs"
    rm -rf "$APKTOOL_DIR/product/overlay/framework-res__pa3qxxx__auto_generated_rro_product.apk/res"
    cp -a --preserve=all \
        "$SRC_DIR/target/$TARGET_CODENAME/overlay" \
        "$APKTOOL_DIR/product/overlay/framework-res__pa3qxxx__auto_generated_rro_product.apk/res"
fi

# TODO: Add a proper check if we need to remove this
DELETE_FROM_WORK_DIR "product" "overlay/SystemUI__r12sxxx__auto_generated_rro_product.apk"
