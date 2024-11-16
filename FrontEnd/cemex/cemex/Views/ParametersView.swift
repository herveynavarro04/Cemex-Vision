import SwiftUI

struct ParametersView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var parameters: ModelParameters
    let onSubmit: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Building Parameters") {
                    Stepper("Floors: \(parameters.floors)", value: $parameters.floors, in: 1...10)
                    
                    Picker("Style", selection: $parameters.style) {
                        Text("Modern").tag("Modern")
                        Text("Classical").tag("Classical")
                        Text("Industrial").tag("Industrial")
                    }
                    
                    Slider(value: $parameters.scale, in: 0.5...2.0) {
                        Text("Scale: \(parameters.scale, specifier: "%.1f")x")
                    }
                }
            }
            .navigationTitle("Model Parameters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Generate") {
                        onSubmit()
                        dismiss()
                    }
                }
            }
        }
    }
} 