//
//  LoginView.swift
//  FindMyCharity
//
//  Login and signup screen for user authentication.
//

import SwiftUI

// MARK: - Login View

struct LoginView: View {
    
    // MARK: - Environment
    
    @EnvironmentObject var authService: AuthenticationService
    
    // MARK: - State
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var isShowingSignup: Bool = false
    @State private var showPassword: Bool = false
    @State private var showForgotPassword: Bool = false
    @State private var forgotPasswordEmail: String = ""
    @State private var showForgotPasswordAlert: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background solid color
            Color(red: 0.18, green: 0.49, blue: 0.20)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Logo and Title
                    logoSection
                    
                    // Login/Signup Form
                    formSection
                    
                    // Login/Signup Button
                    actionButton
                    
                    // Error Message
                    if let error = authService.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Forgot Password (only show on login)
                    if !isShowingSignup {
                        forgotPasswordButton
                    }
                    
                    // Divider
                    dividerSection
                    
                    // Social Login
                    socialLoginSection
                    
                    // Toggle Login/Signup
                    toggleSection
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
            }
        }
        .sheet(isPresented: $showForgotPassword) {
            forgotPasswordSheet
        }
        .alert("Password Reset", isPresented: $showForgotPasswordAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("If an account exists with that email, a password reset link has been sent.")
        }
    }
    
    // MARK: - Logo Section
    
    private var logoSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "globe.americas.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.white)
            }
            
            Text("FindMyCharity")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
            
            Text("Discover & Support Charities Worldwide")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Form Section
    
    private var formSection: some View {
        VStack(spacing: 16) {
            // Username (only for signup)
            if isShowingSignup {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 24)
                    
                    TextField("", text: $username, prompt: Text("Username").foregroundStyle(.white.opacity(0.7)))
                        .foregroundStyle(.white)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                .padding()
                .background(.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Email Field
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(width: 24)
                
                TextField("", text: $email, prompt: Text("Email").foregroundStyle(.white.opacity(0.7)))
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .foregroundStyle(.white)
            }
            .padding()
            .background(.white.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Password Field
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(width: 24)
                
                if showPassword {
                    TextField("", text: $password, prompt: Text("Password").foregroundStyle(.white.opacity(0.7)))
                        .foregroundStyle(.white)
                } else {
                    SecureField("", text: $password, prompt: Text("Password").foregroundStyle(.white.opacity(0.7)))
                        .foregroundStyle(.white)
                }
                
                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            .padding()
            .background(.white.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    // MARK: - Action Button
    
    private var actionButton: some View {
        Button {
            performAuth()
        } label: {
            HStack {
                if authService.isLoading {
                    ProgressView()
                        .tint(.green)
                } else {
                    Text(isShowingSignup ? "Sign Up" : "Log In")
                        .font(.headline)
                }
            }
            .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.20))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.2), radius: 5, y: 3)
        }
        .disabled(authService.isLoading || email.isEmpty || password.isEmpty || (isShowingSignup && username.isEmpty))
    }
    
    // MARK: - Perform Auth
    
    private func performAuth() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Task {
            do {
                if isShowingSignup {
                    try await authService.signUp(email: trimmedEmail, password: trimmedPassword, username: trimmedUsername)
                } else {
                    try await authService.signIn(email: trimmedEmail, password: trimmedPassword)
                }
            } catch {
                print("Auth error: \(error)")
            }
        }
    }
    
    // MARK: - Forgot Password
    
    private var forgotPasswordButton: some View {
        Button {
            forgotPasswordEmail = email
            showForgotPassword = true
        } label: {
            Text("Forgot Password?")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
        }
    }
    
    // MARK: - Forgot Password Sheet
    
    private var forgotPasswordSheet: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Enter your email address and we'll send you a link to reset your password.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                TextField("Email", text: $forgotPasswordEmail)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button {
                    sendPasswordReset()
                } label: {
                    Text("Send Reset Link")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.18, green: 0.49, blue: 0.20))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(forgotPasswordEmail.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showForgotPassword = false
                    }
                }
            }
        }
    }
    
    // MARK: - Send Password Reset
    
    private func sendPasswordReset() {
        Task {
            do {
                try await authService.resetPassword(email: forgotPasswordEmail)
                showForgotPassword = false
                showForgotPasswordAlert = true
            } catch {
                print("Reset error: \(error)")
            }
        }
    }
    
    // MARK: - Divider Section
    
    private var dividerSection: some View {
        HStack {
            Rectangle()
                .fill(.white.opacity(0.3))
                .frame(height: 1)
            
            Text("or continue with")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
            
            Rectangle()
                .fill(.white.opacity(0.3))
                .frame(height: 1)
        }
    }
    
    // MARK: - Social Login Section
    
    private var socialLoginSection: some View {
        HStack(spacing: 20) {
            socialButton(icon: "apple.logo", label: "Apple") {
                // TODO: Implement Apple Sign In
            }
            
            socialButton(icon: "g.circle.fill", label: "Google") {
                // TODO: Implement Google Sign In
            }
        }
    }
    
    private func socialButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(.white.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    // MARK: - Toggle Section
    
    private var toggleSection: some View {
        HStack {
            Text(isShowingSignup ? "Already have an account?" : "Don't have an account?")
                .foregroundStyle(.white.opacity(0.7))
            
            Button {
                isShowingSignup.toggle()
                authService.errorMessage = nil
            } label: {
                Text(isShowingSignup ? "Log In" : "Sign Up")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }
        }
        .font(.subheadline)
        .padding(.top, 10)
    }
}

// MARK: - Preview

#Preview {
    LoginView()
        .environmentObject(AuthenticationService())
}
