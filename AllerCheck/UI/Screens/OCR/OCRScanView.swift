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
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            ZStack {
                // Dynamic theme background
                Color.appBackground(theme: themeManager.currentTheme)
                    .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    // MARK: - Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.appGreen.opacity(0.2), Color.appYellow.opacity(0.15)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "doc.text.viewfinder")
                                .font(.system(size: 50))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.appGreen, Color.appYellow],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .padding(.top, 40)
                        
                        Text("Etiketten İçindekiler Oku")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                            .multilineTextAlignment(.center)
                        
                        Text("Ürün etiketinin fotoğrafını çekin")
                            .font(.subheadline)
                            .foregroundColor(Color.appSecondaryText(theme: themeManager.currentTheme))
                    }

                    // MARK: - Camera Button
                    Button {
                        showCamera = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .font(.title3)
                            Text("Fotoğraf Çek")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [Color.appGreen, Color.appGreen.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.appGreen.opacity(0.3), radius: 15, x: 0, y: 8)
                    }
                    .padding(.horizontal, 32)

                    // MARK: - Processing State
                    if viewModel.isProcessing {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                                .tint(Color.appGreen)
                            Text("Metin tanınıyor...")
                                .font(.headline)
                                .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.appCard(theme: themeManager.currentTheme))
                                .shadow(color: (themeManager.currentTheme == .dark) ? Color.black.opacity(0.3) : Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                        )
                        .padding(.horizontal, 32)
                    }

                    // MARK: - Recognized Text Preview
                    if !viewModel.recognizedText.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "text.viewfinder")
                                    .foregroundColor(Color.appGreen)
                                Text("Tanınan Metin")
                                    .font(.headline)
                                    .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                            }
                            
                            ScrollView {
                                Text(viewModel.recognizedText)
                                    .font(.subheadline)
                                    .foregroundColor(Color.appSecondaryText(theme: themeManager.currentTheme))
                                    .lineSpacing(4)
                            }
                            .frame(maxHeight: 150)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.appCard(theme: themeManager.currentTheme))
                                .shadow(color: (themeManager.currentTheme == .dark) ? Color.black.opacity(0.3) : Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                        )
                        .padding(.horizontal, 32)
                    }

                    // MARK: - Error Message
                    if let error = viewModel.errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(error)
                                .font(.subheadline)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                        .shadow(radius: 8)
                        .padding(.horizontal, 32)
                    }

                    Spacer()
                }
            }
            // 📸 Kamera
            .sheet(isPresented: $showCamera) {
                ImagePicker { pickedImage in
                    viewModel.recognizeText(from: pickedImage)
                }
            }
            .preferredColorScheme(themeManager.currentTheme.colorScheme)
            .onAppear {
                viewModel.recognizedText = ""
                viewModel.errorMessage = nil
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
