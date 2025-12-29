//
//  AllerCheckApp.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import SwiftUI
import CoreData

@main
struct AllerCheckApp: App {

    // CoreData
    let persistenceController = PersistenceController.shared

    // Global kullanıcı ayarları (alerjen seçimleri)
    @StateObject private var userSettings = UserSettings()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                // CoreData context
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext
                )
                // User settings (profil)
                .environmentObject(userSettings)
        }
    }
}
