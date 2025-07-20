import Foundation

// MARK: - App Store App Model
public struct AppStoreApp: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let iconUrl: String
    public let appStoreUrl: String
    public let price: Double
    public let formattedPrice: String
    public let category: String
    public let averageRating: Double
    public let ratingCount: Int
    public let version: String
    public let releaseDate: Date
    public let bundleId: String
    
    // MARK: - Public Initializer
    public init(
        id: String,
        name: String,
        description: String,
        iconUrl: String,
        appStoreUrl: String,
        price: Double,
        formattedPrice: String,
        category: String,
        averageRating: Double,
        ratingCount: Int,
        version: String,
        releaseDate: Date,
        bundleId: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconUrl = iconUrl
        self.appStoreUrl = appStoreUrl
        self.price = price
        self.formattedPrice = formattedPrice
        self.category = category
        self.averageRating = averageRating
        self.ratingCount = ratingCount
        self.version = version
        self.releaseDate = releaseDate
        self.bundleId = bundleId
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case name = "trackName"
        case description = "description"
        case iconUrl = "artworkUrl512"
        case appStoreUrl = "trackViewUrl"
        case price = "price"
        case formattedPrice = "formattedPrice"
        case category = "primaryGenreName"
        case averageRating = "averageUserRating"
        case ratingCount = "userRatingCount"
        case version = "version"
        case releaseDate = "releaseDate"
        case bundleId = "bundleId"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle both String and Int for trackId
        if let idInt = try? container.decode(Int.self, forKey: .id) {
            self.id = String(idInt)
        } else {
            self.id = try container.decode(String.self, forKey: .id)
        }
        
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.iconUrl = try container.decode(String.self, forKey: .iconUrl)
        self.appStoreUrl = try container.decode(String.self, forKey: .appStoreUrl)
        self.price = try container.decodeIfPresent(Double.self, forKey: .price) ?? 0.0
        self.formattedPrice = try container.decodeIfPresent(String.self, forKey: .formattedPrice) ?? "Free"
        self.category = try container.decodeIfPresent(String.self, forKey: .category) ?? "Unknown"
        self.averageRating = try container.decodeIfPresent(Double.self, forKey: .averageRating) ?? 0.0
        self.ratingCount = try container.decodeIfPresent(Int.self, forKey: .ratingCount) ?? 0
        self.version = try container.decodeIfPresent(String.self, forKey: .version) ?? "1.0"
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId) ?? ""
        
        // Parse release date
        let dateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        let formatter = ISO8601DateFormatter()
        self.releaseDate = formatter.date(from: dateString) ?? Date()
    }
}

// MARK: - iTunes API Response
struct iTunesResponse: Codable {
    let resultCount: Int
    let results: [AppStoreApp]
}

// MARK: - JSON Configuration for Website
public struct AppConfig: Codable, Identifiable {
    public let id = UUID()
    public let appStoreUrl: String
    public let customTitle: String?
    public let customDescription: String?
    public let featured: Bool
    
    enum CodingKeys: String, CodingKey {
        case appStoreUrl = "url"
        case customTitle = "title"
        case customDescription = "description" 
        case featured = "featured"
    }
    
    public init(appStoreUrl: String, customTitle: String? = nil, customDescription: String? = nil, featured: Bool = false) {
        self.appStoreUrl = appStoreUrl
        self.customTitle = customTitle
        self.customDescription = customDescription
        self.featured = featured
    }
}

// MARK: - Apps Configuration
public struct AppsConfiguration: Codable {
    public let apps: [AppConfig]
    public let title: String
    public let subtitle: String?
    
    public init(apps: [AppConfig], title: String = "Other Apps", subtitle: String? = nil) {
        self.apps = apps
        self.title = title
        self.subtitle = subtitle
    }
} 