//
//  ProductDTO.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import Foundation

struct ProductResponseDTO: Decodable {
    let status: Int
    let product: ProductDTO?
}

struct ProductDTO: Decodable {
    let product_name: String?
    let brands: String?
    let ingredients_text: String?
    let allergens: String?
}

extension ProductDTO: Identifiable, Hashable {

    var id: String {
        product_name ?? UUID().uuidString
    }

    static func == (lhs: ProductDTO, rhs: ProductDTO) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
