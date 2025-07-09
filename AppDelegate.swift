import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var daemonManager: DaemonManager?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("BluetoothAutoSleeper GUI started")
        
        // Создаем менеджер daemon'а
        daemonManager = DaemonManager()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        print("BluetoothAutoSleeper GUI terminating")
        
        // При завершении GUI НЕ останавливаем daemon - он должен работать независимо
        // Пользователь может явно остановить daemon через интерфейс
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Разрешаем приложению завершиться при закрытии последнего окна
        return true
    }
} 