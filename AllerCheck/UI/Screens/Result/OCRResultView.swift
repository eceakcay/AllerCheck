//
//  OCRResultView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import SwiftUI

struct OCRResultView: View {

    let ocrText: String
    
    @State private var extractedIngredients: String?
    @State private var animateCircle = false
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var viewModel = ResultViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Dynamic theme background with risk color accent
            let isDark = themeManager.currentTheme == .dark
            LinearGradient(
                colors: [
                    viewModel.riskLevel.color.opacity(isDark ? 0.15 : 0.08),
                    Color.appBackground(theme: themeManager.currentTheme)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // MARK: - Header
                    VStack(spacing: 8) {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.system(size: 40))
                            .foregroundColor(Color.appGreen)
                        
                        Text("Etiket Analizi")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                    }
                    .padding(.top, 20)

                    // MARK: - Risk Göstergesi
                    VStack(spacing: 20) {
                        ZStack {
                            // Pulsing circle effect
                            Circle()
                                .fill(viewModel.riskLevel.color.opacity(0.2))
                                .frame(width: 180, height: 180)
                                .scaleEffect(animateCircle ? 1.1 : 1.0)
                                .animation(
                                    Animation.easeInOut(duration: 2.0)
                                        .repeatForever(autoreverses: true),
                                    value: animateCircle
                                )
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            viewModel.riskLevel.color,
                                            viewModel.riskLevel.color.opacity(0.8)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 160, height: 160)
                                .shadow(color: viewModel.riskLevel.color.opacity(0.4), radius: 20)
                            
                            Image(systemName: viewModel.riskLevel == .safe ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)

                        Text(viewModel.riskLevel.title)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(viewModel.riskLevel.color)

                        Text(viewModel.riskLevel.description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                            .padding(.horizontal, 32)
                            .lineSpacing(4)
                    }

                    // MARK: - İçindekiler Card
                    if let ingredients = extractedIngredients {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "list.bullet.rectangle")
                                    .foregroundColor(Color.appGreen)
                                Text("İçindekiler")
                                    .font(.headline)
                                    .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                            }
                            
                            Text(ingredients)
                                .font(.subheadline)
                                .foregroundColor(Color.appSecondaryText(theme: themeManager.currentTheme))
                                .lineSpacing(4)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.appCard(theme: themeManager.currentTheme))
                                .shadow(color: isDark ? Color.black.opacity(0.3) : Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                        )
                        .padding(.horizontal)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                            Text("İçindekiler bulunamadı")
                                .font(.headline)
                                .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                            Text("Lütfen daha net bir fotoğraf çekin")
                                .font(.subheadline)
                                .foregroundColor(Color.appSecondaryText(theme: themeManager.currentTheme))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.appCard(theme: themeManager.currentTheme))
                                .shadow(color: isDark ? Color.black.opacity(0.3) : Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                        )
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 40)

                    // MARK: - Yeni Etiket Tara Butonu
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Yeni Etiket Tara")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color.appGreen, Color.appGreen.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.appGreen.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
        .preferredColorScheme(themeManager.currentTheme.colorScheme)
        .onAppear {
            guard let ingredients =
                OCRTextParser.extractIngredients(from: ocrText) else {

                viewModel.riskLevel = .warning
                extractedIngredients = nil
                print("⚠️ İçindekiler bulunamadı")
                animateCircle = true
                return
            }

            extractedIngredients = ingredients

            print("🧾 EKRANDA GÖSTERİLEN İÇİNDEKİLER: \(ingredients)")

            viewModel.calculateRiskFromOCR(
                ingredientsText: ingredients,
                userAllergens: userSettings.selectedAllergens
            )
            
            animateCircle = true
        }
    }
}
