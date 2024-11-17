import SwiftUI
import SceneKit

struct ModelGridView: View {
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 20)
    ]
    
    // Sample data - replace with your actual models
    let models = ["model1", "model2", "model3", "model4"] // Your model names
    @State private var selectedModel: String?
    @State private var showingDetail = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(models, id: \.self) { model in
                    Image(model) // Replace with your actual model preview image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedModel = model
                            showingDetail = true
                        }
                }
            }
            .padding()
        }
        .navigationTitle("Modelos Existentes")
        .sheet(isPresented: $showingDetail) {
            if let selectedModel = selectedModel {
                Model3DDetailView(modelName: selectedModel)
            }
        }
    }
}

struct Model3DDetailView: View {
    let modelName: String
    @Environment(\.dismiss) var dismiss
    
    private func loadModel() -> SCNScene? {
        // Load directly from asset catalog
        return SCNScene(named: modelName, inDirectory: "Models.scnassets")
    }
    
    var body: some View {
        NavigationStack {
            if let scene = loadModel() {
                SceneView(
                    scene: scene,
                    options: [
                        .allowsCameraControl,
                        .autoenablesDefaultLighting,
                        .temporalAntialiasingEnabled
                    ]
                )
                .navigationTitle("Vista 3D")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Cerrar") {
                            dismiss()
                        }
                    }
                }
            } else {
                Text("No se pudo cargar el modelo 3D")
                    .foregroundColor(.red)
            }
        }
    }
} 