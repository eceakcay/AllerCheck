//
//  OCRResultView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import SwiftUI

struct OCRResultView: View {

    let ocrText: String
    
    @State private var extractedIngredients: String?
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var viewModel = ResultViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {

            Text("Etiket Analizi")
                .font(.title)
                .bold()

            Circle()
                .fill(viewModel.riskLevel.color)
                .frame(width: 140, height: 140)

            Text(viewModel.riskLevel.title)
                .font(.largeTitle)
                .bold()

            Text(viewModel.riskLevel.description)
                .multilineTextAlignment(.center)
                .padding()

            if let ingredients = extractedIngredients {
                VStack(alignment: .leading, spacing: 8) {

                    Text("İçindekiler")
                        .font(.headline)

                    Text(ingredients)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Yeni Etiket Tara")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
        }
        .padding()
        .onAppear {
            guard let ingredients =
                OCRTextParser.extractIngredients(from: ocrText) else {

                viewModel.riskLevel = .warning
                extractedIngredients = nil
                print("⚠️ İçindekiler bulunamadı")
                return
            }

            extractedIngredients = ingredients

            print("🧾 EKRANDA GÖSTERİLEN İÇİNDEKİLER: \(ingredients)")

            viewModel.calculateRiskFromOCR(
                ingredientsText: ingredients,
                userAllergens: userSettings.selectedAllergens
            )
        }
    }
}

