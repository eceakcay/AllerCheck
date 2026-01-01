//
//  BarcodeScanView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct BarcodeScanView: View {

    @StateObject private var viewModel = BarcodeScanViewModel()
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            ZStack {

                // MARK: - Camera Preview
                CameraView(session: viewModel.session)
                    .ignoresSafeArea()

                // MARK: - Top Instruction
                VStack {
                    HStack(spacing: 12) {
                        Image(systemName: "viewfinder")
                            .font(.title3)
                        Text("Barkodu kameraya hizalayın")
                            .font(.headline)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .shadow(color: Color.black.opacity(0.2), radius: 10)
                    )
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .padding(.horizontal, 20)

                    Spacer()
                }

                // MARK: - Loading Overlay
                if viewModel.isLoading {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                        Text("Ürün aranıyor...")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding(32)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(radius: 20)
                    )
                }

                // MARK: - Scanned Barcode Display
                if let code = viewModel.scannedCode, !viewModel.isLoading {
                    VStack {
                        Spacer()

                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Barkod Okundu")
                                    .font(.headline)
                                Text(code)
                                    .font(.subheadline)
                                    .opacity(0.9)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.green, Color.green.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color.green.opacity(0.4), radius: 15, x: 0, y: 8)
                        )
                        .padding(.bottom, 50)
                        .padding(.horizontal, 20)
                    }
                }

                // MARK: - Error Message
                if let error = viewModel.errorMessage {
                    VStack {
                        Spacer()

                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title3)
                            Text(error)
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.red, Color.red.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color.red.opacity(0.4), radius: 15, x: 0, y: 8)
                        )
                        .padding(.bottom, 50)
                        .padding(.horizontal, 20)
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
            .preferredColorScheme(themeManager.currentTheme.colorScheme)
        }
    }
}

#Preview {
    BarcodeScanView()
}
