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
6. **Test**: Generate a test widget in the test folder for each feature added.
7. **Flutter**: Using Flutter 3.41.2 

---

**MainIdea**
 1. Core "Social" Loop (The MVP Heart)
   * Book Search & Discovery: Integration with Google Books API so users can quickly find any book.
   * The "Live Feed": An Instagram-style vertical feed where users see reviews from people they follow. Each "post" shows the book cover, a 5-star rating, and the user's
     text review.
   * The Review Board: A way for users to post, edit, and delete their own reviews (as you mentioned, these should persist).

  2. Streamlined Tracking
   * Simple Shelves: Instead of complex custom lists, start with three standard statuses: Want to Read, Reading, and Finished.
   * Reading Progress: A simple way to log "I'm on page X of Y" which then generates an automated update in the social feed.

  3. Personalized Profile
   * The "Showcase": A profile section for a short bio and the user's "Top 5 All-Time Favorite Books" (to give it that personal touch immediately).
   * Activity History: A clean list of the user's past reviews and reading milestones.

  4. Basic Social Graph
   * Follow/Unfollow: The ability to find other readers and follow them to populate your home feed.

**Feature 1: Create a profile**

 [x] 1.1 **User Authentication**
   - **Concept:** Establish a secure gateway using Firebase Auth, allowing users to create accounts and log in with email/password
                  and google authentication.
   - **Goal:** Implement an `AuthService` and `authProvider` to manage the user's session.

 [x] 1.2 **User Model**
   - **Concept:** Define a structured Dart data class to represent the user's identity, interests (genres), and personal details consistently across the app.
   - **Goal:** Create a `UserModel` in `/models` with fields for `uid`, `displayName`, `bio`, `profilePicUrl`, and `favoriteGenres`.

 [x] 1.3 **User Collection (Firestore)**
   - **Concept:** Persistently store user profiles in the cloud to enable social features like following and sharing bookshelves.
   - **Goal:** Create a `UserService` to handle Firestore operations for the `users` collection, ensuring every authenticated user has a corresponding document.

 [x] 1.4 **Onboarding Screen**
   - **Concept:** Create a welcoming first-time experience where users can personalize their profile (name, bio, genres) before entering the main feed.
   - **Goal:** Build a UI that captures user preferences and saves them to both Firestore and `shared_preferences` (to track onboarding completion).

 [x] 1.5 **Auth Wrapper**
   - **Concept:** Implement a state-aware entry point that automatically directs users to the correct screen based on their login and onboarding status.
   - **Goal:** Refactor `main.dart` to show the `LoginScreen`, `OnboardingScreen`, or `MainNavigation` (Feature 7) dynamically.

 [x] 1.6 **Home Screen Navigation**
  - **Concept:** Build a modern, "Instagram-like" navigation structure to demonstrate the app's core flow.
  - **Goal:** Implement a hardcoded `MainNavigation` with a `BottomNavigationBar` to switch between Home, Search, Library, and Profile.


 **Feature 2: Book Tracking & Discovery**  

 [x] 2.1 **Book Search Service**
   - **Concept:** Bridge the app with a global library (Google Books API) to provide users with a vast database of books to explore and track.
   - **Goal:** Integrate with a Book API to allow users to search for books by title, author, or ISBN. Create a `BookModel` in `/models`.

 [x] 2.2 **Top Favorites Showcase**
   - **Concept:** Allow users to personalize their profile by showcasing their "Top 5" all-time favorite books.
   - **Goal:** Update `UserModel` and Profile UI to allow selecting and displaying 5 favorite books fetched from the Book API.

 [x] 2.3 **Personal Bookshelves**
   - **Concept:** Create a digital representation of a physical library, allowing users to organize their past, present, and future reads.
   - **Goal:** Implement reading status tracking: "Want to Read", "Currently Reading", and "Finished" using Firestore sub-collections.

 [x] 2.4 **Reading Progress Updates**
   - **Concept:** Turn reading into a dynamic activity by allowing users to log their journey, creating a history of their engagement with a book.
   - **Goal:** Allow users to update page numbers/percentages and store a history of these updates for the activity feed.

 [x] 2.5 **Genre Recommendations**
   - **Concept:** Personalize the discovery experience by surfacing books that align with a user's unique reading DNA.
   - **Goal:** Suggest books based on "Favorite genres" from onboarding and past reading history.

