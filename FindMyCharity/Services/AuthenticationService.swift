//
//
//  AuthenticationService.swift
//  FindMyCharity
//
//  Handles user authentication with Firebase.
//
import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

// MARK: - Authentication Service

@MainActor
class AuthenticationService: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var user: User?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    // MARK: - Initialization
    
    init() {
        setupAuthStateListener()
    }
    
    deinit {
        if let listener = authStateListener {
            auth.removeStateDidChangeListener(listener)
        }
    }
    
    // MARK: - Auth State Listener
    
    private func setupAuthStateListener() {
        authStateListener = auth.addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    // MARK: - Sign Up with Email
    
    func signUp(email: String, password: String, username: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            // Create user account
            let result = try await auth.createUser(withEmail: email, password: password)
            
            // Update display name
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = username
            try await changeRequest.commitChanges()
            
            // Save user data to Firestore
            try await saveUserToFirestore(userId: result.user.uid, email: email, username: username)
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Sign In with Email
    
    func signIn(email: String, password: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            try await auth.signIn(withEmail: email, password: password)
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Sign Out
    
    func signOut() throws {
        do {
            try auth.signOut()
        } catch {
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Password Reset
    
    func resetPassword(email: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            try await auth.sendPasswordReset(withEmail: email)
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Save User to Firestore
    
    private func saveUserToFirestore(userId: String, email: String, username: String) async throws {
        let userData: [String: Any] = [
            "email": email,
            "username": username,
            "createdAt": Timestamp(date: Date()),
            "profileImageURL": ""
        ]
        
        try await db.collection("users").document(userId).setData(userData)
    }
    
    // MARK: - Get Current User Data
    
    func getCurrentUserData() async throws -> [String: Any]? {
        guard let userId = user?.uid else { return nil }
        
        let document = try await db.collection("users").document(userId).getDocument()
        return document.data()
    }
    
    // MARK: - Update User Data
    
    func updateUserData(data: [String: Any]) async throws {
        guard let userId = user?.uid else { return }
        
        try await db.collection("users").document(userId).updateData(data)
    }
}
