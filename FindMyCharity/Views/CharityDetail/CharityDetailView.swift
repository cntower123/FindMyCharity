//
//  CharityDetailView.swift
//  FindMyCharity
//
//  A detailed view showing full information about a charity.
//  Presented as a sheet when a user taps on a charity pin.
//

import SwiftUI

// MARK: - Charity Detail View

struct CharityDetailView: View {
    
    // MARK: - Properties
    
    let charity: Charity
    
    // MARK: - Environment
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    // MARK: - State
    
    @State private var viewModel: CharityDetailViewModel
    @State private var isFavorite: Bool = false
    
    // MARK: - Initialization
    
    init(charity: Charity) {
        self.charity = charity
        self._viewModel = State(wrappedValue: CharityDetailViewModel(charity: charity))
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header with cause badge
                    headerSection
                    
                    // Mission description
                    descriptionSection
                    
                    // Location info
                    locationSection
                    
                    // Cause tags
                    causesSection
                    
                    // Additional info
                    if charity.foundedYear != nil || charity.registrationNumber != nil {
                        additionalInfoSection
                    }
                    
                    // Action buttons
                    actionButtons
                }
                .padding(.horizontal, AppConstants.UI.standardPadding)
                .padding(.bottom, 32)
            }
            .navigationTitle(charity.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 16) {
                        // Favorite button
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                isFavorite.toggle()
                                saveFavorite()
                            }
                        } label: {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 20))
                                .foregroundColor(isFavorite ? .red : .gray)
                                .scaleEffect(isFavorite ? 1.1 : 1.0)
                        }
                        
                        // Share button
                        ShareLink(
                            item: charity.websiteURL,
                            subject: Text(charity.name),
                            message: Text("Check out \(charity.name): \(charity.description)")
                        ) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
            .onAppear {
                loadFavoriteStatus()
                saveToHistory()
            }
        }
    }
    
    // MARK: - Favorite Methods
    
    private func loadFavoriteStatus() {
        let favorites = UserDefaults.standard.stringArray(forKey: "favoriteCharities") ?? []
        isFavorite = favorites.contains(charity.id)
    }
    
    private func saveFavorite() {
        var favorites = UserDefaults.standard.stringArray(forKey: "favoriteCharities") ?? []
        
        if isFavorite {
            if !favorites.contains(charity.id) {
                favorites.append(charity.id)
            }
        } else {
            favorites.removeAll { $0 == charity.id }
        }
        
        UserDefaults.standard.set(favorites, forKey: "favoriteCharities")
        
        // Also save charity details for profile display
        saveFavoriteDetails()
    }
    
    private func saveFavoriteDetails() {
        var favoriteDetails = UserDefaults.standard.dictionary(forKey: "favoriteCharityDetails") as? [String: [String: String]] ?? [:]
        
        if isFavorite {
            favoriteDetails[charity.id] = [
                "name": charity.name,
                "country": charity.country,
                "cause": charity.cause.rawValue
            ]
        } else {
            favoriteDetails.removeValue(forKey: charity.id)
        }
        
        UserDefaults.standard.set(favoriteDetails, forKey: "favoriteCharityDetails")
    }
    
    private func saveToHistory() {
        var historyDetails = UserDefaults.standard.dictionary(forKey: "historyCharityDetails") as? [String: [String: String]] ?? [:]
        
        // Add to history
        historyDetails[charity.id] = [
            "name": charity.name,
            "country": charity.country,
            "cause": charity.cause.rawValue
        ]
        
        // Keep only last 20
        if historyDetails.count > 20 {
            let keysToKeep = Array(historyDetails.keys.suffix(20))
            historyDetails = historyDetails.filter { keysToKeep.contains($0.key) }
        }
        
        UserDefaults.standard.set(historyDetails, forKey: "historyCharityDetails")
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(charity.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            HStack(spacing: 8) {
                CauseBadgeView(cause: charity.cause, style: .prominent)
                
                Spacer()
                
                // Favorite indicator
                if isFavorite {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("Saved")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Description Section
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Mission")
            
            Text(charity.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
    }
    
    // MARK: - Location Section
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Location")
            
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.red)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(charity.locationString)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(charity.continent.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadius))
        }
    }
    
    // MARK: - Causes Section
    
    private var causesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Focus Areas")
            
            FlowLayout(spacing: 8) {
                ForEach(charity.allCauses) { cause in
                    CauseBadgeView(cause: cause, style: .standard)
                }
            }
        }
    }
    
    // MARK: - Additional Info Section
    
    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Details")
            
            VStack(spacing: 12) {
                if let year = charity.foundedYear {
                    InfoRow(
                        icon: "calendar",
                        label: "Founded",
                        value: String(year)
                    )
                }
                
                if let regNumber = charity.registrationNumber {
                    InfoRow(
                        icon: "doc.text",
                        label: "Registration",
                        value: regNumber
                    )
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadius))
        }
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                openURL(charity.websiteURL)
            } label: {
                HStack {
                    Image(systemName: "globe")
                    Text("Visit Website")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(charity.cause.color)
                .clipShape(RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadius))
            }
            
            Button {
                UIPasteboard.general.string = charity.websiteURL.absoluteString
            } label: {
                HStack {
                    Image(systemName: "link")
                    Text("Copy Link")
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(charity.cause.color)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(charity.cause.color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadius))
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Section Header

private struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.primary)
    }
}

// MARK: - Info Row

private struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            Text(label)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY),
                proposal: ProposedViewSize(frame.size)
            )
        }
    }
    
    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        let maxWidth = proposal.width ?? .infinity
        var frames: [CGRect] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            
            frames.append(CGRect(origin: CGPoint(x: currentX, y: currentY), size: size))
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
        
        let totalHeight = currentY + lineHeight
        return (CGSize(width: maxWidth, height: totalHeight), frames)
    }
}

// MARK: - Preview

#Preview {
    CharityDetailView(charity: .sample)
}
