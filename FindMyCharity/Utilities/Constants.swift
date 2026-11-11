//
//  Constants.swift
//  FindMyCharity
//
//  App-wide constants and configuration values.
//  Centralized location for easy maintenance and modification.
//

import Foundation
import MapKit

// MARK: - App Constants

/// Global constants used throughout the app
enum AppConstants {
    
    // MARK: - App Info
    
    static let appName = "FindMyCharity"
    static let appVersion = "1.0.0"
    
    // MARK: - Map Configuration
    
    enum Map {
        /// Default region to show when app launches (shows world view)
        static let defaultRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 20.0, longitude: 0.0),
            span: MKCoordinateSpan(latitudeDelta: 120, longitudeDelta: 180)
        )
        
        /// Minimum zoom level (most zoomed out)
        static let minZoomDelta: Double = 0.01
        
        /// Maximum zoom level (most zoomed in)
        static let maxZoomDelta: Double = 180.0
        
        /// Animation duration for map movements
        static let animationDuration: Double = 0.5
        
        /// Distance threshold (in km) for clustering pins
        static let clusteringThreshold: Double = 50.0
        
        /// Span to use when focusing on a single charity
        static let charityFocusSpan = MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5
        )
        
        /// Span to use when focusing on a country
        static let countryFocusSpan = MKCoordinateSpan(
            latitudeDelta: 10.0,
            longitudeDelta: 10.0
        )
    }
    
    // MARK: - Search Configuration
    
    enum Search {
        /// Minimum characters before search begins
        static let minimumQueryLength = 2
        
        /// Debounce delay for search input (in seconds)
        static let debounceDelay: Double = 0.3
        
        /// Maximum number of search suggestions to show
        static let maxSuggestions = 5
        
        /// Placeholder text for search bar
        static let placeholder = "Search charities, causes, or locations..."
    }
    
    // MARK: - UI Configuration
    
    enum UI {
        /// Standard corner radius for cards
        static let cornerRadius: CGFloat = 12.0
        
        /// Standard padding
        static let standardPadding: CGFloat = 16.0
        
        /// Small padding
        static let smallPadding: CGFloat = 8.0
        
        /// Animation duration for UI transitions
        static let animationDuration: Double = 0.3
        
        /// Shadow radius for elevated components
        static let shadowRadius: CGFloat = 8.0
        
        /// Maximum width for content on larger screens (iPad)
        static let maxContentWidth: CGFloat = 600.0
    }
    
    // MARK: - API Configuration (for future use)
    
    enum API {
        /// Base URL for the charity API
        static let baseURL = "https://api.findmycharity.org/v1"
        
        /// Request timeout in seconds
        static let timeout: TimeInterval = 30.0
        
        /// Number of items per page for pagination
        static let pageSize = 50
    }
}

// MARK: - Feature Flags

/// Feature flags for controlling app behavior
enum FeatureFlags {
    /// Whether to use mock data instead of real API
    static let useMockData = true
    
    /// Whether to enable pin clustering
    static let enableClustering = true
    
    /// Whether to show debug information
    static let showDebugInfo = false
    
    /// Whether to enable analytics
    static let enableAnalytics = false
}
