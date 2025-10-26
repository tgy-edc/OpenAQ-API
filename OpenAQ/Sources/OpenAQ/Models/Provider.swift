//
//  Provider.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public struct Provider: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let sourceName: String
    public let exportPrefix: String
    public let datetimeAdded: Date
    public let datetimeFirst: Date
    public let datetimeLast: Date
    public let entitiesId: Int?
    public let parameters: [ParameterShort]
    public let bbox: BoundingBox?
    
    public struct ParameterShort: Codable, Identifiable {
        public let id: Int
        public let name: String
        public let units: String
        public let displayName: String?
    }
    
    public struct BoundingBox: Codable {
        public let type: String
        public let coordinates: [[[Double]]]
    }
}
