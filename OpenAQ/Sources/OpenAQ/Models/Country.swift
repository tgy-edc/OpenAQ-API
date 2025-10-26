//
//  Country.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public struct Country: Codable, Identifiable {
    public let id: Int
    public let code: String
    public let name: String
    public let datetimeFirst: Date?
    public let datetimeLast: Date?
    public let parameters: [ParameterShort]
    
    public struct ParameterShort: Codable, Identifiable {
        public let id: Int
        public let name: String
        public let units: String
        public let displayName: String?
    }
}
