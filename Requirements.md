# Project Requirements: App Name
# Developmer: Autumn 
# Description: a social media app based around books \

**Requirements** 
Gemini: When reading this file to implement a step, you MUST adhere to the following architectural rules:

1. State Management: Use flutter_riverpod exclusively. Do not use setState for complex logic.

2. Architecture: Maintain strict separation of concerns:
    ●  /models: Pure Dart data classes (use json_serializable or freezed if helpful).
    ● /services: Backend/API communication only. No UI code.
    ● /providers: Riverpod providers linking services to the UI.
    ● /screens & /widgets: UI only. Keep files small. Extract complex widgets into their own files.

3. Local Storage: Use shared_preferences for local app state (e.g., theme toggles, onboarding status).

4. Database: Use Firebase Firestore for persistent cloud data.

5. Stepwise Execution: Only implement the specific step requested in the prompt. Do not jump ahead.