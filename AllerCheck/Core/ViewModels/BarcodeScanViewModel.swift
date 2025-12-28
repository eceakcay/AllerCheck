//
//  BarcodeScanViewModel.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import AVFoundation
import Combine

final class BarcodeScanViewModel: NSObject, ObservableObject {

    let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()

    @Published var scannedCode: String?

    override init() {
        super.init()
        configureSession()
    }

    private func configureSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device)
        else { return }

        session.beginConfiguration()

        if session.canAddInput(input) {
            session.addInput(input)
        }

        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(
                self,
                queue: DispatchQueue.main
            )

            metadataOutput.metadataObjectTypes = [
                .ean8, .ean13, .upce
            ]
        }

        session.commitConfiguration()
    }

    func startScanning() {
        if !session.isRunning {
            session.startRunning()
        }
    }

    func stopScanning() {
        if session.isRunning {
            session.stopRunning()
        }
    }
}

extension BarcodeScanViewModel: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let value = object.stringValue
        else { return }

        scannedCode = value
        stopScanning()
    }
}
