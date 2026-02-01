import SwiftUI

struct OfflineStorageView: View {
    @State private var offlineManager = OfflineManager.shared
    
    var body: some View {
        List {
            Section(header: Text("Storage Usage")) {
                HStack {
                    Text("Used Space")
                    Spacer()
                    // Real logic: In a real app we'd calculate directory size
                    // For now, let's estimate based on file count * avg size (e.g. 15MB)
                    let estimated = Double(offlineManager.downloadedContent.count) * 15.0
                    Text(String(format: "%.1f MB", estimated))
                        .foregroundStyle(Color.Text.secondary)
                }
                HStack {
                    Text("Free Space")
                    Spacer()
                    // Fetch real device free space if possible, else generic
                     Text(ByteCountFormatter.string(fromByteCount: Int64((try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[.systemFreeSize] as? Int) ?? 0), countStyle: .file))
                        .foregroundStyle(Color.Text.secondary)
                }
            }
            
            Section(header: Text("Downloaded Content")) {
                if offlineManager.downloadedContent.isEmpty {
                    Text("No downloaded content")
                        .foregroundStyle(Color.Text.secondary)
                } else {
                    ForEach(Array(offlineManager.downloadedContent).sorted(), id: \.self) { id in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(id) // Ideally fetch Name
                                    .fontWeight(.medium)
                                Text("Offline Bundle")
                                    .font(.caption)
                                    .foregroundStyle(Color.Text.secondary)
                            }
                            Spacer()
                            Button(action: {
                                Task { offlineManager.removeContent(for: id) }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundStyle(Color.State.error)
                            }
                        }
                    }
                }
            }
            
            Section {
                Button("Clear All Downloads") {
                    // Action
                }
                .foregroundStyle(Color.State.error)
            }
        }
        .navigationTitle("Offline Storage")
        .background(Color.Surface.secondary)
    }
}
