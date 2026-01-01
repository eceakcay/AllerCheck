//
//  HistoryViewModel.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import Foundation

import Combine

final class HistoryViewModel: ObservableObject {

    @Published var products: [CDProduct] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service = HistoryService()

    func loadHistory() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedProducts = try service.fetchHistory()
                await MainActor.run {
                    self.products = fetchedProducts
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Geçmiş yüklenirken hata oluştu."
                    self.isLoading = false
                    print("❌ History load error:", error)
                }
            }
        }
    }
}
