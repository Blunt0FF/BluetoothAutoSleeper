import SwiftUI

struct LogsView: View {
    @ObservedObject var daemonManager: DaemonManager
    @State private var logs: String = ""
    @State private var isAutoRefreshing = true
    @State private var refreshTimer: Timer?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // Заголовок
            HStack {
                Text("Daemon Logs")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Кнопка обновления
                Button("Refresh") {
                    refreshLogs()
                }
                
                // Переключатель авто-обновления
                Toggle("Auto-refresh", isOn: $isAutoRefreshing)
                    .toggleStyle(SwitchToggleStyle())
                
                // Кнопка очистки
                Button("Clear") {
                    daemonManager.clearLogs()
                    logs = ""
                }
                .foregroundColor(.red)
                
                // Кнопка закрытия
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .keyboardShortcut(.escape)
            }
            .padding()
            
            // Область логов
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(alignment: .leading, spacing: 2) {
                        if logs.isEmpty {
                            Text("No logs available")
                                .foregroundColor(.secondary)
                                .italic()
                        } else {
                            ForEach(logs.components(separatedBy: .newlines), id: \.self) { line in
                                if !line.isEmpty {
                                    HStack {
                                        Text(line)
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(getLogColor(for: line))
                                        Spacer()
                                    }
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 1)
                                    .background(
                                        line.contains("ERROR") ? Color.red.opacity(0.1) :
                                        line.contains("🚀") || line.contains("✅") ? Color.green.opacity(0.1) :
                                        Color.clear
                                    )
                                    .cornerRadius(2)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .onChange(of: logs) { _ in
                        // Автоматически прокручиваем к последней строке
                        if let lastLine = logs.components(separatedBy: .newlines).last {
                            proxy.scrollTo(lastLine, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(NSColor.textBackgroundColor))
            .border(Color.gray, width: 1)
            .frame(minHeight: 300)
            
            // Информация о daemon'е
            HStack {
                VStack(alignment: .leading) {
                    Text("Daemon Status: \(daemonManager.isDaemonRunning ? "RUNNING" : "STOPPED")")
                        .font(.caption)
                        .foregroundColor(daemonManager.isDaemonRunning ? .green : .red)
                    
                    Text("Bluetooth: \(daemonManager.isBluetoothEnabled ? "ON" : "OFF")")
                        .font(.caption)
                        .foregroundColor(daemonManager.isBluetoothEnabled ? .blue : .gray)
                }
                
                Spacer()
                
                Text("Logs update every 2 seconds")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .frame(width: 600, height: 400)
        .onAppear {
            refreshLogs()
            startAutoRefresh()
        }
        .onDisappear {
            stopAutoRefresh()
        }
    }
    
    private func refreshLogs() {
        logs = daemonManager.getDaemonLogs()
    }
    
    private func getLogColor(for line: String) -> Color {
        if line.contains("ERROR") || line.contains("❌") {
            return .red
        } else if line.contains("🚀") || line.contains("✅") {
            return .green
        } else if line.contains("💤") || line.contains("☀️") {
            return .blue
        } else if line.contains("🔵") {
            return .purple
        } else {
            return .primary
        }
    }
    
    private func startAutoRefresh() {
        guard isAutoRefreshing else { return }
        
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            if isAutoRefreshing {
                refreshLogs()
            }
        }
    }
    
    private func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
} 