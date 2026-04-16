#!/usr/bin/env bash
# HyperOS Debloat Script (Linux / macOS)
# Tested on: Xiaomi / POCO / Redmi devices running HyperOS
# Curated for India — removes bloatware, ads, games, and unnecessary services
#
# Requirements:
#   - ADB installed: sudo apt install android-tools-adb
#   - USB Debugging enabled on your phone
#   - Phone connected via USB
#
# Usage:
#   chmod +x debloat.sh
#   ./debloat.sh

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Disable colors when stdout is not a terminal (e.g. piped or redirected)
if [ ! -t 1 ]; then
    GREEN='' YELLOW='' RED='' CYAN='' BOLD='' DIM='' NC=''
fi

PACKAGES=(
    # --- WPS / Kingsoft ---
    "cn.wps.moffice_eng"
    "cn.wps.xiaomi.abroad.lite"

    # --- Amazon ---
    "com.amazon.appmanager"
    "com.amazon.fv"
    "com.amazon.kindle"
    "com.amazon.mp3"
    "com.amazon.mshop.android"
    "com.amazon.mshop.android.shopping"
    "com.amazon.venezia"

    # --- AliExpress / Temu / Lemon ---
    "com.alibaba.aliexpresshd"
    "com.einnovation.temu"
    "com.lemon.lvoverseas"

    # --- AOSP apps you probably don't need ---
    "com.android.bips"
    "com.android.bookmarkprovider"
    "com.android.deskclock"
    "com.android.dreams.basic"
    "com.android.egg"
    "com.android.hotwordenrollment.okgoogle"
    "com.android.hotwordenrollment.xgoogle"
    "com.android.printspooler"
    "com.android.providers.downloads.ui"
    "com.android.stk"
    "com.android.stk.overlay.miui"

    # --- Audible / Booking / TripAdvisor ---
    "com.audible.application"
    "com.booking"
    "com.tripadvisor.tripadvisor"

    # --- Bitdefender ---
    "com.bitdefender.security"

    # --- Casual / Puzzle Games ---
    "com.block.juggle"
    "com.block.puzzle.game.hippo.mi"
    "com.crazy.juicer.xm"
    "com.fugo.wow"
    "com.funtomic.matchmasters"
    "com.gameduell.tarot"
    "com.jewelsblast.ivygames.adventure.free"
    "com.nf.snake"
    "com.oakever.tiletrip"
    "com.plarium.raidlegends"
    "com.soulcompany.bubbleshooter.relaxing"
    "com.sukhavati.gotoplaying.bubble.bubbleshooter.mint"
    "com.tripledot.solitaire"
    "com.vitastudio.mahjong"
    "net.wooga.junes_journey_hidden_object_mystery_game"
    "com.mygalaxy"
    "com.blurb.checkout"

    # --- CNN Edge Panel ---
    "com.cnn.mobile.android.phone.edgepanel"

    # --- Duokan Remote Controller ---
    "com.duokan.phone.remotecontroller"

    # --- Facebook ---
    "com.facebook.appmanager"
    "com.facebook.katana"
    "com.facebook.orca"
    "com.facebook.services"
    "com.facebook.system"

    # --- Flipboard ---
    "com.flipboard.app"
    "com.flipboard.boxer.app"

    # --- Google apps ---
    "com.google.ambient.streaming"
    "com.google.android.apps.books"
    "com.google.android.apps.chromecast.app"
    "com.google.android.apps.docs"
    "com.google.android.apps.healthdata"
    "com.google.android.apps.magazines"
    "com.google.android.apps.plus"
    "com.google.android.apps.subscriptions.red"
    "com.google.android.apps.tachyon"
    "com.google.android.apps.wellbeing"
    "com.google.android.apps.youtube.music"
    "com.google.android.adservices.api"
    "com.google.android.feedback"
    "com.google.android.federatedcompute"
    "com.google.android.music"
    "com.google.android.ondevicepersonalization.services"
    "com.google.android.printservice.recommendation"
    "com.google.android.projection.gearhead"
    "com.google.android.talk"
    "com.google.android.videos"
    "com.google.android.youtube"
    "com.google.ar.core"
    "com.google.audio.hearing.visualization.accessibility.scribe"
    "com.google.mainline.adservices"
    "com.google.vr.vrcore"

    # --- IMDB ---
    "com.imdb.mobile"

    # --- Polaris Office ---
    "com.infraware.polarisoffice5"

    # --- LinkedIn ---
    "com.linkedin.android"

    # --- MediaTek Voice ---
    "com.mediatek.voicecommand"
    "com.mediatek.voiceunlock"

    # --- Mi Credit ---
    "com.micredit.in"

    # --- Microsoft ---
    "com.microsoft.office.excel"
    "com.microsoft.office.officehubrow"
    "com.microsoft.office.outlook"
    "com.microsoft.office.powerpoint"
    "com.microsoft.office.word"
    "com.microsoft.skydrive"
    "com.microsoftsdk.crossdeviceservicebroker"

    # --- MIUI / HyperOS bloat ---
    "com.miui.analytics"
    "com.miui.android.fashiongallery"
    "com.miui.audioeffect"
    "com.miui.audiomonitor"
    "com.miui.backup"
    "com.miui.bugreport"
    "com.miui.carlink"
    "com.miui.cleaner"
    "com.miui.cloudbackup"
    "com.miui.cloudservice"

    "com.miui.daemon"
    "com.miui.extraphoto"
    "com.miui.fm"
    "com.miui.fmservice"
    "com.miui.huanji"
    "com.miui.hybrid"
    "com.miui.hybrid.accessory"
    "com.miui.micloudsync"
    "com.miui.mishare.connectivity"
    "com.miui.misightservice"
    "com.miui.misound"
    "com.miui.miservice"
    "com.miui.miwallpaper"
    "com.miui.msa.global"
    "com.miui.notes"
    "com.miui.notification"
    "com.miui.personalassistant"
    "com.miui.phone.carriers.overlay.h3g"
    "com.miui.player"
    "com.miui.smsextra"
    "com.miui.systemadsolution"
    "com.miui.touchassistant"
    "com.miui.translation.kingsoft"
    "com.miui.translation.xmcloud"
    "com.miui.translation.youdao"
    "com.miui.translationservice"
    "com.miui.userguide"
    "com.miui.videoplayer"
    "com.miui.voiceassist"
    "com.miui.voiceassistoverlay"
    "com.miui.voicetrigger"
    "com.miui.weather2"
    "com.miui.yellowpage"

    # --- Mi Pay / Wallet ---
    "com.mipay.wallet.id"
    "com.mipay.wallet.in"
    "org.mipay.android.manager"
    "com.unionpay.tsmservice.mi"

    # --- Netflix ---
    "com.netflix.mediaclient"
    "com.netflix.partner.activation"

    # --- Opera ---
    "com.opera.browser"
    "com.opera.max.oem"
    "com.opera.preinstall"

    # --- Sec / Singtel ---
    "com.sec.android.app.withtv"
    "com.singtel.mysingtel"

    # --- Skype ---
    "com.skype.raider"

    # --- Sogou IME ---
    "com.sohu.inputmethod.sogou.xiaomi"

    # --- Spotify ---
    "com.spotify.music"

    # --- SwiftKey ---
    "com.touchtype.swiftkey"

    # --- Tencent / IFAA ---
    "com.tencent.soter.soterserver"
    "org.ifaa.aidl.manager"

    # --- Vlingo ---
    "com.vlingo.midas"

    # --- Xiaomi ---
    "com.mi.appfinder"
    "com.mi.global.pocobbs"
    "com.mi.global.pocostore"
    "com.mi.globalbrowser"
    "com.mi.globalminusscreen"
    "com.xiaomi.aiasst.vision"
    "com.xiaomi.barrage"
    "com.xiaomi.calendar"
    "com.xiaomi.discover"
    "com.xiaomi.finddevice"
    "com.xiaomi.gamecenter.sdk.service"
    "com.xiaomi.glgm"
    "com.xiaomi.joyose"
    "com.xiaomi.migameservice"
    "com.xiaomi.midrop"
    "com.xiaomi.mipicks"
    "com.xiaomi.mirecycle"
    "com.xiaomi.payment"
    "com.xiaomi.simactivate.service"
    "com.xiaomi.smarthome"
    "com.xiaomi.ugd"
    "com.xiaomi.xmsfkeeper"

    # --- Gaming optimization (safe to remove if you don't game) ---
    "com.enhance.gameservice"

    # --- TikTok ---
    "com.zhiliaoapp.musically"

    # --- AutoDoc ---
    "de.autodoc.gmbh"

    # --- Debug / Factory / Test ---
    "com.debug.loggerui"
    "com.huaqin.factory"
    "com.mi.AutoTest"
    "com.wdstechnology.android.kryten"
)

