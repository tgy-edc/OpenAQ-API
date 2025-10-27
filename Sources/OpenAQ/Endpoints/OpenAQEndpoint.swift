//
//  OpenAQEndpoint.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

internal enum OpenAQEndpoint {
    typealias AggregationSource = OpenAQClient.AggregationSource
        
    case parameters(page: Int, limit: Int)
    case parameterDetails(id: Int)
    case locations(page: Int, limit: Int, radius: Int? = nil, coordinates: String? = nil, bbox: String? = nil, parameterId: Int? = nil)
    case locationDetails(id: Int)
    case countries(page: Int, limit: Int)
    case countryDetails(id: Int)
    case instruments(page: Int, limit: Int)
    case instrumentDetails(id: Int)
    case latestByLocation(locationId: Int)
    case latestByParameter(parameterId: Int)
    case licenses(page: Int, limit: Int)
    case licenseDetails(id: Int)
    case manufacturers(page: Int, limit: Int)
    case manufacturerDetails(id: Int)
    case measurements(sensorId: Int, page: Int, limit: Int, dateFrom: Date?, dateTo: Date?)
    case hourlyMeasurements(sensorId: Int, page: Int, limit: Int, dateFrom: Date?, dateTo: Date?)
    case dailyMeasurements(sensorId: Int, page: Int, limit: Int, dateFrom: Date?, dateTo: Date?)
    case yearlyMeasurements(sensorId: Int, page: Int, limit: Int, dateFrom: Date?, dateTo: Date?)
    case monthlyMeasurements(sensorId: Int, source: AggregationSource, page: Int, limit: Int, dateFrom: Date?, dateTo: Date?)
    case hourOfDayMeasurements(sensorId: Int, page: Int, limit: Int, dateFrom: Date?, dateTo: Date?)
    case dayOfWeekMeasurements(sensorId: Int, source: AggregationSource, page: Int, limit: Int, dateFrom: Date?, dateTo: Date?)
    case monthOfYearMeasurements(sensorId: Int, source: AggregationSource, page: Int, limit: Int, dateFrom: Date?, dateTo: Date?)
    case owners(page: Int, limit: Int)
    case ownerDetails(id: Int)
    case providers(page: Int, limit: Int)
    case providerDetails(id: Int)
    case sensors(page: Int, limit: Int)
    case sensorDetails(id: Int)
        
    func buildRequest(baseURL: URL) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("Invalid URL components")
        }
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
    }
}
