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
        let ingredients = product.ingredients_text ?? ""
        calculateRisk(ingredientsText: ingredients, userAllergens: userAllergens)
    }
    
    func calculateRiskFromOCR(
        ingredientsText: String,
        userAllergens: [Allergen]
    ) {
        calculateRisk(ingredientsText: ingredientsText, userAllergens: userAllergens)
    }
    
    // Tek birleşik fonksiyon - kod tekrarını önler
    private func calculateRisk(
        ingredientsText: String,
        userAllergens: [Allergen]
    ) {
        riskLevel = analyzer.analyze(
            ingredientsText: ingredientsText,
            selectedAllergens: userAllergens
        )
    }
}
