//
//  MainTabView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
            HistoryView()
                .tabItem {
                    Label("Geçmiş", systemImage: "clock")
                }
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle")
                }
        }
        .tint(Color.appGreen)
        .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
}

#Preview {
    MainTabView()
}
