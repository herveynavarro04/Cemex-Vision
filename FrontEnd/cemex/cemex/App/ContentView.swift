//
//  ContentView.swift
//  cemex
//
//  Created by ramiro garza on 11/15/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var showImmersiveSpace = false
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    var body: some View {
        MainNavigationView()
            .onChange(of: showImmersiveSpace) { _, isShowing in
                Task {
                    if isShowing {
                        await openImmersiveSpace(id: "ModelViewer")
                    } else {
                        await dismissImmersiveSpace()
                    }
                }
            }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
