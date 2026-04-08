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

## Maintenance & Stability
**User:** Fix failing tests in `widget_test` and `auth_wrapper_test`.  
**Gemini:** 
- Updated tests to mock Firestore profiles instead of just local storage.
- Fixed Firebase Auth initialization errors in the test environment.
- Verified all 22 tests are passing.

**User:** Fix errors in `main_navigation` and `library_provider`.  
**Gemini:** 
- Aligned `AsyncNotifier` syntax with Riverpod 3.2.1.
- Resolved "missing implementation" errors in generated models.
- Cleaned up lint warnings and missing icon references.

---

### 3.1 Book Reviews & Ratings
**User:** Implement feature 3.1
***Gemini**
✦ I have successfully implemented Feature 3.1: Book Reviews & Ratings and integrated it into your Live Board.

  New Capabilities:
   1. Rate & Review: Users can now leave 1-5 star ratings and written reviews for any book in their library.
   2. Interactive Dialog: Tapping "Rate & Review" in the Library opens a stylized dialog with star selection and a text field.
   3. Live Board (Global Feed): The Feed tab has been transformed into a community hub. It now displays a vertical "Live Board" of reviews from all users, alongside your
      personalized genre recommendations.
   4. Real-Time Sync: Using Firestore streams, new reviews appear on the Live Board instantly without needing to refresh.
   5. Clean Architecture: Separated the ReviewModel, ReviewService, and ReviewNotifier to maintain the project's high standards.

### 3.2 Live Activity Feed
**User:** Implement feature 3.2
**Gemini** 

---
### UI Polish & Refinement
**User:** Improve TabBar visibility in Library and move Save button in Edit Profile to the bottom.
**Gemini:** 
- Explicitly styled `TabBar` colors in `LibraryScreen` for better contrast.
- Moved "Save" button to the bottom of `EditProfileScreen` as a full-width `ElevatedButton` for better visibility and ergonomics.
- Implement Popup menu that encourages user to leave a review after finishing a book

