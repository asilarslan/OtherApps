#if canImport(XCTest)
import XCTest
@testable import OtherApps

final class OtherAppsTests: XCTestCase {
    
    func testAppStoreAppInitialization() {
        let app = AppStoreApp(
            id: "123456789",
            name: "Test App",
            description: "Test description",
            iconUrl: "https://example.com/icon.png",
            appStoreUrl: "https://apps.apple.com/app/id123456789",
            price: 0.0,
            formattedPrice: "Free",
            category: "Productivity",
            averageRating: 4.5,
            ratingCount: 100,
            version: "1.0",
            releaseDate: Date(),
            bundleId: "com.test.app"
        )
        
        XCTAssertEqual(app.id, "123456789")
        XCTAssertEqual(app.name, "Test App")
        XCTAssertEqual(app.price, 0.0)
        XCTAssertEqual(app.averageRating, 4.5)
    }
    
    func testAppConfigInitialization() {
        let config = AppConfig(
            appStoreUrl: "https://apps.apple.com/app/id123456789",
            customTitle: "Custom Title",
            customDescription: "Custom Description",
            featured: true
        )
        
        XCTAssertEqual(config.appStoreUrl, "https://apps.apple.com/app/id123456789")
        XCTAssertEqual(config.customTitle, "Custom Title")
        XCTAssertTrue(config.featured)
    }
    
    func testAppsConfigurationInitialization() {
        let appConfig = AppConfig(appStoreUrl: "https://apps.apple.com/app/id123456789")
        let configuration = AppsConfiguration(
            apps: [appConfig],
            title: "My Apps",
            subtitle: "Check them out!"
        )
        
        XCTAssertEqual(configuration.apps.count, 1)
        XCTAssertEqual(configuration.title, "My Apps")
        XCTAssertEqual(configuration.subtitle, "Check them out!")
    }
    
    func testOtherAppsSampleConfiguration() {
        let sampleConfig = OtherApps.sampleConfiguration()
        
        XCTAssertEqual(sampleConfig.apps.count, 2)
        XCTAssertEqual(sampleConfig.title, "My Other Apps")
        XCTAssertNotNil(sampleConfig.subtitle)
        XCTAssertEqual(sampleConfig.apps[0].appStoreUrl, "https://apps.apple.com/us/app/cartoonify-me/id6747951776")
        XCTAssertTrue(sampleConfig.apps[0].featured)
    }
    
    func testAppStoreServiceErrorDescriptions() {
        let invalidURLError = AppStoreServiceError.invalidURL
        let appNotFoundError = AppStoreServiceError.appNotFound
        
        XCTAssertNotNil(invalidURLError.errorDescription)
        XCTAssertNotNil(appNotFoundError.errorDescription)
        XCTAssertEqual(invalidURLError.errorDescription, "Invalid URL provided")
        XCTAssertEqual(appNotFoundError.errorDescription, "App not found in App Store")
    }
    
    func testLibraryVersion() {
        XCTAssertEqual(OtherApps.version, "1.0.0")
    }
}
#endif 