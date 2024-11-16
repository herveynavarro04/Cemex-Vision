import SwiftUI
import VisionKit
import AVFoundation

struct SketchScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scannerModel = DocumentScannerModel()
    @State private var showingConfirmation = false
    @State private var showingPermissionAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if scannerModel.isScanning {
                    if VNDocumentCameraViewController.isSupported {
                        DocumentCamera(isScanning: $scannerModel.isScanning, scannedImage: $scannerModel.scannedImage)
                            .ignoresSafeArea()
                    } else {
                        // Show error if device doesn't support document scanning
                        ContentUnavailableView(
                            "Scanner Unavailable",
                            systemImage: "camera.badge.exclamationmark",
                            description: Text("This device does not support document scanning.")
                        )
                    }
                } else {
                    // Initial scanning instructions
                    VStack(spacing: 20) {
                        Image(systemName: "doc.viewfinder")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("Position your sketch within the frame")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        
                        Text("Make sure your drawing is well-lit and the entire sketch is visible")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            checkCameraPermission()
                        }) {
                            HStack {
                                Image(systemName: "camera.viewfinder")
                                Text("Start Scanning")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Capsule())
                        }
                        .padding(.top)
                    }
                    .padding()
                }
            }
            .navigationDestination(isPresented: $showingConfirmation) {
                if let image = scannerModel.scannedImage {
                    SketchConfirmationView(scannedImage: image)
                }
            }
            .onChange(of: scannerModel.scannedImage) { _, newImage in
                if newImage != nil {
                    showingConfirmation = true
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Camera Access Required", isPresented: $showingPermissionAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Settings") {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
            } message: {
                Text("Please allow camera access in Settings to scan sketches.")
            }
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            scannerModel.isScanning = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        scannerModel.isScanning = true
                    } else {
                        showingPermissionAlert = true
                    }
                }
            }
        case .denied, .restricted:
            showingPermissionAlert = true
        @unknown default:
            showingPermissionAlert = true
        }
    }
}

// Document scanner model to handle the scanning process
class DocumentScannerModel: ObservableObject {
    @Published var isScanning = false
    @Published var scannedImage: UIImage?
}

// Document camera view using VisionKit
struct DocumentCamera: UIViewControllerRepresentable {
    @Binding var isScanning: Bool
    @Binding var scannedImage: UIImage?
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocumentCamera
        
        init(_ parent: DocumentCamera) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            // Get the scanned image
            let image = scan.imageOfPage(at: 0)
            parent.scannedImage = image
            parent.isScanning = false
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.isScanning = false
        }
    }
} 
