import SwiftUI

struct Toast: Equatable {
    var message: String
    var type: ToastType = .info
    var duration: Double = 3.0
}

enum ToastType {
    case info, success, error
    
    var color: Color {
        switch self {
        case .info: return Color.Brand.primary
        case .success: return Color.state.success
        case .error: return Color.state.error
        }
    }
    
    var icon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "exclamationmark.triangle.fill"
        }
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    if let toast = toast {
                        VStack {
                            Spacer()
                            HStack(spacing: Space.md) {
                                Image(systemName: toast.type.icon)
                                Text(toast.message)
                                    .style(Typography.caption)
                                    .fontWeight(.medium)
                            }
                            .foregroundStyle(.white)
                            .padding()
                            .background(toast.type.color)
                            .cornerRadius(Radius.pill)
                            .shadow(radius: 4)
                            .padding(.bottom, Space.xxl)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .onAppear {
                                workItem?.cancel()
                                let task = DispatchWorkItem {
                                    withAnimation {
                                        self.toast = nil
                                    }
                                }
                                workItem = task
                                DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
                            }
                        }
                    }
                }
                .animation(.spring(), value: toast)
            )
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
