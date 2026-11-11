//
//  CLLocationCoordinate2D+Extensions.swift
//  FindMyCharity
//
//  Useful extensions for CLLocationCoordinate2D
//  to simplify geographic calculations and comparisons.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - Equatable Conformance

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

// MARK: - Distance Calculations

extension CLLocationCoordinate2D {
    
    /// Calculates the distance in kilometers to another coordinate
    /// - Parameter other: The destination coordinate
    /// - Returns: Distance in kilometers
    func distance(to other: CLLocationCoordinate2D) -> Double {
        let thisLocation = CLLocation(latitude: latitude, longitude: longitude)
        let otherLocation = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return thisLocation.distance(from: otherLocation) / 1000.0 // Convert meters to km
    }
    
    /// Checks if this coordinate is within a specified radius of another coordinate
    /// - Parameters:
    ///   - other: The center coordinate to check against
    ///   - radiusKm: The radius in kilometers
    /// - Returns: True if within the radius
    func isWithin(radiusKm: Double, of other: CLLocationCoordinate2D) -> Bool {
        distance(to: other) <= radiusKm
    }
}

// MARK: - Region Helpers

extension CLLocationCoordinate2D {
    
    /// Creates a map region centered on this coordinate with the specified span
    /// - Parameter span: The coordinate span for the region
    /// - Returns: An MKCoordinateRegion centered on this coordinate
    func region(span: MKCoordinateSpan) -> MKCoordinateRegion {
        MKCoordinateRegion(center: self, span: span)
    }
    
    /// Creates a map region centered on this coordinate with the specified delta
    /// - Parameter delta: The latitude/longitude delta (same for both)
    /// - Returns: An MKCoordinateRegion centered on this coordinate
    func region(delta: Double) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: self,
            span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        )
    }
}

// MARK: - Validation

extension CLLocationCoordinate2D {
    
    /// Checks if the coordinate has valid values
    var isValid: Bool {
        latitude >= -90 && latitude <= 90 &&
        longitude >= -180 && longitude <= 180
    }
    
    /// A zero coordinate (0, 0) - useful for default values
    static let zero = CLLocationCoordinate2D(latitude: 0, longitude: 0)
}

// MARK: - Debug Description

extension CLLocationCoordinate2D: @retroactive CustomStringConvertible {
    public var description: String {
        String(format: "(%.4f, %.4f)", latitude, longitude)
    }
}
