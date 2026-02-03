import Foundation

// MARK: - Grok AI Models
struct GrokChatRequest: Codable {
    let messages: [GrokMessage]
    let model: String
    let temperature: Double
    let max_tokens: Int
}

struct GrokMessage: Codable {
    let role: String
    let content: String
}

struct GrokChatResponse: Codable {
    let choices: [GrokChoice]
}

struct GrokChoice: Codable {
    let message: GrokMessage
}

// MARK: - Summary Storage Model
struct NewsSummary: Codable {
    let articleIdentifier: String // Using title + source as unique ID
    let summary: String
    let timestamp: Date
}

// MARK: - Grok AI Service
class GrokAIService {
    static let shared = GrokAIService()
    private init() {}
    
    private let apiKey = ""
    private let baseURL = "https://api.x.ai/v1/chat/completions"
    
    // UserDefaults key for storing summaries
    private let summariesKey = "cached_news_summaries"
    
    // MARK: - Public Methods
    
    /// Get summary for a news article (checks cache first, then generates if needed)
    func getSummary(for newsItem: NewsItem, completion: @escaping (Result<String, Error>) -> Void) {
        
        // Create unique identifier using title + source
        let identifier = createIdentifier(for: newsItem)
        
        // 1. Check if we already have a cached summary
        if let cachedSummary = getCachedSummary(for: identifier) {
            print("📦 Using cached summary for: \(newsItem.title ?? "Unknown")")
            completion(.success(cachedSummary))
            return
        }
        
        // 2. Generate new summary
        print("🤖 Generating new summary for: \(newsItem.title ?? "Unknown")")
        generateSummary(for: newsItem, identifier: identifier, completion: completion)
    }
    
    // MARK: - Private Methods
    
    private func createIdentifier(for newsItem: NewsItem) -> String {
        // Use title + source as unique identifier
        let title = newsItem.title ?? ""
        let source = newsItem.source
        return "\(title)_\(source)".replacingOccurrences(of: " ", with: "_")
    }
    
    private func generateSummary(for newsItem: NewsItem, identifier: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "GrokAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Prepare the prompt with full article content
        let title = newsItem.title ?? "No title"
        let description = newsItem.description ?? "No description"
        
        // If article URL exists, we'll mention it for context
        let articleContext = newsItem.articleURL != nil ? "\nSource: \(newsItem.articleURL!)" : ""
        
        let prompt = """
        Summarize this tech news article in 2-3 clear, concise sentences. Focus on the key facts and what developers/tech professionals need to know:
        
        Title: \(title)
        
        Content: \(description)
        \(articleContext)
        
        Provide ONLY the summary, without any preamble or additional commentary.
        """
        
        let request = GrokChatRequest(
            messages: [
                GrokMessage(role: "user", content: prompt)
            ],
            model: "grok-beta",
            temperature: 0.7,
            max_tokens: 300
        )
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "GrokAI", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            // Debug: Print response
            if let responseString = String(data: data, encoding: .utf8) {
                print("🔍 Grok API Response: \(responseString)")
            }
            
            do {
                let grokResponse = try JSONDecoder().decode(GrokChatResponse.self, from: data)
                
                if let summary = grokResponse.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) {
                    // Cache the summary
                    self?.cacheSummary(summary, for: identifier)
                    completion(.success(summary))
                } else {
                    completion(.failure(NSError(domain: "GrokAI", code: -3, userInfo: [NSLocalizedDescriptionKey: "No summary in response"])))
                }
                
            } catch {
                print("❌ Decoding error: \(error)")
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    // MARK: - Cache Management
    
    private func getCachedSummary(for identifier: String) -> String? {
        let summaries = loadCachedSummaries()
        return summaries[identifier]?.summary
    }
    
    private func cacheSummary(_ summary: String, for identifier: String) {
        var summaries = loadCachedSummaries()
        summaries[identifier] = NewsSummary(
            articleIdentifier: identifier,
            summary: summary,
            timestamp: Date()
        )
        
        saveSummaries(summaries)
    }
    
    private func loadCachedSummaries() -> [String: NewsSummary] {
        guard let data = UserDefaults.standard.data(forKey: summariesKey),
              let summaries = try? JSONDecoder().decode([String: NewsSummary].self, from: data) else {
            return [:]
        }
        return summaries
    }
    
    private func saveSummaries(_ summaries: [String: NewsSummary]) {
        if let data = try? JSONEncoder().encode(summaries) {
            UserDefaults.standard.set(data, forKey: summariesKey)
        }
    }
    
    /// Clear all cached summaries
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: summariesKey)
        print("🗑️ Cleared all cached summaries")
    }
    
    /// Get cache statistics
    func getCacheInfo() -> (count: Int, oldestDate: Date?) {
        let summaries = loadCachedSummaries()
        let oldest = summaries.values.map { $0.timestamp }.min()
        return (summaries.count, oldest)
    }
}
