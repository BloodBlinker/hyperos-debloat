@echo off
:: HyperOS Debloat Script (Windows)
:: Tested on: Xiaomi / POCO / Redmi devices running HyperOS
:: Curated for India — removes bloatware, ads, games, and unnecessary services
::
:: Requirements:
::   - ADB (Android Debug Bridge) installed and in PATH
::     Download: https://developer.android.com/tools/releases/platform-tools
::   - USB Debugging enabled on your phone
::   - Phone connected via USB (or ADB over Wi-Fi)
::
:: Usage: Double-click debloat.bat (or run from Command Prompt)

setlocal EnableDelayedExpansion
title HyperOS Debloat Script

echo.
echo ========================================
echo    HyperOS Debloat Script
echo ========================================
echo.

:: Check ADB is available
where adb >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 'adb' not found.
    echo.
    echo  1. Download Android Platform Tools from:
    echo     https://developer.android.com/tools/releases/platform-tools
    echo  2. Extract the zip.
    echo  3. Either add the folder to PATH, or place this script inside the
    echo     extracted folder and run it from there.
    echo.
    pause
    exit /b 1
)

:: Check device is connected
adb devices | findstr /R "device$" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] No ADB device detected.
    echo.
    echo  1. Enable Developer Options on your phone.
    echo  2. Enable USB Debugging.
    echo  3. Connect via USB and tap "Allow" when prompted on the phone.
    echo.
    pause
    exit /b 1
)

echo [OK] Device detected.
echo.
echo WARNING: This will remove packages for the current user (--user 0).
echo          Apps can be restored via Google Play or:
echo          adb shell cmd package install-existing ^<package^>
echo.
set /p CONFIRM="Continue? [y/N]: "
if /i not "%CONFIRM%"=="y" (
    echo Aborted.
    pause
    exit /b 0
)
echo.

set SUCCESS=0
set SKIPPED=0
set FAILED=0
set TOTAL=181