[x] 3.1 **Book Reviews & Ratings**
  - **Concept:** Empower users to share their literary opinions via a persistent "Live Board" where reviews can be assigned a 1–5 star rating.
  - **Goal:** Implement a 5-star rating system and text reviews that can be edited or deleted by the user.
    [x] 3.1.1 Data Synchronization (Critical): Currently, when you edit or delete a "Post" on the Live Board, it only
     updates the activities collection. It does not update the corresponding document in the reviews collection. We should use a Firestore batch to ensure both are updated together.

  [x] 3.1.2 Activity History on Profile: The "MainIdea" in Requirements.md mentions  an "Activity History" section on the profile (a list of the user's past reviews and milestones). Currently, the profile only shows the "Top 3 Favorites."

   [x] 3.1.3 Book Details Screen: While we can see a global feed of reviews, there is no way to click on a book and see all
      reviews for just that specific book. Most onTap methods for books are currently marked with // TODO: Book
      Details.


   [x] 3.1.4 Review Management in Library: In the "Finished" tab of the Library, it would be a better user experience if
      the "Rate & Review" option changed to "Edit Review" or "View Review" if the user has already submitted one.
   3.1.5. Duplicate Prevention: There is currently no logic to prevent a user from accidentally posting multiple
      different reviews for the same book.

 [x] 3.2 **Live Activity Feed**
   - **Concept:** A "clean", Instagram-style vertical feed where users see their friends' reading milestones and reviews in real-time.
   - **Goal:** Build a chronological feed showing updates like "Started reading" or "Rated [Book] 5 stars" with persistent posts.

 [x] 3.3 **Follow System**
   - **Concept:** Build the social graph of the app, allowing readers to connect with others who share similar tastes.
   - **Goal:** Allow users to follow/unfollow each other and store these relationships in Firestore.

 [x] 3.4 **User Discovery & Community Hub**
   - **Concept:** Provide a dedicated space for users to find each other and grow their social circle.
   - **Goal:** Implement a "Community" tab in the bottom navigation featuring a global user search and a "Suggested for You" list based on shared favorite genres.

**Feature 4: Advanced Experience Improvements (Post-MVP)**

 [x] 4.1 **Advanced Search Logic**
   - **Concept:** Improve the search experience by making it more forgiving and intuitive, handling typos and partial matches gracefully.
   - **Goal:** Implement a fuzzy search algorithm or better API querying to ensure users find books even with minor misspellings.

 [x] 4.2 **Smart Recommendations Engine**
   - **Concept:** Move beyond simple genre matching to a "Netflix-style" recommendation system based on specific tropes, authors, and niche themes.
   - **Goal:** Leverage the Google Books API and internal user data to suggest books like "Books set in libraries" or specific tropes (e.g., "enemies-to-lovers").

 [x] 4.3 **Custom Book Lists (Personalized Shelves)**
   - **Concept:** Empower users to curate themed collections beyond the three default statuses.
   - **Goal:** Enable users to create, name, and add books to custom public or private lists (e.g. "Favorite Thrillers", "2024 TBR").

 [x] 4.4 **Bulk Shelf Management**
   - **Concept:** Streamline library organization by allowing users to manage multiple books simultaneously.
   - **Goal:** Implement a "Batch Mode" in the Library where users can select multiple books to move between shelves or remove from their collection at once.

 [x] 4.5 **Enhanced Rating System (Half Stars)**
     - **Concept:** Provide more nuance to book evaluations by allowing users to rate books using half-star increments.
     - **Goal:** Update the rating UI and `ReviewModel` to support 0.5-step ratings (e.g., 4.5 stars).

 [x] 4.6 **Reading Memories**
   - **Concept:** Foster nostalgia and re-engagement by reminding users of their past reading milestones.
   - **Goal:** Implement a "On This Day" feature that notifies users about what they were reading or reviewing on the same date in previous years.

 [ ] 4.7 **Customized Yearly Goals**
   - **Concept:** Expand yearly challenges to include custom sub-goals (e.g., "Read 5 Non-fiction books", "Read 3 books over 500 pages").
   - **Goal:** Update the goal tracking logic to support varied criteria beyond simple book counts.

 [ ] 4.8 **Reading Statistics & Visualizations**
   - **Concept:** Turn a user's reading history into actionable and visually appealing data.
   - **Goal:** Create a dashboard on the profile with charts and stats showing reading habits (e.g., books per month, genre breakdown, page count trends).

**Feature 5: Community & Gamification**

 [ ] 5.1 **Shared Book Lists**
   - **Concept:** Foster collaborative discovery by allowing users to curate lists together.
   - **Goal:** Implement "Collaborative Lists" where multiple users can contribute books to a single shared collection.

 [ ] 5.2 **Reading Goals & Gamification**
   - **Concept:** Motivate users through yearly challenges, reading streaks, and unlockable badges that attach to their profile.
   - **Goal:** Implement a yearly challenge progress bar and logic for "Streak" and "Goal reached" badges.

**Feature 6: Privacy and Settings**

 [ ] 6.1 **Private Shelves**
   - **Concept:** Respect user privacy by giving them control over which parts of their library are public or "eyes-only."
   - **Goal:** Option to make specific bookshelves or lists private from other users.

 [ ] 6.2 **Account Settings**
   - **Concept:** Provide essential tools for users to manage their identity and account security.
   - **Goal:** Implement change password, delete account, and change username features.

 [ ] 6.3 **Theme Toggle**
   - **Concept:** Enhance accessibility and visual comfort by offering a choice between light and dark aesthetics.
   - **Goal:** Use `shared_preferences` to persist light/dark mode selection.

**Feature 7: Notifications**

 [ ] 7.1 **Push Notifications & Reminders**
   - **Concept:** Keep users engaged with alerts for social interactions and inactivity reminders if they haven't opened the app in a while.
   - **Goal:** Notify users of new followers/likes, and implement a "reminder to read" system for inactive users.

**Feature 8: Navigation and Structure**

 [x] 8.1 **Main App Layout**
   - **Concept:** Establish a modern, "Instagram-like" hierarchy with a high-performance UI.
   - **Goal:** Implement a `BottomNavigationBar` with five main tabs: Home (Social Feed), Explore (Discovery & Search), Community (User Search), My Library, and Profile.

**Feature 9: Real-Time Communication**

 [ ] 9.1 **User-to-User Chat**
   - **Concept:** Foster community discussion through a direct messaging feature where readers can discuss books.
   - **Goal:** Implement a real-time chat service using Firestore for private 1-on-1 messaging.
