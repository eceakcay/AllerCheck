//
//  HistoryView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct HistoryView: View {

    @StateObject private var viewModel = HistoryViewModel()
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            ZStack {
                // Dynamic theme background
                Color.appBackground(theme: themeManager.currentTheme)
                    .ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.products.isEmpty {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(Color.appGreen)
                        Text("Yükleniyor...")
                            .font(.headline)
                            .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                    }
                } else if viewModel.products.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "clock.badge.xmark")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.gray.opacity(0.6), .gray.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Text("Henüz tarama geçmişi yok")
                            .font(.headline)
                            .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                        Text("Taradığınız ürünler burada görünecek")
                            .font(.subheadline)
                            .foregroundColor(Color.appSecondaryText(theme: themeManager.currentTheme))
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.products, id: \.id) { product in
                                HistoryCard(product: product)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .refreshable {
                        viewModel.loadHistory()
                    }
                }
                
                if let error = viewModel.errorMessage {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(error)
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding()
                    }
                }
            }
            .navigationTitle("Geçmiş")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(themeManager.currentTheme.colorScheme)
            .onAppear {
                viewModel.loadHistory()
            }
        }
    }
}

struct HistoryCard: View {
    let product: CDProduct
    @EnvironmentObject private var themeManager: ThemeManager
    
    private var riskColor: Color {
        switch product.riskLevel {
        case "Güvenli":
            return .green
        case "Riskli":
            return .red
        case "Dikkat":
            return .orange
        default:
            return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Risk indicator
            Circle()
                .fill(riskColor)
                .frame(width: 12, height: 12)
                .shadow(color: riskColor.opacity(0.5), radius: 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name ?? "Ürün")
                    .font(.headline)
                    .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                
                if let brand = product.brand, !brand.isEmpty {
                    Text(brand)
                        .font(.subheadline)
                        .foregroundColor(Color.appSecondaryText(theme: themeManager.currentTheme))
                }
                
                HStack {
                    Label(product.riskLevel ?? "", systemImage: "exclamationmark.shield.fill")
                        .font(.caption)
                        .foregroundColor(riskColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(riskColor.opacity(themeManager.currentTheme == .dark ? 0.2 : 0.15))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Text(product.scanDate ?? Date(), style: .date)
                        .font(.caption)
                        .foregroundColor(Color.appTertiaryText(theme: themeManager.currentTheme))
                }
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color.appTertiaryText(theme: themeManager.currentTheme))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appCard(theme: themeManager.currentTheme))
                .shadow(color: themeManager.currentTheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
    }
}

#Preview {
    HistoryView()
        .environmentObject(ThemeManager())
}
