//
//  Sensor.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public struct Sensor: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let parameter: ParameterShort
    public let datetimeFirst: DatetimeObject
    public let datetimeLast: DatetimeObject
    public let coverage: Coverage
    public let latest: LatestMeasurement
    public let summary: MeasurementSummary
        
    public struct ParameterShort: Codable {
        public let id: Int
        public let name: String
        public let units: String
        public let displayName: String?
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
    
    public struct LatestMeasurement: Codable {
        public let datetime: DatetimeObject
        public let value: Double
        public let coordinates: Coordinates?
    }

    public struct MeasurementSummary: Codable {
        public let min: Double
        public let max: Double
        public let avg: Double
    }
}
