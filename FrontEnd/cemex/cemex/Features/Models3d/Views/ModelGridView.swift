import SwiftUI

struct ModelGridView: View {
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 20)
    ]
    
    let models = ["test3dscene"]
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
    }
}

#Preview {
    ModelGridView()
} 