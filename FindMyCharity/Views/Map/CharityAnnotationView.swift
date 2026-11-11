//
//  CharityAnnotationView.swift
//  FindMyCharity
//
//  Custom map annotation view for charity pins.
//  Shows the charity's cause with a colored pin icon.
//

import SwiftUI

// MARK: - Charity Annotation View

/// A custom annotation view displayed on the map for each charity
struct CharityAnnotationView: View {
    
    // MARK: - Properties
    
    let charity: Charity
    let isSelected: Bool
    
    // MARK: - Private Properties
    
    /// Animation state for selection
    @State private var isAnimating: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Pin head with cause icon
            ZStack {
                // Outer circle (shadow effect)
                Circle()
                    .fill(charity.cause.color.opacity(0.3))
                    .frame(width: pinSize + 8, height: pinSize + 8)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                    .opacity(isSelected ? 1.0 : 0.0)
                
                // Main pin circle
                Circle()
                    .fill(charity.cause.color)
                    .frame(width: pinSize, height: pinSize)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                
                // Cause icon
                Image(systemName: charity.cause.iconName)
                    .font(.system(size: iconSize, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
            
            // Pin pointer
            Triangle()
                .fill(charity.cause.color)
                .frame(width: 12, height: 8)
                .offset(y: -2)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
        }
        .offset(y: isSelected ? -5 : 0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
    
    // MARK: - Computed Properties
    
    private var pinSize: CGFloat {
        isSelected ? 44 : 36
    }
    
    private var iconSize: CGFloat {
        isSelected ? 20 : 16
    }
}

// MARK: - Triangle Shape

/// A simple triangle shape for the pin pointer
private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Compact Pin Variant

/// A smaller pin variant for when many pins are clustered
struct CompactCharityPinView: View {
    let cause: CharityCause
    
    var body: some View {
        Circle()
            .fill(cause.color)
            .frame(width: 24, height: 24)
            .overlay {
                Image(systemName: cause.iconName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Cluster Pin

/// A pin showing a cluster of multiple charities
struct ClusterPinView: View {
    let count: Int
    let dominantCause: CharityCause?
    
    var body: some View {
        ZStack {
            Circle()
                .fill(dominantCause?.color ?? .gray)
                .frame(width: 44, height: 44)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
            
            Text("\(count)")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Previews

#Preview("Standard Pin") {
    VStack(spacing: 40) {
        CharityAnnotationView(
            charity: .sample,
            isSelected: false
        )
        
        CharityAnnotationView(
            charity: .sample,
            isSelected: true
        )
    }
    .padding(50)
    .background(Color.gray.opacity(0.3))
}

#Preview("Different Causes") {
    HStack(spacing: 30) {
        ForEach([CharityCause.education, .healthcare, .environment, .cleanWater, .hunger], id: \.self) { cause in
            CharityAnnotationView(
                charity: Charity(
                    id: cause.rawValue,
                    name: cause.rawValue,
                    description: "",
                    cause: cause,
                    secondaryCauses: [],
                    latitude: 0,
                    longitude: 0,
                    country: "",
                    countryCode: "",
                    continent: .northAmerica,
                    city: nil,
                    websiteURL: URL(string: "https://example.com")!,
                    logoURL: nil,
                    foundedYear: nil,
                    registrationNumber: nil
                ),
                isSelected: false
            )
        }
    }
    .padding(50)
    .background(Color.gray.opacity(0.3))
}
