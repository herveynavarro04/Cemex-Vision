import SwiftUI
import RealityKit

struct ModelViewerSpace: View {
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @State private var isRotating = true
    
    var body: some View {
        RealityView { content in
            // This is where we'll add the 3D model content
            // For now, just a placeholder
            let model = ModelEntity(mesh: .generateBox(size: 0.3))
            model.model?.materials = [SimpleMaterial(color: .blue, isMetallic: true)]
            
            // Add automatic rotation
            if isRotating {
                model.components[RotationComponent.self] = RotationComponent()
            }
            
            content.add(model)
        }
        
        // Overlay controls
        VStack {
            HStack {
                Toggle("Auto-Rotate", isOn: $isRotating)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button("Close") {
                    Task {
                        await dismissImmersiveSpace()
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            
            Spacer()
        }
    }
}

// Custom component for automatic rotation
struct RotationComponent: Component {
    var rotationSpeed: Float = 0.5
} 