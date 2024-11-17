import SwiftUI
import PhotosUI

struct MainNavigationView: View {
    @State private var showingModelGrid = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var showingBlueprintSelection = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Beautiful gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.2, blue: 0.45).opacity(0.8), // Deep blue
                        Color(red: 0.3, green: 0.4, blue: 0.6).opacity(0.8), // Medium blue
                        Color(red: 0.5, green: 0.6, blue: 0.8).opacity(0.8)  // Light blue
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Content
                VStack(spacing: 100) {
                    VStack(spacing: 20) {
                        Image("cemex")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 600)
                            .shadow(radius: 10)
                    }
                    .padding(.top, 20)
                    
                    // Main action buttons
                    VStack(spacing: 24) {
                        Button(action: { showingBlueprintSelection = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.title)
                                Text("Elegir Planos")
                                    .font(.title)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(15)
                        }
                        
                        Button(action: { showingModelGrid = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "cube.fill")
                                    .font(.title)
                                Text("Modelos Existentes")
                                    .font(.title)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(red: 0.2, green: 0.3, blue: 0.6))
                            .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationDestination(isPresented: $showingModelGrid) {
                ModelGridView()
            }
            .navigationDestination(isPresented: $showingBlueprintSelection) {
                BlueprintSelectionView()
            }
        }
    }
}

#Preview {
    MainNavigationView()
}
