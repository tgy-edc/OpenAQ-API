//
//  Manufacturer.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public struct Manufacturer: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let instruments: [InstrumentShort]
    
    public struct InstrumentShort: Codable, Identifiable {
        public let id: Int
        public let name: String
    }
}
