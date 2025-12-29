//
//  AllergenData.swift
//  AllerCheck
//
//  Created by Ece Akcay on 28.12.2025.
//

import Foundation

struct AllergenData {

    static let all: [Allergen] = [

        // Süt ve süt ürünleri
        Allergen(
            name: "Laktoz",
            keywords: [
                "milk", "lactose",
                "süt", "peynir", "yoğurt", "krema", "tereyağı", "whey", "casein"
            ]
        ),

        // Gluten içeren tahıllar
        Allergen(
            name: "Gluten",
            keywords: [
                "gluten", "buğday", "wheat",
                "arpa", "çavdar", "yulaf", "malt"
            ]
        ),

        // Yumurta
        Allergen(
            name: "Yumurta",
            keywords: [
                "egg", "yumurta",
                "albumin", "ovalbumin"
            ]
        ),

        // Yer fıstığı
        Allergen(
            name: "Fıstık",
            keywords: [
                "peanut", "yer fıstığı",
                "groundnut"
            ]
        ),

        // Soya
        Allergen(
            name: "Soya",
            keywords: [
                "soy", "soya",
                "soybean", "soya lesitini", "lecithin"
            ]
        ),

        // Kabuklu yemişler
        Allergen(
            name: "Kabuklu Yemişler",
            keywords: [
                "almond", "badem",
                "hazelnut", "fındık",
                "walnut", "ceviz",
                "cashew", "kajun",
                "pistachio", "antep fıstığı"
            ]
        ),

        // Balık
        Allergen(
            name: "Balık",
            keywords: [
                "fish", "balık",
                "tuna", "ton balığı",
                "salmon", "somon"
            ]
        ),

        // Kabuklu deniz ürünleri
        Allergen(
            name: "Kabuklu Deniz Ürünleri",
            keywords: [
                "shrimp", "karides",
                "crab", "yengeç",
                "lobster", "ıstakoz"
            ]
        ),

        // Susam
        Allergen(
            name: "Susam",
            keywords: [
                "sesame", "susam",
                "tahini", "tahin"
            ]
        ),

        // Hardal
        Allergen(
            name: "Hardal",
            keywords: [
                "mustard", "hardal"
            ]
        ),

        // Kereviz
        Allergen(
            name: "Kereviz",
            keywords: [
                "celery", "kereviz"
            ]
        ),

        // Sülfitler
        Allergen(
            name: "Sülfit",
            keywords: [
                "sulfite", "sülfit",
                "sulphur dioxide", "kükürt dioksit"
            ]
        )
    ]
}
