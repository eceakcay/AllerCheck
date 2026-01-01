//
//  ProfileView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct ProfileView: View {

    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            ZStack {
                // Dynamic theme background
                Color.appBackground(theme: themeManager.currentTheme)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Card
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.appGreen.opacity(0.2), Color.appYellow.opacity(0.15)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.appGreen, Color.appYellow],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            
                            Text("Alerjen Tercihlerim")
                                .font(.title2)
                                .bold()
                                .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                            
                            Text("\(viewModel.selectedAllergens.count) alerjen seçildi")
                                .font(.subheadline)
                                .foregroundColor(Color.appSecondaryText(theme: themeManager.currentTheme))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.appCard(theme: themeManager.currentTheme))
                                .shadow(color: themeManager.currentTheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                        )
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        // MARK: - Theme Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tema")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                            
                            HStack(spacing: 8) {
                                ForEach(AppTheme.allCases, id: \.self) { theme in
                                    Button {
                                        themeManager.currentTheme = theme
                                    } label: {
                                        HStack(spacing: 6) {
                                            Image(systemName: theme == .light ? "sun.max.fill" : "moon.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(themeManager.currentTheme == theme ? Color.appGreen : Color.appTertiaryText(theme: themeManager.currentTheme))
                                            
                                            Text(theme.displayName)
                                                .font(.system(size: 14))
                                                .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(themeManager.currentTheme == theme ? Color.appGreen.opacity(0.1) : Color.appCard(theme: themeManager.currentTheme))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(themeManager.currentTheme == theme ? Color.appGreen.opacity(0.5) : Color.clear, lineWidth: 1.5)
                                                )
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.appCard(theme: themeManager.currentTheme))
                                .shadow(color: themeManager.currentTheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                        
                        // Allergens List
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.allAllergens) { allergen in
                                AllergenToggleCard(
                                    allergen: allergen,
                                    isSelected: viewModel.isSelected(allergen),
                                    onToggle: {
                                        viewModel.toggleAllergen(allergen)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(themeManager.currentTheme.colorScheme)
            .onAppear {
                viewModel.load(from: userSettings.selectedAllergens)
            }
            .onChange(of: viewModel.selectedAllergens) { _ in
                userSettings.selectedAllergens =
                    viewModel.selectedAllergenObjects()
            }
        }
    }
}

struct AllergenToggleCard: View {
    let allergen: Allergen
    let isSelected: Bool
    let onToggle: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.appGreen.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(isSelected ? Color.appGreen : Color.appTertiaryText(theme: themeManager.currentTheme))
                }
                
                // Text
                Text(allergen.name)
                    .font(.headline)
                    .foregroundColor(Color.appPrimaryText(theme: themeManager.currentTheme))
                
                Spacer()
                
                // Toggle indicator
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color.appTertiaryText(theme: themeManager.currentTheme))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appCard(theme: themeManager.currentTheme))
                    .shadow(color: isSelected ? Color.appGreen.opacity(themeManager.currentTheme == .dark ? 0.3 : 0.2) : (themeManager.currentTheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.08)), radius: isSelected ? 8 : 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.appGreen.opacity(0.5) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    ProfileView()
        .environmentObject(UserSettings())
        .environmentObject(ThemeManager())
}
