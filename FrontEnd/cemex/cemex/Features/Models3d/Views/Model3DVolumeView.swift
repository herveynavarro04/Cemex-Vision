import SwiftUI
import RealityKit

struct Model3DVolumeView: View {
    let modelName: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            RealityView { content in
                // Create a simple cube as fallback
                let mesh = MeshResource.generateBox(size: 0.1)
                let material = SimpleMaterial(color: .blue, roughness: 0.5, isMetallic: true)
                let entity = ModelEntity(mesh: mesh, materials: [material])
                
                // Position the entity in front of the user
                entity.position = SIMD3(x: 0, y: 0, z: -0.3)
                
                // Add the entity to the scene
                content.add(entity)
                
            } update: { content in
                // Synchronous update if needed
            }
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
            )
            .task {
                // Async loading of the model
                if let modelEntity = try? await Entity(named: modelName) {
                    modelEntity.position = SIMD3(x: 0, y: 0, z: -0.3)
                    print("✅ Model loaded successfully")
                } else {
                    print("❌ Failed to load model: \(modelName)")
                }
            }
        }
        .navigationTitle("Vista 3D")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Cerrar") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    Model3DVolumeView(modelName: "test3dscene")
} 