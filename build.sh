#!/bin/bash

# Скрипт для сборки BluetoothAutoSleeper приложения с daemon'ом

APP_NAME="BluetoothAutoSleeper"
BUNDLE_ID="com.example.BluetoothAutoSleeper"

echo "🔨 Building $APP_NAME..."

# Создаем структуру .app
mkdir -p "$APP_NAME.app/Contents/MacOS"
mkdir -p "$APP_NAME.app/Contents/Resources"

# Копируем Info.plist
cp Info.plist "$APP_NAME.app/Contents/"

# Копируем иконку
if [ -f "BluetoothAutoSleeper.icns" ]; then
    cp BluetoothAutoSleeper.icns "$APP_NAME.app/Contents/Resources/"
    echo "✅ Icon copied"
else
    echo "⚠️ Icon not found, skipping..."
fi

echo "📦 Compiling GUI application..."
# Компилируем GUI приложение
swiftc -o "$APP_NAME.app/Contents/MacOS/$APP_NAME" \
    -target x86_64-apple-macos11.0 \
    -framework SwiftUI \
    -framework Cocoa \
    -framework IOBluetooth \
    -framework IOKit \
    Main.swift \
    AppDelegate.swift \
    ContentView.swift \
    LogsView.swift \
    DaemonManager.swift

if [ $? -ne 0 ]; then
    echo "❌ GUI build failed!"
    exit 1
fi

echo "⚙️ Compiling daemon..."
# Компилируем daemon
swiftc -o "$APP_NAME.app/Contents/MacOS/BluetoothAutoSleeperDemon" \
    -target x86_64-apple-macos11.0 \
    -framework Cocoa \
    -framework IOBluetooth \
    -framework IOKit \
    BluetoothDaemon.swift

if [ $? -ne 0 ]; then
    echo "❌ Daemon build failed!"
    exit 1
fi

echo "✅ Build successful!"
echo "📦 App bundle created: $APP_NAME.app"
echo ""
echo "Components:"
echo "  - GUI Application: $APP_NAME.app/Contents/MacOS/$APP_NAME"
echo "  - Background Daemon: $APP_NAME.app/Contents/MacOS/BluetoothAutoSleeperDemon"
echo ""
echo "To run the app:"
echo "open $APP_NAME.app"
echo ""
echo "To install the app:"
echo "cp -r $APP_NAME.app /Applications/"
echo ""
echo "The daemon will be managed by the GUI application." 