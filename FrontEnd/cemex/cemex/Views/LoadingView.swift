import SwiftUI

struct LoadingView: View {
    @State private var isLoading = true

    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            // Loading Content
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(5) // Make the spinner larger

                Text("Procesando Planos")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.8))
            )
        }
        .opacity(isLoading ? 1 : 0)
        .animation(.easeInOut, value: isLoading)
    }
}

#Preview{
    LoadingView()
}
