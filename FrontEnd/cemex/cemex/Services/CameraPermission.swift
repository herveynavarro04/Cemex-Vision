//
//  CameraPermission.swift
//  cemex
//
//  Created by Adolfo Gonzalez on 16/11/24.
//

import AVFoundation
import SwiftUI

func requestCameraAccess() {
    AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted {
            print("Camera access granted.")
        } else {
            print("Camera access denied.")
        }
    }
}


func checkCameraPermission() {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    switch status {
    case .authorized:
        print("Camera access already granted.")
    case .notDetermined:
        print("Requesting camera access.")
        requestCameraAccess()
    case .denied, .restricted:
        print("Camera access denied or restricted. Show alert.")
        // Handle by showing an alert or guiding the user to settings
        openAppSettings()
    @unknown default:
        print("Unknown authorization status.")
    }
}

func openAppSettings() {
    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
    }
}
