#!/bin/bash

# Тестовый скрипт для проверки работы daemon'а BluetoothAutoSleeper

echo "🧪 Testing BluetoothAutoSleeper Daemon..."

DAEMON_PATH="./BluetoothAutoSleeper.app/Contents/MacOS/BluetoothAutoSleeperDemon"
PID_FILE="/tmp/bluetooth_daemon.pid"
LOG_FILE="/tmp/bluetooth_daemon.log"

# Функция для проверки состояния daemon'а
check_daemon_status() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "✅ Daemon is running (PID: $PID)"
            return 0
        else
            echo "❌ Daemon PID file exists but process is not running"
            return 1
        fi
    else
        echo "❌ Daemon is not running (no PID file)"
        return 1
    fi
}

# Функция для запуска daemon'а
start_daemon() {
    echo "🚀 Starting daemon..."
    if [ -f "$DAEMON_PATH" ]; then
        "$DAEMON_PATH" &
        sleep 2
        check_daemon_status
    else
        echo "❌ Daemon binary not found at $DAEMON_PATH"
        echo "Please build the app first with: ./build.sh"
        return 1
    fi
}

# Функция для остановки daemon'а
stop_daemon() {
    echo "🛑 Stopping daemon..."
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            kill -TERM "$PID"
            sleep 2
            if kill -0 "$PID" 2>/dev/null; then
                echo "⚠️ Daemon still running, using SIGKILL..."
                kill -KILL "$PID"
            fi
            echo "✅ Daemon stopped"
        else
            echo "⚠️ Daemon was not running"
        fi
        rm -f "$PID_FILE"
    else
        echo "⚠️ No PID file found"
    fi
}

# Функция для просмотра логов
show_logs() {
    echo "📋 Daemon logs:"
    if [ -f "$LOG_FILE" ]; then
        echo "----------------------------------------"
        tail -n 20 "$LOG_FILE"
        echo "----------------------------------------"
    else
        echo "📄 No logs available"
    fi
}

# Функция для очистки логов
clear_logs() {
    echo "🧹 Clearing logs..."
    rm -f "$LOG_FILE"
    echo "✅ Logs cleared"
}

# Главное меню
case "${1:-status}" in
    "start")
        start_daemon
        ;;
    "stop")
        stop_daemon
        ;;
    "restart")
        stop_daemon
        sleep 1
        start_daemon
        ;;
    "status")
        check_daemon_status
        ;;
    "logs")
        show_logs
        ;;
    "clear")
        clear_logs
        ;;
    "install-blueutil")
        echo "🔧 Installing blueutil for better Bluetooth control..."
        if command -v brew >/dev/null 2>&1; then
            brew install blueutil
            echo "✅ blueutil installed successfully"
        else
            echo "❌ Homebrew not found. Please install Homebrew first:"
            echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        fi
        ;;
    "bluetooth-status")
        echo "🔍 Checking Bluetooth status..."
        if command -v blueutil >/dev/null 2>&1; then
            POWER_STATUS=$(blueutil -p)
            echo "Bluetooth power: $POWER_STATUS"
            blueutil --connected
        else
            echo "⚠️ blueutil not installed. Use '$0 install-blueutil' to install it."
            echo "Alternative check via system_profiler:"
            system_profiler SPBluetoothDataType | grep -E "(Bluetooth|State|Connected)"
        fi
        ;;
    "test")
        echo "🧪 Full test sequence..."
        echo ""
        echo "1. Stopping any existing daemon..."
        stop_daemon
        echo ""
        echo "2. Starting daemon..."
        start_daemon
        echo ""
        echo "3. Checking status..."
        check_daemon_status
        echo ""
        echo "4. Showing logs..."
        show_logs
        echo ""
        echo "5. Daemon will continue running. Use '$0 stop' to stop it."
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|clear|bluetooth-status|install-blueutil|test}"
        echo ""
        echo "Commands:"
        echo "  start              - Start the daemon"
        echo "  stop               - Stop the daemon"
        echo "  restart            - Restart the daemon"
        echo "  status             - Check daemon status"
        echo "  logs               - Show daemon logs"
        echo "  clear              - Clear daemon logs"
        echo "  bluetooth-status   - Check current Bluetooth status and connections"
        echo "  install-blueutil   - Install blueutil for better Bluetooth control"
        echo "  test               - Run full test sequence"
        exit 1
        ;;
esac 