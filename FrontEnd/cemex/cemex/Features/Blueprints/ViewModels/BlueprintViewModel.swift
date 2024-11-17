import SwiftUI

@MainActor
class BlueprintViewModel: ObservableObject {
    @Published var blueprints: [Blueprint] = []
    
    init() {
        loadBlueprintsFromAssets()
    }
    
    private func loadBlueprintsFromAssets() {
        for i in 1...50 {
            let imageName = "plano\(i)"
            if let _ = UIImage(named: imageName) {
                let blueprint = Blueprint(
                    name: "Plano \(i)", 
                    imageName: imageName
                )
                blueprints.append(blueprint)
            }
        }
    }
    
    func selectBlueprint(_ blueprint: Blueprint) {
        print("Selected blueprint: \(blueprint.name)")
    }
} 