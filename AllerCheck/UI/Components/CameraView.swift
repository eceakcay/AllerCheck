//
//  CameraView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {

    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds

        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}


