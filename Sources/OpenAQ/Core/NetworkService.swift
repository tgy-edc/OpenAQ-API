//
//  NetworkService.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

internal struct NetworkService {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let baseURL = URL(string: "https://api.openaq.org/v3/")!
    
    init(apiKey: String) {
        let config = URLSessionConfiguration.default
        
        config.httpAdditionalHeaders = [
            "X-API-Key": apiKey,
            "Accept": "application/json"
        ]
        self.session = URLSession(configuration: config)
        
        self.decoder = JSONDecoder()
        
        self.decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatter1 = ISO8601DateFormatter()
            formatter1.formatOptions = [.withInternetDateTime]
            if let date = formatter1.date(from: dateString) {
                return date
            }
            
            let formatter2 = ISO8601DateFormatter()
            formatter2.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter2.date(from: dateString) {
                return date
            }
            
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "yyyy-MM-dd"
            if let date = formatter3.date(from: dateString) {
                return date
            }
            
            throw OpenAQError.dateDecodingError(dateString)
        }
    }
    
    internal func request<T: Decodable>(_ endpoint: OpenAQEndpoint) async throws -> T {
        let request = endpoint.buildRequest(baseURL: baseURL)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAQError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw OpenAQError.decodingError(error)
            }
        case 401:
            throw OpenAQError.unauthorized
        case 403:
            throw OpenAQError.forbidden
        case 404:
            throw OpenAQError.notFound
        case 410:
            throw OpenAQError.gone
        case 422:
            throw OpenAQError.unprocessableContent
        case 429:
            throw OpenAQError.tooManyRequests
        case 500...504:
            throw OpenAQError.serverError(code: httpResponse.statusCode)
        default:
            throw OpenAQError.httpError(code: httpResponse.statusCode)
        }
    }
}
