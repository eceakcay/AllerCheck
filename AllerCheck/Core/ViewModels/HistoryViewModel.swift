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

    private let service = HistoryService()

    func loadHistory() {
        products = service.fetchHistory()
    }
}
