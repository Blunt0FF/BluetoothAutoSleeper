import SwiftUI

@main
struct BluetoothAutoSleeperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 350, minHeight: 250)
        }
    }
} 