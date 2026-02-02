import SwiftUI

struct OfflineStorageView: View {
    @Environment(\.diContainer) var di
    // Use computed property or just access di directly
    var offlineManager: OfflineManager { di.offlineManager }
    
    var body: some View {
        List {
            Section(header: Text("Storage Usage")) {
                HStack {
                    Text("Used Space")
                    Spacer()
                    Text(getUsedSpace())
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
                                Task { offlineManager.removeContent(for: id, tenantId: di.tenantService.currentTenantId) }
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
                    for id in offlineManager.downloadedContent {
                         offlineManager.removeContent(for: id, tenantId: di.tenantService.currentTenantId)
                    }
                }
                .foregroundStyle(Color.State.error)
            }
        }
        .navigationTitle("Offline Storage")
        .background(Color.Surface.secondary)
    }
    
    private func getUsedSpace() -> String {
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return "0 KB" }
        let downloadsURL = docs.appendingPathComponent("downloads").appendingPathComponent(di.tenantService.currentTenantId)
        
        guard let size = try? FileManager.default.allocatedSizeOfDirectory(at: downloadsURL) else { return "0 KB" }
        return ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
    }
}

extension FileManager {
    func allocatedSizeOfDirectory(at url: URL) throws -> UInt64 {
        var size: UInt64 = 0
        guard let enumerator = enumerator(at: url, includingPropertiesForKeys: [.totalFileAllocatedSizeKey]) else { return 0 }
        for case let fileURL as URL in enumerator {
            let values = try fileURL.resourceValues(forKeys: [.totalFileAllocatedSizeKey])
            size += UInt64(values.totalFileAllocatedSize ?? 0)
        }
        return size
    }
}
