import SwiftUI

struct M360Toggle: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
                .style(Typography.bodyMd)
                .foregroundStyle(Color.Text.primary)
        }
        .tint(Color.Brand.primary)
    }
}
