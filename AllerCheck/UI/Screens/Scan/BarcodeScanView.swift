//
//  BarcodeScanView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct BarcodeScanView: View {
    @StateObject private var viewModel = BarcodeScanViewModel()
    
    var body: some View {
        ZStack {
            CameraView(session: viewModel.session)
                .ignoresSafeArea()
            VStack {
                Text("Barkodu kameraya hizalayın")
                    .padding()
                           .background(.black.opacity(0.6))
                           .foregroundColor(.white)
                           .cornerRadius(10)

                       Spacer()
            }
            
            if let code = viewModel.scannedCode {
                VStack {
                    Spacer()

                    Text("Barkod: \(code)")
                        .padding()
                        .background(.green)
                        .cornerRadius(12)
                        .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            viewModel.startScanning()
        }
        .onDisappear {
            viewModel.stopScanning()
        }
    }
}

#Preview {
    BarcodeScanView()
}
