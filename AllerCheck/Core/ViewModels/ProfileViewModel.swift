//
//  ProfileViewModel.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import Combine

final class ProfileViewModel: ObservableObject {

    @Published var selectedAllergens: Set<String> = []

    let allAllergens = AllergenData.all

    // 🔥 DIŞARIDAN BAŞLATILABİLİR INIT
    func load(from allergens: [Allergen]) {
        selectedAllergens = Set(allergens.map { $0.name })
    }

    func toggleAllergen(_ allergen: Allergen) {
        if selectedAllergens.contains(allergen.name) {
            selectedAllergens.remove(allergen.name)
        } else {
            selectedAllergens.insert(allergen.name)
        }
    }

    func isSelected(_ allergen: Allergen) -> Bool {
        selectedAllergens.contains(allergen.name)
    }

    func selectedAllergenObjects() -> [Allergen] {
        allAllergens.filter {
            selectedAllergens.contains($0.name)
        }
    }
}
