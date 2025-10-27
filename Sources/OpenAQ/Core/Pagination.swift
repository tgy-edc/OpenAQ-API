//
//  Pagination.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public struct PagedResponse<T: Decodable>: Decodable {
    public let meta: Meta
    public let results: [T]
}

public struct Meta: Decodable {
    public let name: String?
    public let website: String?
    public let page: Int
    public let limit: Int
    public let found: Int

    enum CodingKeys: String, CodingKey {
        case name, website, page, limit, found
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.website = try container.decodeIfPresent(String.self, forKey: .website)
        self.page = try container.decode(Int.self, forKey: .page)
        self.limit = try container.decode(Int.self, forKey: .limit)

        if let intValue = try? container.decode(Int.self, forKey: .found) {
            self.found = intValue
        }
        else if let stringValue = try? container.decode(String.self, forKey: .found) {
            let cleanedString = stringValue.replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "<", with: "")
            self.found = Int(cleanedString) ?? 0 
        }
        else {
            self.found = 0
        }
    }
}
