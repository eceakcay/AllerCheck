//
//  ResultView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct ResultView: View {

    @StateObject private var viewModel = ResultViewModel()
    let product: ProductDTO
    private let historyService = HistoryService()

    @EnvironmentObject private var userSettings: UserSettings

    // ResultView'den geri dönmek için
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {

            // MARK: - Ürün Adı
            Text(product.product_name ?? "Ürün")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)

            // MARK: - Risk Göstergesi
            Circle()
                .fill(viewModel.riskLevel.color)
                .frame(width: 140, height: 140)

            Text(viewModel.riskLevel.title)
                .font(.largeTitle)
                .bold()

            Text(viewModel.riskLevel.description)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            // MARK: - Yeni Ürün Tara Butonu
            Button {
                dismiss()
            } label: {
                Text("Yeni Ürün Tara")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.bottom, 20)
        }
        .padding()
        .onAppear {
            viewModel.calculateRisk(
                product: product,
                userAllergens: userSettings.selectedAllergens
            )

            historyService.saveProduct(
                product: product,
                riskLevel: viewModel.riskLevel
            )
        }
    }
}

#Preview {
    ResultView(
        product: ProductDTO(
            product_name: "Örnek Ürün",
            brands: "Test Marka",
            ingredients_text: "Süt, şeker",
            allergens: "milk"
        )
    )
    // Preview için environment object ekliyoruz
    .environmentObject(UserSettings())
}
