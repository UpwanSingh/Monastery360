import SwiftUI

struct PermissionPrimingView: View {
    @Environment(DIContainer.self) var di
    @Environment(\.dismiss) var dismiss
    
    var onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Color.Surface.elevated.ignoresSafeArea()
            
            VStack(spacing: Space.lg) {
                Text("Enable Experiences")
                    .style(Typography.h2)
                    .padding(.top, Space.xl)
                
                Text("To show you nearby monasteries and enable 360 navigation, we need access to:")
                    .style(Typography.bodyMd)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Space.lg)
                
                VStack(alignment: .leading, spacing: Space.lg) {
                    PermissionRow(icon: "location.circle.fill", title: "Location", desc: "For nearby sanctuary discovery.")
                    PermissionRow(icon: "gyroscope", title: "Motion", desc: "For immersive 360° tours.")
                }
                .padding(Space.lg)
                
                Spacer()
                
                Button(action: {
                    requestPermissions()
                }) {
                    Text("Allow Access")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.Brand.primary)
                        .foregroundStyle(Color.Text.inverse)
                        .cornerRadius(Radius.pill)
                }
                .padding(.horizontal, Space.lg)
                
                Button("Not Now") {
                    onContinue()
                }
                .foregroundStyle(Color.Text.secondary)
                .padding(.bottom, Space.xl)
            }
        }
    }
    
    func requestPermissions() {
        Task {
            // Trigger Location Service
            await di.locationService.requestAuthorization()
            // Continue flow
            onContinue()
        }
    }
}

struct PermissionRow: View {
    let icon: String
    let title: String
    let desc: String
    
    var body: some View {
        HStack(spacing: Space.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.Brand.secondary)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(title).style(Typography.h3)
                Text(desc).style(Typography.caption).foregroundStyle(Color.Text.secondary)
            }
        }
    }
}
