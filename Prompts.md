# SYE App Development Log: Conversation with Gemini

This document tracks the iterative development process of the SYE (Share Your Experience) app.

---

## Phase 1: Project Foundation & User Profiles

### 1.0 Initial Setup
**User:** Read `requirements.md` and familiarize yourself with the basic idea of this app.  
**Gemini:** Ready to begin implementation. Phase 1 focuses on creating user profiles and authentication.

**User:** Can you get rid of the old counter code? It's not necessary for this app.  
**Gemini:** Removed counter logic from `main.dart` and `widget_test.dart`. Simplified `MyHomePage` to a basic welcome screen.

### 1.1 User Authentication
**User:** Implement step 1.1. Don't jump ahead.  
**Gemini:** 
- Created `AuthService` for sign-in/up/out using Firebase Auth.
- Created `authProvider` using Riverpod to track user sessions.
- Standardized project directory structure.

### 1.2 User Model
**User:** Implement step 1.2.  
**Gemini:** 
- Integrated `freezed` and `json_serializable`.
- Created `UserModel` with fields for `uid`, `displayName`, `bio`, and `favoriteGenres`.
- Added unit tests for serialization and value equality.

### 1.3 User Collection (Firestore)
**User:** Implement Requirement 1.3.  
**Gemini:** 
- Created `UserService` for Firestore CRUD operations.
- Added `currentUserDataProvider` to reactively sync profile data.
- Added service tests with mocks.

### 1.4 Onboarding Screen
**User:** Implement Requirement 1.4.  
**Gemini:** 
- Created `StorageService` for local settings (onboarding status).
- Built `OnboardingScreen` UI with multi-select genre chips.
- Updated `main.dart` to initialize local storage.

### 1.5 Auth Wrapper & Navigation
**User:** Implement Requirement 1.5.  
**Gemini:** 
- Created `AuthWrapper` as the app's routing "brain."
- Implemented `LoginScreen` and `MainNavigation` placeholders.
- Added widget tests for all routing scenarios.

**User:** Implement Requirement 1.6 (Home Screen Navigation).  
**Gemini:** Built a modern bottom navigation bar with four hubs: Feed, Search, Library, and Profile.

---

## Phase 2: Book Tracking & Discovery

### 2.1 Book Search Service
**User:** Implement feature 2.1.  
**Gemini:** 
- Integrated Google Books API.
- Built a modern search UI with debouncing and error handling.
- Implemented the `BookCard` widget for results.

### 2.2 Top Favorites Showcase
**User:** Implement feature 2.2.  
**Gemini:** 
- Updated `UserModel` to store book IDs.
- Created `SelectFavoritesScreen` for searching and picking favorites.
- Integrated favorites showcase into the `ProfileScreen`.

**User:** Can you change it to top 3 favorite books instead of 5?  
**Gemini:** Updated limits and UI labels across the Profile and Selection screens to reflect a "Top 3" limit.

### 2.3 Personal Bookshelves
**User:** Implement feature 2.3.  
**Gemini:** 
- Created `LibraryBookModel` and `ReadingStatus` enum.
- Implemented `LibraryService` for Firestore sub-collections.
- Built `LibraryScreen` with a 3-tab layout (Reading, Want to Read, Finished).
- Added "Quick Add" popup menus to search results.

### 2.4 Reading Progress Updates
**User:** Implement feature 2.4.  
**Gemini:** 
- Added `currentPage` and `totalPages` to the library model.
- Created `ProgressUpdateModel` for history logging.
- Added progress bars and an `UpdateProgressDialog` to the Library UI.

### 2.5 Genre Recommendations
**User:** Implement feature 2.5.  
**Gemini:** 
- Added genre-based search logic to `BookService`.
- Replaced the Home placeholder with a functional `FeedScreen`.
- Implemented pull-to-refresh for personalized book suggestions.

---

## Phase 3: Social Interactions

### 3.1 Book Reviews & Ratings
**User:** Implement feature 3.1  
**Gemini:** 
- Created `ReviewModel` and `ReviewService` for Firestore review storage.
- Implemented `ReviewDialog` for a unified rating and text review experience.
- Transformed `FeedScreen` into a "Live Board" displaying global activities and reviews.
- Added automated activity posting when starting or finishing books.

### 3.1.1 Data Synchronization
**User:** Implement feature 3.1.1  
**Gemini:** 
- Linked `ReviewModel` and `ActivityModel` with cross-referencing IDs.
- Implemented atomic batch operations in `ReviewService` to ensure edits/deletions sync across both collections.
- Updated `ActivityNotifier` and `ReviewNotifier` to use these synchronized methods.
- Resolved Riverpod 3.0 compatibility by updating `StateProvider` imports to `legacy.dart`.

### 3.1.2 Activity History on Profile
**User:** Implement feature 3.1.2  
**Gemini:** 
- Extracted `ActivityCard` into a shared widget for consistent UI across the Feed and Profile.
- Added `userActivitiesProvider` to stream a specific user's actions.
- Updated `ProfileScreen` to display a chronological "Activity History" section.
- Verified functionality with a custom Firestore composite index.

### 3.1.3 Book Details Screen
**User:** Implement feature 3.1.3  
**Gemini:** 
- Created `BookDetailsScreen` to display full book descriptions and reader reviews.
- Added `singleBookProvider` for efficient individual book fetching.
- Enabled global navigation: tapping any book in the Feed, Search, or Library now opens its details.
- Gracefully handled Web CORS issues with an `errorBuilder` for book covers.

### 3.2 Live Activity Feed
**User:** Implement feature 3.2  
**Gemini:** Successfully built the chronological "Live Board" hub that displays real-time updates (starting books, progress, reviews) from all users.

