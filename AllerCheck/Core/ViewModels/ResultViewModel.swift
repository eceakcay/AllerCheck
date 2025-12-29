//
//  ResultViewModel.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import Foundation
import Combine

final class ResultViewModel: ObservableObject {

    @Published var riskLevel: RiskLevel = .safe

    private let analyzer = AllergenAnalyzer()

    func calculateRisk(
        product: ProductDTO,
        userAllergens: [Allergen]
    ) {

        let ingredients =
        product.ingredients_text ?? ""

        riskLevel = analyzer.analyze(
            ingredientsText: ingredients,
            selectedAllergens: userAllergens
        )
    }
    
    func calculateRiskFromOCR(
        ingredientsText: String,
        userAllergens: [Allergen]
    ) {
        let lowercasedText = ingredientsText.lowercased()

        var detectedNames: [String] = []

        for allergen in userAllergens {
            for keyword in allergen.keywords {
                if lowercasedText.contains(keyword.lowercased()) {
                    detectedNames.append(allergen.name)
                    break
                }
            }
        }

        if detectedNames.isEmpty {
            riskLevel = .safe
        } else {
            riskLevel = .danger
        }
    }
}
