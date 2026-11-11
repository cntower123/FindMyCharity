//
//  Charity.swift
//  FindMyCharity
//
//  The core data model representing a charitable organization.
//  Designed to be populated from an external API in production.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - Charity Model

/// Represents a charitable organization with all relevant information
/// for display in the app.
struct Charity: Identifiable, Codable, Hashable {
    
    // MARK: - Properties
    
    /// Unique identifier for the charity
    let id: String
    
    /// Official name of the charity organization
    let name: String
    
    /// Brief description of the charity's mission and work
    let description: String
    
    /// The primary cause category this charity supports
    let cause: CharityCause
    
    /// Additional cause categories (if the charity works across multiple areas)
    let secondaryCauses: [CharityCause]
    
    /// Geographic coordinates of the charity's headquarters or primary location
    let latitude: Double
    let longitude: Double
    
    /// The country where the charity operates or is headquartered
    let country: String
    
    /// ISO country code (e.g., "US", "GB", "KE")
    let countryCode: String
    
    /// The continent where the charity is located
    let continent: Continent
    
    /// City or region name (optional, for more specific location display)
    let city: String?
    
    /// URL to the charity's official website
    let websiteURL: URL
    
    /// URL to the charity's logo image (optional)
    let logoURL: URL?
    
    /// Year the charity was founded (optional)
    let foundedYear: Int?
    
    /// Registration or tax ID number (optional, varies by country)
    let registrationNumber: String?
    
    // MARK: - Computed Properties
    
    /// The geographic coordinate for map display
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Formatted location string for display
    var locationString: String {
        if let city = city {
            return "\(city), \(country)"
        }
        return country
    }
    
    /// All causes (primary + secondary) for filtering purposes
    var allCauses: [CharityCause] {
        [cause] + secondaryCauses
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Charity, rhs: Charity) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Map Annotation Support

/// Extension to make Charity work seamlessly with MapKit annotations
extension Charity {
    
    /// Creates a map annotation item for use with SwiftUI Map
    var annotationItem: CharityAnnotationItem {
        CharityAnnotationItem(charity: self)
    }
}

/// A wrapper struct for using Charity as a map annotation
/// Conforms to Identifiable for use in SwiftUI's Map view
struct CharityAnnotationItem: Identifiable {
    let charity: Charity
    
    var id: String { charity.id }
    var coordinate: CLLocationCoordinate2D { charity.coordinate }
}

// MARK: - Search & Filter Support

extension Charity {
    
    /// Checks if the charity matches a search query
    /// Searches across name, description, cause, and location
    func matches(searchQuery: String) -> Bool {
        guard !searchQuery.isEmpty else { return true }
        
        let lowercasedQuery = searchQuery.lowercased()
        
        // Check name
        if name.lowercased().contains(lowercasedQuery) {
            return true
        }
        
        // Check description
        if description.lowercased().contains(lowercasedQuery) {
            return true
        }
        
        // Check cause categories
        if allCauses.contains(where: { $0.matches(query: lowercasedQuery) }) {
            return true
        }
        
        // Check location
        if country.lowercased().contains(lowercasedQuery) {
            return true
        }
        
        if countryCode.lowercased() == lowercasedQuery {
            return true
        }
        
        if continent.matches(query: lowercasedQuery) {
            return true
        }
        
        if let city = city, city.lowercased().contains(lowercasedQuery) {
            return true
        }
        
        return false
    }
    
    /// Checks if the charity is located in a specific continent
    func isInContinent(_ continent: Continent) -> Bool {
        self.continent == continent
    }
    
    /// Checks if the charity is located in a specific country
    func isInCountry(_ countryName: String) -> Bool {
        country.lowercased() == countryName.lowercased() ||
        countryCode.lowercased() == countryName.lowercased()
    }
    
    /// Checks if the charity supports a specific cause
    func supportsCause(_ cause: CharityCause) -> Bool {
        allCauses.contains(cause)
    }
}

// MARK: - Sample/Preview Data

extension Charity {
    
    /// A sample charity for use in previews and testing
    static let sample = Charity(
        id: "sample-001",
        name: "Global Education Initiative",
        description: "Providing quality education to underserved communities worldwide through teacher training, school construction, and educational resources.",
        cause: .education,
        secondaryCauses: [.youthDevelopment],
        latitude: 40.7128,
        longitude: -74.0060,
        country: "United States",
        countryCode: "US",
        continent: .northAmerica,
        city: "New York",
        websiteURL: URL(string: "https://www.example-education.org")!,
        logoURL: nil,
        foundedYear: 2005,
        registrationNumber: "501c3-12345"
    )
}
