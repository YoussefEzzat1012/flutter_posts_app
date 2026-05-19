# Flutter Posts App

A clean, feature-based Flutter application demonstrating modern mobile development practices including state management (BLoC), REST API integration, local storage caching, and offline support.

---

## Project Overview

This application is a simple posts management system that allows users to:

- **Browse** a list of posts fetched from a public API
- **View** detailed information for each post
- **Search** posts by title or content in real-time
- **Create** new posts with form validation
- **Work offline** with cached data loading automatically when internet is unavailable

The project follows **Feature-Based Modular Architecture** where each feature (authentication, posts) is self-contained with its own data, business logic, and presentation layers. This structure ensures scalability, maintainability, and independent testability of each module.

---

## Architecture

The project uses a **simple feature-based structure** where each feature is organized as an independent module:

```
lib/
├── core/                    # Shared code (theme, widgets, services)
│   ├── constants/           # App constants & API endpoints
│   ├── theme/               # Light & dark Material 3 themes
│   ├── utils/               # Extension methods & helpers
│   ├── services/            # API, local storage, connectivity
│   └── widgets/             # Reusable UI components
└── features/                # Feature modules
    ├── splash/
    ├── auth/                # Authentication feature
    │   ├── data/
    │   │   ├── models/      # User data structure
    │   │   └── repositories/# Data operations
    │   └── presentation/
    │       ├── bloc/        # BLoC state management
    │       └── screens/     # UI screens
    └── posts/               # Posts feature
        ├── data/
        │   ├── models/      # Post data structure
        │   └── repositories/# Data operations
        └── presentation/
            ├── bloc/        # BLoC state management
            ├── screens/     # List, detail, create
            └── widgets/     # Post card component
```

**Why Feature-Based?**

Each feature encapsulates its own data layer (models, repositories), business logic layer (BLoC), and presentation layer (screens, widgets). This separation ensures that adding new features does not require modifying existing code, multiple developers can work on different features simultaneously without conflicts, and each feature can be tested independently. The core layer provides shared utilities that remain reusable across all features.

---

## How to Run

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter_posts_app.git
   cd flutter_posts_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build APK

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

### Build iOS (macOS only)

```bash
flutter build ios --release
```

---

## Libraries Used

| Library | Purpose |
|---------|---------|
| `flutter_bloc` | State management using BLoC pattern for predictable, testable business logic |
| `bloc` | Core BLoC library providing the event-state mechanism |
| `equatable` | Value equality for states and events to prevent unnecessary UI rebuilds |
| `http` | Lightweight HTTP client for REST API calls to JSONPlaceholder |
| `shared_preferences` | Simple local key-value storage for caching posts and user sessions |
| `connectivity_plus` | Network state detection to enable offline-first data decisions |
| `cupertino_icons` | iOS-style icon assets for cross-platform consistency |

---

## API Endpoints (JSONPlaceholder)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/posts` | Fetch all posts |
| GET | `/posts/{id}` | Fetch single post |
| POST | `/posts` | Create new post |
| GET | `/users/1` | Mock login (fetch user data) |

---

## State Management Flow

```
UI Event → BLoC Event → Repository → API/Cache → BLoC State → UI Update
```

Example: Creating a Post
1. User taps "Publish" → `CreatePost` event dispatched
2. `PostsBloc` calls `PostRepository.createPost()`
3. Repository checks connectivity:
   - **Online**: POST to API, then cache result
   - **Offline**: Save to local cache with generated ID
4. `PostCreated` state emitted → UI shows success & navigates back
5. `LoadPosts` triggered → List refreshes with new post

---

## Offline Behavior

- **Posts List**: Loads from cache if no internet. Shows cached posts with pull-to-refresh to retry.
- **Post Detail**: Falls back to cached post if API fails or offline.
- **Create Post**: Saves locally when offline, appears in list immediately. Will sync when online (future enhancement).
- **Login**: Works offline with fallback user creation.

---

## Features

- **Splash Screen** - Animated app launch with fade/scale transitions
- **Authentication** - Mock login with offline fallback
- **Posts List** - Browse all posts with pull-to-refresh
- **Post Details** - View individual post with full content
- **Create Post** - Add new posts with form validation
- **Search** - Real-time filtering through posts
- **Offline Support** - Cached posts load without internet
- **Dark Mode** - Automatic system theme detection
- **Responsive UI** - Adapts to phones and tablets

---

## Testing

Run widget tests:
```bash
flutter test
```

---

## License

MIT License - feel free to use this as a starter template for your Flutter projects.
