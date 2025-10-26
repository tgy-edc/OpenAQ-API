//
//  Instrument.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public struct Instrument: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let isMonitor: Bool
    public let manufacturer: ManufacturerShort
    
    public struct ManufacturerShort: Codable {
        public let id: Int
        public let name: String
    }
}
