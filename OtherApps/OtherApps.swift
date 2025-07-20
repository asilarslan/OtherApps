import SwiftUI

// MARK: - Main Library Interface

/// OtherApps - A SwiftUI library for displaying your other apps from App Store
/// 
/// Features:
/// - Fetches app metadata from iTunes Search API
/// - Multiple layout options (grid, list, carousel, featured)
/// - Beautiful, modern UI design
/// - Support for JSON configuration files
/// - Automatic app icon and info loading
/// - Error handling and loading states
/// 
/// Example usage:
/// ```swift
/// // Simple usage with App Store URLs
/// OtherAppsView.withUrls([
///     "https://apps.apple.com/us/app/cartoonify-me/id6747951776",
///     "https://apps.apple.com/us/app/another-app/id123456789"
/// ])
/// 
/// // From JSON URL
/// OtherAppsView.withJsonUrl("https://your-website.com/apps.json")
/// 
/// // Custom configuration
/// OtherAppsView(
///     configuration: AppsConfiguration(...),
///     layout: .featured
/// )
/// ```

public struct OtherApps {
    /// Current version of the library
    public static let version = "1.0.0"
    
    /// Create a simple "Other Apps" view with URLs
    public static func view(
        urls: [String],
        title: String = "Other Apps",
        layout: OtherAppsLayout = .grid
    ) -> OtherAppsView {
        OtherAppsView.withUrls(urls, title: title, layout: layout)
    }
    
    /// Create a view from a JSON configuration URL
    public static func view(
        jsonUrl: String,
        layout: OtherAppsLayout = .grid
    ) -> OtherAppsView {
        OtherAppsView.withJsonUrl(jsonUrl, layout: layout)
    }
    
    /// Create a sample configuration for testing
    public static func sampleConfiguration() -> AppsConfiguration {
        AppStoreService.sampleConfiguration()
    }
}

// MARK: - Public Exports

// Re-export all public types for easy access
public typealias OtherAppsConfiguration = AppsConfiguration
public typealias OtherAppConfig = AppConfig  
public typealias OtherAppStoreApp = AppStoreApp
public typealias OtherAppStoreService = AppStoreService

// MARK: - SwiftUI View Extensions

public extension View {
    /// Add an "Other Apps" section to your view
    func otherApps(
        urls: [String],
        title: String = "Other Apps",
        layout: OtherAppsLayout = .grid
    ) -> some View {
        VStack(spacing: 0) {
            self
            OtherApps.view(urls: urls, title: title, layout: layout)
        }
    }
    
    /// Add an "Other Apps" section from JSON URL
    func otherApps(
        jsonUrl: String,
        layout: OtherAppsLayout = .grid
    ) -> some View {
        VStack(spacing: 0) {
            self
            OtherApps.view(jsonUrl: jsonUrl, layout: layout)
        }
    }
} 