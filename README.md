# Samsung Galaxy A03 Core (`SM-A032F` / `a3core`) — Linux (Ubuntu Touch & postmarketOS)

Порт **Ubuntu Touch 20.04 Focal (`armhf`)** и **postmarketOS (`aarch64`)** для **Samsung Galaxy A03 Core (`SM-A032F`, Unisoc SC9863A, ядро `4.14.199`)** поверх стокового `vendor`/`system` (Android 13).

## Статус (Ubuntu Touch)
- **Работает:** дисплей (`720×1600`, `GRID_UNIT_PX=16`, PowerVR Rogue GE8322 OpenGL ES 3.2), тачскрин (`ilitek_tddi`), Wi-Fi (`sprdwl_ng`), звук через внешний усилитель `fs15xxx` (`HPL`/`HPR` + `Inter PA Config=304`), OpenStore, установка/запуск приложений, терминал и экранная клавиатура (`maliit-server`), регулировка яркости (`repowerd`).
- **Известные мелочи:**
  - Яркость регулируется в диапазоне `0..255` (из `4095` в `sprd_backlight`).
  - Вертикальный шов 1px по центру иконок `LomiriShape` (особенность драйвера PowerVR Rogue GE8322, чисто косметическая).

## Содержимое репозитория
- `kernel/a3core_defconfig` — конфигурация ядра `4.14.199` (с включёнными `CONFIG_SPRD_WATCHDOG_FIQ`/`PMIC` и отключённым `CONFIG_BRIDGE_NETFILTER` для совместимости `sk_buff` с `sprdwl_ng.ko`).
- `kernel/seccomp.c` — патч защиты от паники при повреждённом указателе `tsk->seccomp.filter`.
- `ubuntu-touch-overlay/` — конфиги и скрипты устройства (`a3core-android-prep.sh`, `a3core-android-post.sh`, `lxc/android`, `pulse/touch.pa`, `deviceinfo`, `getprop`/`aa-exec` обёртки).
- `releases/` (в GitHub Releases):
  - `ubuntu-touch-a3core-boot.img` + `ubuntu-touch-a3core-rootfs.img.xz`
  - `postmarketos-a3core-boot.img` + `postmarketos-a3core-rootfs.img.xz`

## Установка Ubuntu Touch (поверх стокового Android 13)
1. Распакуйте `ubuntu-touch-a3core-rootfs.img.xz` (`xz -d ubuntu-touch-a3core-rootfs.img.xz`) и поместите `ubuntu-touch-a3core-rootfs.img` как `/data/rootfs.img` (на раздел `userdata`).
2. Прошейте `ubuntu-touch-a3core-boot.img` в раздел `boot` (`/dev/mmcblk0p40` через `heimdall` / TWRP / `fastboot`).
3. Перезагрузите устройство. Первичная настройка Wi-Fi выполняется стандартно через интерфейс Lomiri.
