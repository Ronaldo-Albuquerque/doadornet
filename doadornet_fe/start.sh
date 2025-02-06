#!/bin/bash

# emulator @raa_emulador &
# sleep 10  # Aguarda 10 segundos para garantir que o emulador iniciou
# flutter run


flutter emulators
flutter emulators --launch raa_emulator
sleep 30
adb install build/app/outputs/flutter-apk/app-debug.apk
emulator -avd raa_emulator -verbose
flutter run