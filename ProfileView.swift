//
//  ProfileView.swift
//  FindMyCharity
//
//  User profile screen.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @EnvironmentObject var authService: AuthenticationService
    
    @State private var username: String = "User Name"
    @State private var email: String = "user@example.com"
    @State private var isEditingProfile: Bool = false
    @State private var profileImage: UIImage? = nil
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var showingLogoutAlert: Bool = false
    @State private var favoriteCharities: [SavedCharity] = []
    @State private var historyCharities: [SavedCharity] = []
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Header Section
                Section {
                    profileHeader
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                }
                
                // Favorites Section
                Section {
                    if favoriteCharities.isEmpty {
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image(systemName: "heart")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                                Text("No favorites yet")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Tap the heart on any charity to save it")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 20)
                            Spacer()
                        }
                    } else {
                        ForEach(favoriteCharities) { charity in
                            FavoriteCharityRow(charity: charity)
                        }
                        .onDelete(perform: removeFavorite)
                    }
                } header: {
                    HStack {
                        Text("My Favorites")
                        Spacer()
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                }
                
                // History Section
                Section {
                    if historyCharities.isEmpty {
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image(systemName: "clock")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                                Text("No history yet")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Charities you view will appear here")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 20)
                            Spacer()
                        }
                    } else {
                        ForEach(historyCharities) { charity in
                            HistoryCharityRow(charity: charity)
                        }
                    }
                } header: {
                    HStack {
                        Text("Recently Viewed")
                        Spacer()
                        if !historyCharities.isEmpty {
                            Button("Clear") {
                                clearHistory()
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    }
                }
                
                // Impact Summary Section
                Section("Your Impact") {
                    HStack {
                        ImpactCard(icon: "heart.fill", color: .red, value: "\(favoriteCharities.count)", label: "Favorites")
                        Spacer()
                        ImpactCard(icon: "eye.fill", color: .blue, value: "\(historyCharities.count)", label: "Viewed")
                        Spacer()
                        ImpactCard(icon: "globe", color: .green, value: "\(uniqueCountries)", label: "Countries")
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
                }
                
                // Logout Section
                Section {
                    Button {
                        showingLogoutAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out")
                            Spacer()
                        }
                        .foregroundStyle(.red)
                        .fontWeight(.semibold)
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $isEditingProfile) {
                EditProfileSheet(username: $username, profileImage: $profileImage, selectedPhotoItem: $selectedPhotoItem)
            }
            .alert("Log Out", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    try? authService.signOut()
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
            .onAppear {
                loadFavorites()
                loadHistory()
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var uniqueCountries: Int {
        let favoriteCountries = Set(favoriteCharities.map { $0.country })
        let historyCountries = Set(historyCharities.map { $0.country })
        return favoriteCountries.union(historyCountries).count
    }
    
    // MARK: - Methods
    
    private func loadFavorites() {
        guard let details = UserDefaults.standard.dictionary(forKey: "favoriteCharityDetails") as? [String: [String: String]] else {
            favoriteCharities = []
            return
        }
        
        favoriteCharities = details.map { (id, info) in
            SavedCharity(
                id: id,
                name: info["name"] ?? "Unknown",
                country: info["country"] ?? "Unknown",
                causeName: info["cause"] ?? "Human Rights"
            )
        }.sorted { $0.name < $1.name }
    }
    
    private func loadHistory() {
        guard let details = UserDefaults.standard.dictionary(forKey: "historyCharityDetails") as? [String: [String: String]] else {
            historyCharities = []
            return
        }
        
        historyCharities = details.map { (id, info) in
            SavedCharity(
                id: id,
                name: info["name"] ?? "Unknown",
                country: info["country"] ?? "Unknown",
                causeName: info["cause"] ?? "Human Rights"
            )
        }
    }
    
    private func removeFavorite(at offsets: IndexSet) {
        for index in offsets {
            let charity = favoriteCharities[index]
            
            var favorites = UserDefaults.standard.stringArray(forKey: "favoriteCharities") ?? []
            favorites.removeAll { $0 == charity.id }
            UserDefaults.standard.set(favorites, forKey: "favoriteCharities")
            
            var details = UserDefaults.standard.dictionary(forKey: "favoriteCharityDetails") as? [String: [String: String]] ?? [:]
            details.removeValue(forKey: charity.id)
            UserDefaults.standard.set(details, forKey: "favoriteCharityDetails")
        }
        
        favoriteCharities.remove(atOffsets: offsets)
    }
    
    private func clearHistory() {
        UserDefaults.standard.removeObject(forKey: "historyCharityDetails")
        historyCharities = []
    }
    
    // MARK: - Profile Header
    
    private var profileHeader: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .green],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                        }
                }
                
                Button {
                    isEditingProfile = true
                } label: {
                    Circle()
                        .fill(.white)
                        .frame(width: 32, height: 32)
                        .shadow(radius: 2)
                        .overlay {
                            Image(systemName: "pencil")
                                .font(.system(size: 14))
                                .foregroundStyle(.blue)
                        }
                }
            }
            
            Text(username)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(email)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

// MARK: - Saved Charity Model

struct SavedCharity: Identifiable {
    let id: String
    let name: String
    let country: String
    let causeName: String
    
    var cause: CharityCause {
        CharityCause.allCases.first { $0.rawValue == causeName } ?? .humanRights
    }
}

// MARK: - Favorite Charity Row

struct FavoriteCharityRow: View {
    let charity: SavedCharity
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(charity.cause.color)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: charity.cause.iconName)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(charity.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(charity.country)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
                .font(.caption)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - History Charity Row

struct HistoryCharityRow: View {
    let charity: SavedCharity
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(charity.cause.color.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: charity.cause.iconName)
                        .foregroundColor(charity.cause.color)
                        .font(.system(size: 16))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(charity.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(charity.country)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Impact Card

struct ImpactCard: View {
    let icon: String
    let color: Color
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Edit Profile Sheet

private struct EditProfileSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var username: String
    @Binding var profileImage: UIImage?
    @Binding var selectedPhotoItem: PhotosPickerItem?
    
    @State private var tempUsername: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    ZStack(alignment: .bottomTrailing) {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .green],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 50))
                                        .foregroundStyle(.white)
                                }
                        }
                        
                        Circle()
                            .fill(.blue)
                            .frame(width: 36, height: 36)
                            .overlay {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .onChange(of: selectedPhotoItem) { _, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            profileImage = image
                        }
                    }
                }
                
                Text("Tap to change photo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username")
                        .font(.headline)
                    
                    TextField("Enter username", text: $tempUsername)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 40)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        username = tempUsername
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                tempUsername = username
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationService())
}
