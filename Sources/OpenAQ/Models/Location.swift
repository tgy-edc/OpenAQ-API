//
//  Location.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public struct Location: Decodable, Identifiable {
    public let id: Int
    public let name: String
    public let locality: String?
    public let timezone: String?
    public let country: CountryShort?
    public let owner: OwnerShort?
    public let provider: ProviderShort?
    public let isMobile: Bool
    public let isMonitor: Bool
    public let instruments: [InstrumentShort]
    public let sensors: [SensorShort]
    public let coordinates: Coordinates
    public let licenses: [LicenseInfo]?
    public let bounds: [Double]?
    public let distance: Double?
    public let datetimeFirst: DatetimeObject?
    public let datetimeLast: DatetimeObject?
    
    
    public struct CountryShort: Codable {
        public let id: Int
        public let code: String
        public let name: String
    }
    
    public struct OwnerShort: Codable {
        public let id: Int
        public let name: String
    }
    
    public struct ProviderShort: Codable {
        public let id: Int
        public let name: String
    }
    
    public struct InstrumentShort: Codable {
        public let id: Int
        public let name: String
    }
    
    public struct SensorShort: Codable, Identifiable {
        public let id: Int
        public let name: String
        public let parameter: ParameterShort
    }
    
    public struct ParameterShort: Codable {
        public let id: Int
        public let name: String
        public let units: String
        public let displayName: String?
    }
    
    public struct LicenseInfo: Decodable {
        public let id: Int
        public let name: String
        public let dateFrom: Date?
        public let dateTo: Date?
        public let attribution: Attribution?
        
        public struct Attribution: Codable {
            public let name: String?
            public let url: String?
        }
    }
}
