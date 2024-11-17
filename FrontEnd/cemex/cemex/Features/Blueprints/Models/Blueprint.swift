import Foundation

struct Blueprint: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
    
    static func == (lhs: Blueprint, rhs: Blueprint) -> Bool {
        lhs.id == rhs.id
    }
} 