//
//  HomeView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct HomeView: View {
    @State private var navigateToBarcode = false
    @State private var navigateToOCR = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dynamic theme background
                let isDark = themeManager.currentTheme == .dark
                LinearGradient(
                    colors: [
                        Color.appBackground(theme: themeManager.currentTheme),
                        isDark ? Color(red: 0.12, green: 0.15, blue: 0.12) : Color.appLightGreen
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
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
                                
                                Image(systemName: "shield.checkered")
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
                            
                            Text("AllerCheck")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                            
                            Text("Ürünlerinizi güvenle kontrol edin")
                                .font(.subheadline)
                                .foregroundColor(Color.appSecondaryText(theme: themeManager.currentTheme))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // MARK: - Action Cards
                        VStack(spacing: 20) {
                            // Barkod Tarama Card
                            Button {
                                navigateToBarcode = true
                            } label: {
                                HStack(spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.appYellow.opacity(0.2), Color.appYellow.opacity(0.1)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 70, height: 70)
                                        
                                        Image(systemName: "barcode.viewfinder")
                                            .font(.system(size: 30))
                                            .foregroundColor(Color.appYellow)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Barkod Tara")
                                            .font(.headline)
                                            .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                                        
                                        Text("Ürün barkodunu okutarak kontrol edin")
                                            .font(.subheadline)
                                            .foregroundColor(Color.appSecondaryText(theme: themeManager.currentTheme))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(Color.appTertiaryText(theme: themeManager.currentTheme))
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.appCard(theme: themeManager.currentTheme))
                                        .shadow(color: isDark ? Color.black.opacity(0.3) : Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Etiket Okuma Card
                            Button {
                                navigateToOCR = true
                            } label: {
                                HStack(spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.green.opacity(0.2), Color.green.opacity(0.1)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 70, height: 70)
                                        
                                        Image(systemName: "doc.text.viewfinder")
                                            .font(.system(size: 30))
                                            .foregroundColor(.green)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Etiket Oku")
                                            .font(.headline)
                                            .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                                        
                                        Text("Etiket fotoğrafı çekerek içindekileri analiz edin")
                                            .font(.subheadline)
                                            .foregroundColor(Color.appSecondaryText(theme: themeManager.currentTheme))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(Color.appTertiaryText(theme: themeManager.currentTheme))
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.appCard(theme: themeManager.currentTheme))
                                        .shadow(color: isDark ? Color.black.opacity(0.3) : Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("Ana Sayfa")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(themeManager.currentTheme.colorScheme)
            .navigationDestination(isPresented: $navigateToBarcode) {
                BarcodeScanView()
            }
            .navigationDestination(isPresented: $navigateToOCR) {
                OCRScanView()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ThemeManager())
}
