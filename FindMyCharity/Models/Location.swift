//
//  Location.swift
//  FindMyCharity
//
//  Provides location-related data structures and utilities
//  for geographic filtering and search functionality.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - Continent

/// Represents the major continents for geographic filtering
enum Continent: String, CaseIterable, Codable, Identifiable {
    case africa = "Africa"
    case asia = "Asia"
    case europe = "Europe"
    case northAmerica = "North America"
    case southAmerica = "South America"
    case oceania = "Oceania"
    case antarctica = "Antarctica"
    
    var id: String { rawValue }
    
    /// Approximate center coordinate for the continent
    var centerCoordinate: CLLocationCoordinate2D {
        switch self {
        case .africa:
            return CLLocationCoordinate2D(latitude: 1.0, longitude: 20.0)
        case .asia:
            return CLLocationCoordinate2D(latitude: 34.0, longitude: 100.0)
        case .europe:
            return CLLocationCoordinate2D(latitude: 50.0, longitude: 10.0)
        case .northAmerica:
            return CLLocationCoordinate2D(latitude: 45.0, longitude: -100.0)
        case .southAmerica:
            return CLLocationCoordinate2D(latitude: -15.0, longitude: -60.0)
        case .oceania:
            return CLLocationCoordinate2D(latitude: -25.0, longitude: 135.0)
        case .antarctica:
            return CLLocationCoordinate2D(latitude: -82.0, longitude: 0.0)
        }
    }
    
    /// Suggested zoom level (span) for viewing this continent
    var suggestedSpan: MKCoordinateSpan {
        switch self {
        case .africa:
            return MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 60)
        case .asia:
            return MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 80)
        case .europe:
            return MKCoordinateSpan(latitudeDelta: 35, longitudeDelta: 40)
        case .northAmerica:
            return MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 60)
        case .southAmerica:
            return MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 50)
        case .oceania:
            return MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 60)
        case .antarctica:
            return MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 60)
        }
    }
    
    /// Search keywords associated with this continent
    var searchKeywords: [String] {
        switch self {
        case .africa:
            return ["africa", "african"]
        case .asia:
            return ["asia", "asian", "middle east"]
        case .europe:
            return ["europe", "european", "eu"]
        case .northAmerica:
            return ["north america", "usa", "canada", "mexico", "caribbean", "central america"]
        case .southAmerica:
            return ["south america", "latin america", "latin"]
        case .oceania:
            return ["oceania", "australia", "pacific", "pacific islands"]
        case .antarctica:
            return ["antarctica", "antarctic"]
        }
    }
    
    /// Checks if a search query matches this continent
    func matches(query: String) -> Bool {
        let lowercasedQuery = query.lowercased()
        return searchKeywords.contains { keyword in
            keyword.contains(lowercasedQuery) || lowercasedQuery.contains(keyword)
        }
    }
}

// MARK: - Country Data

/// A structure containing country information for search and filtering
struct Country: Identifiable, Codable {
    let id: String // ISO country code
    let name: String
    let continent: Continent
    let centerCoordinate: CLLocationCoordinate2D
    
    /// Search keywords including common names and abbreviations
    var searchKeywords: [String] {
        [name.lowercased(), id.lowercased()]
    }
    
    func matches(query: String) -> Bool {
        let lowercasedQuery = query.lowercased()
        return searchKeywords.contains { $0.contains(lowercasedQuery) } ||
               lowercasedQuery.contains(name.lowercased())
    }
}

// MARK: - Codable Extension for CLLocationCoordinate2D

extension CLLocationCoordinate2D: @retroactive Codable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}

// MARK: - Country Database

/// A static database of countries for location-based filtering
struct CountryDatabase {
    
