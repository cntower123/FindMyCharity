//
//  FindMyCharityApp.swift
//  FindMyCharity
//
//  Main entry point for the FindMyCharity application.
//

import SwiftUI
import Firebase

// App Delegate for Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("🔥 Firebase configured successfully")
        return true
    }
}

@main
struct FindMyCharityApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authService = AuthenticationService()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authService)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

//Demo Login Info.
//Username: LMillerTest
//email: Test123@gmail.com
//Password: Test123!
