//
//  OCRTextParser.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import Foundation

struct OCRTextParser {

    private static func normalize(_ text: String) -> String {
        text
            .lowercased()
            .replacingOccurrences(of: "ı", with: "i")
            .replacingOccurrences(of: "ş", with: "s")
            .replacingOccurrences(of: "ğ", with: "g")
            .replacingOccurrences(of: "ç", with: "c")
            .replacingOccurrences(of: "ö", with: "o")
            .replacingOccurrences(of: "ü", with: "u")
    }

    static func extractIngredients(from text: String) -> String? {

        let normalized = normalize(text)

        guard let startRange =
            normalized.range(of: "icindekiler") ??
            normalized.range(of: "ingredients")
        else {
            return nil
        }

        // İçindekiler kelimesinden sonrasını al
        let afterKeyword =
            normalized[startRange.upperBound...]

        // Bitiş kelimeleri
        let stopWords = [
            "enerji",
            "besin",
            "saklayiniz",
            "son tuketim",
            "stt",
            "gunes gormeyen",
            "serin",
            "kuru yerde",
            "buzdolabi",
            "ambalaj",
            "uretici",
            "parti no"
        ]

        var endIndex = afterKeyword.endIndex

        for word in stopWords {
            if let range = afterKeyword.range(of: word) {
                endIndex = range.lowerBound
                break
            }
        }

        let ingredients =
            afterKeyword[..<endIndex]
                .replacingOccurrences(of: ":", with: "")
                .replacingOccurrences(of: "\n", with: " ")
                .trimmingCharacters(in: .whitespacesAndNewlines)

        return ingredients.isEmpty ? nil : ingredients
    }
}
