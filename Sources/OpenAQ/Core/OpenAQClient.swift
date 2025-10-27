//
//  OpenAQClient.swift
//  OpenAQ
//
//  Created by Celal Can Sağnak on 20.10.2025.
//

import Foundation

public final class OpenAQClient {
    
    private let networkService: NetworkService
    
    public init(apiKey: String) {
        self.networkService = NetworkService(apiKey: apiKey)
    }
    
    public enum AggregationSource: String {
        case measurements
        case hours
        case days
    }
    
    public func getParameters(page: Int = 1, limit: Int = 100) async throws -> PagedResponse<Parameter> {
        try await networkService.request(.parameters(page: page, limit: limit))
    }
    
    public func getParameter(id: Int) async throws -> PagedResponse<Parameter> {
        try await networkService.request(.parameterDetails(id: id))
    }
    
    public func getLocations(
        page: Int = 1,
        limit: Int = 100,
        parameterId: Int? = nil,
        coordinates: String? = nil,
        radius: Int? = nil,
        bbox: String? = nil
    ) async throws -> PagedResponse<Location> {
        try await networkService.request(.locations(
            page: page,
            limit: limit,
            radius: radius,
            coordinates: coordinates,
            bbox: bbox,
            parameterId: parameterId
        ))
    }
    
    public func getLocation(id: Int) async throws -> PagedResponse<Location> {
        try await networkService.request(.locationDetails(id: id))
    }
    
    public func getCountries(page: Int = 1, limit: Int = 100) async throws -> PagedResponse<Country> {
        try await networkService.request(.countries(page: page, limit: limit))
    }
    
    public func getCountry(id: Int) async throws -> PagedResponse<Country> {
        try await networkService.request(.countryDetails(id: id))
    }
    
    public func getInstruments(page: Int = 1, limit: Int = 100) async throws -> PagedResponse<Instrument> {
        try await networkService.request(.instruments(page: page, limit: limit))
    }
    
    public func getInstrument(id: Int) async throws -> PagedResponse<Instrument> {
        try await networkService.request(.instrumentDetails(id: id))
    }
    
    public func getLatest(locationId: Int) async throws -> PagedResponse<LatestMeasurement> {
        try await networkService.request(.latestByLocation(locationId: locationId))
    }
    
    public func getLatest(parameterId: Int) async throws -> PagedResponse<LatestMeasurement> {
        try await networkService.request(.latestByParameter(parameterId: parameterId))
    }
    
    public func getLicenses(page: Int = 1, limit: Int = 100) async throws -> PagedResponse<License> {
        try await networkService.request(.licenses(page: page, limit: limit))
    }
    
    public func getLicense(id: Int) async throws -> PagedResponse<License> {
        try await networkService.request(.licenseDetails(id: id))
    }
    
    public func getManufacturers(page: Int = 1, limit: Int = 100) async throws -> PagedResponse<Manufacturer> {
        try await networkService.request(.manufacturers(page: page, limit: limit))
    }
    
    public func getManufacturer(id: Int) async throws -> PagedResponse<Manufacturer> {
        try await networkService.request(.manufacturerDetails(id: id))
    }
    
    public func getMeasurements(
        sensorId: Int,
        page: Int = 1,
        limit: Int = 100,
        dateFrom: Date? = nil,
        dateTo: Date? = nil
    ) async throws -> PagedResponse<Measurement> {
        try await networkService.request(.measurements(
            sensorId: sensorId,
            page: page,
            limit: limit,
            dateFrom: dateFrom,
            dateTo: dateTo
        ))
    }
    
    public func getHourlyMeasurements(
        sensorId: Int,
        page: Int = 1,
        limit: Int = 100,
        dateFrom: Date? = nil,
        dateTo: Date? = nil
    ) async throws -> PagedResponse<Measurement> {
        try await networkService.request(.hourlyMeasurements(
            sensorId: sensorId,
            page: page,
            limit: limit,
            dateFrom: dateFrom,
            dateTo: dateTo
        ))
    }
    
