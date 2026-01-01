//
//  UserSettings.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import Combine
import Foundation

final class UserSettings: ObservableObject {

    @Published var selectedAllergens: [Allergen] = [] {
        didSet {
            print("💾 SAVE:", selectedAllergens.map { $0.name })
            saveAllergens()
        }
    }

    private let key = "selectedAllergens"

    init() {
        loadAllergens()
    }

    private func saveAllergens() {
        let names = selectedAllergens.map { $0.name }
        UserDefaults.standard.set(names, forKey: key)
        // synchronize() artık gerekli değil - otomatik senkronize ediliyor
    }

    private func loadAllergens() {
        let savedNames =
            UserDefaults.standard.stringArray(forKey: key) ?? []

        print("📥 LOAD:", savedNames)

        selectedAllergens = AllergenData.all.filter {
            savedNames.contains($0.name)
        }
    }
}


