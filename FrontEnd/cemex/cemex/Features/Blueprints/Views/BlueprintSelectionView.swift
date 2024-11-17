import SwiftUI

struct BlueprintSelectionView: View {
    @StateObject private var viewModel = BlueprintViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = false
    
    let columns = [
        GridItem(.adaptive(minimum: 300), spacing: 20)
    ]
    
    var body: some View {
        ZStack {
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
                            isLoading = true
                            viewModel.selectBlueprint(blueprint)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                isLoading = false
                                dismiss()
                            }
                        }
                    }
                }
                .padding()
            }
            
            if isLoading {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding()
                    
                    Text("Modelando diseño")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
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
