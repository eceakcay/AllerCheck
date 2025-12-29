//
//  ProfileView.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import SwiftUI

struct ProfileView: View {

    // Profil ekranının kendi ViewModel’i
    @StateObject private var viewModel = ProfileViewModel()

    // Global kullanıcı ayarları (EnvironmentObject)
    @EnvironmentObject private var userSettings: UserSettings

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Alerjen Tercihlerim")) {
                    ForEach(viewModel.allAllergens) { allergen in
                        Toggle(
                            allergen.name,
                            isOn: Binding(
                                get: {
                                    viewModel.isSelected(allergen)
                                },
                                set: { _ in
                                    viewModel.toggleAllergen(allergen)
                                }
                            )
                        )
                    }
                }
            }
            .navigationTitle("Profil")
            .onChange(of: viewModel.selectedAllergens) { _ in
                userSettings.selectedAllergens =
                    viewModel.selectedAllergenObjects()
            }
        }
    }
}

#Preview {
    // Preview için mock UserSettings ekliyoruz
    ProfileView()
        .environmentObject(UserSettings())
}
