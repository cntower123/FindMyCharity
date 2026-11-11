//
//
//  OnboardingView.swift
//  FindMyCharity
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                // Page content
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "globe.americas.fill",
                        iconColor: .blue,
                        title: "Find My Charity",
                        subtitle: "Discover and support charitable organizations around the world"
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "magnifyingglass",
                        iconColor: .green,
                        title: "Search Your Way",
                        subtitle: "Filter charities by cause like Education, Healthcare, or Clean Water — and by country"
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "heart.fill",
                        iconColor: .red,
                        title: "Make a Difference",
                        subtitle: "Learn about charities and connect directly to support causes you care about"
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 20)
                
                // Buttons
                VStack(spacing: 12) {
                    if currentPage == 2 {
                        // Get Started button on last page
                        Button(action: {
                            withAnimation {
                                hasCompletedOnboarding = true
                            }
                        }) {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 40)
                    } else {
                        // Next button
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 40)
                        
                        // Skip button
                        Button(action: {
                            withAnimation {
                                hasCompletedOnboarding = true
                            }
                        }) {
                            Text("Skip")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.top, 30)
                .padding(.bottom, 50)
            }
        }
    }
}

// MARK: - Onboarding Page

struct OnboardingPage: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Icon with background circle
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 160, height: 160)
                
                Image(systemName: icon)
                    .font(.system(size: 70))
                    .foregroundColor(iconColor)
            }
            .padding(.bottom, 20)
            
            // Title
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
            
            // Subtitle
            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
