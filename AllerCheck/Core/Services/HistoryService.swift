//
//  HistoryService.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import Foundation
import CoreData

final class HistoryService {

    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    // 🔹 Ürün kaydet
    func saveProduct(
        product: ProductDTO,
        riskLevel: RiskLevel
    ) throws {
        // Background context kullanarak main thread'i bloklamayalım
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        
        try backgroundContext.performAndWait {
            let cdProduct = CDProduct(context: backgroundContext)

            cdProduct.id = UUID()
            cdProduct.name = product.product_name
            cdProduct.brand = product.brands
            cdProduct.ingredients = product.ingredients_text
            cdProduct.riskLevel = riskLevel.title
            cdProduct.scanDate = Date()

            do {
                try backgroundContext.save()
            } catch {
                print("❌ CoreData Save Error:", error)
                throw error
            }
        }
    }

    // 🔹 Geçmişi getir
    func fetchHistory() throws -> [CDProduct] {
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "scanDate", ascending: false)
        ]
        
        // Fetch limit ekle (performans için)
        request.fetchLimit = 100

        do {
            return try context.fetch(request)
        } catch {
            print("❌ CoreData Fetch Error:", error)
            throw error
        }
    }
}
