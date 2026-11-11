//
//  CharityCause.swift
//  FindMyCharity
//

import SwiftUI

enum CharityCause: String, CaseIterable, Codable, Identifiable {
    case education = "Education"
    case healthcare = "Healthcare"
    case environment = "Environment"
    case cleanWater = "Clean Water"
    case hunger = "Hunger Relief"
    case housing = "Housing"
    case animalWelfare = "Animal Welfare"
    case disasterRelief = "Disaster Relief"
    case humanRights = "Human Rights"
    case artsAndCulture = "Arts & Culture"
    case youthDevelopment = "Youth Development"
    case elderCare = "Elder Care"
    case mentalHealth = "Mental Health"
    case refugeeSupport = "Refugee Support"
    case climate = "Climate Action"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .education: return "book.fill"
        case .healthcare: return "heart.fill"
        case .environment: return "leaf.fill"
        case .cleanWater: return "drop.fill"
        case .hunger: return "fork.knife"
        case .housing: return "house.fill"
        case .animalWelfare: return "pawprint.fill"
        case .disasterRelief: return "exclamationmark.triangle.fill"
        case .humanRights: return "person.3.fill"
        case .artsAndCulture: return "paintpalette.fill"
        case .youthDevelopment: return "figure.and.child.holdinghands"
        case .elderCare: return "figure.walk"
        case .mentalHealth: return "brain.head.profile"
        case .refugeeSupport: return "globe.americas.fill"
        case .climate: return "thermometer.sun.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .education: return .blue
        case .healthcare: return .red
        case .environment: return .green
        case .cleanWater: return .cyan
        case .hunger: return .orange
        case .housing: return .brown
        case .animalWelfare: return .purple
        case .disasterRelief: return .yellow
        case .humanRights: return .indigo
        case .artsAndCulture: return .pink
        case .youthDevelopment: return .teal
        case .elderCare: return .mint
        case .mentalHealth: return Color(red: 0.6, green: 0.4, blue: 0.8)
        case .refugeeSupport: return Color(red: 0.2, green: 0.6, blue: 0.8)
        case .climate: return Color(red: 0.2, green: 0.7, blue: 0.4)
        }
    }
    
    var searchKeywords: [String] {
        switch self {
        case .education:
            return ["education", "school", "learning", "teaching", "students", "literacy"]
        case .healthcare:
            return ["health", "healthcare", "medical", "medicine", "hospital", "clinic", "disease"]
        case .environment:
            return ["environment", "nature", "conservation", "wildlife", "forest", "ocean"]
        case .cleanWater:
            return ["water", "clean water", "sanitation", "wells", "drinking water"]
        case .hunger:
            return ["hunger", "food", "feeding", "nutrition", "meals", "famine"]
        case .housing:
            return ["housing", "shelter", "homeless", "homes", "affordable housing"]
        case .animalWelfare:
            return ["animal", "animals", "pets", "rescue", "wildlife", "shelter"]
        case .disasterRelief:
            return ["disaster", "emergency", "relief", "earthquake", "flood", "hurricane"]
        case .humanRights:
            return ["human rights", "rights", "justice", "equality", "freedom", "advocacy"]
        case .artsAndCulture:
            return ["arts", "culture", "music", "theater", "museum", "heritage"]
        case .youthDevelopment:
            return ["youth", "children", "kids", "young", "mentoring", "after school"]
        case .elderCare:
            return ["elder", "elderly", "senior", "seniors", "aging", "retirement"]
        case .mentalHealth:
            return ["mental health", "mental", "counseling", "therapy", "wellness", "suicide prevention"]
        case .refugeeSupport:
            return ["refugee", "refugees", "asylum", "displaced", "migration", "immigrant"]
        case .climate:
            return ["climate", "global warming", "carbon", "renewable", "sustainability", "emissions"]
        }
    }
    
    func matches(query: String) -> Bool {
        let lowercasedQuery = query.lowercased()
        if rawValue.lowercased().contains(lowercasedQuery) {
            return true
        }
        return searchKeywords.contains { keyword in
            keyword.contains(lowercasedQuery) || lowercasedQuery.contains(keyword)
        }
    }
}
