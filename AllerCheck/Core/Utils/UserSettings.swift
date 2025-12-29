//
//  UserSettings.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import Combine

final class UserSettings: ObservableObject {
    @Published var selectedAllergens: [Allergen] = []
}
