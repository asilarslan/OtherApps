import SwiftUI

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
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    private var compactCard: some View {
        HStack(spacing: 12) {
            AppIconView(url: app.iconUrl, size: 45)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(app.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            StarRatingView(rating: app.averageRating, size: 10)
        }
        .padding(12)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
    }
    
    private var minimalCard: some View {
        HStack(spacing: 8) {
            AppIconView(url: app.iconUrl, size: 30)
            
            Text(app.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(8)
    }
    
    // MARK: - Actions
    
    private func openAppStore() {
        if let url = URL(string: app.appStoreUrl) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - App Card Style

public enum AppCardStyle {
    case standard
    case compact
    case featured
    case minimal
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
                .fill(Color(UIColor.systemGray5))
                .overlay(
                    Image(systemName: "app")
                        .foregroundColor(Color(UIColor.systemGray3))
                        .font(.system(size: size * 0.4))
                )
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.2))
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

// MARK: - Previews

struct AppCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleApp = AppStoreApp(
            id: "123456",
            name: "Cartoonify Me",
            description: "Transform your photos into amazing cartoons with AI technology. Easy to use, professional results.",
            iconUrl: "https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/example.jpg/512x512bb.jpg",
            appStoreUrl: "https://apps.apple.com/us/app/cartoonify-me/id6747951776",
            price: 0.0,
            formattedPrice: "Free",
            category: "Photo & Video",
            averageRating: 4.5,
            ratingCount: 1250,
            version: "1.0",
            releaseDate: Date(),
            bundleId: "com.example.cartoonify"
        )
        
        VStack(spacing: 16) {
            AppCardView(app: sampleApp, style: .featured)
            AppCardView(app: sampleApp, style: .standard)
            AppCardView(app: sampleApp, style: .compact)
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
    }
} 