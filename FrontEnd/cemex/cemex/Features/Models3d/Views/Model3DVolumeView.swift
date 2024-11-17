import SwiftUI
import RealityKit

struct Model3DVolumeView: View {
    let modelName: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Model3D(named: modelName, bundle: Bundle.main)
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
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