if [[ "$TARGET_CODENAME" = "r11s" ]]; then # TODO: add r11s support to ExtremeKRNL
    LOG "- $TARGET_CODENAME detected, skipping ExtremeKRNL patch"
    exit 0
fi

# [
EXTREMEKRNL_REPO="https://github.com/ExtremeXT/android_kernel_samsung_s5e9925"

BUILD_KERNEL()
{
    local PARENT=$(pwd)
    cd $KERNEL_TMP_DIR

    EVAL "./build.sh -m ${TARGET_CODENAME} -k y"

    cd $PARENT
}

SAFE_PULL_CHANGES()
{
    set -eo pipefail

    local PARENT=$(pwd)

    cd "$KERNEL_TMP_DIR"

    EVAL "git fetch origin"

    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse origin/main)
    BASE=$(git merge-base @ origin/main)

    # Now we have three cases that we need to take care of.
    if [[ "$LOCAL" == "$REMOTE" ]]; then
        LOG "- Local branch is up-to-date with remote."
    elif [[ "$LOCAL" == "$BASE" ]]; then
        LOG "- Fast-forward possible. Pulling."
        EVAL "git pull --ff-only"
    elif [[ "$REMOTE" == "$BASE" ]]; then
        LOGW "- Local branch is ahead of remote. Not doing anything."
    else
        cd "$PARENT"
        ABORT "Remote history has diverged (possible force-push)."
    fi

    cd "$PARENT"
}

REPLACE_KERNEL_BINARIES()
{
    local KERNEL_TMP_DIR="$KERNEL_TMP_DIR-$TARGET_PLATFORM"
    [[ ! -d "$KERNEL_TMP_DIR" ]] && mkdir -p "$KERNEL_TMP_DIR"

    if [[ -d "$KERNEL_TMP_DIR/.git" ]]; then
        LOG "- Existing git repo found, trying to pull latest changes"
        if ! SAFE_PULL_CHANGES; then
            ABORT "Could not pull latest Kernel changes. If you hold local changes, please rebase to the new base. If not, cleaning the kernel_tmp_dir should suffice."
        fi
    else
        LOG "- Cloning ExtremeKernel"
        EVAL "git clone "$EXTREMEKRNL_REPO" --single-branch "$KERNEL_TMP_DIR" --recurse-submodules"
    fi

    LOG "- Running the kernel build script."
    BUILD_KERNEL

    for i in "boot" "dtbo" "vendor_boot"; do
        [[ -f "$WORK_DIR/kernel/$i.img" ]] && rm -f "$WORK_DIR/kernel/$i.img"
        mv -f "$KERNEL_TMP_DIR/build/out/$TARGET_CODENAME/$i.img" "$WORK_DIR/kernel/$i.img"
    done
}

UPDATE_MODULES()
{
    for i in "fingerprint" "fingerprint_sysfs" "input_booster_lkm" "sec_debug_coredump"; do
        mv -f "$KERNEL_TMP_DIR-$TARGET_PLATFORM/build/out/$TARGET_CODENAME/modules_dlkm/$i.ko" "$WORK_DIR/vendor_dlkm/lib/modules"
    done
    if [[ "$TARGET_CODENAME" == "r0s" || "$TARGET_CODENAME" == "r11s" ]]; then
        mv -f "$KERNEL_TMP_DIR-$TARGET_PLATFORM/build/out/$TARGET_CODENAME/modules_dlkm/wlan.ko" "$WORK_DIR/vendor_dlkm/lib/modules"
    else
        mv -f "$KERNEL_TMP_DIR-$TARGET_PLATFORM/build/out/$TARGET_CODENAME/modules_dlkm/dhd.ko" "$WORK_DIR/vendor_dlkm/lib/modules"
    fi
}
# ]

REPLACE_KERNEL_BINARIES
UPDATE_MODULES
