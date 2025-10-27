//
//  OpenAQTests.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import XCTest
@testable import OpenAQ

final class OpenAQTests: XCTestCase {
    
    var client: OpenAQClient!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let apiKey = "3d4f3434b2cbfc2cbc0129ffc3307c5a26547f3340225516d3f17965c75ba876"
        self.client = OpenAQClient(apiKey: apiKey)
    }
    
    func test_01_GetParameters_SuccessAndDecode() async throws {
        guard let client = self.client else { return }
        let response = try await client.getParameters(limit: 5)
        XCTAssertEqual(response.meta.limit, 5)
        XCTAssertFalse(response.results.isEmpty)
        XCTAssertNotNil(response.results.first?.name)
    }
    
    func test_02_GetLocationDetails_SuccessAndDecode() async throws {
        guard let client = self.client else { return }
        let locationId = 8118
        let response = try await client.getLocation(id: locationId)
        let location = try XCTUnwrap(response.results.first)
        XCTAssertEqual(location.id, locationId)
        XCTAssertEqual(location.name, "New Delhi")
        XCTAssertFalse(location.sensors.isEmpty)
    }
    
    func test_03_Error_401_InvalidKey() async {
        let invalidClient = OpenAQClient(apiKey: "BU_KESINLIKLE_GECERSIZ_BIR_ANAHTAR")
        do {
            _ = try await invalidClient.getParameters()
            XCTFail("İstek geçersiz anahtar ile başarılı olmamalıydı.")
        } catch {
            guard let aqError = error as? OpenAQError else {
                XCTFail("Hata 'OpenAQError' tipinde olmalıydı, ama '\(type(of: error))' tipinde geldi.")
                return
            }
            XCTAssertEqual(aqError, .unauthorized)
        }
    }
    
    func test_04_Error_404_NotFound() async {
        guard let client = self.client else { return }
        do {
            _ = try await client.getLocation(id: -1)
            XCTFail("İstek var olmayan bir ID ile başarılı olmamalıydı.")
        } catch let error as OpenAQError {
            XCTAssertEqual(error, .unprocessableContent)
        } catch {
            XCTFail("Hata 'OpenAQError' tipinde olmalıydı.")
        }
    }
    
    func test_05_Error_422_UnprocessableContent() async {
        guard let client = self.client else { return }
        
        do {
            _ = try await client.getLocations(
                page: 1,
                limit: 1,
                parameterId: nil as Int?,
                coordinates: "28.63,77.22",
                radius: 1000,
                bbox: "5.48,-0.39,5.73,-0.02"
            )
            XCTFail("Hem radius hem bbox ile yapılan istek başarılı olmamalıydı.")
        } catch let error as OpenAQError {
            XCTAssertEqual(error, .serverError(code: 500))
        } catch {
            XCTFail("Hata 'OpenAQError' tipinde olmalıydı.")
        }
    }
    
    func test_06_Locations_QueryByParameterID() async throws {
        guard let client = self.client else { return }
        let pm25ParameterID = 2
        let response = try await client.getLocations(limit: 5, parameterId: pm25ParameterID)
        XCTAssertFalse(response.results.isEmpty, "PM2.5 için sonuç gelmeli.")
        let firstLocation = try XCTUnwrap(response.results.first)
        let hasPM25Sensor = firstLocation.sensors.contains { $0.parameter.id == pm25ParameterID }
        XCTAssertTrue(hasPM25Sensor, "Dönen lokasyonun bir PM2.5 sensörüne sahip olması beklenir.")
    }
    
    func test_07_Locations_QueryByRadius() async throws {
        guard let client = self.client else { return }
        let coords = "28.63576,77.22445"
        let newDelhiID = 8118
        let response = try await client.getLocations(coordinates: coords, radius: 1000)
        let locationIDs = response.results.map { $0.id }
        XCTAssertTrue(locationIDs.contains(newDelhiID), "New Delhi (8118) kendi koordinatlarının 1km (radius) içinde olmalı.")
    }
    
    func test_08_Pagination_QueryPage2() async throws {
        guard let client = self.client else { return }
        let response1 = try await client.getParameters(page: 1, limit: 1)
        let firstResultID = try XCTUnwrap(response1.results.first?.id)
        let response2 = try await client.getParameters(page: 2, limit: 1)
        let secondResultID = try XCTUnwrap(response2.results.first?.id)
        XCTAssertNotEqual(firstResultID, secondResultID, "Sayfa 1'deki sonuç ile Sayfa 2'deki sonuç farklı olmalı.")
    }
    
    
    func test_09_Latest_Decoding_CodingKeys() async throws {
        guard let client = self.client else { return }
        let locationId = 2178
        let response = try await client.getLatest(locationId: locationId)
        XCTAssertFalse(response.results.isEmpty, "En son ölçüm (latest) sonuçları boş gelmemeli.")
        let firstLatest = try XCTUnwrap(response.results.first)
        XCTAssertEqual(firstLatest.locationsId, locationId, "locationsId alanı yanlış çözümlendi.")
        XCTAssertGreaterThan(firstLatest.sensorsId, 0, "sensorsId alanı 0'dan büyük olmalı.")
        XCTAssertNotNil(firstLatest.datetime.utc, "Tarih nesnesi (UTC) çözümlenmeli.")
    }
    
    func test_10_Measurements_Aggregation_DayOfWeek() async throws {
        guard let client = self.client else { return }
        let sensorId = 3917
        
        let calendar = Calendar.current
        let dateTo = calendar.date(from: DateComponents(year: 2024, month: 1, day: 31))!
        let dateFrom = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        
        let response = try await client.getDayOfWeekMeasurements(
            sensorId: sensorId,
            source: .hours,
            page: 1,
            limit: 7,
            dateFrom: dateFrom,
            dateTo: dateTo
        )
        
        XCTAssertEqual(response.results.count, 7)
        let firstDay = try XCTUnwrap(response.results.first)
        XCTAssertNotNil(firstDay.summary, "Toplulaştırılmış (aggregated) veride 'summary' nesnesi olmalı.")
        XCTAssertNotNil(firstDay.summary?.avg, "Ortalama (avg) değeri çözümlenmeli.")
    }
    
    func test_11_AdvancedIntegrationFetch() async throws {
        guard let client = self.client else { return }
        do {
            let locationId = 2178
            let locationResponse = try await client.getLocation(id: locationId)
            let location = try XCTUnwrap(locationResponse.results.first, "1. Adım Başarısız: Lokasyon (2178) bulunamadı.")
            
            XCTAssertEqual(location.name, "Del Norte")
            print("1. Lokasyon Çekildi: \(location.name)")
            
            let sensorId = 3917
            let sensorShort = try XCTUnwrap(location.sensors.first(where: { $0.id == sensorId }), "2. Adım Başarısız: Sensör (3917) lokasyonda bulunamadı.")
            
            let sensorResponse = try await client.getSensor(id: sensorShort.id)
            let sensor = try XCTUnwrap(sensorResponse.results.first, "2. Adım Başarısız: Sensör (3917) detayları çekilemedi.")
            
            XCTAssertEqual(sensor.name, "o3 ppm")
            print("2. Sensör Detayı Çekildi: \(sensor.name)")
            
            
            let calendar = Calendar.current
            let dateTo = calendar.date(from: DateComponents(year: 2024, month: 1, day: 31))!
            let dateFrom = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!
            
            let measurementsResponse = try await client.getDayOfWeekMeasurements(
                sensorId: sensorId,
                source: .hours,
                page: 1,
                limit: 7,
                dateFrom: dateFrom,
                dateTo: dateTo
            )
            
            XCTAssertEqual(measurementsResponse.results.count, 7)
            print("3. Ölçümler Çekildi: Haftanın 7 günü için toplulaştırma alındı.")
            
            let countryId = try XCTUnwrap(location.country?.id, "4. Adım Başarısız: Lokasyonun ülke ID'si yok.")
            let countryResponse = try await client.getCountry(id: countryId)
            let country = try XCTUnwrap(countryResponse.results.first, "4. Adım Başarısız: Ülke (155) çekilemedi.")
            
            XCTAssertEqual(country.code, "US")
            print("4. Ülke Çekildi: \(country.name)")
            
            let providerId = try XCTUnwrap(location.provider?.id, "5. Adım Başarısız: Lokasyonun sağlayıcı ID'si yok.")
            let providerResponse = try await client.getProvider(id: providerId)
            let provider = try XCTUnwrap(providerResponse.results.first, "5. Adım Başarısız: Sağlayıcı (119) çekilemedi.")
            
            XCTAssertEqual(provider.name, "AirNow")
            print("5. Sağlayıcı Çekildi: \(provider.name)")
            
            let instrumentId = try XCTUnwrap(location.instruments.first?.id, "6. Adım Başarısız: Lokasyonun cihaz ID'si yok.")
            let instrumentResponse = try await client.getInstrument(id: instrumentId)
            let instrument = try XCTUnwrap(instrumentResponse.results.first, "6. Adım Başarısız: Cihaz (2) çekilemedi.")
            
            XCTAssertEqual(instrument.name, "Government Monitor")
            print("6. Cihaz Çekildi: \(instrument.name)")
            
            let manufacturerId = instrument.manufacturer.id
            let manufacturerResponse = try await client.getManufacturer(id: manufacturerId)
            let manufacturer = try XCTUnwrap(manufacturerResponse.results.first, "7. Adım Başarısız: Üretici (4) çekilemedi.")
            
            XCTAssertEqual(manufacturer.id, 4)
            print("7. Üretici Çekildi: \(manufacturer.name)")
            
            let latestResponse = try await client.getLatest(locationId: locationId)
            let latestMeasurement = try XCTUnwrap(latestResponse.results.first, "8. Adım Başarısız: 'En Son' veri çekilemedi.")
            
            XCTAssertEqual(latestMeasurement.locationsId, locationId)
            print("8. 'En Son' Veri Çekildi. (Örn: Değer \(latestMeasurement.value))")
        } catch {
            XCTFail("Gelişmiş veri çekme testi başarısız oldu: \(error.localizedDescription)")
        }
    }
    
    func test_12_FetchRecentAndLatestDataInTurkey() async throws {
        guard let client = self.client else { return }
        
        print("\nTEST 12: TÜRKİYE (SON 1 AY) AKTİF SENSÖR TESTİ BAŞLADI")
        
        let turkeyBbox = "25.4,35.8,44.9,42.1"
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        
        do {
            let response = try await client.getLocations(limit: 500, bbox: turkeyBbox)
            let allLocations = response.results
            let recentLocations = allLocations.filter { location in
                guard let lastDate = location.datetimeLast?.utc else {
                    return false
                }
                return lastDate > oneMonthAgo
            }
            
            XCTAssertFalse(recentLocations.isEmpty, "Türkiye'de son 1 ayda veri gönderen aktif lokasyon bulunamadı.")
            
            print("Başarılı: Türkiye'de \(allLocations.count) lokasyon bulundu.")
            print("Bunlardan \(recentLocations.count) tanesi SON 1 AY İÇİNDE veri göndermiş.")
            
            
            for location in recentLocations.prefix(5) {
                print("\n >>>>>> LOKASYON: \(location.name) (ID: \(location.id))")
                print("   Şehir: \(location.locality ?? "N/A")")
                print("   Son Veri Zamanı: \(location.datetimeLast!.utc.description)")
                let latestResponse = try await client.getLatest(locationId: location.id)
                let latestMeasurements = latestResponse.results
                if latestMeasurements.isEmpty {
                    print("     - (Bu lokasyon için 'latest' verisi bulunamadı, bu bir gecikme olabilir)")
                } else {
                    print("   En Son Ölçülen Veriler:")
                    
                    for measurement in latestMeasurements {
                        let sensorInfo = location.sensors.first(where: { $0.id == measurement.sensorsId })
                        let paramName = sensorInfo?.parameter.displayName ?? sensorInfo?.parameter.name ?? "Bilinmeyen Parametre"
                        let paramUnits = sensorInfo?.parameter.units ?? ""
                        print("     - \(paramName): \(measurement.value) \(paramUnits)")
                        print("       (Ölçüm Zamanı: \(measurement.datetime.utc.description))")
                    }
                }
            }
            
            print("\nTEST 13: TAMAMLANDI")
            
        } catch {
            XCTFail("Türkiye (Son 1 Ay) testi başarısız oldu: \(error.localizedDescription)")
        }
    }
    
    func test_13_Error_429_RateLimit() async {
        guard let client = self.client else { return }
        print("\nTEST 13: RATE LIMIT (429) TESTİ BAŞLADI")
        
        let requestCount = 1000
        let validLocationId = 8118
        var rateLimitErrorCaught = false
        
        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                for i in 0..<requestCount {
                    group.addTask {
                        _ = try await client.getLocation(id: validLocationId)
                        print("Rate Limit Test: İstek \(i+1) başarılı.")
                    }
                    try await Task.sleep(nanoseconds: 1_000_000)
                }
                
                try await group.waitForAll()
            }
            XCTFail("Rate limit testine rağmen 429 hatası alınamadı. \(requestCount) isteğin tamamı başarılı oldu. API limiti beklenenden yüksek veya test yeterince hızlı çalışmadı.")
            
        } catch let error as OpenAQError where error == .tooManyRequests {
            rateLimitErrorCaught = true
            print("Başarılı: Rate limit (429) hatası beklendiği gibi yakalandı.")
            XCTAssertTrue(rateLimitErrorCaught)
        } catch {
            XCTFail("Rate limit testi sırasında beklenmedik bir hata oluştu: \(error)")
        }
        print("TEST 13: TAMAMLANDI")
    }
    
    func test_14_Measurements_Aggregation_Monthly() async throws {
        guard let client = self.client else { return }
        let sensorId = 3917
        let calendar = Calendar.current
        let dateTo = calendar.date(from: DateComponents(year: 2023, month: 12, day: 31))!
        let dateFrom = calendar.date(from: DateComponents(year: 2023, month: 1, day: 1))!
        let response = try await client.getMonthlyMeasurements(
            sensorId: sensorId,
            source: .hours,
            limit: 12,
            dateFrom: dateFrom,
            dateTo: dateTo
        )
        XCTAssertEqual(response.results.count, 12, "Aylık toplulaştırma 12 sonuç döndürmedi.")
        XCTAssertNotNil(response.results.first?.summary, "Aylık veride 'summary' olmalı.")
        print("Aylık Aggregation Testi Başarılı.")
    }
    
    func test_15_Measurements_Aggregation_Yearly() async throws {
        guard let client = self.client else { return }
        let sensorId = 3917
        let calendar = Calendar.current
        let dateTo = calendar.date(from: DateComponents(year: 2023, month: 12, day: 31))!
        let dateFrom = calendar.date(from: DateComponents(year: 2021, month: 1, day: 1))!
        let response = try await client.getYearlyMeasurements(
            sensorId: sensorId,
            limit: 5,
            dateFrom: dateFrom,
            dateTo: dateTo
        )
        XCTAssertEqual(response.results.count, 3, "Yıllık toplulaştırma 3 sonuç döndürmedi.")
        XCTAssertNotNil(response.results.first?.summary, "Yıllık veride 'summary' olmalı.")
        print("Yıllık Aggregation Testi Başarılı.")
    }
    
    func test_16_Measurements_Aggregation_MonthOfYear() async throws {
        guard let client = self.client else { return }
        let sensorId = 3917
        let calendar = Calendar.current
        let dateTo = calendar.date(from: DateComponents(year: 2023, month: 12, day: 31))!
        let dateFrom = calendar.date(from: DateComponents(year: 2023, month: 1, day: 1))!
        let response = try await client.getMonthOfYearMeasurements(
            sensorId: sensorId,
            source: .days,
            limit: 12,
            dateFrom: dateFrom,
            dateTo: dateTo
        )
        XCTAssertEqual(response.results.count, 12, "Yılın Ayı toplulaştırması 12 sonuç döndürmedi.")
        XCTAssertNotNil(response.results.first?.summary, "Yılın Ayı verisinde 'summary' olmalı.")
        print("Yılın Ayı Aggregation Testi Başarılı.")
    }
    
    func test_17_GetLicenseDetails_Decode() async throws {
        guard let client = self.client else { return }
        let licenseId = 41
        let response = try await client.getLicense(id: licenseId)
        let license = try XCTUnwrap(response.results.first, "Lisans (ID: \(licenseId)) bulunamadı.")
        XCTAssertEqual(license.id, licenseId)
        XCTAssertEqual(license.name, "CC BY 4.0")
        XCTAssertTrue(license.commercialUseAllowed, "CC BY 4.0 ticari kullanıma izin vermeli.")
        XCTAssertTrue(license.attributionRequired, "CC BY 4.0 atıf gerektirmeli.")
        print("Lisans Detayı Çözümleme Testi Başarılı.")
    }
    
    func test_18_GetOwnerDetails_Decode() async throws {
        guard let client = self.client else { return }
        let ownerId = 3549
        let response = try await client.getOwner(id: ownerId)
        let owner = try XCTUnwrap(response.results.first, "Sahip (ID: \(ownerId)) bulunamadı.")
        XCTAssertEqual(owner.id, ownerId)
        XCTAssertEqual(owner.name, "City of Zabok")
        print("Sahip Detayı Çözümleme Testi Başarılı.")
    }
}
