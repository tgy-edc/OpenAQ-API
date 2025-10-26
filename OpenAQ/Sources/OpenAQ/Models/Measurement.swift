//
//  Measurement.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public struct Measurement: Codable {
    public let value: Double
    public let parameter: ParameterShort
    public let period: Period
    public let summary: MeasurementSummary?
    public let coverage: Coverage
    public let coordinates: Coordinates?
        
    public struct ParameterShort: Codable {
        public let id: Int
        public let name: String
        public let units: String
        public let displayName: String?
    }
    
    public struct Period: Codable {
        public let label: String
        public let interval: String?
        public let datetimeFrom: DatetimeObject
        public let datetimeTo: DatetimeObject
    }

    public struct MeasurementSummary: Codable {
        public let min: Double
        public let q02: Double?
        public let q25: Double?
        public let median: Double
        public let q75: Double?
        public let q98: Double?
        public let max: Double
        public let avg: Double
        public let sd: Double?
    }

    public struct Coverage: Codable {
        public let expectedCount: Int
        public let expectedInterval: String?
        public let observedCount: Int
        public let observedInterval: String?
        public let percentComplete: Double
        public let percentCoverage: Double
        public let datetimeFrom: DatetimeObject
        public let datetimeTo: DatetimeObject
    }
}
