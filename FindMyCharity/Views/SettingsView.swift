//
//  SettingsView.swift
//  FindMyCharity
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var authService: AuthenticationService
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    @State private var isDarkMode = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
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
                        Text("English")
                            .foregroundColor(.secondary)
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
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
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
}

// MARK: - Settings Row

struct SettingsRow: View {
    let icon: String
    let color: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(color)
                .cornerRadius(6)
            
            Text(title)
        }
    }
}

// MARK: - Personal Info Settings View

struct PersonalInfoSettingsView: View {
    @State private var name: String = "User"
    @State private var email: String = "user@example.com"
    
    var body: some View {
        List {
            Section("Profile") {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(name)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text(email)
                        .foregroundColor(.secondary)
                }
            }
            
            Section {
                Button("Change Password") {
                    // Handle password change
                }
            }
        }
        .navigationTitle("Personal Info")
    }
}

// MARK: - Notifications Settings View

struct NotificationsSettingsView: View {
    @State private var pushEnabled = true
    @State private var newCharityAlerts = true
    @State private var donationReminders = false
    @State private var newsletter = false
    
    var body: some View {
        List {
            Section("Push Notifications") {
                Toggle("Enable Push Notifications", isOn: $pushEnabled)
                Toggle("New Charity Alerts", isOn: $newCharityAlerts)
                Toggle("Donation Reminders", isOn: $donationReminders)
            }
            
            Section("Email") {
                Toggle("Newsletter", isOn: $newsletter)
            }
        }
        .navigationTitle("Notifications")
    }
}

// MARK: - Help & Support Settings View

struct HelpSupportSettingsView: View {
    var body: some View {
        List {
            Section("FAQ") {
                FAQSettingsItem(question: "How do I donate?", answer: "Tap on any charity to view details, then tap the 'Donate' button to visit their website.")
                FAQSettingsItem(question: "How do I save favorites?", answer: "Tap the heart icon on any charity card to save it to your favorites.")
                FAQSettingsItem(question: "How do I search for charities?", answer: "Use the search bar on the map screen to filter by cause or country.")
            }
            
            Section("Contact Us") {
                Link(destination: URL(string: "mailto:support@findmycharity.com")!) {
                    HStack {
                        Text("Email Support")
                        Spacer()
                        Image(systemName: "envelope")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Help & Support")
    }
}

struct FAQSettingsItem: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(question)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
            
            if isExpanded {
                Text(answer)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Privacy Policy Settings View

struct PrivacyPolicySettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy")
                    .font(.title.bold())
                
                Text("Last updated: January 2026")
                    .foregroundColor(.secondary)
                
                Text("Your privacy is important to us. This policy explains how FindMyCharity collects, uses, and protects your information.")
                
                Text("Information We Collect")
                    .font(.headline)
                
                Text("We collect information you provide directly, such as your name and email when you create an account. We also collect usage data to improve our services.")
                
                Text("How We Use Your Information")
                    .font(.headline)
                
                Text("We use your information to provide and improve our services, personalize your experience, and communicate with you about updates and features.")
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

// MARK: - Terms of Service View

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Terms of Service")
                    .font(.title.bold())
                
                Text("Last updated: January 2026")
                    .foregroundColor(.secondary)
                
                Text("By using FindMyCharity, you agree to these terms. Please read them carefully.")
                
                Text("Use of Service")
                    .font(.headline)
                
                Text("FindMyCharity provides information about charitable organizations. We do not process donations directly - all donations are handled through the respective charity's website.")
                
                Text("User Responsibilities")
                    .font(.headline)
                
                Text("You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account.")
            }
            .padding()
        }
        .navigationTitle("Terms of Service")
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthenticationService())
}