set NUM=0
for %%P in (
    cn.wps.moffice_eng
    cn.wps.xiaomi.abroad.lite
    com.alibaba.aliexpresshd
    com.amazon.appmanager
    com.amazon.fv
    com.amazon.kindle
    com.amazon.mp3
    com.amazon.mshop.android
    com.amazon.mshop.android.shopping
    com.amazon.venezia
    com.android.bips
    com.android.bookmarkprovider
    com.android.deskclock
    com.android.dreams.basic
    com.android.egg
    com.android.hotwordenrollment.okgoogle
    com.android.hotwordenrollment.xgoogle
    com.android.printspooler
    com.android.providers.downloads.ui
    com.android.stk
    com.android.stk.overlay.miui
    com.audible.application
    com.bitdefender.security
    com.block.juggle
    com.block.puzzle.game.hippo.mi
    com.blurb.checkout
    com.booking
    com.cnn.mobile.android.phone.edgepanel
    com.crazy.juicer.xm
    com.debug.loggerui
    com.duokan.phone.remotecontroller
    com.einnovation.temu
    com.enhance.gameservice
    com.facebook.appmanager
    com.facebook.katana
    com.facebook.orca
    com.facebook.services
    com.facebook.system
    com.flipboard.app
    com.flipboard.boxer.app
    com.fugo.wow
    com.funtomic.matchmasters
    com.gameduell.tarot
    com.google.ambient.streaming
    com.google.android.adservices.api
    com.google.android.apps.books
    com.google.android.apps.chromecast.app
    com.google.android.apps.docs
    com.google.android.apps.healthdata
    com.google.android.apps.magazines
    com.google.android.apps.plus
    com.google.android.apps.subscriptions.red
    com.google.android.apps.tachyon
    com.google.android.apps.wellbeing
    com.google.android.apps.youtube.music
    com.google.android.feedback
    com.google.android.federatedcompute
    com.google.android.music
    com.google.android.ondevicepersonalization.services
    com.google.android.printservice.recommendation
    com.google.android.projection.gearhead
    com.google.android.talk
    com.google.android.videos
    com.google.android.youtube
    com.google.ar.core
    com.google.audio.hearing.visualization.accessibility.scribe
    com.google.mainline.adservices
    com.google.vr.vrcore
    com.huaqin.factory
    com.imdb.mobile
    com.infraware.polarisoffice5
    com.jewelsblast.ivygames.adventure.free
    com.lemon.lvoverseas
    com.linkedin.android
    com.mediatek.voicecommand
    com.mediatek.voiceunlock
    com.mi.appfinder
    com.mi.AutoTest
    com.mi.global.pocobbs
    com.mi.global.pocostore
    com.mi.globalbrowser
    com.mi.globalminusscreen
    com.micredit.in
    com.microsoft.office.excel
    com.microsoft.office.officehubrow
    com.microsoft.office.outlook
    com.microsoft.office.powerpoint
    com.microsoft.office.word
    com.microsoft.skydrive
    com.microsoftsdk.crossdeviceservicebroker
    com.miui.analytics
    com.miui.android.fashiongallery
    com.miui.audioeffect
    com.miui.audiomonitor
    com.miui.backup
    com.miui.bugreport
    com.miui.carlink
    com.miui.cleaner
    com.miui.cloudbackup
    com.miui.cloudservice

    com.miui.daemon
    com.miui.extraphoto
    com.miui.fm
    com.miui.fmservice
    com.miui.huanji
    com.miui.hybrid
    com.miui.hybrid.accessory
    com.miui.micloudsync
    com.miui.mishare.connectivity
    com.miui.misightservice
    com.miui.misound
    com.miui.miservice
    com.miui.miwallpaper
    com.miui.msa.global
    com.miui.notes
    com.miui.notification
    com.miui.personalassistant
    com.miui.phone.carriers.overlay.h3g
    com.miui.player
    com.miui.smsextra
    com.miui.systemadsolution
    com.miui.touchassistant
    com.miui.translation.kingsoft
    com.miui.translation.xmcloud
    com.miui.translation.youdao
    com.miui.translationservice
    com.miui.userguide
    com.miui.videoplayer
    com.miui.voiceassist
    com.miui.voiceassistoverlay
    com.miui.voicetrigger
    com.miui.weather2
    com.miui.yellowpage
    com.mipay.wallet.id
    com.mipay.wallet.in
    com.mygalaxy
    com.netflix.mediaclient
    com.netflix.partner.activation
    com.nf.snake
    com.oakever.tiletrip
    com.opera.browser
    com.opera.max.oem
    com.opera.preinstall
    com.plarium.raidlegends
    com.sec.android.app.withtv
    com.singtel.mysingtel
    com.skype.raider
    com.sohu.inputmethod.sogou.xiaomi
    com.soulcompany.bubbleshooter.relaxing
    com.spotify.music
    com.sukhavati.gotoplaying.bubble.bubbleshooter.mint
    com.tencent.soter.soterserver
    com.touchtype.swiftkey
    com.tripadvisor.tripadvisor
    com.tripledot.solitaire
    com.unionpay.tsmservice.mi
    com.vitastudio.mahjong
    com.vlingo.midas
    com.wdstechnology.android.kryten
    com.xiaomi.aiasst.vision
    com.xiaomi.barrage
    com.xiaomi.calendar
    com.xiaomi.discover
    com.xiaomi.finddevice
    com.xiaomi.gamecenter.sdk.service
    com.xiaomi.glgm
    com.xiaomi.joyose
    com.xiaomi.migameservice
    com.xiaomi.midrop
    com.xiaomi.mipicks
    com.xiaomi.mirecycle
    com.xiaomi.payment
    com.xiaomi.simactivate.service
    com.xiaomi.smarthome
    com.xiaomi.ugd
    com.xiaomi.xmsfkeeper
    com.zhiliaoapp.musically
    de.autodoc.gmbh
    net.wooga.junes_journey_hidden_object_mystery_game
    org.ifaa.aidl.manager
    org.mipay.android.manager
) do (
    set /a NUM+=1
    set PKG=%%P
    set "OUTPUT="
    for /f "delims=" %%O in ('adb shell pm uninstall -k --user 0 !PKG! 2^>^&1') do set OUTPUT=%%O

    <nul set /p "=[!NUM!/!TOTAL!] !PKG! ... "

    echo !OUTPUT! | findstr /i "^Success" >nul 2>&1
    if not errorlevel 1 (
        echo OK
        set /a SUCCESS+=1
    ) else (
        echo !OUTPUT! | findstr /i "not installed Unknown package" >nul 2>&1
        if not errorlevel 1 (
            echo Not installed
            set /a SKIPPED+=1
        ) else (
            echo FAILED - !OUTPUT!
            set /a FAILED+=1
        )
    )
)

echo.
echo ========================================
echo  Done.
echo    Removed : %SUCCESS%
echo    Skipped : %SKIPPED% (not present)
echo    Failed  : %FAILED%
echo ========================================
echo.
echo Reboot your phone for all changes to take effect.
echo.
if %SUCCESS% GTR 0 (
    echo Tip: If gaming performance feels off, restore these packages:
    echo   adb shell cmd package install-existing com.xiaomi.joyose
    echo   adb shell cmd package install-existing com.xiaomi.migameservice
    echo   adb shell cmd package install-existing com.xiaomi.gamecenter.sdk.service
    echo   adb shell cmd package install-existing com.enhance.gameservice
    echo.
)
pause