    /// All available countries
    static let countries: [Country] = [
        // Africa
        Country(id: "NG", name: "Nigeria", continent: .africa,
                centerCoordinate: CLLocationCoordinate2D(latitude: 9.082, longitude: 8.675)),
        Country(id: "KE", name: "Kenya", continent: .africa,
                centerCoordinate: CLLocationCoordinate2D(latitude: -1.286, longitude: 36.817)),
        Country(id: "ZA", name: "South Africa", continent: .africa,
                centerCoordinate: CLLocationCoordinate2D(latitude: -30.559, longitude: 22.937)),
        Country(id: "EG", name: "Egypt", continent: .africa,
                centerCoordinate: CLLocationCoordinate2D(latitude: 26.820, longitude: 30.802)),
        Country(id: "GH", name: "Ghana", continent: .africa,
                centerCoordinate: CLLocationCoordinate2D(latitude: 7.946, longitude: -1.023)),
        Country(id: "ET", name: "Ethiopia", continent: .africa,
                centerCoordinate: CLLocationCoordinate2D(latitude: 9.145, longitude: 40.489)),
        Country(id: "TZ", name: "Tanzania", continent: .africa,
                centerCoordinate: CLLocationCoordinate2D(latitude: -6.369, longitude: 34.888)),
        Country(id: "UG", name: "Uganda", continent: .africa,
                centerCoordinate: CLLocationCoordinate2D(latitude: 1.373, longitude: 32.290)),
        
        // Asia
        Country(id: "IN", name: "India", continent: .asia,
                centerCoordinate: CLLocationCoordinate2D(latitude: 20.593, longitude: 78.962)),
        Country(id: "CN", name: "China", continent: .asia,
                centerCoordinate: CLLocationCoordinate2D(latitude: 35.861, longitude: 104.195)),
        Country(id: "JP", name: "Japan", continent: .asia,
                centerCoordinate: CLLocationCoordinate2D(latitude: 36.204, longitude: 138.252)),
        Country(id: "PH", name: "Philippines", continent: .asia,
                centerCoordinate: CLLocationCoordinate2D(latitude: 12.879, longitude: 121.774)),
        Country(id: "VN", name: "Vietnam", continent: .asia,
                centerCoordinate: CLLocationCoordinate2D(latitude: 14.058, longitude: 108.277)),
        Country(id: "TH", name: "Thailand", continent: .asia,
                centerCoordinate: CLLocationCoordinate2D(latitude: 15.870, longitude: 100.992)),
        Country(id: "BD", name: "Bangladesh", continent: .asia,
                centerCoordinate: CLLocationCoordinate2D(latitude: 23.684, longitude: 90.356)),
        Country(id: "PK", name: "Pakistan", continent: .asia,
                centerCoordinate: CLLocationCoordinate2D(latitude: 30.375, longitude: 69.345)),
        Country(id: "ID", name: "Indonesia", continent: .asia,
                centerCoordinate: CLLocationCoordinate2D(latitude: -0.789, longitude: 113.921)),
        Country(id: "NP", name: "Nepal", continent: .asia,
                centerCoordinate: CLLocationCoordinate2D(latitude: 28.394, longitude: 84.124)),
        
        // Europe
        Country(id: "GB", name: "United Kingdom", continent: .europe,
                centerCoordinate: CLLocationCoordinate2D(latitude: 55.378, longitude: -3.436)),
        Country(id: "DE", name: "Germany", continent: .europe,
                centerCoordinate: CLLocationCoordinate2D(latitude: 51.165, longitude: 10.451)),
        Country(id: "FR", name: "France", continent: .europe,
                centerCoordinate: CLLocationCoordinate2D(latitude: 46.227, longitude: 2.213)),
        Country(id: "IT", name: "Italy", continent: .europe,
                centerCoordinate: CLLocationCoordinate2D(latitude: 41.871, longitude: 12.567)),
        Country(id: "ES", name: "Spain", continent: .europe,
                centerCoordinate: CLLocationCoordinate2D(latitude: 40.463, longitude: -3.749)),
        Country(id: "NL", name: "Netherlands", continent: .europe,
                centerCoordinate: CLLocationCoordinate2D(latitude: 52.132, longitude: 5.291)),
        Country(id: "SE", name: "Sweden", continent: .europe,
                centerCoordinate: CLLocationCoordinate2D(latitude: 60.128, longitude: 18.643)),
        Country(id: "CH", name: "Switzerland", continent: .europe,
                centerCoordinate: CLLocationCoordinate2D(latitude: 46.818, longitude: 8.227)),
        Country(id: "UA", name: "Ukraine", continent: .europe,
                centerCoordinate: CLLocationCoordinate2D(latitude: 48.379, longitude: 31.165)),
        Country(id: "PL", name: "Poland", continent: .europe,
                centerCoordinate: CLLocationCoordinate2D(latitude: 51.919, longitude: 19.145)),
        
        // North America
        Country(id: "US", name: "United States", continent: .northAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: 37.090, longitude: -95.712)),
        Country(id: "CA", name: "Canada", continent: .northAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: 56.130, longitude: -106.346)),
        Country(id: "MX", name: "Mexico", continent: .northAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: 23.634, longitude: -102.552)),
        Country(id: "GT", name: "Guatemala", continent: .northAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: 15.783, longitude: -90.230)),
        Country(id: "HN", name: "Honduras", continent: .northAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: 15.199, longitude: -86.241)),
        Country(id: "HT", name: "Haiti", continent: .northAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: 18.971, longitude: -72.285)),
        
        // South America
        Country(id: "BR", name: "Brazil", continent: .southAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: -14.235, longitude: -51.925)),
        Country(id: "AR", name: "Argentina", continent: .southAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: -38.416, longitude: -63.616)),
        Country(id: "CO", name: "Colombia", continent: .southAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: 4.570, longitude: -74.297)),
        Country(id: "PE", name: "Peru", continent: .southAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: -9.189, longitude: -75.015)),
        Country(id: "CL", name: "Chile", continent: .southAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: -35.675, longitude: -71.542)),
        Country(id: "EC", name: "Ecuador", continent: .southAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: -1.831, longitude: -78.183)),
        Country(id: "BO", name: "Bolivia", continent: .southAmerica,
                centerCoordinate: CLLocationCoordinate2D(latitude: -16.290, longitude: -63.588)),
        
        // Oceania
        Country(id: "AU", name: "Australia", continent: .oceania,
                centerCoordinate: CLLocationCoordinate2D(latitude: -25.274, longitude: 133.775)),
        Country(id: "NZ", name: "New Zealand", continent: .oceania,
                centerCoordinate: CLLocationCoordinate2D(latitude: -40.900, longitude: 174.885)),
        Country(id: "FJ", name: "Fiji", continent: .oceania,
                centerCoordinate: CLLocationCoordinate2D(latitude: -17.713, longitude: 178.065)),
        Country(id: "PG", name: "Papua New Guinea", continent: .oceania,
                centerCoordinate: CLLocationCoordinate2D(latitude: -6.314, longitude: 143.955)),
    ]
    
    /// Find a country by search query
    static func find(query: String) -> Country? {
        let lowercasedQuery = query.lowercased().trimmingCharacters(in: .whitespaces)
        return countries.first { $0.matches(query: lowercasedQuery) }
    }
    
    /// Find all countries in a continent
    static func countries(in continent: Continent) -> [Country] {
        countries.filter { $0.continent == continent }
    }
}
