import SwiftUI
import RealityKit
import RealityKitContent

struct TestUSDZView: View {
    var body: some View {
        Model3D(named: "Plano", bundle: realityKitContentBundle) { model in
            model
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: 300, height: 300)
        #if DEBUG
        .task {
            // Debug: Print available models in RealityKitContent bundle
            print("Available models:", realityKitContentBundle.urls(forResourcesWithExtension: "usda", subdirectory: nil) ?? [])
        }
        #endif
    }
}

#Preview {
    TestUSDZView()
}
