# Project Requirements: SYE (Social Media for Books)
# Developer: Autumn 
# Description: A social media app based around books.

**Core Architectural Rules**
Gemini: When reading this file to implement a step, you MUST adhere to the following:

1. **State Management**: Use `flutter_riverpod` exclusively. Do not use `setState` for complex logic.
2. **Architecture**: Maintain strict separation of concerns:
    - `/lib/models`: Pure Dart data classes (use `json_serializable` or `freezed`).
    - `/lib/services`: Backend/API communication (Firebase, etc.). No UI code.
    - `/lib/providers`: Riverpod providers linking services to the UI.
    - `/lib/screens` & `/lib/widgets`: UI only. Keep files small. Extract complex widgets.
3. **Local Storage**: Use `shared_preferences` for local app state (e.g., theme toggles, onboarding status).
4. **Database**: Use Firebase Firestore for persistent cloud data.
5. **Stepwise Execution**: Only implement the specific step requested in the prompt. Do not jump ahead.

---

**Feature 1: Create a profile**

 1.1 **User Authentication**
   - **Concept:** Establish a secure gateway using Firebase Auth, allowing users to create accounts and log in with email/password.
   - **Goal:** Implement an `AuthService` and `authProvider` to manage the user's session.

 1.2 **User Model**
   - **Concept:** Define a structured Dart data class to represent the user's identity, interests (genres), and personal details consistently across the app.
   - **Goal:** Create a `UserModel` in `/models` with fields for `uid`, `displayName`, `bio`, `profilePicUrl`, and `favoriteGenres`.

 1.3 **User Collection (Firestore)**
   - **Concept:** Persistently store user profiles in the cloud to enable social features like following and sharing bookshelves.
   - **Goal:** Create a `UserService` to handle Firestore operations for the `users` collection, ensuring every authenticated user has a corresponding document.

 1.4 **Onboarding Screen**
   - **Concept:** Create a welcoming first-time experience where users can personalize their profile (name, bio, genres) before entering the main feed.
   - **Goal:** Build a UI that captures user preferences and saves them to both Firestore and `shared_preferences` (to track onboarding completion).

 1.5 **Auth Wrapper**
   - **Concept:** Implement a state-aware entry point that automatically directs users to the correct screen based on their login and onboarding status.
   - **Goal:** Refactor `main.dart` to show the `LoginScreen`, `OnboardingScreen`, or `MainNavigation` (Feature 7) dynamically.


 **Feature 2: Book Tracking & Discovery**  

 2.1 **Book Search Service**
   - **Concept:** Bridge the app with a global library (Google Books API) to provide users with a vast database of books to explore and track.
   - **Goal:** Integrate with a Book API to allow users to search for books by title, author, or ISBN. Create a `BookModel` in `/models`.

 2.2 **Personal Bookshelves**
   - **Concept:** Create a digital representation of a physical library, allowing users to organize their past, present, and future reads.
   - **Goal:** Implement reading status tracking: "Want to Read", "Currently Reading", and "Finished" using Firestore sub-collections.

 2.3 **Reading Progress Updates**
   - **Concept:** Turn reading into a dynamic activity by allowing users to log their journey, creating a history of their engagement with a book.
   - **Goal:** Allow users to update page numbers/percentages and store a history of these updates for the activity feed.

 2.4 **Genre Recommendations**
   - **Concept:** Personalize the discovery experience by surfacing books that align with a user's unique reading DNA.
   - **Goal:** Suggest books based on "Favorite genres" from onboarding and past reading history.

**Feature 3: Social Interactions**

 3.1 **Book Reviews & Ratings**
   - **Concept:** Empower users to share their literary opinions, helping the community discover quality reads through collective wisdom.
   - **Goal:** Implement a 1–5 star rating system and text reviews stored in a top-level Firestore collection.

 3.2 **Activity Feed**
   - **Concept:** Create a "living" home screen where users can see their friends' reading milestones in real-time, fostering a sense of community.
   - **Goal:** Build a chronological feed showing updates like "Started reading" or "Rated [Book] 5 stars" from followed users.

 3.3 **Follow System**
   - **Concept:** Build the social graph of the app, allowing readers to connect with others who share similar tastes.
   - **Goal:** Allow users to follow/unfollow each other and store these relationships in Firestore.

**Feature 4: Community & Lists**

 4.1 **Custom Book Lists**
   - **Concept:** Allow users to curate and share themed collections, moving beyond basic bookshelves to creative storytelling.
   - **Goal:** Enable users to create public or private themed lists (e.g., "Best Sci-Fi of 2024").

 4.2 **Reading Goals**
   - **Concept:** Motivate users to read more by gamifying their progress through yearly challenges and visual milestones.
   - **Goal:** Implement a yearly reading challenge with a visual progress bar on the profile.

**Feature 5: Privacy and Settings**

 5.1 **Private Shelves**
   - **Concept:** Respect user privacy by giving them control over which parts of their library are public or "eyes-only."
   - **Goal:** Option to make specific bookshelves private from other users.

 5.2 **Account Settings**
   - **Concept:** Provide essential tools for users to manage their identity and account security.
   - **Goal:** Implement change password, delete account, and change username features.

 5.3 **Theme Toggle**
   - **Concept:** Enhance accessibility and visual comfort by offering a choice between light and dark aesthetics.
   - **Goal:** Use `shared_preferences` to persist light/dark mode selection.

**Feature 6: Notifications**

 6.1 **Push Notifications**
   - **Concept:** Keep users engaged with the community by providing timely alerts for social interactions and book trends.
   - **Goal:** Notify users of new followers, likes/comments on reviews, or trending books on their "Want to Read" list.

**Feature 7: Navigation and Structure**

 7.1 **Main App Layout**
   - **Concept:** Establish a clear, intuitive hierarchy that makes all core features (Feed, Search, Library, Profile) easily accessible.
   - **Goal:** Implement a `BottomNavigationBar` with four main tabs: Home, Search, My Library, and Profile.

