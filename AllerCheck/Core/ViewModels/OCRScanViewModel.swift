//
//  OCRScanViewModel.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import Foundation
import Vision
import UIKit
import Combine

final class OCRScanViewModel: ObservableObject {

    @Published var recognizedText: String = ""
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String?

    func recognizeText(from image: UIImage) {

        print("📸 OCR başladı")

        isProcessing = true
        recognizedText = ""
        errorMessage = nil

        // 1️⃣ Görsel kontrolü
        guard let cgImage = image.cgImage else {
            isProcessing = false
            errorMessage = "Görsel CGImage'a dönüştürülemedi."
            print("❌ CGImage alınamadı")
            return
        }

        // 2️⃣ OCR isteği
        let request = VNRecognizeTextRequest { [weak self] request, error in
            DispatchQueue.main.async {

                self?.isProcessing = false

                // 3️⃣ Vision error yakalama
                if let error = error {
                    self?.errorMessage = "OCR Hatası: \(error.localizedDescription)"
                    print("❌ OCR Vision Error:", error)
                    return
                }

                // 4️⃣ Sonuç kontrolü
                guard let observations =
                        request.results as? [VNRecognizedTextObservation],
                      !observations.isEmpty else {

                    self?.errorMessage = "Metin bulunamadı. Fotoğraf net olmayabilir."
                    print("⚠️ OCR sonucu boş")
                    return
                }

                // 5️⃣ Metin birleştirme
                let text = observations
                    .compactMap { observation in
                        observation.topCandidates(1).first?.string
                    }
                    .joined(separator: "\n")

                print("📝 OCR sonucu:")
                print(text)

                self?.recognizedText = text
            }
        }

        // 6️⃣ OCR ayarları
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["tr-TR", "en-US"]

        // 7️⃣ Handler
        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: .up,
            options: [:]
        )

        // 8️⃣ OCR çalıştır
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.isProcessing = false
                    self.errorMessage = "OCR çalıştırılamadı: \(error.localizedDescription)"
                    print("❌ OCR Handler Error:", error)
                }
            }
        }
    }
}
