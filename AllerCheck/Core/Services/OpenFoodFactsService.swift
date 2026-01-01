//
//  OpenFoodFactsService.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import Foundation

final class OpenFoodFactsService {
    
    // Cache için basit in-memory cache
    private var cache: [String: (product: ProductDTO, timestamp: Date)] = [:]
    private let cacheExpirationTime: TimeInterval = 3600 // 1 saat
    private let cacheQueue = DispatchQueue(label: "com.allercheck.cache")
    
    // URLSession configuration ile timeout
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        configuration.timeoutIntervalForResource = 15.0
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()
    
    func fetchProduct(barcode: String) async throws -> ProductDTO {
        // Cache kontrolü
        if let cached = getCachedProduct(barcode: barcode) {
            return cached
        }
        
        let urlString = "https://world.openfoodfacts.org/api/v2/product/\(barcode)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // Retry mekanizması ile istek
        var lastError: Error?
        let maxRetries = 2
        
        for attempt in 0...maxRetries {
            do {
                let (data, urlResponse) = try await session.data(from: url)
                
                // HTTP status kontrolü
                if let httpResponse = urlResponse as? HTTPURLResponse,
                   httpResponse.statusCode != 200 {
                    throw URLError(.badServerResponse)
                }
                
                let decoder = JSONDecoder()
                let productResponse = try decoder.decode(ProductResponseDTO.self, from: data)
                
                guard productResponse.status == 1,
                      let product = productResponse.product else {
                    throw ProductError.notFound
                }
                
                // Cache'e kaydet
                cacheProduct(barcode: barcode, product: product)
                
                return product
                
            } catch {
                lastError = error
                
                // Son deneme değilse bekle ve tekrar dene
                if attempt < maxRetries {
                    try? await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempt)) * 1_000_000_000)) // Exponential backoff
                    continue
                }
            }
        }
        
        throw lastError ?? URLError(.unknown)
    }
    
    // MARK: - Cache Methods
    
    private func getCachedProduct(barcode: String) -> ProductDTO? {
        return cacheQueue.sync {
            guard let cached = cache[barcode],
                  Date().timeIntervalSince(cached.timestamp) < cacheExpirationTime else {
                cache.removeValue(forKey: barcode)
                return nil
            }
            return cached.product
        }
    }
    
    private func cacheProduct(barcode: String, product: ProductDTO) {
        cacheQueue.async {
            self.cache[barcode] = (product: product, timestamp: Date())
        }
    }
}
