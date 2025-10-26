//
//  OpenAQError.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public enum OpenAQError: Error, LocalizedError, Equatable {
    case invalidResponse
    case httpError(code: Int)
    case unauthorized
    case forbidden
    case notFound
    case gone
    case unprocessableContent
    case tooManyRequests
    case serverError(code: Int)
    case dateDecodingError(String)
    case decodingError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Unauthorized: API key is invalid or missing."
            
        case .forbidden:
            return "Forbidden: You do not have access to this resource, or your account may be blocked."
            
        case .notFound:
            return "Not Found: The requested resource does not exist."
            
        case .gone:
            return "Gone: This resource no longer exists, likely an old API version."
            
        case .unprocessableContent:
            return "Unprocessable Content: The query provided is incorrect (e.g., conflicting parameters)."
            
        case .tooManyRequests:
            return "Too Many Requests: You have exceeded the API rate limit."
            
        case .serverError(let code):
            return "Server Error: OpenAQ services failed with code \(code)."
            
        case .httpError(let code):
            return "HTTP Error: An unhandled HTTP error occurred with code \(code)."
            
        case .dateDecodingError(let dateString):
            return "Decoding Error: Failed to decode an unexpected date format: \(dateString)."
            
        case .decodingError(let error):
            return "Decoding Error: Failed to decode the JSON response. \(error.localizedDescription)"
            
        case .invalidResponse:
            return "Invalid Response: The server returned a response that was not a valid HTTP response."
        }
    }

    public static func == (lhs: OpenAQError, rhs: OpenAQError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidResponse, .invalidResponse),
             (.unauthorized, .unauthorized),
             (.forbidden, .forbidden),
             (.notFound, .notFound),
             (.gone, .gone),
             (.unprocessableContent, .unprocessableContent),
             (.tooManyRequests, .tooManyRequests):
            return true
            
        case (.httpError(let lhsCode), .httpError(let rhsCode)):
            return lhsCode == rhsCode
            
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
            
        case (.dateDecodingError(let lhsString), .dateDecodingError(let rhsString)):
            return lhsString == rhsString
            
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
                default:
            return false
        }
    }
}
