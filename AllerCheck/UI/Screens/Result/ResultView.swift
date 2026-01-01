//
//  ResultView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct ResultView: View {

    @StateObject private var viewModel = ResultViewModel()
    let product: ProductDTO
    private let historyService = HistoryService()
    @State private var animateCircle = false
    @State private var hasSavedToHistory = false

    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var themeManager: ThemeManager

    // ResultView'den geri dönmek için
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
                    // MARK: - Ürün Adı
                    VStack(spacing: 8) {
                        if let brand = product.brands, !brand.isEmpty {
                            Text(brand)
                                .font(.subheadline)
                                .foregroundColor(Color.appSecondaryText(theme: themeManager.currentTheme))
                                .textCase(.uppercase)
                        }
                        
                        Text(product.product_name ?? "Ürün")
                            .font(.system(size: 28, weight: .bold))
                            .multilineTextAlignment(.center)
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
                    if let ingredients = product.ingredients_text, !ingredients.isEmpty {
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
                                .shadow(color: (themeManager.currentTheme == .dark) ? Color.black.opacity(0.3) : Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                        )
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 40)

                    // MARK: - Yeni Ürün Tara Butonu
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "barcode.viewfinder")
                            Text("Yeni Ürün Tara")
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
            viewModel.calculateRisk(
                product: product,
                userAllergens: userSettings.selectedAllergens
            )
            
            animateCircle = true
            
            // Risk hesaplandıktan sonra kaydet - sadece bir kez
            if !hasSavedToHistory {
                hasSavedToHistory = true
                Task {
                    do {
                        try historyService.saveProduct(
                            product: product,
                            riskLevel: viewModel.riskLevel
                        )
                    } catch {
                        print("❌ History save error:", error)
                    }
                }
            }
        }
    }
}

#Preview {
    ResultView(
        product: ProductDTO(
            product_name: "Örnek Ürün",
            brands: "Test Marka",
            ingredients_text: "Süt, şeker",
            allergens: "milk"
        )
    )
    .environmentObject(UserSettings())
    .environmentObject(ThemeManager())
}
