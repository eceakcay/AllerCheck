//
//  Allergen.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import Foundation

struct Allergen: Identifiable {
    let id = UUID()
    let name: String
    let keywords: [String]
}
