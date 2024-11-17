import SwiftUI
import RealityKitContent
import RealityKit

struct ModelGridView: View {
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 20)
    ]
    
    let models = ["Plano"]
    @State private var showingDetail = false
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(models, id: \.self) { model in
                    VStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 150)
                            .overlay(
                                Model3D(named: model, bundle: realityKitContentBundle) { model in
                                    model
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    Image(systemName: "cube.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 100, height: 100)
                            )
                        
                        Text(model)
                            .font(.caption)
                    }
                    .onTapGesture {
                        Task {
                            await openImmersiveSpace(id: "3DModel")
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Modelos Existentes")
    }
}

#Preview {
    ModelGridView()
} 