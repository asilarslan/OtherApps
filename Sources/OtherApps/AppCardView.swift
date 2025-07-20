import SwiftUI
import StoreKit

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public struct AppCardView: View {
    let app: AppStoreApp
    let style: AppCardStyle
    let onTap: (() -> Void)?
    
    public init(app: AppStoreApp, style: AppCardStyle = .standard, onTap: (() -> Void)? = nil) {
        self.app = app
        self.style = style
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            onTap?() ?? openAppStore()
        }) {
            switch style {
            case .standard:
                standardCard
            case .compact:
                compactCard
            case .featured:
                featuredCard
            case .minimal:
                minimalCard
            case .list:
                listCard
            }
        }
        .buttonStyle(AppCardButtonStyle())
    }
    
    // MARK: - Card Styles
    
    private var standardCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                AppIconView(url: app.iconUrl, size: 60)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(app.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text(app.category)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        StarRatingView(rating: app.averageRating, size: 12)
                        
                        Text("(\(app.ratingCount.formatted()))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(app.formattedPrice)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("GET")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
            
            if !app.description.isEmpty {
                Text(app.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(16)
        .background(systemBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    private var compactCard: some View {
        VStack(spacing: 8) {
            // App icon at the top
            AppIconView(url: app.iconUrl, size: 50)
            
            // App info
            VStack(alignment: .center, spacing: 4) {
                Text(app.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Text(app.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                // Rating and price in a row
                HStack(spacing: 4) {
                    StarRatingView(rating: app.averageRating, size: 10)
                    
                    if app.price > 0 {
                        Text(app.formattedPrice)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                }
            }
            
            // Get button
            Button(action: {
                // Action handled by parent button
            }) {
                Text("GET")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            .disabled(true) // Parent button handles the action
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(secondarySystemBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var featuredCard: some View {
        VStack(spacing: 0) {
            // Header with gradient
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 120)
                
                HStack(alignment: .bottom, spacing: 12) {
                    AppIconView(url: app.iconUrl, size: 70)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(app.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Text(app.category)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        HStack(spacing: 4) {
                            StarRatingView(rating: app.averageRating, size: 12, color: .white)
                            
                            Text("(\(app.ratingCount.formatted()))")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    Spacer()
                }
                .padding(16)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                if !app.description.isEmpty {
                    Text(app.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
                
                HStack {
                    Text(app.formattedPrice)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("GET")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
            .padding(16)
        }
        .background(systemBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
    }
    
    private var minimalCard: some View {
        HStack(spacing: 12) {
            AppIconView(url: app.iconUrl, size: 35)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(shortAppStoreUrl)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.clear)
    }
    
    private var shortAppStoreUrl: String {
        // Extract short URL from full App Store URL
        if let url = URL(string: app.appStoreUrl),
           let host = url.host {
            return "\(host)\(url.path)"
        }
        return app.appStoreUrl
    }
    
    private var listCard: some View {
        HStack(spacing: 12) {
            AppIconView(url: app.iconUrl, size: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(app.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(app.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    StarRatingView(rating: app.averageRating, size: 10)
                    
                    if app.price > 0 {
                        Text(app.formattedPrice)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                // Action handled by parent button
            }) {
                Text("GET")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            .disabled(true) // Parent button handles the action
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .frame(height: 60) // Fixed height for consistent list
        .background(secondarySystemBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Platform-specific Colors
    
    private var systemBackgroundColor: Color {
        #if canImport(UIKit)
        return Color(UIColor.systemBackground)
        #else
        return Color(NSColor.controlBackgroundColor)
        #endif
    }
    
    private var secondarySystemBackgroundColor: Color {
        #if canImport(UIKit)
        return Color(UIColor.secondarySystemBackground)
        #else
        return Color(NSColor.controlColor)
        #endif
    }
    
    private var systemGray5Color: Color {
        #if canImport(UIKit)
        return Color(UIColor.systemGray5)
        #else
        return Color(NSColor.controlColor)
        #endif
    }
    
    private var systemGray3Color: Color {
        #if canImport(UIKit)
        return Color(UIColor.systemGray3)
        #else
        return Color(NSColor.tertiaryLabelColor)
        #endif
    }
    
    // MARK: - Actions
    
    private func openAppStore() {
        #if canImport(UIKit)
        // Extract app identifier from URL
        let appIdentifier = extractAppIdentifier(from: app.appStoreUrl)
        
        if let appId = appIdentifier {
            // Use SKOverlay for in-app presentation
            showAppStoreOverlay(appIdentifier: appId)
        } else {
            // Fallback to external App Store
            openExternalAppStore()
        }
        #elseif canImport(AppKit)
        // macOS doesn't support SKOverlay, use external App Store
        openExternalAppStore()
        #endif
    }
    
    private func extractAppIdentifier(from urlString: String) -> String? {
        // Extract app ID from various URL formats
        let patterns = [
            "id(\\d+)",           // id123456789
            "app/([^/]+)",        // app/app-name
            "\\/(\\d+)$"          // /123456789
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: urlString, range: NSRange(urlString.startIndex..., in: urlString)) {
                let range = Range(match.range(at: 1), in: urlString)!
                return String(urlString[range])
            }
        }
        
        return nil
    }
    
    private func showAppStoreOverlay(appIdentifier: String) {
        #if canImport(UIKit)
        if #available(iOS 14.0, *) {
            let config = SKOverlay.AppConfiguration(appIdentifier: appIdentifier, position: .bottom)
            let overlay = SKOverlay(configuration: config)
            
            // Find the window scene to present the overlay
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                overlay.present(in: windowScene)
            }
        } else {
            // Fallback for iOS < 14.0
            openExternalAppStore()
        }
        #endif
    }
    
    private func openExternalAppStore() {
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
}

// MARK: - App Card Style

public enum AppCardStyle {
    case standard
    case compact
    case featured
    case minimal
    case list
}

// MARK: - Supporting Views

struct AppIconView: View {
    let url: String
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            RoundedRectangle(cornerRadius: size * 0.2)
                .fill(placeholderBackgroundColor)
                .overlay(
                    Image(systemName: "app")
                        .foregroundColor(placeholderForegroundColor)
                        .font(.system(size: size * 0.4))
                )
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.2))
    }
    
    private var placeholderBackgroundColor: Color {
        #if canImport(UIKit)
        return Color(UIColor.systemGray5)
        #else
        return Color(NSColor.controlColor)
        #endif
    }
    
    private var placeholderForegroundColor: Color {
        #if canImport(UIKit)
        return Color(UIColor.systemGray3)
        #else
        return Color(NSColor.tertiaryLabelColor)
        #endif
    }
}

struct StarRatingView: View {
    let rating: Double
    let size: CGFloat
    let color: Color
    
    init(rating: Double, size: CGFloat = 12, color: Color = .yellow) {
        self.rating = rating
        self.size = size
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: starType(for: index))
                    .font(.system(size: size))
                    .foregroundColor(color)
            }
        }
    }
    
    private func starType(for index: Int) -> String {
        let threshold = Double(index + 1)
        if rating >= threshold {
            return "star.fill"
        } else if rating > threshold - 1.0 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}

// MARK: - Button Style

struct AppCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
} 