import SwiftUI
import SceneKit
import CoreMotion

struct PanoramaView: UIViewRepresentable {
    let imageUrl: URL?
    @Binding var isGyroEnabled: Bool
    
    // SceneKit Components
    private let scene = SCNScene()
    private let cameraNode = SCNNode()
    // Motion Manager for Gyro
    private let motionManager = CMMotionManager()
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = scene
        scnView.allowsCameraControl = true // Allow touch panning
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = .black
        
        // Setup Camera
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
        // Setup Sphere
        let sphere = SCNSphere(radius: 10.0)
        sphere.firstMaterial?.isDoubleSided = true // Important: View from inside
        sphere.firstMaterial?.diffuse.contents = UIColor.darkGray // Loading State
        
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(sphereNode)
        
        context.coordinator.setup(sphereNode: sphereNode, cameraNode: cameraNode)
        
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update Texture if URL changed
        if let url = imageUrl, context.coordinator.currentUrl != url {
            context.coordinator.loadImage(url: url)
        }
        
        // Update Gyro State
        context.coordinator.updateMotion(enabled: isGyroEnabled, manager: motionManager)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        var sphereNode: SCNNode?
        var cameraNode: SCNNode?
        var currentUrl: URL?
        var timer: Timer?
        
        func setup(sphereNode: SCNNode, cameraNode: SCNNode) {
            self.sphereNode = sphereNode
            self.cameraNode = cameraNode
        }
        
        func loadImage(url: URL) {
            currentUrl = url
            print("Loading 360 texture from: \(url)")
            
            // Case 1: Offline / Local File
            if url.isFileURL {
                if let image = UIImage(contentsOfFile: url.path) {
                    DispatchQueue.main.async {
                        self.sphereNode?.geometry?.firstMaterial?.diffuse.contents = image
                    }
                } else {
                    print("Error: Could not load local 360 file at \(url.path)")
                }
                return
            }
            
            // Case 2: Remote URL
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    print("Error loading 360 texture: \(error.localizedDescription)")
                    return
                }
                
                guard let self = self, let data = data, let image = UIImage(data: data) else {
                    print("Error: Invalid data or image format for 360 texture")
                    return
                }
                
                DispatchQueue.main.async {
                    // Apply texture to inner sphere surface
                    self.sphereNode?.geometry?.firstMaterial?.diffuse.contents = image
                }
            }.resume()
        }
        
        func updateMotion(enabled: Bool, manager: CMMotionManager) {
            if enabled {
                if !manager.isDeviceMotionActive {
                    manager.deviceMotionUpdateInterval = 1.0 / 60.0
                    manager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
                        guard let data = data, let self = self else { return }
                        let attitude = data.attitude
                        // Map attitude to camera orientation
                        self.cameraNode?.eulerAngles = SCNVector3(
                            x: Float(-attitude.pitch),
                            y: Float(attitude.roll), // Basic mapping, usually needs more math for landscape/portrait
                            z: Float(attitude.yaw)
                        )
                    }
                }
            } else {
                manager.stopDeviceMotionUpdates()
            }
        }
    }
}
