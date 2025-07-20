import Foundation
import Combine

@MainActor
public class AppStoreService: ObservableObject {
    public static let shared = AppStoreService()
    
    @Published public var isLoading = false
    @Published public var loadingProgress = 0.0
    
    private let urlSession: URLSession
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = URLCache(memoryCapacity: 50_000_000, diskCapacity: 100_000_000, diskPath: nil)
        self.urlSession = URLSession(configuration: config)
    }
    
    // MARK: - Public Methods
    
    /// Fetches app information for multiple App Store URLs
    public func fetchApps(from configuration: AppsConfiguration) async throws -> [AppStoreApp] {
        isLoading = true
        loadingProgress = 0.0
        
        defer {
            isLoading = false
            loadingProgress = 1.0
        }
        
        let total = configuration.apps.count
        var apps: [AppStoreApp] = []
        
        for (index, appConfig) in configuration.apps.enumerated() {
            do {
                let app = try await fetchApp(from: appConfig.appStoreUrl)
                apps.append(app)
            } catch {
                print("Failed to fetch app from \(appConfig.appStoreUrl): \(error)")
            }
            
            loadingProgress = Double(index + 1) / Double(total)
        }
        
        return apps
    }
    
    /// Fetches app information for multiple App Store URLs from JSON URL
    public func fetchApps(from jsonUrl: String) async throws -> [AppStoreApp] {
        let configuration = try await fetchConfiguration(from: jsonUrl)
        return try await fetchApps(from: configuration)
    }
    
    /// Fetches configuration from a JSON URL
    public func fetchConfiguration(from jsonUrl: String) async throws -> AppsConfiguration {
        guard let url = URL(string: jsonUrl) else {
            throw AppStoreServiceError.invalidURL
        }
        
        let (data, _) = try await urlSession.data(from: url)
        return try JSONDecoder().decode(AppsConfiguration.self, from: data)
    }
    
    /// Fetches a single app from App Store URL
    public func fetchApp(from appStoreUrl: String) async throws -> AppStoreApp {
        let appId = try extractAppId(from: appStoreUrl)
        return try await fetchApp(by: appId)
    }
    
    /// Fetches app by App Store ID
    public func fetchApp(by appId: String) async throws -> AppStoreApp {
        let urlString = "https://itunes.apple.com/lookup?id=\(appId)"
        guard let url = URL(string: urlString) else {
            throw AppStoreServiceError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AppStoreServiceError.invalidResponse
        }
        
        let iTunesResponse = try JSONDecoder().decode(iTunesResponse.self, from: data)
        
        guard let app = iTunesResponse.results.first else {
            throw AppStoreServiceError.appNotFound
        }
        
        return app
    }
    
    // MARK: - Private Methods
    
    private func extractAppId(from appStoreUrl: String) throws -> String {
        // Handle different App Store URL formats
        // https://apps.apple.com/us/app/cartoonify-me/id6747951776
        // https://itunes.apple.com/app/id6747951776
        // https://apps.apple.com/app/id6747951776
        
        guard let url = URL(string: appStoreUrl) else {
            throw AppStoreServiceError.invalidURL
        }
        
        let urlString = url.absoluteString
        
        // Extract ID using regex
        let patterns = [
            "id(\\d+)",  // Most common: id followed by digits
            "/id(\\d+)", // With slash
            "id=(\\d+)"  // With equals sign
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []),
               let match = regex.firstMatch(in: urlString, options: [], range: NSRange(location: 0, length: urlString.count)) {
                let range = match.range(at: 1)
                if let swiftRange = Range(range, in: urlString) {
                    return String(urlString[swiftRange])
                }
            }
        }
        
        throw AppStoreServiceError.invalidAppStoreURL
    }
}

// MARK: - Service Errors

public enum AppStoreServiceError: LocalizedError {
    case invalidURL
    case invalidAppStoreURL
    case invalidResponse
    case appNotFound
    case networkError(Error)
    case decodingError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .invalidAppStoreURL:
            return "Invalid App Store URL format"
        case .invalidResponse:
            return "Invalid response from App Store"
        case .appNotFound:
            return "App not found in App Store"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Convenience Extensions

public extension AppStoreService {
    /// Creates a sample configuration for testing
    static func sampleConfiguration() -> AppsConfiguration {
        return AppsConfiguration(
            apps: [
                AppConfig(
                    appStoreUrl: "https://apps.apple.com/us/app/cartoonify-me/id6747951776",
                    customTitle: nil,
                    customDescription: nil,
                    featured: true
                ),
                AppConfig(
                    appStoreUrl: "https://apps.apple.com/us/app/instagram/id389801252",
                    customTitle: nil,
                    customDescription: nil,
                    featured: false
                )
            ],
            title: "My Other Apps",
            subtitle: "Check out my other creations!"
        )
    }
} 