import SwiftUI

struct OfflineStorageView: View {
    @State private var offlineManager = OfflineManager.shared
    @State private var downloadedItems: [String] = [] // Mock list
    
    var body: some View {
        List {
            Section(header: Text("Storage Usage")) {
                HStack {
                    Text("Used Space")
                    Spacer()
                    Text("1.2 GB") // Mock
                        .foregroundStyle(Color.Text.secondary)
                }
                HStack {
                    Text("Free Space")
                    Spacer()
                    Text("45 GB") // Mock
                        .foregroundStyle(Color.Text.secondary)
                }
            }
            
            Section(header: Text("Downloaded Content")) {
                if offlineManager.downloadedContent.isEmpty {
                    Text("No downloaded content")
                        .foregroundStyle(Color.Text.secondary)
                } else {
                    ForEach(Array(offlineManager.downloadedContent), id: \.self) { id in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(id) // Ideally fetch Name
                                    .fontWeight(.medium)
                                Text("350 MB")
                                    .font(.caption)
                                    .foregroundStyle(Color.Text.secondary)
                            }
                            Spacer()
                            Button(action: {
                                offlineManager.removeContent(for: id)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundStyle(Color.state.error)
                            }
                        }
                    }
                }
            }
            
            Section {
                Button("Clear All Downloads") {
                    // Action
                }
                .foregroundStyle(Color.state.error)
            }
        }
        .navigationTitle("Offline Storage")
        .background(Color.Surface.secondary)
    }
}
