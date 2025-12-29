//
//  HistoryService.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import Foundation
import CoreData

final class HistoryService {

    private let context =
        PersistenceController.shared.container.viewContext

    // 🔹 Ürün kaydet
    func saveProduct(
        product: ProductDTO,
        riskLevel: RiskLevel
    ) {
        let cdProduct = CDProduct(context: context)

        cdProduct.id = UUID()
        cdProduct.name = product.product_name
        cdProduct.brand = product.brands
        cdProduct.ingredients = product.ingredients_text
        cdProduct.riskLevel = riskLevel.title
        cdProduct.scanDate = Date()

        do {
            try context.save()
        } catch {
            print("❌ CoreData Save Error:", error)
        }
    }

    // 🔹 Geçmişi getir
    func fetchHistory() -> [CDProduct] {
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "scanDate", ascending: false)
        ]

        return (try? context.fetch(request)) ?? []
    }
}
