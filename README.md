# Samsung Galaxy A03 Core (`SM-A032F` / `a3core`) — Linux (Ubuntu Touch & postmarketOS)

**Ubuntu Touch 20.04 Focal (`armhf`)** and **postmarketOS (`aarch64`)** port for **Samsung Galaxy A03 Core (`SM-A032F`, Unisoc SC9863A, kernel `4.14.199`)** running on top of stock Android 13 `vendor`/`system`.

## Status (Ubuntu Touch)
- **Working:** Display (`720×1600`, `GRID_UNIT_PX=16`, PowerVR Rogue GE8322 OpenGL ES 3.2), touchscreen (`ilitek_tddi`), Wi-Fi (`sprdwl_ng`), speaker audio via external `fs15xxx` amplifier (`HPL`/`HPR` routing + `Inter PA Config=304`), OpenStore, app installation & launch, Terminal & on-screen keyboard (`maliit-server`), brightness control (`repowerd`).
- **Known minor issues:**
  - Brightness slider operates in the `0..255` range (out of `4095` in `sprd_backlight`).
  - Cosmetic 1px vertical seam down the center of `LomiriShape` app icons (PowerVR Rogue GE8322 shader quirk).

## Repository Contents
- `kernel/a3core_defconfig` — Kernel `4.14.199` configuration (with `CONFIG_SPRD_WATCHDOG_FIQ`/`PMIC` enabled and `CONFIG_BRIDGE_NETFILTER` disabled for `sk_buff` ABI compatibility with `sprdwl_ng.ko`).
- `kernel/seccomp.c` — Guard patch preventing kernel panics on corrupted `tsk->seccomp.filter` pointers.
- `ubuntu-touch-overlay/` — Device scripts and configuration files (`a3core-android-prep.sh`, `a3core-android-post.sh`, `lxc/android`, `pulse/touch.pa`, `deviceinfo`, `getprop`/`aa-exec` wrappers).
- **GitHub Releases (`v1.0`):**
  - `ubuntu-touch-a3core-boot.img` + `ubuntu-touch-a3core-rootfs.img.xz`
  - `postmarketos-a3core-boot.img` + `postmarketos-a3core-rootfs.img.xz`

## Installation (Ubuntu Touch over stock Android 13)
1. Extract `ubuntu-touch-a3core-rootfs.img.xz` (`xz -d ubuntu-touch-a3core-rootfs.img.xz`) and place `ubuntu-touch-a3core-rootfs.img` as `/data/rootfs.img` (on the `userdata` partition).
2. Flash `ubuntu-touch-a3core-boot.img` to the `boot` partition (`/dev/mmcblk0p40` via Heimdall / TWRP / fastboot).
3. Reboot the device. Initial Wi-Fi setup can be done directly in the Lomiri UI.
