//
//  AllerCheckApp.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

@main
struct AllerCheckApp: App {
    @StateObject private var userSettings = UserSettings()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(userSettings)
        }
    }
}
