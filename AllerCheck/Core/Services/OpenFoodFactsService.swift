//
//  OpenFoodFactsService.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import Foundation

final class OpenFoodFactsService {
    
    func fetchProduct(barcode: String) async throws -> ProductDTO {
        let urlString = "https://world.openfoodfacts.org/api/v2/product/\(barcode)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ProductResponseDTO.self, from: data)
        
        guard response.status == 1 ,
              let product = response.product
        else {
            throw ProductError.notFound
        }
        
        return product
    }
}
