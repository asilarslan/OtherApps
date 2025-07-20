//
//  DemoView.swift
//  Demo
//
//  Created by Asil Arslan on 20.07.2025.
//

import SwiftUI
import OtherApps

struct DemoView: View {
    @State private var selectedLayout: OtherAppsLayout = .grid
    @State private var showingLayoutPicker = false
    
    private let sampleUrls = [
        "https://apps.apple.com/us/app/cartoonify-me/id6747951776",
        "https://apps.apple.com/us/app/instagram/id389801252",
        "https://apps.apple.com/us/app/whatsapp-messenger/id310633997",
        "https://apps.apple.com/us/app/telegram-messenger/id686449807",
        "https://apps.apple.com/us/app/spotify-music-and-podcasts/id324684580"
    ]
    
    var body: some View {
        NavigationView {
            TabView {
                // Tab 1: Simple Usage
                NavigationView {
                    simpleUsageTab
                        .navigationTitle("Simple Usage")
                        .navigationBarTitleDisplayMode(.large)
                }
                .tabItem {
                    Label("Simple", systemImage: "apps.iphone")
                }
                
                // Tab 2: Layout Options
                NavigationView {
                    layoutOptionsTab
                        .navigationTitle("Layout Options")
                        .navigationBarTitleDisplayMode(.large)
                }
                .tabItem {
                    Label("Layouts", systemImage: "square.grid.2x2")
                }
                
                // Tab 3: JSON Demo
                NavigationView {
                    jsonDemoTab
                        .navigationTitle("JSON Demo")
                        .navigationBarTitleDisplayMode(.large)
                }
                .tabItem {
                    Label("JSON", systemImage: "doc.text")
                }
                
                // Tab 4: Advanced
                NavigationView {
                    advancedTab
                        .navigationTitle("Advanced")
                        .navigationBarTitleDisplayMode(.large)
                }
                .tabItem {
                    Label("Advanced", systemImage: "gearshape")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Tab Views
    
    private var simpleUsageTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Basic Usage Example")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Just provide App Store URLs and you're done!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Code Example
                CodeExampleView(
                    title: "Swift Code",
                    code: """
                    OtherAppsView.withUrls([
                        "https://apps.apple.com/us/app/cartoonify-me/id6747951776",
                        "https://apps.apple.com/us/app/instagram/id389801252",
                        "https://apps.apple.com/us/app/whatsapp-messenger/id310633997"
                    ])
                    """
                )
                
                // Live Example
                VStack(alignment: .leading, spacing: 12) {
                    Text("Live Preview")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    OtherApps.view(
                        urls: Array(sampleUrls.prefix(3)),
                        title: "My Apps",
                        layout: .grid
                    )
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private var layoutOptionsTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Layout Picker
                VStack(alignment: .leading, spacing: 12) {
                    Text("Choose Layout Style")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Picker("Layout", selection: $selectedLayout) {
                        Text("Grid").tag(OtherAppsLayout.grid)
                        Text("List").tag(OtherAppsLayout.list)
                        Text("Featured").tag(OtherAppsLayout.featured)
                        Text("Carousel").tag(OtherAppsLayout.carousel)
                        Text("Minimal").tag(OtherAppsLayout.minimal)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }
                
                // Layout Demo
                OtherApps.view(
                    urls: sampleUrls,
                    title: layoutTitle(for: selectedLayout),
                    layout: selectedLayout
                )
                
                // Layout Descriptions
                layoutDescriptionView(for: selectedLayout)
                    .padding(.horizontal)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private var jsonDemoTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("JSON Configuration")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Load apps dynamically from your website's JSON file")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // JSON Example
                CodeExampleView(
                    title: "JSON Structure",
                    code: """
                    {
                      "title": "My Other Apps",
                      "subtitle": "Check out my other creations!",
                      "apps": [
                        {
                          "url": "https://apps.apple.com/us/app/app/id123",
                          "featured": true
                        },
                        {
                          "url": "https://apps.apple.com/us/app/app2/id456",
                          "featured": false
                        }
                      ]
                    }
                    """
                )
                
                // Swift Code
                CodeExampleView(
                    title: "Swift Implementation",
                    code: """
                    OtherAppsView.withJsonUrl("https://yoursite.com/apps.json")
                    """
                )
                
                // Note about JSON
                InfoBoxView(
                    title: "Local JSON Demo",
                    message: "In a real app, you'd load from your website. Here we're using a local configuration for demo purposes.",
                    icon: "info.circle"
                )
                
                // Local Config Demo
                let localConfig = AppsConfiguration(
                    apps: sampleUrls.map { AppConfig(appStoreUrl: $0) },
                    title: "JSON Configuration Demo",
                    subtitle: "Loaded from configuration object"
                )
                
                OtherAppsView(configuration: localConfig, layout: .featured)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private var advancedTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Advanced Features")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Custom handlers, view modifiers, and more")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Custom Tap Handler
                VStack(alignment: .leading, spacing: 12) {
                    Text("Custom App Tap Handler")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    CodeExampleView(
                        title: "Custom Tap Action",
                        code: """
                        OtherAppsView(configuration: config) { app in
                            print("User tapped: \\(app.name)")
                            // Your custom action here
                            // Default: opens App Store
                        }
                        """
                    )
                    
                    OtherAppsView(
                        appStoreUrls: Array(sampleUrls.prefix(2)),
                        title: "Custom Tap Demo",
                        layout: .grid
                    ) { app in
                        print("Custom tap: \(app.name)")
                        // Still opens App Store after logging
                    }
                }
                
                // View Modifier
                VStack(alignment: .leading, spacing: 12) {
                    Text("As View Modifier")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    CodeExampleView(
                        title: "View Extension",
                        code: """
                        YourContentView()
                            .otherApps(urls: appUrls)
                        """
                    )
                    
                    // Demo with modifier
                    VStack(spacing: 20) {
                        Text("Your App Content")
                            .font(.title)
                            .padding(40)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .otherApps(
                        urls: Array(sampleUrls.prefix(2)),
                        title: "Added with Modifier",
                        layout: .grid
                    )
                }
                
                // Performance Notes
                InfoBoxView(
                    title: "Performance Features",
                    message: "• Smart image caching\n• Lazy loading\n• Memory efficient\n• Progress tracking",
                    icon: "speedometer"
                )
                
                // Feature List
                featuresListView
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // MARK: - Helper Views
    
    private func layoutTitle(for layout: OtherAppsLayout) -> String {
        switch layout {
        case .grid: return "Grid Layout Demo"
        case .list: return "List Layout Demo"
        case .featured: return "Featured Layout Demo"
        case .carousel: return "Carousel Layout Demo"
        case .minimal: return "Minimal Layout Demo"
        }
    }
    
    private func layoutDescriptionView(for layout: OtherAppsLayout) -> some View {
        Group {
            switch layout {
            case .grid:
                InfoBoxView(
                    title: "Grid Layout",
                    message: "Perfect for showcasing multiple apps in a compact 2-column grid. Great for space efficiency.",
                    icon: "square.grid.2x2"
                )
            case .list:
                InfoBoxView(
                    title: "List Layout",
                    message: "Detailed vertical cards with full descriptions. Best for fewer apps with more information.",
                    icon: "list.bullet"
                )
            case .featured:
                InfoBoxView(
                    title: "Featured Layout",
                    message: "Highlights the first app with a beautiful gradient header, others shown in grid below.",
                    icon: "star.fill"
                )
            case .carousel:
                InfoBoxView(
                    title: "Carousel Layout",
                    message: "Horizontal scrolling showcase. Perfect for highlighting apps in a fun, interactive way.",
                    icon: "arrow.left.and.right"
                )
            case .minimal:
                InfoBoxView(
                    title: "Minimal Layout",
                    message: "Ultra-clean, minimal design with just app icons and names. Perfect for settings screens or about pages.",
                    icon: "doc.text"
                )
            }
        }
    }
    
    private var featuresListView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Library Features")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                FeatureCardView(
                    icon: "globe",
                    title: "iTunes API",
                    description: "Fetches real app data"
                )
                
                FeatureCardView(
                    icon: "photo",
                    title: "Auto Icons",
                    description: "Downloads app icons"
                )
                
                FeatureCardView(
                    icon: "star.fill",
                    title: "Ratings",
                    description: "Shows app ratings"
                )
                
                FeatureCardView(
                    icon: "square.grid.2x2",
                    title: "5 Layouts",
                    description: "Multiple display styles"
                )
                
                FeatureCardView(
                    icon: "doc.text",
                    title: "JSON Config",
                    description: "Web-based setup"
                )
                
                FeatureCardView(
                    icon: "exclamationmark.triangle",
                    title: "Error Handling",
                    description: "Graceful failures"
                )
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Supporting Views

struct CodeExampleView: View {
    let title: String
    let code: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
    }
}

struct InfoBoxView: View {
    let title: String
    let message: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(message)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct FeatureCardView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}


#Preview {
    DemoView()
}
