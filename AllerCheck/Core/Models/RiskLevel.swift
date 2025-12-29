//
//  RiskLevel.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import Foundation
import SwiftUI

enum RiskLevel {
    case safe
    case warning
    case danger
    
    var title : String {
        switch self {
        case .safe:
            return "Güvenli"
        case .warning:
            return "Dikkat"
        case .danger:
            return "Riskli"
        }
    }
    
    var description: String {
        switch self {
        case .safe:
            return "Bu ürün seçilen alerjenleri içermiyor."
        case .warning:
            return "Ürün iz miktarda alerjen içerebilir."
        case .danger:
            return "Bu ürün alerjen içeriyor!"
        }
    }
    
    var color: Color {
        switch self {
        case .safe:
            return .green
        case .warning:
            return .yellow
        case .danger:
            return .red
        }
    }
}
