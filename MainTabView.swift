//
//  MainTabView.swift
//  FindMyCharity
//
//  Main tab bar navigation for the app.
//

import SwiftUI

// MARK: - Main Tab View

struct MainTabView: View {
    
    // MARK: - State
    
    @State private var selectedTab: Tab = .map
    @State private var mapViewModel = MapViewModel()
    
    // MARK: - Tab Enum
    
    enum Tab {
        case map
        case profile
        case settings
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Map Tab
            MapContainerView()
                .environment(mapViewModel)
                .tabItem {
                    Image(systemName: selectedTab == .map ? "map.fill" : "map")
                    Text("Map")
                }
                .tag(Tab.map)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == .profile ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(Tab.profile)
            
            // Settings Tab
            SettingsTabView()
                .tabItem {
                    Image(systemName: selectedTab == .settings ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(Tab.settings)
        }
        .tint(Color(red: 0.18, green: 0.49, blue: 0.20))
    }
}

// MARK: - Settings Tab View (wrapper for SettingsView)

struct SettingsTabView: View {
    var body: some View {
        NavigationStack {
            SettingsContentView()
                .navigationTitle("Settings")
        }
    }
}

// MARK: - Settings Content View

struct SettingsContentView: View {
    
    @EnvironmentObject var authService: AuthenticationService
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var notificationsEnabled = true
    @State private var showDeleteAlert = false
    
    var body: some View {
        List {
            // Account Section
            Section("Account") {
                NavigationLink {
                    PersonalInfoSettingsView()
                } label: {
                    SettingsRow(icon: "person.fill", color: .blue, title: "Personal Info")
                }
                
                NavigationLink {
                    NotificationsSettingsView()
                } label: {
                    SettingsRow(icon: "bell.fill", color: .red, title: "Notifications")
                }
            }
            
            // Preferences Section
            Section("Preferences") {
                HStack {
                    SettingsRow(icon: "moon.fill", color: .purple, title: "Dark Mode")
                    Spacer()
                    Toggle("", isOn: $isDarkMode)
                        .labelsHidden()
                }
                
                HStack {
                    SettingsRow(icon: "globe", color: .green, title: "Language")
                    Spacer()
                    Text("Coming Soon")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
            
            // Support Section
            Section("Support") {
                NavigationLink {
                    HelpSupportSettingsView()
                } label: {
                    SettingsRow(icon: "questionmark.circle.fill", color: .teal, title: "Help & Support")
                }
                
                NavigationLink {
                    PrivacyPolicySettingsView()
                } label: {
                    SettingsRow(icon: "lock.shield.fill", color: .gray, title: "Privacy Policy")
                }
                
                NavigationLink {
                    TermsOfServiceView()
                } label: {
                    SettingsRow(icon: "doc.text.fill", color: .gray, title: "Terms of Service")
                }
            }
            
            // About Section
            Section("About") {
                HStack {
                    SettingsRow(icon: "info.circle.fill", color: .blue, title: "Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
            }
            
            // Danger Zone
            Section {
                Button(action: {
                    showDeleteAlert = true
                }) {
                    HStack {
                        Spacer()
                        Text("Delete Account")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Handle account deletion
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone.")
        }
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
        .environmentObject(AuthenticationService())
}

