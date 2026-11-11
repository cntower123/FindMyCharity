//
//  RootView.swift
//  FindMyCharity
//
//  Controls navigation between Onboarding, Login and Main app.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var authService: AuthenticationService
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                // First time user - show onboarding
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else if authService.isAuthenticated {
                // Logged in - show main app
                MainTabView()
            } else {
                // Not logged in - show login
                LoginView()
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthenticationService())
}
