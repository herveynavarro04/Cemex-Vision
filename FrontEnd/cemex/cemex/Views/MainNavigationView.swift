import SwiftUI
import PhotosUI

struct MainNavigationView: View {
    @State private var showingModelGrid = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
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
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            HStack(spacing: 12) {
                                Image(systemName: "doc.viewfinder")
                                    .font(.title)
                                Text("Scan New Sketch")
                                    .font(.title)
                            }
                            .frame(maxWidth: 900)
                            .padding()
                            .foregroundColor(.white)
                        }
                        
                        Button(action: { showingModelGrid = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "square.grid.2x2")
                                    .font(.title)
                                Text("Existing Models")
                                    .font(.title)
                            }
                            .frame(maxWidth: 900)
                            .padding()
                            .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onChange(of: selectedItem) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = Image(uiImage: uiImage)
                        // Here you can add logic to handle the selected image
                    }
                }
            }
            .navigationDestination(isPresented: $showingModelGrid) {
                ModelGridView()
            }
        }
    }
}

#Preview {
    MainNavigationView()
}
