# BluetoothAutoSleeper

A simple Mac application that automatically manages Bluetooth power state during sleep and wake transitions.

## What the app does

- **Automatically disables Bluetooth** when Mac goes to sleep (with 5-second delay)
- **Automatically enables Bluetooth** when Mac wakes up
- **Smart delay** - if Mac wakes up within 5 seconds, Bluetooth stays connected
- Provides a control panel for managing the background process
- Runs independently in background mode regardless of GUI

## Key Features

### 🎧 Smart 5-Second Delay
- **Scenario**: User listens to music with headphones and accidentally closes MacBook
- **If wakes up within 5 seconds**: Bluetooth stays connected, music doesn't stop
- **If sleep lasts longer than 5 seconds**: Considered intentional, Bluetooth automatically disconnects

## Architecture

The application consists of two components:

1. **GUI Application** (`BluetoothAutoSleeper.app`) - control panel for management
2. **Background Daemon** (`BluetoothAutoSleeperDemon`) - background process that handles sleep/wake events

## Build and Installation

### Requirements
- macOS 11.0 or newer
- Xcode Command Line Tools installed
- Swift compiler

### Building
```bash
cd BluetoothAutoSleeper
chmod +x build.sh
./build.sh
```

### Installation
```bash
# Copy application to Applications folder
cp -r BluetoothAutoSleeper.app /Applications/

# Or run directly from current folder
open BluetoothAutoSleeper.app
```

## Usage

1. Launch BluetoothAutoSleeper.app
2. Click **START** button to launch the background daemon
3. The background process will run independently from GUI
4. When Mac goes to sleep:
   - Daemon starts **5-second countdown**
   - If Mac wakes up within 5 seconds → Bluetooth stays enabled
   - If sleep lasts > 5 seconds → Bluetooth automatically disconnects
5. When waking up after long sleep - Bluetooth automatically enables
6. Click **View Logs** to see daemon activity
7. Click **STOP** to stop the background process

## Testing

### Testing smart delay:
1. Enable Bluetooth and connect headphones
2. Start daemon: `./test_daemon.sh start`
3. **Quick wake**: Close MacBook and immediately open (< 5 sec) → Bluetooth stays enabled
4. **Long sleep**: Close MacBook and wait > 5 sec → Bluetooth disconnects
5. Check logs: `./test_daemon.sh logs`

### Key Features:
- **Daemon runs independently** - you can close GUI application, daemon continues running
- **Control panel** - GUI serves only for daemon management
- **Logging** - all events are logged for tracking

## Permissions

On first launch, the application may request permissions:
- **Accessibility** - for controlling system elements
- **AppleEvents** - for executing AppleScript commands

## Additional Features

The application supports two methods for Bluetooth control:
1. **AppleScript** - main method through system interface
2. **blueutil** - alternative method (if installed)

### Installing blueutil (optional)
```bash
brew install blueutil
```

## Notes

- **Daemon runs independently** - after starting you can close GUI
- **Logs** - all events are logged to `/tmp/bluetooth_daemon.log`
- **PID file** - daemon creates `/tmp/bluetooth_daemon.pid` file
- For full automation, you can add daemon to startup

## Project Structure

```
BluetoothAutoSleeper/
├── Main.swift                    # GUI application entry point
├── AppDelegate.swift             # GUI event handling
├── ContentView.swift             # Main interface (control panel)
├── LogsView.swift                # Logs viewing window
├── DaemonManager.swift           # Daemon management
├── BluetoothDaemon.swift         # Background process
├── Info.plist                    # Application settings
├── BluetoothAutoSleeper.icns     # Application icon
├── build.sh                      # Build script
└── README.md                     # Documentation
```

## Components in Built Application

```
BluetoothAutoSleeper.app/
├── Contents/
│   ├── Info.plist
│   ├── MacOS/
│   │   ├── BluetoothAutoSleeper       # GUI application
│   │   └── BluetoothAutoSleeperDemon  # Background process
│   └── Resources/
│       └── BluetoothAutoSleeper.icns
```

## License

MIT License 