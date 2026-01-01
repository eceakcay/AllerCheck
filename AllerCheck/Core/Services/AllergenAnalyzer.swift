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
        
        // Metni kelimelere ayır ve normalize et
        let words = ingredientsLowercased
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }

        for allergen in selectedAllergens {
            for keyword in allergen.keywords {
                let keywordLower = keyword.lowercased()
                
                // Tam kelime eşleşmesi kontrolü
                if words.contains(keywordLower) {
                    return .danger
                }
                
                // Kelime sınırları içinde eşleşme kontrolü (örn: "gluten-free" içinde "gluten" bulunmamalı)
                let wordBoundaryPattern = "\\b\(NSRegularExpression.escapedPattern(for: keywordLower))\\b"
                if let regex = try? NSRegularExpression(pattern: wordBoundaryPattern, options: .caseInsensitive),
                   regex.firstMatch(in: ingredientsLowercased, range: NSRange(location: 0, length: ingredientsLowercased.utf16.count)) != nil {
                    return .danger
                }
            }
        }

        return .safe
    }
}
