//
//  MapViewModel.swift
//  FindMyCharity
//

import Foundation
import MapKit
import Observation
import SwiftUI

@MainActor
@Observable
final class MapViewModel {
    
    private(set) var allCharities: [Charity] = []
    private(set) var filteredCharities: [Charity] = []
    
    var selectedCharity: Charity?
    var isShowingDetail: Bool = false
    var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
    ))
    
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    
    private let service = GlobalGivingService.shared
    
    init() {
        print("⭐ MapViewModel initialized")
    }
    
    func loadCharities() async {
        print("⭐ loadCharities() called")
        isLoading = true
        errorMessage = nil
        
        do {
            let charities = try await service.fetchCharities()
            allCharities = charities
            print("⭐ Loaded \(allCharities.count) charities from GlobalGiving")
        } catch {
            print("⭐ Error loading charities: \(error)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func filterCharities(cause: CharityCause?, country: String) {
        print("⭐ Filtering - Cause: \(cause?.rawValue ?? "All"), Country: \(country.isEmpty ? "All" : country)")
        
        filteredCharities = allCharities.filter { charity in
            let causeMatch = cause == nil || charity.cause == cause
            let countryMatch = country.isEmpty || charity.country.localizedCaseInsensitiveContains(country)
            return causeMatch && countryMatch
        }
        
        print("⭐ Found \(filteredCharities.count) matching charities")
        
        if filteredCharities.count == 1, let first = filteredCharities.first {
            cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
                center: first.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            ))
        } else if !filteredCharities.isEmpty {
            let lats = filteredCharities.map { $0.latitude }
            let lons = filteredCharities.map { $0.longitude }
            let centerLat = (lats.min()! + lats.max()!) / 2
            let centerLon = (lons.min()! + lons.max()!) / 2
            let latSpan = max((lats.max()! - lats.min()!) * 1.5, 10)
            let lonSpan = max((lons.max()! - lons.min()!) * 1.5, 10)
            
            cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                span: MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lonSpan)
            ))
        }
    }
    
    func selectCharity(_ charity: Charity) {
        selectedCharity = charity
        isShowingDetail = true
    }
    
    func deselectCharity() {
        selectedCharity = nil
        isShowingDetail = false
    }
    
    func openDonateURL(for charity: Charity) {
        UIApplication.shared.open(charity.websiteURL)
    }
}
