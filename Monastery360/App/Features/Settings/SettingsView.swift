import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("offlineMode") private var offlineMode = false
    
    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $isDarkMode)
            }
            
            Section("Network") {
                Toggle("Offline Mode", isOn: $offlineMode)
                Text("When enabled, only downloaded content will be shown.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            
            Section("Legal") {
                Text("Version 1.0.0")
            }
        }
        .navigationTitle("Settings")
    }
}
