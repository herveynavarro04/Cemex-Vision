import SwiftUI

class BlueprintViewModel: ObservableObject {
    @Published var blueprints: [Blueprint] = []
    
    init() {
        loadBlueprintsFromAssets()
    }
    
    private func loadBlueprintsFromAssets() {
        // Try to load all plano images (plano1, plano2, etc.)
        for i in 1...50 { // We'll check up to 50 possible images
            let imageName = "plano\(i)"
            
            if let _ = UIImage(named: imageName) {
                let blueprint = Blueprint(
                    name: "Plano \(i)", 
                    imageName: imageName
                )
                blueprints.append(blueprint)
                print("📸 Found image: \(imageName)")
            }
        }
        
        if blueprints.isEmpty {
            print("⚠️ No images found")
        } else {
            print("✅ Loaded \(blueprints.count) images")
        }
    }
    
    func selectBlueprint(_ blueprint: Blueprint) {
        print("Selected blueprint: \(blueprint.name)")
    }
} 