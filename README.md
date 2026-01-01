# AllerCheck

AllerCheck, ürünlerin alerjen içeriğini kontrol etmenize yardımcı olan bir iOS uygulamasıdır. Barkod tarama ve OCR (Optik Karakter Tanıma) teknolojileri kullanarak ürün etiketlerini analiz eder ve kullanıcının seçtiği alerjenleri tespit eder.

## 📱 Özellikler

### Temel Özellikler
- **Barkod Tarama**: Ürün barkodunu okutarak OpenFoodFacts API'sinden ürün bilgilerini çeker
- **OCR Tarama**: Ürün etiketinin fotoğrafını çekerek içindekiler listesini analiz eder
- **Alerjen Tespiti**: 12 farklı alerjen türünü otomatik olarak tespit eder
- **Risk Seviyesi**: Ürünlerin risk seviyesini (Güvenli, Dikkat, Riskli) gösterir
- **Geçmiş**: Taradığınız ürünlerin geçmişini görüntüleyin
- **Profil**: Kişisel alerjen tercihlerinizi yönetin

### Desteklenen Alerjenler
- Laktoz (Süt ve süt ürünleri)
- Gluten (Buğday, arpa, çavdar, yulaf)
- Yumurta
- Fıstık
- Soya
- Kabuklu Yemişler (Badem, fındık, ceviz, kajun, antep fıstığı)
- Balık
- Kabuklu Deniz Ürünleri
- Susam
- Hardal
- Kereviz
- Sülfit

### Teknik Özellikler
- **Dark/Light Mode**: Tema desteği
- **CoreData**: Yerel veri saklama
- **Cache Mekanizması**: API yanıtlarını cache'ler
- **Retry Logic**: Ağ hatalarında otomatik yeniden deneme
- **Modern UI**: SwiftUI ile geliştirilmiş modern arayüz

## 🛠 Teknolojiler

- **SwiftUI**: Kullanıcı arayüzü
- **CoreData**: Veri kalıcılığı
- **Vision Framework**: OCR işlemleri için
- **AVFoundation**: Kamera erişimi
- **URLSession**: Ağ istekleri
- **OpenFoodFacts API**: Ürün bilgileri

## 📋 Gereksinimler

- iOS 16.0 veya üzeri
- Xcode 15.0 veya üzeri
- Swift 5.9 veya üzeri
- Kamera erişimi (OCR ve barkod tarama için)

## 🚀 Kurulum

1. Projeyi klonlayın:
```bash
git clone <repository-url>
cd AllerCheck
```

2. Xcode'da projeyi açın:
```bash
open AllerCheck.xcodeproj
```

3. Projeyi derleyin ve çalıştırın (⌘R)

## 📁 Proje Yapısı

```
AllerCheck/
├── App/
│   ├── AllerCheckApp.swift      # Ana uygulama giriş noktası
│   └── Persistence.swift        # CoreData yapılandırması
├── Core/
│   ├── Models/                  # Veri modelleri
│   ├── Services/                # API ve iş mantığı servisleri
│   ├── ViewModels/              # MVVM view modelleri
│   ├── Helpers/                 # Yardımcı sınıflar
│   └── Utils/                   # Yardımcı araçlar
└── UI/
    ├── Screens/                 # Ekran görünümleri
    └── Components/              # Yeniden kullanılabilir bileşenler
```

## 🎯 Kullanım

### Barkod Tarama
1. Ana ekrandan "Barkod Tara" seçeneğini seçin
2. Kamerayı ürün barkoduna yönlendirin
3. Uygulama otomatik olarak barkodu okur ve ürün bilgilerini getirir
4. Sonuç ekranında alerjen analizi görüntülenir

### OCR Tarama
1. Ana ekrandan "Etiket Oku" seçeneğini seçin
2. Ürün etiketinin fotoğrafını çekin
3. Uygulama etiketten metni çıkarır ve alerjen analizi yapar
4. Sonuç ekranında tespit edilen alerjenler gösterilir

### Profil Ayarları
1. Profil sekmesine gidin
2. Alerjen tercihlerinizi seçin/deseçleyin
3. Tema tercihinizi ayarlayın (Açık/Koyu)

## 🔧 Yapılandırma

### API Ayarları
Uygulama OpenFoodFacts API'sini kullanır. API endpoint'i `OpenFoodFactsService.swift` dosyasında yapılandırılmıştır:

```swift
let urlString = "https://world.openfoodfacts.org/api/v2/product/\(barcode)"
```

### Cache Ayarları
Cache süresi varsayılan olarak 1 saat olarak ayarlanmıştır. `OpenFoodFactsService.swift` dosyasında değiştirilebilir:

```swift
private let cacheExpirationTime: TimeInterval = 3600 // 1 saat
```

## 📝 Lisans

Bu proje kişisel kullanım için geliştirilmiştir.

## 👤 Geliştirici

Ece Akcay

## 🙏 Teşekkürler

- [OpenFoodFacts](https://world.openfoodfacts.org/) - Ürün veritabanı API'si
- Apple - SwiftUI ve iOS framework'leri

---

**Not**: Bu uygulama bilgilendirme amaçlıdır. Ciddi alerjik reaksiyonlar için mutlaka bir sağlık uzmanına danışın.

