//
//  BarcodeScanViewModel.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import AVFoundation
import Combine
import Foundation

final class BarcodeScanViewModel: NSObject, ObservableObject {

    // MARK: - Camera
    let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()

    // MARK: - Published States
    @Published var scannedCode: String?
    @Published var product: ProductDTO?
    @Published var isLoading: Bool = false
    @Published var shouldNavigateToOCR: Bool = false
    @Published var errorMessage: String?

    // MARK: - Services
    private let apiService = OpenFoodFactsService()

    // MARK: - Init
    override init() {
        super.init()
        configureSession()
    }

    // MARK: - Camera Configuration
    private func configureSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device)
        else {
            errorMessage = "Kamera erişimi sağlanamadı."
            return
        }

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
                .ean8,
                .ean13,
                .upce
            ]
        }

        session.commitConfiguration()
    }

    // MARK: - Camera Control
    func startScanning() {
        guard !session.isRunning else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }

    func stopScanning() {
        guard session.isRunning else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
        }
    }
    
    func resetScanning() {
        scannedCode = nil
        product = nil
        errorMessage = nil
        shouldNavigateToOCR = false

        startScanning()
    }
    
    deinit {
        // Kaynak temizliği
        if session.isRunning {
            session.stopRunning()
        }
    }


    // MARK: - Barcode Handling
    private func handleBarcode(_ code: String) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedProduct = try await apiService.fetchProduct(barcode: code)

                await MainActor.run {
                    self.product = fetchedProduct
                    self.isLoading = false
                }

            } catch ProductError.notFound {
                await MainActor.run {
                    self.isLoading = false
                    self.shouldNavigateToOCR = true
                }

            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Ürün bilgisi alınırken hata oluştu."
                }
            }
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension BarcodeScanViewModel: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let value = object.stringValue
        else { return }

        // Aynı barkodun tekrar tekrar okunmasını önler
        guard scannedCode == nil else { return }

        scannedCode = value
        stopScanning()
        handleBarcode(value)
    }
}