    public func getDailyMeasurements(
        sensorId: Int,
        page: Int = 1,
        limit: Int = 100,
        dateFrom: Date? = nil,
        dateTo: Date? = nil
    ) async throws -> PagedResponse<Measurement> {
        try await networkService.request(.dailyMeasurements(
            sensorId: sensorId,
            page: page,
            limit: limit,
            dateFrom: dateFrom,
            dateTo: dateTo
        ))
    }
    
    public func getMonthlyMeasurements(
        sensorId: Int,
        source: AggregationSource,
        page: Int = 1,
        limit: Int = 100,
        dateFrom: Date? = nil,
        dateTo: Date? = nil
    ) async throws -> PagedResponse<Measurement> {
        try await networkService.request(.monthlyMeasurements(
            sensorId: sensorId,
            source: source,
            page: page,
            limit: limit,
            dateFrom: dateFrom,
            dateTo: dateTo
        ))
    }
    
    public func getYearlyMeasurements(
        sensorId: Int,
        page: Int = 1,
        limit: Int = 100,
        dateFrom: Date? = nil,
        dateTo: Date? = nil
    ) async throws -> PagedResponse<Measurement> {
        try await networkService.request(.yearlyMeasurements(
            sensorId: sensorId,
            page: page,
            limit: limit,
            dateFrom: dateFrom,
            dateTo: dateTo
        ))
    }
    
    public func getHourOfDayMeasurements(
        sensorId: Int,
        page: Int = 1,
        limit: Int = 24,
        dateFrom: Date? = nil,
        dateTo: Date? = nil
    ) async throws -> PagedResponse<Measurement> {
        try await networkService.request(.hourOfDayMeasurements(
            sensorId: sensorId,
            page: page,
            limit: limit,
            dateFrom: dateFrom,
            dateTo: dateTo
        ))
    }
    
    public func getDayOfWeekMeasurements(
        sensorId: Int,
        source: AggregationSource,
        page: Int = 1,
        limit: Int = 7,
        dateFrom: Date? = nil,
        dateTo: Date? = nil
    ) async throws -> PagedResponse<Measurement> {
        try await networkService.request(.dayOfWeekMeasurements(
            sensorId: sensorId,
            source: source,
            page: page,
            limit: limit,
            dateFrom: dateFrom,
            dateTo: dateTo
        ))
    }
    
    public func getMonthOfYearMeasurements(
        sensorId: Int,
        source: AggregationSource,
        page: Int = 1,
        limit: Int = 12,
        dateFrom: Date? = nil,
        dateTo: Date? = nil
    ) async throws -> PagedResponse<Measurement> {
        try await networkService.request(.monthOfYearMeasurements(
            sensorId: sensorId,
            source: source,
            page: page,
            limit: limit,
            dateFrom: dateFrom,
            dateTo: dateTo
        ))
    }
    
    public func getOwners(page: Int = 1, limit: Int = 100) async throws -> PagedResponse<Owner> {
        try await networkService.request(.owners(page: page, limit: limit))
    }
    
    public func getOwner(id: Int) async throws -> PagedResponse<Owner> {
        try await networkService.request(.ownerDetails(id: id))
    }
    
    public func getProviders(page: Int = 1, limit: Int = 100) async throws -> PagedResponse<Provider> {
        try await networkService.request(.providers(page: page, limit: limit))
    }
    
    public func getProvider(id: Int) async throws -> PagedResponse<Provider> {
        try await networkService.request(.providerDetails(id: id))
    }
    
    public func getSensors(page: Int = 1, limit: Int = 100) async throws -> PagedResponse<Sensor> {
        try await networkService.request(.sensors(page: page, limit: limit))
    }
    
    public func getSensor(id: Int) async throws -> PagedResponse<Sensor> {
        try await networkService.request(.sensorDetails(id: id))
    }
}
