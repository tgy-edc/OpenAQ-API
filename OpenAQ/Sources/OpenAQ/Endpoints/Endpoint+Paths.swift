//
//  Endpoint+Paths.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

internal extension OpenAQEndpoint {
    
    var path: String {
        switch self {
        case .parameters:
            return "parameters"
        case .parameterDetails(let id):
            return "parameters/\(id)"
        case .locations:
            return "locations"
        case .locationDetails(let id):
            return "locations/\(id)"
        case .countries:
            return "countries"
        case .countryDetails(let id):
            return "countries/\(id)"
        case .instruments:
            return "instruments"
        case .instrumentDetails(let id):
            return "instruments/\(id)"
        case .latestByLocation(let locationId):
            return "locations/\(locationId)/latest"
        case .latestByParameter(let parameterId):
            return "parameters/\(parameterId)/latest"
        case .licenses:
            return "licenses"
        case .licenseDetails(let id):
            return "licenses/\(id)"
        case .manufacturers:
            return "manufacturers"
        case .manufacturerDetails(let id):
            return "manufacturers/\(id)"
        case .measurements(let sensorId, _, _, _, _):
            return "sensors/\(sensorId)/measurements"
        case .hourlyMeasurements(let sensorId, _, _, _, _):
            return "sensors/\(sensorId)/hours"
        case .dailyMeasurements(let sensorId, _, _, _, _):
            return "sensors/\(sensorId)/days"
        case .yearlyMeasurements(let sensorId, _, _, _, _):
            return "sensors/\(sensorId)/years"
        case .monthlyMeasurements(let sensorId, let source, _, _, _, _):
            return "sensors/\(sensorId)/\(source.rawValue)/monthly"
        case .hourOfDayMeasurements(let sensorId, _, _, _, _):
            return "sensors/\(sensorId)/hours/hourofday"
        case .dayOfWeekMeasurements(let sensorId, let source, _, _, _, _):
            return "sensors/\(sensorId)/\(source.rawValue)/dayofweek"
        case .monthOfYearMeasurements(let sensorId, let source, _, _, _, _):
            return "sensors/\(sensorId)/\(source.rawValue)/monthofyear"
        case .owners:
            return "owners"
        case .ownerDetails(let id):
            return "owners/\(id)"
        case .providers:
            return "providers"
        case .providerDetails(let id):
            return "providers/\(id)"
        case .sensors:
            return "sensors"
        case .sensorDetails(let id):
            return "sensors/\(id)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        
        switch self {
            
        case .parameters(let p, let l),
                .countries(let p, let l),
                .instruments(let p, let l),
                .licenses(let p, let l),
                .manufacturers(let p, let l),
                .owners(let p, let l),
                .providers(let p, let l),
                .sensors(let p, let l):
            
            items.append(URLQueryItem(name: "page", value: "\(p)"))
            items.append(URLQueryItem(name: "limit", value: "\(l)"))
            
        case .locations(let p, let l, let radius, let coords, let bbox, let paramId):
            items.append(URLQueryItem(name: "page", value: "\(p)"))
            items.append(URLQueryItem(name: "limit", value: "\(l)"))
            
            if let radius, let coords {
                items.append(URLQueryItem(name: "radius", value: "\(radius)"))
                items.append(URLQueryItem(name: "coordinates", value: coords))
            }
            
            if let bbox {
                items.append(URLQueryItem(name: "bbox", value: bbox))
            }
            
            if let paramId {
                items.append(URLQueryItem(name: "parameters_id", value: "\(paramId)"))
            }
            
        case .measurements(sensorId: _, let p, let l, let dateFrom, let dateTo),
                .hourlyMeasurements(sensorId: _, let p, let l, let dateFrom, let dateTo),
                .dailyMeasurements(sensorId: _, let p, let l, let dateFrom, let dateTo),
                .yearlyMeasurements(sensorId: _, let p, let l, let dateFrom, let dateTo),
                .monthlyMeasurements(sensorId: _, source: _, let p, let l, let dateFrom, let dateTo),
                .hourOfDayMeasurements(sensorId: _, let p, let l, let dateFrom, let dateTo),
                .dayOfWeekMeasurements(sensorId: _, source: _, let p, let l, let dateFrom, let dateTo),
                .monthOfYearMeasurements(sensorId: _, source: _, let p, let l, let dateFrom, let dateTo):
            
            items.append(URLQueryItem(name: "page", value: "\(p)"))
            items.append(URLQueryItem(name: "limit", value: "\(l)"))
            
            if let dateFrom {
                items.append(URLQueryItem(name: "date_from", value: dateFormatter.string(from: dateFrom)))
            }
            if let dateTo {
                items.append(URLQueryItem(name: "date_to", value: dateFormatter.string(from: dateTo)))
            }
            
        case .parameterDetails, .locationDetails, .countryDetails, .instrumentDetails,
                .latestByLocation, .latestByParameter, .licenseDetails, .manufacturerDetails,
                .ownerDetails, .providerDetails, .sensorDetails:
            break
        }
        
        return items
    }
}