clear

echo -e "${CYAN}${BOLD}"
echo "  ╔════════════════════════════════════════╗"
echo "  ║        HyperOS Debloat Script          ║"
echo "  ║   Xiaomi / POCO / Redmi  •  India      ║"
echo "  ╚════════════════════════════════════════╝"
echo -e "${NC}"

# Check ADB is available
if ! command -v adb &> /dev/null; then
    echo -e "${RED}  [ERROR] 'adb' not found.${NC}"
    echo ""
    echo "  Install it with:"
    echo "    Ubuntu/Debian:  sudo apt install android-tools-adb"
    echo "    macOS:          brew install android-platform-tools"
    echo ""
    read -rp "  Press Enter to exit..."
    exit 1
fi

# Check device is connected
DEVICE_COUNT=$(adb devices 2>/dev/null | grep -c "device$" || true)
if [ "$DEVICE_COUNT" -eq 0 ]; then
    echo -e "${RED}  [ERROR] No device detected.${NC}"
    echo ""
    echo "  1. Enable Developer Options on your phone"
    echo "     (tap HyperOS version 7 times in About Phone)"
    echo "  2. Enable USB Debugging"
    echo "  3. Connect via USB and tap Allow when prompted"
    echo ""
    read -rp "  Press Enter to exit..."
    exit 1
