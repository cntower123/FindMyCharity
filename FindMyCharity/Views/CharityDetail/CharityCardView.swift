//
//  CharityCardView.swift
//  FindMyCharity
//
//  A compact card view showing charity summary information.
//  Used as a preview card when hovering over or initially selecting a pin.
//

import SwiftUI

// MARK: - Charity Card View

/// A compact card showing charity summary, typically displayed on the map
struct CharityCardView: View {
    
    // MARK: - Properties
    
    let charity: Charity
    let onTap: () -> Void
    let onClose: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header row
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(charity.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Text(charity.locationString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
        Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            
            // Cause badge
            CauseBadgeView(cause: charity.cause, style: .compact)
            
            // Description preview
            Text(charity.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            // View details button
            Button(action: onTap) {
                HStack {
                    Text("View Details")
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(charity.cause.color)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadius)
                .fill(.regularMaterial)
                .shadow(
                    color: .black.opacity(0.15),
                    radius: AppConstants.UI.shadowRadius,
                    x: 0,
                    y: 4
                )
        }
        .frame(maxWidth: 320)
    }
}

// MARK: - Mini Card Variant

/// An even more compact card for tight spaces
struct MiniCharityCard: View {
    let charity: Charity
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Cause indicator
                Circle()
                    .fill(charity.cause.color)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: charity.cause.iconName)
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                    }
                
                // Text content
                VStack(alignment: .leading, spacing: 2) {
                    Text(charity.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Text(charity.locationString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(.tertiary)
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.regularMaterial)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Card View") {
    CharityCardView(
        charity: .sample,
        onTap: {},
        onClose: {}
    )
    .padding()
    .background(Color.gray.opacity(0.3))
}

#Preview("Mini Card") {
    MiniCharityCard(
        charity: .sample,
        onTap: {}
    )
    .padding()
    .background(Color.gray.opacity(0.3))
}
