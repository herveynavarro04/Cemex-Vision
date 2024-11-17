import SwiftUI
import RealityKit
import RealityKitContent

struct Model3DVolumeView: View {
    let modelName: String
    @Environment(\.dismiss) var dismiss
    @State private var scale = 0.75
    @State private var rotation = Angle.zero
    @State private var position = SIMD3<Float>(x: 0, y: 0.2, z: -3)
    
    var body: some View {
        RealityView { content in
            // Create a new volume
            let volume = Entity()
            
            // Create a root entity for positioning
            let rootEntity = Entity()
            rootEntity.position = position
            
            do {
                let modelEntity = try await Entity(named: "Plano", in: realityKitContentBundle)
                modelEntity.position = .zero
                modelEntity.scale = SIMD3<Float>(repeating: Float(scale))
                
                // Add gesture components
                modelEntity.components[InputTargetComponent.self] = InputTargetComponent()
                
                // Create a collision component with a simple box shape
                let boxSize: Float = 0.75
                let collisionShape = ShapeResource.generateBox(size: [boxSize, boxSize, boxSize])
                modelEntity.components[CollisionComponent.self] = CollisionComponent(shapes: [collisionShape])
                
                rootEntity.addChild(modelEntity)
                volume.addChild(rootEntity)
                
                // Add lighting
                let lightEntity = Entity()
                let lightComponent = PointLightComponent(
                    color: .white,
                    intensity: 1000,
                    attenuationRadius: 4.0
                )
                lightEntity.components[PointLightComponent.self] = lightComponent
                lightEntity.position = SIMD3<Float>(x: 0, y: 2, z: 2)
                rootEntity.addChild(lightEntity)
                
                content.add(volume)
            } catch {
                print("Failed to load model: \(error)")
            }
        } update: { content in
            // Find the model entity and update its transform
            guard let rootEntity = content.entities.first?.children.first else { return }
            
            // Update position
            rootEntity.position = position
            
            // Update scale
            rootEntity.scale = SIMD3<Float>(repeating: Float(scale))
            
            // Update rotation
            let rotationTransform = Transform(rotation: simd_quatf(angle: Float(rotation.radians), axis: SIMD3<Float>(0, 1, 0)))
            rootEntity.orientation = rotationTransform.rotation
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    let translation = value.translation
                    position = SIMD3<Float>(
                        x: position.x + Float(translation.width) * 0.0001,
                        y: position.y - Float(translation.height) * 0.0001,
                        z: position.z
                    )
                }
        )
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    scale = Double(value)
                }
        )
        .gesture(
            RotationGesture()
                .onChanged { angle in
                    rotation = angle
                }
        )
        .overlay(alignment: .bottom) {
            HStack(spacing: 20) {
                Button(action: {
                    // Reset transforms
                    position = SIMD3<Float>(x: 0, y: 0.2, z: -3)
                    scale = 0.75
                    rotation = .zero
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.6))
                        .clipShape(Circle())
                }
                
                HStack {
                    Button(action: { scale *= 0.9 }) {
                        Image(systemName: "minus.magnifyingglass")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue.opacity(0.6))
                            .clipShape(Circle())
                    }
                    
                    Button(action: { scale *= 1.1 }) {
                        Image(systemName: "plus.magnifyingglass")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    Model3DVolumeView(modelName: "Plano")
} 
