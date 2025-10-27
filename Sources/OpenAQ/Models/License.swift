//
//  License.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public struct License: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let commercialUseAllowed: Bool
    public let attributionRequired: Bool
    public let shareAlikeRequired: Bool
    public let modificationAllowed: Bool
    public let redistributionAllowed: Bool
    public let sourceUrl: String?
}
