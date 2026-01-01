//
//  AppTheme.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import SwiftUI
import Combine

enum AppTheme: String, CaseIterable {
    case light
    case dark
    
    var colorScheme: ColorScheme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    var displayName: String {
        switch self {
        case .light:
            return "Açık"
        case .dark:
            return "Koyu"
        }
    }
}

final class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme = .light {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "appTheme")
        }
    }

    init() {
        if let savedTheme = UserDefaults.standard.string(forKey: "appTheme"),
           let theme = AppTheme(rawValue: savedTheme) {
            self.currentTheme = theme
        }
    }
}

// MARK: - Color Extensions for Dark Mode
extension Color {
    // Helper to determine if dark mode
    private static func isDarkMode(theme: AppTheme) -> Bool {
        return theme == .dark
    }
    
    // Brand colors - Yellow and Green
    static var appGreen: Color {
        Color(red: 0.2, green: 0.75, blue: 0.4) // Vibrant green
    }
    
    static var appYellow: Color {
        Color(red: 1.0, green: 0.85, blue: 0.2) // Vibrant yellow
    }
    
    static var appLightGreen: Color {
        Color(red: 0.85, green: 0.95, blue: 0.85) // Light green tint
    }
    
    static var appLightYellow: Color {
        Color(red: 1.0, green: 0.98, blue: 0.9) // Light yellow tint
    }
    
    // Background colors with yellow/green theme
    static func appBackground(theme: AppTheme) -> Color {
        return isDarkMode(theme: theme) 
            ? Color(red: 0.1, green: 0.15, blue: 0.1) // Dark green tint
            : appLightYellow // Light yellow background
    }
    
    // Card colors
    static func appCard(theme: AppTheme) -> Color {
        return isDarkMode(theme: theme)
            ? Color(red: 0.15, green: 0.2, blue: 0.15) // Dark green card
            : Color.white
    }
    
    // Primary text
    static func appPrimaryText(theme: AppTheme) -> Color {
        return isDarkMode(theme: theme)
            ? Color.white
            : Color(red: 0.1, green: 0.1, blue: 0.1)
    }
    
    // Secondary text
    static func appSecondaryText(theme: AppTheme) -> Color {
        return isDarkMode(theme: theme)
            ? Color.gray
            : Color(red: 0.3, green: 0.3, blue: 0.3)
    }
    
    // Tertiary text
    static func appTertiaryText(theme: AppTheme) -> Color {
        return isDarkMode(theme: theme)
            ? Color.gray.opacity(0.7)
            : Color(red: 0.4, green: 0.4, blue: 0.4)
    }
}

