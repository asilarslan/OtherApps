import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public struct OtherAppsView: View {
    // MARK: - Properties
    
    @StateObject private var service = AppStoreService.shared
    @State private var apps: [AppStoreApp] = []
    @State private var isLoading = false
    @State private var error: Error?
    
    private let configuration: AppsConfiguration?
    private let jsonUrl: String?
    private let layout: OtherAppsLayout
    private let onAppTap: ((AppStoreApp) -> Void)?
    
    // MARK: - Initializers
    
    /// Initialize with a configuration object
    public init(
        configuration: AppsConfiguration,
        layout: OtherAppsLayout = .grid,
        onAppTap: ((AppStoreApp) -> Void)? = nil
    ) {
        self.configuration = configuration
        self.jsonUrl = nil
        self.layout = layout
        self.onAppTap = onAppTap
    }
    
    /// Initialize with a JSON URL
    public init(
        jsonUrl: String,
        layout: OtherAppsLayout = .grid,
        onAppTap: ((AppStoreApp) -> Void)? = nil
    ) {
        self.configuration = nil
        self.jsonUrl = jsonUrl
        self.layout = layout
        self.onAppTap = onAppTap
    }
    
    /// Initialize with App Store URLs
    public init(
        appStoreUrls: [String],
        title: String = "Other Apps",
        subtitle: String? = nil,
        layout: OtherAppsLayout = .grid,
        onAppTap: ((AppStoreApp) -> Void)? = nil
    ) {
        let appConfigs = appStoreUrls.map { AppConfig(appStoreUrl: $0) }
        self.configuration = AppsConfiguration(apps: appConfigs, title: title, subtitle: subtitle)
        self.jsonUrl = nil
        self.layout = layout
        self.onAppTap = onAppTap
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if isLoading {
                loadingView
            } else if let error = error {
                errorView(error)
            } else if apps.isEmpty {
                emptyStateView
            } else {
                contentView
            }
        }
        .task {
            await loadApps()
        }
    }
    
    // MARK: - Views
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Loading apps...")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if service.loadingProgress > 0 {
                ProgressView(value: service.loadingProgress)
                    .frame(width: 200)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(systemGroupedBackgroundColor)
    }
    
    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.orange)
            
            Text("Failed to load apps")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Try Again") {
                Task {
                    await loadApps()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(systemGroupedBackgroundColor)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "app.badge")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text("No apps available")
                .font(.headline)
            
            Text("Check back later for new apps")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(systemGroupedBackgroundColor)
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if let config = configuration {
                    headerView(config)
                }
                
                switch layout {
                case .list:
                    listLayout
                case .grid:
                    gridLayout
                case .carousel:
                    carouselLayout
                case .featured:
                    featuredLayout
                case .minimal:
                    minimalLayout
                }
            }
        }
        .background(systemGroupedBackgroundColor)
    }
    
    private func headerView(_ config: AppsConfiguration) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(config.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            if let subtitle = config.subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    // MARK: - Layout Styles
    
    private var listLayout: some View {
        LazyVStack(spacing: 12) {
            ForEach(apps) { app in
                AppCardView(
                    app: app,
                    style: .list,
                    onTap: { handleAppTap(app) }
                )
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 16)
    }
    
    private var gridLayout: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            ForEach(apps) { app in
                AppCardView(
                    app: app,
                    style: .compact,
                    onTap: { handleAppTap(app) }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    private var carouselLayout: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(apps) { app in
                    AppCardView(
                        app: app,
                        style: .compact,
                        onTap: { handleAppTap(app) }
                    )
                    .frame(width: 160)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
        .padding(.bottom, 16)
    }
    
    private var featuredLayout: some View {
        LazyVStack(spacing: 16) {
            // Featured app (first one)
            if let featuredApp = apps.first {
                AppCardView(
                    app: featuredApp,
                    style: .featured,
                    onTap: { handleAppTap(featuredApp) }
                )
                .padding(.horizontal, 16)
            }
            
            // Other apps in compact style
            if apps.count > 1 {
                LazyVGrid(columns: gridColumns, spacing: 12) {
                    ForEach(Array(apps.dropFirst())) { app in
                        AppCardView(
                            app: app,
                            style: .compact,
                            onTap: { handleAppTap(app) }
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 16)
    }
    
    private var minimalLayout: some View {
        LazyVStack(spacing: 0) {
            ForEach(apps) { app in
                AppCardView(
                    app: app,
                    style: .minimal,
                    onTap: { handleAppTap(app) }
                )
                .padding(.horizontal, 16)
                
                // Add separator line between items
                if app.id != apps.last?.id {
                    Divider()
                        .padding(.horizontal, 16)
                }
            }
        }
        .padding(.bottom, 16)
    }
    
    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]
    }
    
    // MARK: - Platform-specific Colors
    
    private var systemGroupedBackgroundColor: Color {
        #if canImport(UIKit)
        return Color(UIColor.systemGroupedBackground)
        #else
        return Color(NSColor.controlBackgroundColor)
        #endif
    }
    
    // MARK: - Actions
    
    private func handleAppTap(_ app: AppStoreApp) {
        if let onAppTap = onAppTap {
            // Custom callback provided, use it
            onAppTap(app)
        } else {
            // No custom callback, open App Store directly
            openAppStore(for: app)
        }
    }
    
    private func openAppStore(for app: AppStoreApp) {
        #if canImport(UIKit)
        print("🔍 Attempting to open App Store for: \(app.name)")
        print("🔗 App Store URL: \(app.appStoreUrl)")
        
        // Extract app identifier from URL
        let appIdentifier = extractAppIdentifier(from: app.appStoreUrl)
        print("🆔 Extracted App ID: \(appIdentifier ?? "nil")")
        
        if let appId = appIdentifier {
            // Use itms-apps:// URL scheme for reliable App Store opening
            print("📱 Using itms-apps:// for app ID: \(appId)")
            openAppStoreWithScheme(appId: appId)
        } else {
            // Fallback to external App Store
            print("🌐 Falling back to external App Store")
            openExternalAppStore(for: app)
        }
        #elseif canImport(AppKit)
        // macOS doesn't support itms-apps://, use external App Store
        openExternalAppStore(for: app)
        #endif
    }
    
    private func extractAppIdentifier(from urlString: String) -> String? {
        print("🔍 Parsing URL: \(urlString)")
        
        // Simple pattern: look for /id followed by numbers
        if let range = urlString.range(of: "/id") {
            let afterId = String(urlString[range.upperBound...])
            print("🔍 After /id: \(afterId)")
            
            // Extract numbers after /id
            let numbers = afterId.prefix(while: { $0.isNumber })
            if !numbers.isEmpty {
                let appId = String(numbers)
                print("✅ Extracted App ID: \(appId)")
                return appId
            }
        }
        
        print("❌ No app ID pattern matched for URL: \(urlString)")
        return nil
    }
    
    private func openAppStoreWithScheme(appId: String) {
        #if canImport(UIKit)
        // Try SKOverlay first (iOS 14+)
        if #available(iOS 14.0, *) {
            print("📱 iOS 14+ detected, attempting SKOverlay")
            
            let config = SKOverlay.AppConfiguration(appIdentifier: appId, position: .bottom)
            let overlay = SKOverlay(configuration: config)
            
            // Find the window scene to present the overlay
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                print("✅ Window scene found, presenting SKOverlay for app: \(appId)")
                overlay.present(in: windowScene)
                return
            } else {
                print("❌ No window scene found, falling back to itms-apps://")
            }
        }
        
        // Fallback to itms-apps:// URL scheme
        let appStoreUrl = "itms-apps://itunes.apple.com/app/id\(appId)"
        print("🔗 Opening: \(appStoreUrl)")
        
        if let url = URL(string: appStoreUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                        print("✅ Successfully opened App Store for app ID: \(appId)")
                    } else {
                        print("❌ Failed to open App Store, trying external URL")
                    }
                }
            } else {
                let success = UIApplication.shared.openURL(url)
                if !success {
                    print("❌ Failed to open App Store")
                }
            }
        } else {
            print("❌ Invalid itms-apps:// URL")
        }
        #endif
    }
    
    private func openExternalAppStore(for app: AppStoreApp) {
        #if canImport(UIKit)
        guard let url = URL(string: app.appStoreUrl) else { 
            print("Invalid App Store URL: \(app.appStoreUrl)")
            return 
        }
        
        print("Opening external App Store URL: \(url)")
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    print("Failed to open App Store URL: \(url)")
                }
            }
        } else {
            let success = UIApplication.shared.openURL(url)
            if !success {
                print("Failed to open App Store URL: \(url)")
            }
        }
        #elseif canImport(AppKit)
        guard let url = URL(string: app.appStoreUrl) else { 
            print("Invalid App Store URL: \(app.appStoreUrl)")
            return 
        }
        
        print("Opening external App Store URL: \(url)")
        NSWorkspace.shared.open(url)
        #endif
    }
    
    private func loadApps() async {
        isLoading = true
        error = nil
        
        do {
            if let jsonUrl = jsonUrl {
                apps = try await service.fetchApps(from: jsonUrl)
            } else if let configuration = configuration {
                apps = try await service.fetchApps(from: configuration)
            }
        } catch {
            self.error = error
            print("Failed to load apps: \(error)")
        }
        
        isLoading = false
    }
}

// MARK: - Layout Types

public enum OtherAppsLayout {
    case list       // Vertical list with full-width cards
    case grid       // 2-column grid with compact cards
    case carousel   // Horizontal scrolling carousel
    case featured   // Featured first app + grid of others
    case minimal    // Minimal card style for a more compact look
}

// MARK: - Convenience Views

public extension OtherAppsView {
    /// Quick setup for common use case - just provide App Store URLs
    static func withUrls(
        _ urls: [String],
        title: String = "Other Apps",
        layout: OtherAppsLayout = .grid
    ) -> OtherAppsView {
        OtherAppsView(
            appStoreUrls: urls,
            title: title,
            layout: layout
        )
    }
    
    /// Quick setup for JSON URL
    static func withJsonUrl(
        _ url: String,
        layout: OtherAppsLayout = .grid
    ) -> OtherAppsView {
        OtherAppsView(
            jsonUrl: url,
            layout: layout
        )
    }
} 