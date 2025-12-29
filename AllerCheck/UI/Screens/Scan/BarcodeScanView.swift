//
//  BarcodeScanView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct BarcodeScanView: View {

    @StateObject private var viewModel = BarcodeScanViewModel()

    var body: some View {
        NavigationStack {
            ZStack {

                // MARK: - Camera Preview
                CameraView(session: viewModel.session)
                    .ignoresSafeArea()

                // MARK: - Top Instruction
                VStack {
                    Text("Barkodu kameraya hizalayın")
                        .padding()
                        .background(.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 40)

                    Spacer()
                }

                // MARK: - Loading Overlay
                if viewModel.isLoading {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()

                    ProgressView("Ürün aranıyor...")
                        .padding()
                        .background(.white)
                        .cornerRadius(12)
                }

                // MARK: - Scanned Barcode Display
                if let code = viewModel.scannedCode, !viewModel.isLoading {
                    VStack {
                        Spacer()

                        Text("Barkod: \(code)")
                            .padding()
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.bottom, 40)
                    }
                }

                // MARK: - Error Message
                if let error = viewModel.errorMessage {
                    VStack {
                        Spacer()

                        Text(error)
                            .padding()
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.bottom, 40)
                    }
                }
            }
            // MARK: - RESULT NAVIGATION (ÜRÜN BULUNDU)
            .navigationDestination(
                item: $viewModel.product
            ) { product in
                ResultView(product: product)
            }

            // MARK: - OCR NAVIGATION (ÜRÜN BULUNAMADI)
            .navigationDestination(
                isPresented: $viewModel.shouldNavigateToOCR
            ) {
                OCRScanView()
            }

            // ResultView'den geri dönülünce resetle
            .onChange(of: viewModel.product) { oldValue, newValue in
                if newValue == nil {
                    viewModel.resetScanning()
                }
            }

            .onAppear {
                viewModel.startScanning()
            }
            .onDisappear {
                viewModel.stopScanning()
            }
        }
    }
}

#Preview {
    BarcodeScanView()
}