### 3.3 Follow System
**User:** Implement feature 3.3
**Gemini:** 
- **Model Update:** Added `followerCount` and `followingCount` to `UserModel`.
- **Follow Service:** Created `FollowService` using Firestore atomic batches to manage relationships and sync counts.
- **State Management:** Implemented `isFollowingProvider` (stream) and `followActionProvider` (notifier) for real-time UI updates.
- **Profile UI:** Integrated follow stats and a dynamic "Follow/Unfollow" button on user profiles.
- **Verification:** Added `test/services/follow_service_test.dart` to ensure atomic consistency of follow operations.

### 3.4 User Discovery & Community Hub
**User:** There's no way for users to find each other. Can we add a community feature?
**Gemini:** 
- **Requirements Update:** Added Feature 3.4 (User Discovery) and updated the navigation structure to a 5-tab system.
- **Service Enhancement:** Added `searchUsers` to `UserService` for prefix-based display name searching.
- **State Management:** Created `userSearchProvider` to manage asynchronous search states and results.
- **Community UI:** Built `CommunityScreen` featuring a user search bar, results list with quick-follow actions, and seamless profile navigation.
- **Navigation:** Integrated the new "Community" hub into the main bottom navigation bar.
- **Unique Usernames:**
    - Updated `UserModel` to include a mandatory `username` field.
    - Enhanced `OnboardingScreen` to collect and validate unique usernames (at least 3 characters, alphanumeric/underscores).
    - Implemented real-time username availability checks in `UserService`.
    - Updated `CommunityScreen` and `ProfileScreen` to prominently display `@username` handles for easier identification.
    - **Profile Editing:** Enhanced `EditProfileScreen` to allow users to update their `displayName` and `username` with full validation and availability checks.
    - **Legacy Data Stability:** Added a default empty string for the `username` field in the model to prevent app crashes when reading older Firestore documents that lack this field.

## Phase 4: Advanced Experience Improvements (Post-MVP)

### 4.1 Advanced Search Logic
**User:** Improve the search experience to handle typos and partial matches gracefully.
**Gemini:** 
- **Algorithm Implementation:** Integrated the Sørensen–Dice coefficient algorithm into `BookService` for fuzzy string matching.
- **Search Optimization:** Increased API results pool (`maxResults: 40`) and implemented client-side re-ranking to prioritize books whose titles or authors best match the user's query.
- **Verification:** Added comprehensive unit tests in `test/services/book_service_test.dart` to verify that typo-laden queries correctly prioritize relevant results.

### 4.2 Smart Recommendations Engine
**User:** Move beyond simple genre matching to a more personalized recommendation system.
**Gemini:** 
- **Service Enhancement:** Expanded `BookService` with `getSimilarBooks`, utilizing author and category metadata from the user's "Top 3 Favorites" to build complex API queries.
- **Data-Driven Discovery:** Created `smartRecommendationsProvider` to reactively fetch and manage personalized book suggestions.
- **UI Integration:** Redesigned the `FeedScreen` to include a dedicated "More Like Your Favorites" horizontal discovery row, providing users with a "Netflix-style" browsing experience.
- **Logic refinement:** Implemented filtering to ensure users are not recommended books they already have in their "Top Favorites."

---

## Maintenance & Troubleshooting

### Web App Display Issues (CORS)
**User:** The book covers have a giant X through them on the web app.  
**Gemini:** 
- **Root Cause:** Identifed as a CORS (Cross-Origin Resource Sharing) issue where the browser blocks raw image data from Google Books API.
- **Investigation:** Attempted to force the "HTML" web renderer via `launch.json` and `web/index.html`.
- **Finding:** Discovered that in **Flutter 3.41.2**, the `--web-renderer` flag has been removed/unified, making the old "HTML renderer" workaround unavailable in the tool.
- **Resolution:** Confirmed this is a **Web-only visual quirk**. The book covers will display perfectly on mobile apps and emulators as they are not subject to browser CORS policies.

### General Stability
**User:** Fix errors in `main_navigation` and `library_provider`.  
**Gemini:** 
- Aligned `AsyncNotifier` syntax with Riverpod 3.2.1.
- Resolved "missing implementation" errors in generated models.
- Cleaned up lint warnings and missing icon references.
- Fixed `StateProvider` errors by importing from `package:flutter_riverpod/legacy.dart`.

### Google Sign-In & Onboarding UX
**User:** The Google Sign-In feature isn't working on iOS/macOS, and the onboarding flow feels redundant.
**Gemini:**
- **Auth API Update:** Adapted `AuthService` to the **google_sign_in 7.2.0** breaking changes (decoupled auth and authorization).
- **iOS/macOS Fix:** Added missing `GIDClientID` and `CFBundleURLTypes` to `Info.plist`, and updated `GoogleService-Info.plist` with necessary `CLIENT_ID` keys.
- **Android Fix:** Restored the `oauth_client` section in `google-services.json`.
- **Onboarding UX:** Enhanced `OnboardingScreen` to pre-fill the "Display Name" field using the user's authenticated Google account name.
- **Verification:** Implemented comprehensive unit tests in `test/services/auth_service_test.dart` to validate the new sign-in flow.

### Firestore Permissions Issue
**User:** I'm getting a "Profile Error: [cloud_firestore/permission-denied]" even though Google Sign-In is working.
**Gemini:**
- **Root Cause:** Identified that the Firestore Security Rules were either in "Test Mode" (expired) or too restrictive, blocking the initial profile read for new Google users.
- **Resolution:** Provided a comprehensive set of Firestore Security Rules to allow:
    - Authenticated users to read any profile (for social features).
    - Users to write only to their own profile and library.
    - Owners to manage their own activities and reviews.
    - Global read access for the activity feed.