fi

echo -e "  ${GREEN}✓ Device connected${NC}"
echo ""
echo -e "  ${YELLOW}Note:${NC} Packages are removed for your user only (--user 0)."
echo -e "  ${DIM}Everything can be restored from the Play Store or via ADB.${NC}"
echo ""
read -r -p "  Continue? [y/N] " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo ""
    echo "  Aborted."
    exit 0
fi

echo ""
echo -e "  ${DIM}────────────────────────────────────────────${NC}"

TOTAL=${#PACKAGES[@]}
SUCCESS=0
SKIPPED=0
FAILED=0

for i in "${!PACKAGES[@]}"; do
    PKG="${PACKAGES[$i]}"
    NUM=$((i + 1))

    printf "  ${DIM}[%3d/%d]${NC} %-52s" "$NUM" "$TOTAL" "$PKG"

    OUTPUT=$(adb shell pm uninstall -k --user 0 "$PKG" 2>&1)

    if echo "$OUTPUT" | grep -q "^Success"; then
        echo -e "${GREEN}✓ removed${NC}"
        SUCCESS=$((SUCCESS+1))
    elif echo "$OUTPUT" | grep -qiE "not installed|doesn't exist|Unknown package"; then
        echo -e "${DIM}— skipped${NC}"
        SKIPPED=$((SKIPPED+1))
    else
        echo -e "${RED}✗ failed${NC}"
        FAILED=$((FAILED+1))
    fi
done

echo -e "  ${DIM}────────────────────────────────────────────${NC}"
echo ""

if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}  ╔════════════════════════════════════════╗"
    echo -e "  ║            ✓  All done!                ║"
    echo -e "  ╚════════════════════════════════════════╝${NC}"
else
    echo -e "${YELLOW}${BOLD}  ╔════════════════════════════════════════╗"
    echo -e "  ║         Finished with errors           ║"
    echo -e "  ╚════════════════════════════════════════╝${NC}"
fi

echo ""
echo -e "  ${GREEN}  Removed${NC}  $SUCCESS packages"
echo -e "  ${DIM}  Skipped${NC}  $SKIPPED  (not installed on this device)"
if [ "$FAILED" -gt 0 ]; then
    echo -e "  ${RED}  Failed ${NC}  $FAILED"
fi
echo ""
echo -e "  ${YELLOW}→ Reboot your phone to apply all changes.${NC}"
echo ""

if [ "$SUCCESS" -gt 0 ] && [ "$FAILED" -eq 0 ]; then
    echo -e "  ${DIM}Tip: If gaming performance feels off, restore:${NC}"
    echo -e "  ${DIM}  adb shell cmd package install-existing com.xiaomi.joyose${NC}"
    echo -e "  ${DIM}  adb shell cmd package install-existing com.xiaomi.migameservice${NC}"
    echo -e "  ${DIM}  adb shell cmd package install-existing com.xiaomi.gamecenter.sdk.service${NC}"
    echo -e "  ${DIM}  adb shell cmd package install-existing com.enhance.gameservice${NC}"
    echo ""
fi

read -rp "  Press Enter to exit..."
