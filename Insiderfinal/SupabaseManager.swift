import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        let supabaseURL = URL(string: "https://edoumdymwuxndqtmcroz.supabase.co")!
        let supabaseKey = "sb_publishable_haTsV2s4Jazf3-ZGykcMDw_B5VLlBbC"
        
        client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, fullName: String) async throws -> User {
        let response = try await client.auth.signUp(
            email: email,
            password: password,
            data: ["full_name": .string(fullName)]
        )
        
        return response.user
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> Session {
        let session = try await client.auth.signIn(
            email: email,
            password: password
        )
        
        return session
    }
    
    // MARK: - Sign Out
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    // MARK: - Get Current User
    func getCurrentUser() async throws -> User? {
        let session = try await client.auth.session
        return session.user
    }
    
    // MARK: - Check if User is Signed In
    var isUserSignedIn: Bool {
        get async {
            do {
                let session = try await client.auth.session
                return session.user != nil
            } catch {
                return false
            }
        }
    }
    
    // MARK: - Password Reset
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
    }
    
    // MARK: - Update Password
    func updatePassword(newPassword: String) async throws {
        try await client.auth.update(
            user: UserAttributes(password: newPassword)
        )
    }
}

// MARK: - Auth Errors
enum AuthError: LocalizedError {
    case userNotFound
    case invalidCredentials
    case emailAlreadyExists
    case weakPassword
    case networkError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found"
        case .invalidCredentials:
            return "Invalid email or password"
        case .emailAlreadyExists:
            return "Email already exists"
        case .weakPassword:
            return "Password is too weak"
        case .networkError:
            return "Network error. Please try again"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
