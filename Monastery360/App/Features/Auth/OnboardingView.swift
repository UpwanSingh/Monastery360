import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) var appState
    @State private var currentPage = 0
    
    let slides = [
        (title: "Preservation", desc: "Digitally preserving our heritage.", icon: "hand.raised.fill"),
        (title: "Immersion", desc: "Experience 8K 360° tours from home.", icon: "camera.aperture"),
        (title: "Offline", desc: "Download content for remote travel.", icon: "arrow.down.circle.fill")
    ]
    
    var body: some View {
        ZStack {
            Color.Surface.base.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Carousel
                TabView(selection: $currentPage) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        VStack(spacing: Space.md) {
                            Image(systemName: slides[index].icon)
                                .font(.system(size: 100))
                                .foregroundStyle(Color.Brand.secondary)
                                .padding(.bottom, Space.xl)
                            
                            Text(slides[index].title)
                                .style(Typography.h1)
                                .foregroundStyle(Color.Text.primary)
                            
                            Text(slides[index].desc)
                                .style(Typography.bodyLg)
                                .foregroundStyle(Color.Text.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, Space.xl)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 400)
                
                Spacer()
                
                // Buttons
                HStack {
                    if currentPage < slides.count - 1 {
                        Button("Skip") {
                            finishOnboarding()
                        }
                        .foregroundStyle(Color.Text.secondary)
                        
                        Spacer()
                        
                        Button("Next") {
                            withAnimation { currentPage += 1 }
                        }
                        .foregroundStyle(Color.Brand.primary)
                        .fontWeight(.bold)
                    } else {
                        Button(action: finishOnboarding) {
                            Text("Get Started")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.Brand.primary)
                                .foregroundStyle(Color.Text.inverse)
                                .cornerRadius(Radius.pill)
                        }
                        .padding(.horizontal, Space.lg)
                    }
                }
                .padding(Space.lg)
            }
        }
    }
    
    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        withAnimation {
            appState.currentRoute = .authSelection
        }
    }
}
