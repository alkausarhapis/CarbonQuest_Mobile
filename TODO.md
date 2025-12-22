# CarbonQuest Code Cleanup Checklist

## 🎯 Goal

Clean up codebase following feature-based architecture for better maintainability and scalability.

---

## Phase 1: Core/Foundation 🏗️

### Core Services & Configuration

- [v] **api_service.dart**

  - [v] Remove unused imports
  - [v] Add consistent error handling
  - [v] Extract API endpoints to constants
  - [v] Add request/response logging (debug mode)
  - [v] Validate all API methods have proper types

- [v] **auth_middleware.dart**

  - [v] Clean up route guards logic
  - [v] Add proper error messages
  - [v] Ensure null safety throughout

- [v] **navigation_route.dart**
  - [v] Verify all routes are used
  - [v] Consistent naming conventions
  - [v] Add route documentation

### Styles & Theming

- [v] **app_color.dart**

  - [v] Remove unused colors
  - [v] Add color documentation
  - [v] Ensure consistent color usage

- [v] **app_theme.dart**
  - [v] Consolidate theme definitions
  - [v] Remove duplicate styles
  - [v] Add dark mode support (if needed)

---

## Phase 2: Feature Modules 🎨

### 🔐 Auth Feature

- [v] **auth_controller.dart**

  - [v] Remove console.log/debugPrint in production code
  - [ ] Add proper error handling for all auth methods
  - [ ] Extract magic strings (error messages, etc.)
  - [v] Validate token management
  - [v] Add method documentation

- [v] **auth_user.dart** (Model)

  - [v] Validate all fields have proper types
  - [v] Add fromJson/toJson null safety
  - [v] Add copyWith method if needed

- [v] **login_screen.dart**

  - [v] Remove unused imports
  - [v] Extract hardcoded strings to constants
  - [v] Consistent error handling
  - [v] Add loading states
  - [v] Validate form validators

- [v] **register_screen.dart**

  - [v] Remove unused imports
  - [v] Extract validation logic to separate file
  - [v] Consistent error messages
  - [v] Add loading states

- [v] **settings_page.dart**

  - [v] Clean up profile update logic
  - [v] Add proper image handling
  - [v] Consistent error handling
  - [v] Extract dialog to separate widget (the concern is, we just use dialog in here, nothing else)

- [v] **image_controller.dart**
  - [v] Add error handling for image operations
  - [v] Validate image size/format
  - [v] Clean up temporary files

---

### 📝 Quiz Feature

- [v] **quiz_controller.dart**

  - [v] Add proper state management
  - [v] Error handling for API calls
  - [v] Extract business logic from UI
  - [v] Add method documentation

- [v] **quiz.dart** (Model)

  - [v] Validate model structure
  - [v] Add proper null safety
  - [v] Add helper methods if needed

- [v] **quiz_menu_screen.dart**

  - [v] Remove duplicate code
  - [v] Extract quiz card to reusable widget
  - [v] Consistent styling
  - [v] Add empty state handling

- [v] **quiz_question_screen.dart**

  - [v] Clean up question navigation logic
  - [v] Extract answer validation
  - [v] Add proper state management
  - [v] Consistent error handling

- [v] **quiz_score_screen.dart**
  - [v] Clean up score calculation
  - [v] Extract widgets for reusability
  - [v] Add proper navigation
  - [v] Consistent styling

---

### 🎯 Mission Feature

- [v] **mission_controller.dart**

  - [v] Clean up mission state management
  - [v] Add proper error handling
  - [?] Extract business logic
  - [v] Add method documentation

- [v] **Missions.dart** (Model)

  - [v] Validate model structure
  - [v] Add proper null safety
  - [x] Add status enum instead of strings (no need)

- [x] **mission_screen.dart**

  - [x] Remove duplicate code
  - [x] Extract category logic
  - [x] Consistent styling
  - [x] Add empty state handling

- [v] **mission_detail_bottom_sheet.dart**

  - [v] Clean up bottom sheet logic
  - [v] Extract reusable components
  - [v] Add proper error handling
  - [v] Consistent styling

- [v] **active_mission_widget.dart**
  - [v] Validate widget structure
  - [v] Add proper null checks
  - [v] Consistent styling

---

### 🏆 Leaderboard Feature

- [v] **leaderboard_controller.dart**

  - [v] Clean up leaderboard fetching logic
  - [v] Add proper error handling
  - [v] Extract ranking logic
  - [x] Add method documentation

- [v] **Users.dart** (Model)

  - [v] Validate model structure
  - [v] Add proper null safety
  - [x] Add helper methods

- [v] **leaderboard_screen.dart**
  - [v] Remove duplicate code
  - [v] Extract podium widget
  - [v] Clean up share functionality
  - [v] Consistent error handling
  - [v] Add empty state

---

### 📰 Articles Feature

- [v] **Articles.dart** (Model)

  - [v] Validate model structure
  - [v] Add proper null safety
  - [v] Add fromJson validation

- [v] **article_screen.dart**

  - [v] Clean up article display logic
  - [v] Add proper error handling
  - [v] Consistent styling

- [v] **article_widget.dart**
  - [v] Validate widget structure
  - [v] Add proper null checks
  - [v] Consistent styling

---

### 🏠 Home Feature

- [v] **home_screen.dart**

  - [v] Remove duplicate code
  - [v] Extract sections to separate widgets
  - [v] Clean up data fetching logic
  - [v] Add proper error handling
  - [v] Optimize refresh logic

- [v] **daily_points.dart** (Model)
  - [v] Validate model structure
  - [v] Add proper null safety
  - [x] Add helper methods

---

## 🌐 Data Dashboard

- [v] Proper Quiz
- [v] Proper Article
- [v] Proper Mission (at least 5 each)

---
