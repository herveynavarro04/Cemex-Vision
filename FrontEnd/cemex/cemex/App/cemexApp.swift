//
//  cemexApp.swift
//  cemex
//
//  Created by ramiro garza on 11/15/24.
//

import SwiftUI

@main
struct cemexApp: App {
    var body: some Scene {
        WindowGroup {
            MainNavigationView()
        }

        ImmersiveSpace(id: "3DModel") {
            Model3DVolumeView(modelName: "Plano")
        }
    }
}
