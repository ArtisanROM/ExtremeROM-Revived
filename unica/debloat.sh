#
# Copyright (C) 2023 Salvo Giangreco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# UN1CA debloat list
# - Add entries inside the specific partition containing that file (<PARTITION>_DEBLOAT+="")
# - DO NOT add the partition name at the start of any entry (eg. "/system/dpolicy_system")
# - DO NOT add a slash at the start of any entry (eg. "/dpolicy_system")

# Samsung Defex policy
SYSTEM_DEBLOAT+="
dpolicy_system
"
VENDOR_DEBLOAT+="
etc/dpolicy
"

# Samsung SIM Unlock
SYSTEM_DEBLOAT+="
system/bin/ssud
system/etc/init/ssu_pa3qxxx.rc
system/etc/init/ssu.rc
system/etc/permissions/privapp-permissions-com.samsung.ssu.xml
system/etc/sysconfig/samsungsimunlock.xml
system/lib64/android.security.securekeygeneration-ndk.so
system/lib64/vendor.samsung.hardware.security.ssu-V1-ndk.so
system/lib64/libssu_keystore2.so
system/priv-app/SsuService
"

# Recovery restoration script
VENDOR_DEBLOAT+="
recovery-from-boot.p
bin/install-recovery.sh
etc/init/vendor_flash_recovery.rc
"

# SEPolicy version
VENDOR_DEBLOAT+="
etc/selinux/vendor_sepolicy_version
"

# Apps debloat
PRODUCT_DEBLOAT+="
app/AssistantShell
app/Chrome64
app/Duo
app/Gmail2
app/Maps
app/Photos
app/YouTube
overlay/GmsConfigOverlaySearchSelector.apk
priv-app/Messages
priv-app/SearchSelector
"

SYSTEM_DEBLOAT+="
system/app/DRParser
system/app/HMT
system/app/DictDiotekForSec
system/app/FactoryAirCommandManager
system/app/FBAppManager_NS
system/app/PlayAutoInstallConfig
system/app/SamsungCalendar
system/app/SamsungPassAutofill_v1
system/app/StickerCenter
system/app/Fast
system/app/Rampart
system/app/KidsHome_Installer
system/app/SamsungTTSVoice_ar_AE_m00_ICLM
system/app/SamsungTTSVoice_de_DE_f00
system/app/SamsungTTSVoice_en_GB_f00
system/app/SamsungTTSVoice_en_US_l03_ICLM
system/app/SamsungTTSVoice_es_ES_f00
system/app/SamsungTTSVoice_es_MX_f00_ICLM
system/app/SamsungTTSVoice_es_US_f00
system/app/SamsungTTSVoice_fr_FR_f00
system/app/SamsungTTSVoice_hi_IN_f00_ICLM
system/app/SamsungTTSVoice_id_ID_f00_ICLM
system/app/SamsungTTSVoice_it_IT_f00
system/app/SamsungTTSVoice_pl_PL_f00
system/app/SamsungTTSVoice_pt_BR_f00
system/app/SamsungTTSVoice_ru_RU_f00
system/app/SamsungTTSVoice_th_TH_f00
system/app/SamsungTTSVoice_vi_VN_f00
system/etc/PF_TA
system/etc/init/samsung_pass_authenticator_service.rc
system/etc/permissions/privapp-permissions-com.microsoft.skydrive.xml
system/etc/permissions/privapp-permissions-com.samsung.android.app.kfa.xml
system/etc/permissions/privapp-permissions-com.samsung.android.authfw.xml
system/etc/permissions/privapp-permissions-com.samsung.android.dkey.xml
system/etc/permissions/privapp-permissions-com.samsung.android.game.gamehome.xml
system/etc/permissions/privapp-permissions-com.samsung.android.providers.factory.xml
system/etc/permissions/privapp-permissions-com.samsung.android.samsungpass.xml
system/etc/permissions/privapp-permissions-com.samsung.android.spayfw.xml
system/etc/permissions/privapp-permissions-com.sec.android.diagmonagent.xml
system/etc/permissions/privapp-permissions-com.sec.android.soagent.xml
system/etc/permissions/privapp-permissions-com.sec.bcservice.xml
system/etc/permissions/privapp-permissions-com.wssyncmldm.xml
system/etc/permissions/privapp-permissions-de.axelspringer.yana.zeropage.xml
system/etc/permissions/privapp-permissions-meta.xml
system/etc/sysconfig/digitalkey.xml
system/etc/sysconfig/meta-hiddenapi-package-allowlist.xml
system/etc/sysconfig/preinstalled-packages-com.samsung.android.dkey.xml
system/etc/sysconfig/preinstalled-packages-com.samsung.android.spayfw.xml
system/etc/sysconfig/samsungauthframework.xml
system/etc/sysconfig/samsungpassapp.xml
system/hidden/SmartTutor
system/preload/Facebook_stub_preload
system/priv-app/AuthFramework
system/priv-app/AREmojiEditor
system/priv-app/AREmoji
system/priv-app/AvatarEmojiEditor
system/priv-app/SamsungSmartSuggestions
system/priv-app/YourPhone_P1_5
system/priv-app/StickerFaceARAvatar
system/priv-app/SamsungBilling
system/priv-app/BCService
system/priv-app/DeviceKeystring
system/priv-app/DiagMonAgent94
system/priv-app/DigitalKey
system/priv-app/FBInstaller_NS
system/priv-app/FBServices
system/priv-app/FactoryTestProvider
system/priv-app/FotaAgent
system/priv-app/GameHome
system/priv-app/ModemServiceMode
system/priv-app/OneDrive_Samsung_v3
system/priv-app/OMCAgent5
system/priv-app/PaymentFramework
system/priv-app/SOAgent75
system/priv-app/SamsungCarKeyFw
system/priv-app/SamsungPass
system/priv-app/SPPPushClient
system/priv-app/Upday
"

# Gallery AI Semantic Search
SYSTEM_DEBLOAT+="
system/etc/default-permissions/default-permissions-com.samsung.mediasearch.xml
system/etc/mediasearch
system/etc/permissions/privapp-permissions-com.samsung.mediasearch.xml
system/priv-app/MediaSearch
"

# eSIM
if $SOURCE_IS_ESIM_SUPPORTED; then
    if ! $TARGET_IS_ESIM_SUPPORTED; then
        SYSTEM_DEBLOAT+="
        system/etc/permissions/privapp-permissions-com.samsung.android.app.esimkeystring.xml
        system/etc/permissions/privapp-permissions-com.samsung.euicc.mep.xml
        system/etc/sysconfig/preinstalled-packages-com.samsung.android.app.esimkeystring.xml
        system/etc/sysconfig/preinstalled-packages-com.samsung.euicc.xml
        system/priv-app/EsimKeyString
        system/priv-app/EsimClient
        system/priv-app/EuiccService
        "
    fi
fi

# fabric_crypto
if [[ "$TARGET_API_LEVEL" -lt 34 ]]; then
    SYSTEM_DEBLOAT+="
    system/bin/fabric_crypto
    system/etc/init/fabric_crypto.rc
    system/etc/permissions/FabricCryptoLib.xml
    system/etc/permissions/privapp-permissions-com.samsung.android.kmxservice.xml
    system/etc/vintf/manifest/fabric_crypto_manifest.xml
    system/framework/FabricCryptoLib.jar
    system/lib64/com.samsung.security.fabric.cryptod-V1-cpp.so
    system/lib64/vendor.samsung.hardware.security.fkeymaster-V1-cpp.so
    system/lib64/vendor.samsung.hardware.security.fkeymaster-V1-ndk.so
    system/priv-app/KmxService
    "
fi
