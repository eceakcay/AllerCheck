//
//  OCRScanView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct OCRScanView: View {

    @StateObject private var viewModel = OCRScanViewModel()
    @State private var showCamera = false
    @State private var shouldNavigateToResult = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                Text("Etiketten İçindekiler Oku")
                    .font(.title2)
                    .bold()

                Button {
                    showCamera = true
                } label: {
                    Label("Fotoğraf Çek", systemImage: "camera")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                if viewModel.isProcessing {
                    ProgressView("Metin tanınıyor...")
                        .padding()
                }

                if !viewModel.recognizedText.isEmpty {
                    ScrollView {
                        Text(viewModel.recognizedText)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                Spacer()
            }
            .padding()

            // 📸 Kamera
            .sheet(isPresented: $showCamera) {
                ImagePicker { pickedImage in
                    viewModel.recognizeText(from: pickedImage)
                }
            }

            // 🔥 OCR METNİ GELİNCE NAVIGATION
            .onChange(of: viewModel.recognizedText) { newText in
                if !newText.isEmpty {
                    shouldNavigateToResult = true
                }
            }

            // 🔥 ASIL NAVIGATION BURASI
            .navigationDestination(isPresented: $shouldNavigateToResult) {
                OCRResultView(
                    ocrText: viewModel.recognizedText
                )
            }
        }
    }
}
