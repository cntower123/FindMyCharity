//
//  CharityDataProvider.swift
//  FindMyCharity
//
//  Protocol defining the interface for charity data sources.
//  This abstraction allows easy swapping between mock data,
//  local database, or remote API implementations.
//

import Foundation
import CoreLocation

// MARK: - Charity Data Provider Protocol

/// Protocol defining the interface for fetching charity data.
/// Implement this protocol to provide charity data from any source.
protocol CharityDataProvider: Sendable {
    
    /// Fetches all available charities
    /// - Returns: An array of all charities
    func fetchAllCharities() async throws -> [Charity]
    
    /// Fetches charities within a geographic region
    /// - Parameters:
    ///   - center: The center coordinate of the region
    ///   - radiusKm: The radius in kilometers
    /// - Returns: Charities within the specified region
    func fetchCharities(near center: CLLocationCoordinate2D, radiusKm: Double) async throws -> [Charity]
    
    /// Fetches charities matching a search query
    /// - Parameter query: The search query string
    /// - Returns: Charities matching the query
    func searchCharities(query: String) async throws -> [Charity]
    
    /// Fetches charities by cause category
    /// - Parameter cause: The cause category to filter by
    /// - Returns: Charities supporting the specified cause
    func fetchCharities(byCause cause: CharityCause) async throws -> [Charity]
    
    /// Fetches charities in a specific country
    /// - Parameter countryCode: The ISO country code
    /// - Returns: Charities in the specified country
    func fetchCharities(inCountry countryCode: String) async throws -> [Charity]
    
    /// Fetches charities in a specific continent
    /// - Parameter continent: The continent to filter by
    /// - Returns: Charities in the specified continent
    func fetchCharities(inContinent continent: Continent) async throws -> [Charity]
    
    /// Fetches a single charity by ID
    /// - Parameter id: The charity's unique identifier
    /// - Returns: The charity if found, nil otherwise
    func fetchCharity(byId id: String) async throws -> Charity?
}

// MARK: - Data Provider Errors

/// Errors that can occur when fetching charity data
enum CharityDataError: Error, LocalizedError {
    case networkError(underlying: Error)
    case decodingError(underlying: Error)
    case notFound
    case serverError(statusCode: Int)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .notFound:
            return "The requested charity was not found"
        case .serverError(let code):
            return "Server error (code: \(code))"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

// MARK: - Default Implementations

extension CharityDataProvider {
    
    /// Default implementation that filters all charities by location
    func fetchCharities(near center: CLLocationCoordinate2D, radiusKm: Double) async throws -> [Charity] {
        let allCharities = try await fetchAllCharities()
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        return allCharities.filter { charity in
            let charityLocation = CLLocation(latitude: charity.latitude, longitude: charity.longitude)
            let distanceMeters = centerLocation.distance(from: charityLocation)
            return distanceMeters <= radiusKm * 1000
        }
    }
    
    /// Default implementation that searches all charities
    func searchCharities(query: String) async throws -> [Charity] {
        let allCharities = try await fetchAllCharities()
        return allCharities.filter { $0.matches(searchQuery: query) }
    }
    
    /// Default implementation that filters by cause
    func fetchCharities(byCause cause: CharityCause) async throws -> [Charity] {
        let allCharities = try await fetchAllCharities()
        return allCharities.filter { $0.supportsCause(cause) }
    }
    
    /// Default implementation that filters by country
    func fetchCharities(inCountry countryCode: String) async throws -> [Charity] {
        let allCharities = try await fetchAllCharities()
        return allCharities.filter { $0.countryCode.uppercased() == countryCode.uppercased() }
    }
    
    /// Default implementation that filters by continent
    func fetchCharities(inContinent continent: Continent) async throws -> [Charity] {
        let allCharities = try await fetchAllCharities()
        return allCharities.filter { $0.isInContinent(continent) }
    }
    
    /// Default implementation that finds by ID
    func fetchCharity(byId id: String) async throws -> Charity? {
        let allCharities = try await fetchAllCharities()
        return allCharities.first { $0.id == id }
    }
}
