import SwiftUI

struct BlueprintSelectionView: View {
    @StateObject private var viewModel = BlueprintViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let columns = [
        GridItem(.adaptive(minimum: 300), spacing: 20)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.blueprints) { blueprint in
                    VStack {
                        if let image = UIImage(named: blueprint.imageName) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        } else {
                            Text("Image not found")
                                .foregroundColor(.red)
                        }
                        
                        Text(blueprint.name)
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        viewModel.selectBlueprint(blueprint)
                        dismiss()
                    }
                }
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.45).opacity(0.8),
                    Color(red: 0.3, green: 0.4, blue: 0.6).opacity(0.8),
                    Color(red: 0.5, green: 0.6, blue: 0.8).opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Seleccionar Plano")
    }
} 
