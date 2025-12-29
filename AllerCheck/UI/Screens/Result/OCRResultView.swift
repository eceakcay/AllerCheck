//
//  OCRResultView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 29.12.2025.
//

import SwiftUI

struct OCRResultView: View {

    let ocrText: String

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

            ScrollView {
                Text(ocrText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
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
            viewModel.calculateRiskFromOCR(
                ingredientsText: ocrText,
                userAllergens: userSettings.selectedAllergens
            )
        }
    }
}

