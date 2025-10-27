//
//  Parameter.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public struct Parameter: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let units: String
    public let displayName: String?
    public let description: String?
}
