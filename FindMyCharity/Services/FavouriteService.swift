//
//  FavoritesService.swift
//  FindMyCharity
//
//  Handles saving favorites and history to Firebase Firestore.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class FavoritesService: ObservableObject {
    
    static let shared = FavoritesService()
    
    @Published var favoriteCharityIDs: Set<String> = []
    @Published var historyCharityIDs: [String] = []
    @Published var favoriteCharities: [Charity] = []
    @Published var historyCharities: [Charity] = []
    @Published var isLoading: Bool = false
    
    private let db = Firestore.firestore()
    private var favoritesListener: ListenerRegistration?
    private var historyListener: ListenerRegistration?
    
    private var userID: String? {
        Auth.auth().currentUser?.uid
    }
    
    init() {
        // Don't load automatically - wait until refresh() is called
    }
    
    // MARK: - Load Data
    
    func loadData() {
        guard let userID = userID else {
            // No user logged in - clear data
            favoriteCharityIDs = []
            historyCharityIDs = []
            favoriteCharities = []
            historyCharities = []
            return
        }
        
        // Remove old listeners
        favoritesListener?.remove()
        historyListener?.remove()
        
        isLoading = true
        
        // Load favorites
        favoritesListener = db.collection("users").document(userID).collection("favorites")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                guard let documents = snapshot?.documents else {
                    self.isLoading = false
                    return
                }
                DispatchQueue.main.async {
                    self.favoriteCharityIDs = Set(documents.map { $0.documentID })
                    self.updateFavoriteCharities()
                    self.isLoading = false
                }
            }
        
        // Load history
        historyListener = db.collection("users").document(userID).collection("history")
            .order(by: "viewedAt", descending: true)
            .limit(to: 20)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                guard let documents = snapshot?.documents else { return }
                DispatchQueue.main.async {
                    self.historyCharityIDs = documents.map { $0.documentID }
                    self.updateHistoryCharities()
                }
            }
    }
    
    // MARK: - Favorites
    
    func isFavorite(_ charity: Charity) -> Bool {
        favoriteCharityIDs.contains(charity.id)
    }
    
    func toggleFavorite(_ charity: Charity) {
        guard let userID = userID else { return }
        
        let docRef = db.collection("users").document(userID).collection("favorites").document(charity.id)
        
        if isFavorite(charity) {
            docRef.delete()
            favoriteCharityIDs.remove(charity.id)
        } else {
            docRef.setData([
                "charityID": charity.id,
                "name": charity.name,
                "country": charity.country,
                "cause": charity.cause.rawValue,
                "addedAt": Timestamp(date: Date())
            ])
            favoriteCharityIDs.insert(charity.id)
        }
        updateFavoriteCharities()
    }
    
    // MARK: - History
    
    func addToHistory(_ charity: Charity) {
        guard let userID = userID else { return }
        
        let docRef = db.collection("users").document(userID).collection("history").document(charity.id)
        
        docRef.setData([
            "charityID": charity.id,
            "name": charity.name,
            "country": charity.country,
            "cause": charity.cause.rawValue,
            "viewedAt": Timestamp(date: Date())
        ], merge: true)
        
        if let index = historyCharityIDs.firstIndex(of: charity.id) {
            historyCharityIDs.remove(at: index)
        }
        historyCharityIDs.insert(charity.id, at: 0)
        
        // Keep only last 20
        if historyCharityIDs.count > 20 {
            historyCharityIDs = Array(historyCharityIDs.prefix(20))
        }
        updateHistoryCharities()
    }
    
    func clearHistory() {
        guard let userID = userID else { return }
        
        let historyRef = db.collection("users").document(userID).collection("history")
        
        historyRef.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                document.reference.delete()
            }
        }
        
        historyCharityIDs.removeAll()
        historyCharities.removeAll()
    }
    
    // MARK: - Update Local Charity Objects
    
    private func updateFavoriteCharities() {
        let allCharities = GlobalGivingService.shared.cachedCharities
        favoriteCharities = allCharities.filter { favoriteCharityIDs.contains($0.id) }
    }
    
    private func updateHistoryCharities() {
        let allCharities = GlobalGivingService.shared.cachedCharities
        let charityDict = Dictionary(uniqueKeysWithValues: allCharities.map { ($0.id, $0) })
        historyCharities = historyCharityIDs.compactMap { charityDict[$0] }
    }
    
    // MARK: - Refresh
    
    func refresh() {
        loadData()
        updateFavoriteCharities()
        updateHistoryCharities()
    }
    
    // MARK: - Cleanup
    
    func cleanup() {
        favoritesListener?.remove()
        historyListener?.remove()
    }
}
