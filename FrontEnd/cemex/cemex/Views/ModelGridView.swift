import SwiftUI

struct ModelGridView: View {
    // Sample model data
    @State private var models: [ArchitecturalModel] = []
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 20)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(models) { model in
                    ModelGridItem(model: model)
                }
            }
            .padding()
        }
        .navigationTitle("Existing Models")
    }
}

struct ModelGridItem: View {
    let model: ArchitecturalModel
    
    var body: some View {
        VStack {
            // Thumbnail
            RoundedRectangle(cornerRadius: 10)
                .fill(.secondary)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Image(systemName: "building.2")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            
            // Model info
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.headline)
                Text(model.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .onTapGesture {
            // Open model viewer
        }
    }
}

struct ArchitecturalModel: Identifiable {
    let id: UUID
    let name: String
    let createdAt: Date
    let modelURL: URL
} 