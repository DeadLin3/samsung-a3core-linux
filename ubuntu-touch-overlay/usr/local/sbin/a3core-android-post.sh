#!/bin/bash
for d in com.android.runtime com.android.i18n com.android.vndk.v30; do
    if [ -d "/userdata/android-apex/$d" ]; then
        mkdir -p "/android/apex/$d"
        mountpoint -q "/android/apex/$d" || mount --bind "/userdata/android-apex/$d" "/android/apex/$d"
    fi
done
for b in binder hwbinder vndbinder; do
    if [ -e "/dev/binderfs/$b" ]; then
        chmod 0666 "/dev/binderfs/$b"
        rm -f "/dev/$b"
        ln -s "/dev/binderfs/$b" "/dev/$b"
    fi
done
for dev in /dev/ion /dev/pvr_sync /dev/dri/card0 /dev/dri/card1 /dev/dri/renderD128; do
    [ -e "$dev" ] && chmod 0666 "$dev" || true
done
[ -w /sys/class/backlight/sprd_backlight/brightness ] && echo 255 > /sys/class/backlight/sprd_backlight/brightness || true

# Configure Spreadtrum SC2721 + external FS15xx speaker PA
if command -v amixer >/dev/null 2>&1; then
    amixer -c 0 cset name="Inter PA Config" 304 >/dev/null 2>&1 || true
    amixer -c 0 cset name="SmartAmp Boost" 0 >/dev/null 2>&1 || true
    amixer -c 0 cset name="Speaker1 Function" 0 >/dev/null 2>&1 || true
    amixer -c 0 cset name="DACLSPKL Enable" 0 >/dev/null 2>&1 || true
    amixer -c 0 cset name="DACRSPKL Enable" 0 >/dev/null 2>&1 || true
    amixer -c 0 cset name="SPKL Mixer DACLSPKL Switch" 0 >/dev/null 2>&1 || true
    amixer -c 0 cset name="HPL EAR Sel" 1 >/dev/null 2>&1 || true
    amixer -c 0 cset name="HPL Mixer DACLHPL Switch" 1 >/dev/null 2>&1 || true
    amixer -c 0 cset name="HPR Mixer DACRHPR Switch" 1 >/dev/null 2>&1 || true
    amixer -c 0 cset name="Virt HP Jack Switch" 1 >/dev/null 2>&1 || true
    amixer -c 0 cset name="VBC DAC0 Mixer Mux Sel" 2 >/dev/null 2>&1 || true
    amixer -c 0 cset name="VBC DAC1 Mixer Mux Sel" 2 >/dev/null 2>&1 || true
    amixer -c 0 cset name="HPL Playback Volume" 6 >/dev/null 2>&1 || true
    amixer -c 0 cset name="HPR Playback Volume" 6 >/dev/null 2>&1 || true
    amixer -c 0 cset name="DAC Playback Volume" 2 >/dev/null 2>&1 || true
    amixer -c 0 cset name="Speaker Function" 1 >/dev/null 2>&1 || true
    amixer -c 0 cset name="Speaker Mute" 0 >/dev/null 2>&1 || true
fi
