import SwiftUI

struct MainNavigationView: View {
    @State private var showingScanSheet = false
    @State private var showingModelGrid = false
    
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
                VStack(spacing: 40) {
                    VStack(spacing: 20) {
                        Image("cemex")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 600)
                            .shadow(radius: 10)
                        
                    }
                    .padding(.top, 40)
                    
                    // Main action buttons
                    VStack(spacing: 20) {
                        Button(action: { showingScanSheet = true }) {
                            HStack {
                                Image(systemName: "doc.viewfinder")
                                    .font(.title2)
                                Text("Scan New Sketch")
                                    .font(.title3)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                        }
                        
                        Button(action: { showingModelGrid = true }) {
                            HStack {
                                Image(systemName: "square.grid.2x2")
                                    .font(.title2)
                                Text("Existing Models")
                                    .font(.title3)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .sheet(isPresented: $showingScanSheet) {
                SketchScannerView()
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
