//
//  HistoryView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct HistoryView: View {

    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.products, id: \.id) { product in
                    VStack(alignment: .leading, spacing: 6) {

                        Text(product.name ?? "Ürün")
                            .font(.headline)

                        Text(product.riskLevel ?? "")
                            .foregroundColor(.secondary)

                        Text(product.scanDate ?? Date(), style: .date)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Geçmiş")
            .onAppear {
                viewModel.loadHistory()
            }
        }
    }
}

#Preview {
    HistoryView()
}

