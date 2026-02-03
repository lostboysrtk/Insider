// SupabaseConfig.swift
// Supabase Configuration and Connection Manager

import Foundation

/// Supabase Configuration
/// Replace these with your actual Supabase project credentials
struct SupabaseConfig {
    // âš ï¸ IMPORTANT: Replace these with your actual Supabase credentials
    // Find these at: https://app.supabase.com/project/YOUR_PROJECT/settings/api
    static let projectURL = "https://edoumdymwuxndqtmcroz.supabase.co"
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVkb3VtZHltd3V4bmRxdG1jcm96Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk0MTM1ODIsImV4cCI6MjA4NDk4OTU4Mn0.iflIxFiS08HDvsKO_4Ew0h5XsWSvqN5P__kPigXsshA"
    
    // API Endpoints
    static let baseURL = "\(projectURL)/rest/v1"
    static let authURL = "\(projectURL)/auth/v1"
    
    // Table Names
    struct Tables {
        static let newsCards = "news_cards"
        static let userInteractions = "user_interactions"
        static let discussions = "discussions"
        static let comments = "comments"
    }
}

/// Network Response Handler
enum SupabaseError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case serverError(String)
    case unauthorized
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid Supabase URL"
        case .noData:
            return "No data received from Supabase"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        case .unauthorized:
            return "Unauthorized access to Supabase"
        case .notFound:
            return "Resource not found"
        }
    }
}

/// Base Supabase Service with common HTTP methods
class SupabaseService {
    
    // Singleton instance
    static let shared = SupabaseService()
    private init() {}
    
    // MARK: - Generic HTTP Methods
    
    /// Performs a GET request to Supabase
    func get<T: Decodable>(
        endpoint: String,
        queryParams: [String: String] = [:],
        completion: @escaping (Result<T, SupabaseError>) -> Void
    ) {
        var urlComponents = URLComponents(string: "\(SupabaseConfig.baseURL)/\(endpoint)")
        
        if !queryParams.isEmpty {
            urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        performRequest(request: request, completion: completion)
    }
    
    /// Performs a POST request to Supabase
    func post<T: Encodable, R: Decodable>(
        endpoint: String,
        body: T,
        completion: @escaping (Result<R, SupabaseError>) -> Void
    ) {
        guard let url = URL(string: "\(SupabaseConfig.baseURL)/\(endpoint)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        
        do {
            let encoder = JSONEncoder()
            // 🆕 ADD THIS LINE TO FIX THE ERROR
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(body)
        } catch {
            completion(.failure(.encodingError(error)))
            return
        }
        
        performRequest(request: request, completion: completion)
    }
    
    /// Performs a PATCH/UPDATE request to Supabase
    func update<T: Encodable, R: Decodable>(
        endpoint: String,
        body: T,
        queryParams: [String: String] = [:],
        completion: @escaping (Result<R, SupabaseError>) -> Void
    ) {
        var urlComponents = URLComponents(string: "\(SupabaseConfig.baseURL)/\(endpoint)")
        
        if !queryParams.isEmpty {
            urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(.encodingError(error)))
            return
        }
        
        performRequest(request: request, completion: completion)
    }
    
    /// Performs a DELETE request to Supabase
    func delete<R: Decodable>(
        endpoint: String,
        queryParams: [String: String] = [:],
        completion: @escaping (Result<R, SupabaseError>) -> Void
    ) {
        var urlComponents = URLComponents(string: "\(SupabaseConfig.baseURL)/\(endpoint)")
        
        if !queryParams.isEmpty {
            urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        
        performRequest(request: request, completion: completion)
    }
    
    // MARK: - Private Helper
    
    private func performRequest<T: Decodable>(
        request: URLRequest,
        completion: @escaping (Result<T, SupabaseError>) -> Void
    ) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Handle HTTP errors
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case 401:
                completion(.failure(.unauthorized))
            case 404:
                completion(.failure(.notFound))
            default:
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                completion(.failure(.serverError(errorMessage)))
            }
        }.resume()
    }
}
