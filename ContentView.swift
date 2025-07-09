import SwiftUI

struct ContentView: View {
    @StateObject private var daemonManager = DaemonManager()
    @State private var showingLogs = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Заголовок
            Text("BluetoothAutoSleeper")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            // Иконка Bluetooth + статус daemon'а
            HStack(spacing: 20) {
                // Bluetooth статус
                VStack {
                    Image(systemName: daemonManager.isBluetoothEnabled ? "bluetooth" : "bluetooth.slash")
                        .font(.system(size: 40))
                        .foregroundColor(daemonManager.isBluetoothEnabled ? .blue : .gray)
                    
                    Text("Bluetooth")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Стрелка
                Image(systemName: "arrow.right")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                // Daemon статус
                VStack {
                    Image(systemName: daemonManager.isDaemonRunning ? "gear.circle.fill" : "gear.circle")
                        .font(.system(size: 40))
                        .foregroundColor(daemonManager.isDaemonRunning ? .green : .gray)
                    
                    Text("Daemon")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Статус системы
            VStack(spacing: 8) {
                Text("Bluetooth: \(daemonManager.isBluetoothEnabled ? "ON" : "OFF")")
                    .font(.headline)
                    .foregroundColor(daemonManager.isBluetoothEnabled ? .green : .red)
                
                Text("Auto-sleep daemon: \(daemonManager.isDaemonRunning ? "RUNNING" : "STOPPED")")
                    .font(.subheadline)
                    .foregroundColor(daemonManager.isDaemonRunning ? .green : .red)
            }
            
            // Описание приложения
            VStack(alignment: .leading, spacing: 8) {
                Text("This application automatically manages Bluetooth power state:")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("•")
                        Text("Disables Bluetooth when Mac goes to sleep")
                    }
                    HStack {
                        Text("•")
                        Text("Enables Bluetooth when Mac wakes up")
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Главная кнопка On/Off
            Button(action: {
                daemonManager.toggleDaemon()
            }) {
                HStack {
                    Image(systemName: daemonManager.isDaemonRunning ? "stop.circle.fill" : "play.circle.fill")
                        .font(.title2)
                    Text(daemonManager.isDaemonRunning ? "STOP" : "START")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    daemonManager.isDaemonRunning ? 
                    Color.red : Color.green
                )
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
            
            // Кнопка для просмотра логов
            Button("View Logs") {
                showingLogs = true
            }
            .padding(.horizontal)
            
            // Дополнительная информация
            Text("The background daemon runs independently from this control panel")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showingLogs) {
            LogsView(daemonManager: daemonManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 350, height: 250)
    }
} 