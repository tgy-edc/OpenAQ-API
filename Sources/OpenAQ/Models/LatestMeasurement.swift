//
//  LatestMeasurement.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public struct LatestMeasurement: Decodable {
    public let datetime: DatetimeObject
    public let value: Double
    public let coordinates: Coordinates?
    public let sensorsId: Int
    public let locationsId: Int
    
    enum CodingKeys: String, CodingKey {
        case datetime, value, coordinates
        case sensorsld
        case sensorsId
        case sensorId
        case locationsld
        case locationsId
        case locationId
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.datetime = try container.decode(DatetimeObject.self, forKey: .datetime)
        self.value = try container.decode(Double.self, forKey: .value)
        self.coordinates = try container.decodeIfPresent(Coordinates.self, forKey: .coordinates)
        
        if let id = try? container.decode(Int.self, forKey: .sensorsld) {
            self.sensorsId = id
        } else if let id = try? container.decode(Int.self, forKey: .sensorsId) {
            self.sensorsId = id
        } else {
            self.sensorsId = try container.decode(Int.self, forKey: .sensorId)
        }
        
        if let id = try? container.decode(Int.self, forKey: .locationsld) {
            self.locationsId = id
        } else if let id = try? container.decode(Int.self, forKey: .locationsId) {
            self.locationsId = id
        } else {
            self.locationsId = try container.decode(Int.self, forKey: .locationId)
        }
    }
}
