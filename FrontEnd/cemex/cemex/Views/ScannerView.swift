import SwiftUI
import RealityKit

struct ScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingParameters = false
    @State private var isScanning = false
    @State private var scannedImage: UIImage?
    
    // Parameters for the 3D model generation
    @State private var parameters = ModelParameters()
    
    var body: some View {
        NavigationStack {
            VStack {
                if isScanning {
                    // Camera preview would go here
                    // For now, using a placeholder
                    Rectangle()
                        .fill(.secondary)
                        .aspectRatio(4/3, contentMode: .fit)
                        .overlay {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                        }
                } else if let image = scannedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                
                if scannedImage != nil {
                    Button("Configure Parameters") {
                        showingParameters = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if isScanning {
                        Button("Capture") {
                            // Capture logic would go here
                            isScanning.toggle()
                            // Simulating captured image
                            scannedImage = UIImage()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingParameters) {
                ParametersView(parameters: $parameters) {
                    // Handle submission
                    startModelGeneration()
                }
            }
        }
    }
    
    private func startModelGeneration() {
        dismiss()
        // Show loading animation and start model generation
        // This would be handled by your ModelGenerationCoordinator
    }
}

struct ModelParameters {
    var floors: Int = 1
    var style: String = "Modern"
    var scale: Double = 1.0
    // Add other parameters as needed
} 