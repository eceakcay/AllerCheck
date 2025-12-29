//
//  ProfileViewModel.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import Combine

final class ProfileViewModel: ObservableObject {

    // Kullanıcının seçtiği alerjenler
    @Published var selectedAllergens: Set<String> = []

    // Sistem alerjen listesi
    let allAllergens = AllergenData.all

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

    // ResultView için seçilen alerjenleri döner
    func selectedAllergenObjects() -> [Allergen] {
        allAllergens.filter {
            selectedAllergens.contains($0.name)
        }
    }
}
