//
//  CauseBadgeView.swift
//  FindMyCharity
//
//  A reusable badge component displaying a charity cause category.
//  Supports multiple visual styles for different contexts.
//

import SwiftUI

// MARK: - Cause Badge Style

/// Visual style options for the cause badge
enum CauseBadgeStyle {
    /// Large badge with icon and full text
    case prominent
    /// Standard badge with icon and text
    case standard
    /// Compact badge with just text
    case compact
    /// Minimal badge (icon only)
    case minimal
}

// MARK: - Cause Badge View

/// A badge displaying a cause category with appropriate styling
struct CauseBadgeView: View {
    
    // MARK: - Properties
    
    let cause: CharityCause
    let style: CauseBadgeStyle
    
    // MARK: - Initialization
    
    init(cause: CharityCause, style: CauseBadgeStyle = .standard) {
        self.cause = cause
        self.style = style
    }
    
    // MARK: - Body
    
    var body: some View {
        switch style {
        case .prominent:
            prominentBadge
        case .standard:
            standardBadge
        case .compact:
            compactBadge
        case .minimal:
            minimalBadge
        }
    }
    
    // MARK: - Badge Variants
    
    /// Large, eye-catching badge
    private var prominentBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: cause.iconName)
                .font(.system(size: 18, weight: .semibold))
            
            Text(cause.rawValue)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(cause.color)
        .clipShape(Capsule())
    }
    
    /// Standard badge with icon and text
    private var standardBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: cause.iconName)
                .font(.system(size: 12, weight: .medium))
            
            Text(cause.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .foregroundStyle(cause.color)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(cause.color.opacity(0.15))
        .clipShape(Capsule())
    }
    
    /// Compact badge with just text
    private var compactBadge: some View {
        Text(cause.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(cause.color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(cause.color.opacity(0.15))
            .clipShape(Capsule())
    }
    
    /// Minimal badge showing only the icon
    private var minimalBadge: some View {
        Image(systemName: cause.iconName)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(cause.color)
            .padding(8)
            .background(cause.color.opacity(0.15))
            .clipShape(Circle())
    }
}

// MARK: - Cause Icon View

/// A standalone icon for a cause (useful in tight spaces)
struct CauseIconView: View {
    let cause: CharityCause
    let size: CGFloat
    
    init(cause: CharityCause, size: CGFloat = 24) {
        self.cause = cause
        self.size = size
    }
    
    var body: some View {
        Image(systemName: cause.iconName)
            .font(.system(size: size * 0.5, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(cause.color)
            .clipShape(Circle())
    }
}

// MARK: - Cause Color Dot

/// A small colored dot indicator for a cause
struct CauseColorDot: View {
    let cause: CharityCause
    let size: CGFloat
    
    init(cause: CharityCause, size: CGFloat = 8) {
        self.cause = cause
        self.size = size
    }
    
    var body: some View {
        Circle()
            .fill(cause.color)
            .frame(width: size, height: size)
    }
}

// MARK: - Previews

#Preview("All Styles") {
    VStack(spacing: 20) {
        // Prominent
        VStack(alignment: .leading) {
            Text("Prominent").font(.caption).foregroundStyle(.secondary)
            CauseBadgeView(cause: .education, style: .prominent)
        }
        
        // Standard
        VStack(alignment: .leading) {
            Text("Standard").font(.caption).foregroundStyle(.secondary)
            HStack {
                CauseBadgeView(cause: .healthcare, style: .standard)
                CauseBadgeView(cause: .environment, style: .standard)
            }
        }
        
        // Compact
        VStack(alignment: .leading) {
            Text("Compact").font(.caption).foregroundStyle(.secondary)
            HStack {
                CauseBadgeView(cause: .cleanWater, style: .compact)
                CauseBadgeView(cause: .hunger, style: .compact)
                CauseBadgeView(cause: .housing, style: .compact)
            }
        }
        
        // Minimal
        VStack(alignment: .leading) {
            Text("Minimal").font(.caption).foregroundStyle(.secondary)
            HStack {
                CauseBadgeView(cause: .animalWelfare, style: .minimal)
                CauseBadgeView(cause: .disasterRelief, style: .minimal)
                CauseBadgeView(cause: .humanRights, style: .minimal)
            }
        }
    }
    .padding()
}

#Preview("All Causes") {
    ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 12) {
            ForEach(CharityCause.allCases) { cause in
                CauseBadgeView(cause: cause, style: .standard)
            }
        }
        .padding()
    }
}
