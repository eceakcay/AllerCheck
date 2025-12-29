//
//  AllergenAnalyzer.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import Foundation

final class AllergenAnalyzer {

    func analyze(
        ingredientsText: String,
        selectedAllergens: [Allergen]
    ) -> RiskLevel {

        let ingredientsLowercased = ingredientsText.lowercased()

        for allergen in selectedAllergens {
            for keyword in allergen.keywords {
                if ingredientsLowercased.contains(keyword.lowercased()) {
                    return .danger
                }
            }
        }

        return .safe
    }
}
