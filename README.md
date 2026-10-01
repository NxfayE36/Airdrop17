# AirDrop17

Visual iOS-17-inspired AirDrop layer for iPhone 8 Plus / iOS 16.7.16 / Dopamine rootless.

### What it does
- Adds a dark blurred/glass AirDrop capsule over the native share sheet when AirDrop is detected.
- Shows an AirDrop icon and “Bring devices close together”.
- Spring entrance animation and pulsing proximity dots.
- Leaves Apple's native iOS 16 AirDrop transfer/discovery intact.

### Hardware limitation
The iPhone 8 Plus does not have U1 Ultra Wideband. Therefore this recreates the visual interaction; it does not reproduce Apple's UWB proximity protocol.

### Build
Requires Theos + iOS SDK/toolchain.
```sh
export THEOS_PACKAGE_SCHEME=rootless
make clean package FINALPACKAGE=1
```
The .deb will be in `packages/`.

### Install
Copy the resulting .deb to the phone and install with Sileo/Zebra.
