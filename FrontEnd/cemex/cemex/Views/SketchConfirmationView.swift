import SwiftUI
import AVFoundation

struct SketchConfirmationView: View {
    let scannedImage: UIImage
    @Environment(\.dismiss) private var dismiss
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    @State private var buildingType = Set<String>()
    @State private var additionalNotes = ""
    @State private var isRecording = false
    
    private let buildingTypes = ["Residential", "Industrial", "Commercial", "Public"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Scanned image preview
                Image(uiImage: scannedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                
                // Building type selection
                VStack(alignment: .leading, spacing: 15) {
                    Text("Building Type")
                        .font(.headline)
                    
                    FlowLayout(spacing: 10) {
                        ForEach(buildingTypes, id: \.self) { type in
                            CheckboxButton(
                                title: type,
                                isSelected: buildingType.contains(type)
                            ) {
                                if buildingType.contains(type) {
                                    buildingType.remove(type)
                                } else {
                                    buildingType.insert(type)
                                }
                            }
                        }
                    }
                }
                
                // Additional notes with voice input
                VStack(alignment: .leading, spacing: 15) {
                    Text("Additional Notes")
                        .font(.headline)
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $additionalNotes)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Button(action: {
                            if isRecording {
                                speechRecognizer.stopRecording()
                            } else {
                                speechRecognizer.startRecording()
                            }
                            isRecording.toggle()
                        }) {
                            Image(systemName: isRecording ? "waveform" : "mic.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(isRecording ? .red : .blue)
                                .padding(8)
                        }
                        .offset(x: -4, y: -4)
                    }
                }
                
                // Render button
                Button(action: startRendering) {
                    HStack(spacing: 15) {
                        Image(systemName: "wand.and.stars")
                            .font(.title2)
                        Text("Render Sketch")
                            .font(.title3.bold())
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        LinearGradient(
                            colors: [Color("F22331"), Color("F22331").opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color("F22331").opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
            .padding()
        }
        .navigationTitle("Confirm Sketch")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Back") {
                    dismiss()
                }
            }
        }
        .onAppear {
            speechRecognizer.transcriptionHandler = { text in
                additionalNotes += text + " "
            }
        }
    }
    
    private func startRendering() {
        // Handle rendering process
        // This will be implemented later with the API
    }
}

// Checkbox button component
struct CheckboxButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(title)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 1)
            )
        }
        .foregroundColor(isSelected ? .blue : .primary)
    }
}

// Flow layout for checkboxes
struct FlowLayout: Layout {
    let spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return arrangeSubviews(sizes: sizes, proposal: proposal).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = arrangeSubviews(sizes: sizes, proposal: proposal).offsets
        
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(
                at: CGPoint(
                    x: bounds.origin.x + offset.x,
                    y: bounds.origin.y + offset.y
                ),
                proposal: .unspecified
            )
        }
    }
    
    private func arrangeSubviews(sizes: [CGSize], proposal: ProposedViewSize) -> (offsets: [CGPoint], size: CGSize) {
        guard let containerWidth = proposal.width else {
            return (sizes.map { _ in .zero }, .zero)
        }
        
        var result: [CGPoint] = []
        var currentPosition = CGPoint.zero
        var maxY: CGFloat = 0
        
        for size in sizes {
            if currentPosition.x + size.width > containerWidth {
                currentPosition.x = 0
                currentPosition.y = maxY + spacing
            }
            
            result.append(currentPosition)
            
            currentPosition.x += size.width + spacing
            maxY = max(maxY, currentPosition.y + size.height)
        }
        
        return (result, CGSize(width: containerWidth, height: maxY))
    }
}

// Speech recognizer for voice input
class SpeechRecognizer: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var recognitionTask: Task<Void, Never>?
    var transcriptionHandler: ((String) -> Void)?
    
    func startRecording() {
        // Implement speech recognition
        // This would use AVFoundation and Speech frameworks
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionTask?.cancel()
    }
} 
