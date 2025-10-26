<div align="center">

<img src="https://avatars.githubusercontent.com/u/13010539?s=200&v=4" alt="OpenAQ Logo" width="120" />

# OpenAQ Swift Client

**OpenAQ API v3 için modern, `async/await` tabanlı Swift istemcisi.**

</div>

<div align="center">
  
<img src="https://img.shields.io/badge/Swift-5.7%2B-orange" alt="Swift 5.7+">
<img src="https://img.shields.io/badge/Platform-iOS%2013%2B-blue" alt="Platform iOS 13+">
<a href="https://github.com/USERNAME/REPOSITORY/blob/main/LICENSE">
  <img src="https://img.shields.io/badge/License-MIT-lightgrey" alt="License MIT">
</a>
<a href="https://github.com/USERNAME/REPOSITORY/actions/workflows/build.yml">
  <img src="https://img.shields.io/github/actions/workflow/status/USERNAME/REPOSITORY/build.yml?branch=main" alt="Build Status">
</a>

</div>

## Genel Bakış

Bu paket, [OpenAQ](https://openaq.org/) platformunun güçlü v3 API'sine Swift uygulamalarınızdan kolayca erişmeniz için tasarlanmıştır. OpenAQ, dünya çapındaki kamuya açık, gerçek zamanlı ve geçmiş hava kalitesi verilerini toplayan ve paylaşan, kâr amacı gütmeyen bir kuruluştur.

Bu kütüphane ile bu zengin veri kaynağına modern `async/await` sözdizimi ve tam kapsamlı, `Codable` uyumlu data modelleri ile erişin.

## Özellikler

* **Modern Concurrency:** Tamamen `async/await` üzerine kurulu.
* **Tam API Kapsamı:** `Parameters`, `Locations`, `Countries`, `Measurements`, `Latest` ve tüm meta veri endpoint'leri için eksiksiz destek.
* **Güçlü Sorgulama:** Konum, yarıçap, coğrafi kutu (bounding box) ve parametre bazlı detaylı lokasyon sorguları.
* **Gelişmiş Agregasyon (Toplulaştırma):** Saatlik, günlük, aylık, yıllık ve hatta haftanın günü veya yılın ayı bazında toplulaştırılmış ölçüm verileri.
* **Tip Güvenliği (Type-Safe):** Tüm API yanıtları için temiz ve kullanılabilir Swift `struct`'ları.
* **Veri Erişimi:** Hem gerçek zamanlı hem de geçmiş verilere erişim.
* **Detaylı Hata Yönetimi:** Anlaşılır ve spesifik `OpenAQError` enum'u ile güçlü hata yakalama.

## Gereksinimler

* iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
* Swift 5.7+
* Xcode 14+

## Kurulum

`OpenAQ` paketini Swift Package Manager (SPM) kullanarak projenize ekleyebilirsiniz.

Xcode'da: **File > Add Packages...** seçeneğine gidin ve arama çubuğuna bu repository'nin URL'ini yapıştırın:
`https://github.com/CanSagnak1/OpenAQClient`

Veya `Package.swift` dosyanıza `dependencies` dizisi altına ekleyin:

```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MyApp",
    platforms: [
        .iOS(.v13),
    ],
    dependencies: [
        .package(url: "[https://github.com/SENIN-KULLANICI-ADIN/SENIN-REPO-ADIN](https://github.com/SENIN-KULLANICI-ADIN/SENIN-REPO-ADIN)", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MyApp",
            dependencies: [
                .product(name: "OpenAQ", package: "SENIN-REPO-ADIN") // 'package' adını repo adınızla eşleştirin
            ]
        )
    ]
)
````

## Hızlı Başlangıç

OpenAQ API'yi kullanmak için bir API anahtarına ihtiyacınız olacak. [Buradan ücretsiz kayıt olabilirsiniz](https://explore.openaq.org).

```swift
import OpenAQ
import Foundation

// 1. İstemciyi API anahtarınızla başlatın
// Anahtar, tüm istekleri doğrulamak için kullanılır.
let client = OpenAQClient(apiKey: "SIZIN_API_ANAHTARINIZ")

// 2. Asenkron bir fonksiyon içinde API'yi çağırın
func fetchAirQualityParameters() async {
    do {
        // 3. Mevcut tüm hava kalitesi parametrelerini isteyin
        let response = try await client.getParameters(limit: 5)
        
        print("Toplam \(response.meta.found) parametre bulundu.")
        
        // Dönen sonuçlar 'results' dizisindedir
        for parameter in response.results {
            print("- \(parameter.displayName ?? parameter.name) (\(parameter.units)) [ID: \(parameter.id)]")
        }
        
    } catch let error as OpenAQError {
        // 4. Spesifik OpenAQ hatalarını yakalayın
        print("API Hatası: \(error.localizedDescription)")
    } catch {
        // 5. Diğer hataları yakalayın
        print("Beklenmedik Hata: \(error.localizedDescription)")
    }
}

// Fonksiyonu çalıştırmak için
Task {
    await fetchAirQualityParameters()
}

/*
 Örnek Çıktı (Veriler değişebilir):

 Toplam 26 parametre bulundu.
 - PM2.5 (µg/m³) [ID: 2]
 - PM10 (µg/m³) [ID: 1]
 - Ozon (ppm) [ID: 10]
 - Sülfür Dioksit (ppm) [ID: 9]
 - Azot Dioksit (ppm) [ID: 7]
*/
```

## Detaylı Kullanım Örnekleri

### 1\. Koordinat ve Yarıçapa Göre Lokasyon Arama

Belirli bir koordinatın (örneğin, Yeni Delhi) 1000 metre yarıçapındaki PM2.5 ölçen istasyonları bulun.

```swift
func fetchLocationsNearNewDelhi() async throws {
    let pm25ParameterID = 2 // PM2.5 için ID
    let newDelhiCoords = "28.63576,77.22445" // Latitude,Longitude
    
    let response = try await client.getLocations(
        limit: 10,
        parameterId: pm25ParameterID,
        coordinates: newDelhiCoords,
        radius: 1000 // Metre cinsinden yarıçap
    )
    
    print("\(response.results.count) adet istasyon bulundu:")
    for location in response.results {
        print("-> \(location.name) (ID: \(location.id))")
        if let distance = location.distance {
            print("   Uzaklık: \(distance) metre")
        }
    }
}
```

### 2\. Agregasyon: Haftanın Günlerine Göre Veri Çekme

Bir sensörün belirli bir tarih aralığındaki verilerini "haftanın günlerine göre" (Pazartesi, Salı, vb.) toplulaştırılmış olarak alın.

```swift
func fetchDayOfWeekAggregation() async throws {
    let sensorId = 3917 // Örnek bir sensör ID'si (Del Norte, O3 sensörü)
    
    let calendar = Calendar.current
    let dateTo = calendar.date(from: DateComponents(year: 2024, month: 1, day: 31))!
    let dateFrom = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!

    let response = try await client.getDayOfWeekMeasurements(
        sensorId: sensorId,
        source: .hours, // Saatlik verileri baz alarak toplulaştır
        limit: 7,
        dateFrom: dateFrom,
        dateTo: dateTo
    )
    
    print("Ocak 2024 için haftalık ortalamalar (Sensör: \(sensorId)):")
    // 'summary' nesnesi min, max, ortalama gibi istatistikleri içerir
    for measurement in response.results {
        print("- \(measurement.period.label): \(measurement.summary?.avg ?? 0) \(measurement.parameter.units)")
    }
}
```

### 3\. Bir Lokasyonun En Son Verisini Alma

Bir lokasyon ID'si kullanarak oradaki tüm sensörlerin en son ölçüm verilerini alın.

```swift
func fetchLatestDataForLocation() async throws {
    let locationId = 2178 // Örnek lokasyon: Del Norte
    
    let response = try await client.getLatest(locationId: locationId)
    
    print("Lokasyon \(locationId) (\(response.results.first?.coordinates.latitude ?? 0), \(response.results.first?.coordinates.longitude ?? 0)) için en son veriler:")
    for latest in response.results {
        print("  Sensör \(latest.sensorsId) | Değer: \(latest.value)")
        print("  Ölçüm Zamanı (UTC): \(latest.datetime.utc)") //
    }
}
```

## API Kapsamı

Bu kütüphane, OpenAQ v3 API'sinin tüm ana endpoint'lerini destekler:

| Kategori | Metot | Açıklama |
| :--- | :--- | :--- |
| **Parameters** | `getParameters()`<br>`getParameter(id:)` | Ölçüm parametrelerini listeler veya detayını getirir. |
| **Locations** | `getLocations(...)`<br>`getLocation(id:)` | Lokasyonları (istasyonları) arar veya detayını getirir. |
| **Latest** | `getLatest(locationId:)`<br>`getLatest(parameterId:)` | Bir lokasyon veya parametre için en son ölçümleri getirir. |
| **Measurements** | `getMeasurements(...)`<br>`getHourlyMeasurements(...)`<br>`getDailyMeasurements(...)` | Bir sensör için ham veya toplulaştırılmış ölçümleri getirir. |
| **Aggregations** | `getMonthlyMeasurements(...)`<br>`getYearlyMeasurements(...)`<br>`getDayOfWeekMeasurements(...)`<br>`getMonthOfYearMeasurements(...)`<br>`getHourOfDayMeasurements(...)` | Gelişmiş zaman periyotlarına göre toplulaştırma yapar. |
| **Metadata** | `getCountries()`/`getCountry(id:)`<br>`getProviders()`/`getProvider(id:)`<br>`getOwners()`/`getOwner(id:)`<br>`getManufacturers()`/`getManufacturer(id:)`<br>`getInstruments()`/`getInstrument(id:)`<br>`getLicenses()`/`getLicense(id:)` | Ülkeler, sağlayıcılar, lisanslar gibi meta verileri getirir. |
| **Sensors** | `getSensors()`\<g\>`getSensor(id:)` | Sensörleri listeler veya detayını getirir. |

## Hata Yönetimi

Tüm ağ ve API hataları, `OpenAQError` enum'u altında toplanmıştır. Bu, `switch` veya `catch` bloklarında standart HTTP durum kodlarına dayalı spesifik hataları kolayca yakalamanızı sağlar:

```swift
do {
    _ = try await client.getLocation(id: -1) // Geçersiz bir ID
} catch OpenAQError.unprocessableContent {
    print("Sorgu geçersiz veya işlenemez.") // Hata: 422
} catch OpenAQError.notFound {
    print("Bu kaynak bulunamadı.") // Hata: 404
} catch OpenAQError.unauthorized {
    print("API Anahtarınız geçersiz veya eksik.") // Hata: 401
} catch OpenAQError.tooManyRequests {
    print("Rate limit aşıldı. Lütfen bekleyin.") // Hata: 429
} catch {
    print("Bilinmeyen hata: \(error)")
}
```

## Katkıda Bulunma

Katkılarınız ve geri bildirimleriniz her zaman açığız\! Lütfen bir *issue* açın veya *pull request* gönderin.

## Lisans

Bu proje, MIT Lisansı altında yayınlanmıştır. Detaylar için `LICENSE` dosyasına bakın.

```
```
