# Insider - iOS News App

A modern iOS news application built with Swift and UIKit, featuring multiple news categories, discussions, audio features, and user profiles.

## Features

- 📰 **Multiple News Categories**: Daily, Feed, Swift, and Web news
- 💬 **Discussion Forum**: Post and reply to discussions
- 🎧 **Audio News**: Listen to news articles with audio features
- 👤 **User Profiles**: Personalized user profiles with saved libraries
- 🔍 **Search Functionality**: Search through news articles
- 📱 **Modern UI**: Clean and intuitive interface with custom components
- 🔔 **Notifications**: Stay updated with push notifications
- 🔐 **Authentication**: Secure user authentication with Google Sign-In

## Tech Stack

- **Language**: Swift
- **UI Framework**: UIKit
- **Backend**: Supabase
- **Authentication**: AppAuth, GoogleSignIn, GTMAppAuth
- **Database**: Supabase (PostgreSQL)
- **Dependencies**: Swift Package Manager & CocoaPods

## Dependencies

### Swift Package Manager
- AppAuth (2.0.0)
- AppCheck (11.2.0)
- GoogleSignIn (9.0.0)
- GoogleUtilities (8.1.0)
- GTMAppAuth (5.0.0)
- GTMSessionFetcher (3.5.0)
- Promises (2.4.0)
- Supabase (2.40.0)
- swift-asn1 (1.5.1)

### CocoaPods
- Additional dependencies managed through Podfile

## Project Structure

```
Insiderfinal/
├── Assets/                    # App assets and images
├── Data/                      # Data models and API services
│   ├── ImageLoader
│   ├── NewsAPIService
│   └── NewsItem
├── DB/                        # Database models and persistence
│   ├── DatabaseModels
│   ├── IntegrationExamples
│   └── NewsPersistenceManager
├── Module/                    # Feature modules
│   ├── Discussions/          # Discussion forum
│   ├── Home/                 # Home feed and code snippets
│   ├── New Audio/            # Audio features
│   ├── Notification/         # Notifications
│   ├── Onboarding/           # User onboarding
│   ├── Profile/              # User profiles
│   └── Search/               # Search functionality
├── Supabase/                 # Supabase integration
├── functions/                # Edge functions
│   └── fetch-news/
├── config.toml               # Configuration file
├── SupabaseManager.swift     # Supabase manager
├── SceneDelegate.swift       # Scene lifecycle
├── AppDelegate.swift         # App lifecycle
└── Info.plist               # App configuration

```

## Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 16.0 or later
- CocoaPods installed
- Supabase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/Insiderfinal.git
   cd Insiderfinal
   ```

2. **Install dependencies**
   ```bash
   # Install CocoaPods dependencies
   pod install
   
   # Swift Package Manager dependencies are automatically resolved by Xcode
   ```

3. **Configure Supabase**
   - Create a Supabase project at [supabase.com](https://supabase.com)
   - Update your Supabase configuration in `SupabaseConfig.swift`
   - Run the SQL schema from `supabase_schema.sql`

4. **Configure Google Sign-In**
   - Create a project in Google Cloud Console
   - Download `GoogleService-Info.plist`
   - Add it to your project

5. **Open the workspace**
   ```bash
   open Insiderfinal.xcworkspace
   ```

6. **Build and run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## Configuration

### Supabase Setup
Create a `SupabaseConfig.swift` file (not included in repository for security):

```swift
struct SupabaseConfig {
    static let url = "YOUR_SUPABASE_URL"
    static let anonKey = "YOUR_SUPABASE_ANON_KEY"
}
```

### API Keys
All API keys and sensitive credentials should be stored securely and not committed to the repository.

## Features in Detail

### News Feed
- Multiple category tabs (Daily, Feed, Swift, Web)
- Pull-to-refresh functionality
- Infinite scroll pagination
- Card-based news layout

### Discussions
- Create and view discussion posts
- Reply to discussions
- Activity tracking
- Comment system

### Audio Features
- Audio news playback
- Playlist management
- Background audio support

### User Profile
- View and edit profile
- Saved library
- Account settings
- Help and support

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions or support, please open an issue on GitHub.

## Acknowledgments

- Supabase for backend infrastructure
- Google for authentication services
- All open-source contributors

---

**Note**: This is a personal project. Please ensure you configure all API keys and credentials before running the app.
