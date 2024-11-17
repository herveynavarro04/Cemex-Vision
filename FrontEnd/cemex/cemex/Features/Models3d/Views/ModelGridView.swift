import SwiftUI

struct ModelGridView: View {
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 20)
    ]
    
    let models = ["Scene"]
    @State private var selectedModel: String?
    @State private var showingDetail = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(models, id: \.self) { model in
                    VStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 150)
                            .overlay(
                                Image(systemName: "cube.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                            )
                        
                        Text(model)
                            .font(.caption)
                    }
                    .onTapGesture {
                        print("Attempting to load model: \(model)")
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
                NavigationStack {
                    Model3DVolumeView(modelName: selectedModel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onAppear {
            if let modelURL = Bundle.main.url(forResource: "Scene", 
                                            withExtension: "usdz", 
                                            subdirectory: "Models.scnassets") {
                print("✅ Found model at: \(modelURL)")
            } else {
                print("❌ Could not find model in bundle")
                
                // Debug: Print available resources
                if let resourcePath = Bundle.main.resourcePath {
                    do {
                        let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                        print("Available resources: \(contents)")
                    } catch {
                        print("Error listing resources: \(error)")
                    }
                }
            }
        }
    }
}

#Preview {
    ModelGridView()
} 