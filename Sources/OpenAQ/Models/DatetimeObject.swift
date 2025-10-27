//
//  DatetimeObject.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public struct DatetimeObject: Codable {
    public let utc: Date
    public let local: Date?
}
