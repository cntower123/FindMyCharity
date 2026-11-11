//
//  CharityDetailViewModel.swift
//  FindMyCharity
//
//  View model for the charity detail screen.
//  Manages state and actions for viewing individual charity information.
//

import Foundation
import UIKit

// MARK: - Charity Detail View Model

/// View model for managing charity detail view state and actions
@MainActor
@Observable
final class CharityDetailViewModel {
    
    // MARK: - Properties
    
    /// The charity being displayed
    let charity: Charity
    
    /// Whether the share sheet is being shown
    var isShowingShareSheet: Bool = false
    
    /// Whether a link action is in progress
    var isOpeningWebsite: Bool = false
    
    // MARK: - Initialization
    
    init(charity: Charity) {
        self.charity = charity
    }
    
    // MARK: - Actions
    
    /// Opens the charity's website in Safari
    func openWebsite() {
        isOpeningWebsite = true
        UIApplication.shared.open(charity.websiteURL) { [weak self] success in
            Task { @MainActor in
                self?.isOpeningWebsite = false
                if !success {
                    // Could show an error alert here
                    print("Failed to open URL: \(self?.charity.websiteURL.absoluteString ?? "unknown")")
                }
            }
        }
    }
    
    /// Generates share content for the charity
    func shareContent() -> [Any] {
        var items: [Any] = []
        
        // Create share text
        let shareText = """
        Check out \(charity.name)!
        
        \(charity.description)
        
        Learn more: \(charity.websiteURL.absoluteString)
        
        Found on FindMyCharity
        """
        
        items.append(shareText)
        items.append(charity.websiteURL)
        
        return items
    }
    
    /// Triggers the share sheet
    func share() {
        isShowingShareSheet = true
    }
    
    /// Copies the website URL to clipboard
    func copyWebsiteLink() {
        UIPasteboard.general.string = charity.websiteURL.absoluteString
    }
}
