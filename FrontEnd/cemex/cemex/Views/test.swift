import SwiftUI
import RealityKit

struct TestUSDZView: View {
    var body: some View {
        Model3D(named: "Scene", bundle: .main) { model in
            model
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: 300, height: 300)
        #if DEBUG
        .task {
            // Debug: Print available USDZ files in bundle
            print("Available USDZ files:", Bundle.main.urls(forResourcesWithExtension: "usdz", subdirectory: nil) ?? [])
        }
        #endif
    }
}

#Preview {
    TestUSDZView()
}
