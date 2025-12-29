//
//  MainTabView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            BarcodeScanView()
                .tabItem {
                    Label("Tara", systemImage: "barcode.viewfinder")
                }
            OCRScanView()
                .tabItem {
                    Label("Etiket", systemImage: "doc.text.viewfinder")
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
    }
}

#Preview {
    MainTabView()
}
