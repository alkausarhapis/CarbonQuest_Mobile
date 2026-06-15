# API Usage Examples - Frontend Integration Guide

This document provides practical examples for **frontend developers** to integrate with the CarbonQuest Gamification API using JavaScript/TypeScript.

## Table of Contents

1. [Setup & Authentication](#setup--authentication)
2. [User Features](#user-features)
3. [Organization Features](#organization-features)
4. [Quiz System (Simplified)](#quiz-system-simplified)
5. [Common Patterns](#common-patterns)

---

## Setup & Authentication

### API Base URL

```javascript
const API_BASE_URL = "https://your-domain.com"; // or http://localhost:4000 for local
```

### Axios Setup (Recommended)

```javascript
import axios from "axios";

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

// Add token to all requests automatically
api.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;
```

---

## User Features

### 1. Register & Login

```javascript
// Register new user
async function registerUser(userData) {
  try {
    const response = await api.post("/auth/user/register", {
      name: userData.name,
      last_name: userData.lastName, // optional
      birth_date: userData.birthDate, // optional, format: "1995-03-15"
      email: userData.email,
      phone: userData.phone, // optional
      password: userData.password,
    });

    // Save token
    localStorage.setItem("token", response.data.data.token);
    localStorage.setItem("user", JSON.stringify(response.data.data.user));

    return response.data;
  } catch (error) {
    console.error("Registration error:", error.response?.data);
    throw error;
  }
}

// Login
async function loginUser(email, password) {
  try {
    const response = await api.post("/auth/user/login", {
      email,
      password,
    });

    localStorage.setItem("token", response.data.data.token);
    localStorage.setItem("user", JSON.stringify(response.data.data.user));

    return response.data;
  } catch (error) {
    console.error("Login error:", error.response?.data);
    throw error;
  }
}

// Logout
function logoutUser() {
  localStorage.removeItem("token");
  localStorage.removeItem("user");
  window.location.href = "/login";
}
```

### 2. Get User Profile & Update

```javascript
// Get current user info
async function getCurrentUser() {
  try {
    const response = await api.get("/me/profile"); // or use stored user from localStorage
    return response.data.data;
  } catch (error) {
    console.error("Error fetching profile:", error);
    throw error;
  }
}

// Update profile
async function updateProfile(userId, updates) {
  try {
    const response = await api.put(`/users/${userId}`, {
      name: updates.name,
      last_name: updates.lastName,
      birth_date: updates.birthDate, // optional, format: "1990-01-15"
      email: updates.email,
      phone: updates.phone,
    });
    return response.data;
  } catch (error) {
    console.error("Update error:", error.response?.data);
    throw error;
  }
}

// Update password
async function updatePassword(oldPassword, newPassword) {
  try {
    const response = await api.put("/users/password", {
      oldPassword,
      newPassword,
    });
    return response.data;
  } catch (error) {
    console.error("Password update error:", error.response?.data);
    throw error;
  }
}

// Upload profile image
// Note: Rate limited to 10 uploads per 15 minutes
async function uploadProfileImage(userId, file) {
  try {
    const formData = new FormData();
    formData.append("profile_image", file);

    const response = await api.put(`/users/${userId}/profile-image`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });

    return response.data;
  } catch (error) {
    console.error("Upload error:", error.response?.data);
    throw error;
  }
}

// Vue.js example: Image upload from input
// <input type="file" @change="handleFileUpload" accept="image/*" />

function handleFileUpload(event) {
  const file = event.target.files[0];
  if (file && file.size <= 5242880) {
    // 5MB limit
    const userId = JSON.parse(localStorage.getItem("user")).id_user;
    uploadProfileImage(userId, file);
  } else {
    alert("File too large! Max 5MB");
  }
}
```

### 3. Missions

```javascript
// Get all available missions
async function getMissions() {
  try {
    const response = await api.get("/missions");
    return response.data.data; // Array of missions
  } catch (error) {
    console.error("Error fetching missions:", error);
    throw error;
  }
}

// Get my active/completed missions
async function getMyMissions() {
  try {
    const response = await api.get("/me/missions");
    return response.data.data;
  } catch (error) {
    console.error("Error:", error);
    throw error;
  }
}

// Start a mission
async function startMission(missionId) {
  try {
    const response = await api.post("/user-missions", {
      id_mission: missionId,
    });
    return response.data;
  } catch (error) {
    console.error("Error starting mission:", error.response?.data);
    throw error;
  }
}

// Complete a mission
async function completeMission(userMissionId, points) {
  try {
    const response = await api.put(`/user-missions/${userMissionId}`, {
      status: "completed",
      points: points,
      completed_time: new Date().toISOString(),
    });
    return response.data;
  } catch (error) {
    console.error("Error completing mission:", error.response?.data);
    throw error;
  }
}
```

### 4. Leaderboard

```javascript
// Get leaderboard (top users by points)
async function getLeaderboard() {
  try {
    const response = await api.get("/users/leaderboard");
    return response.data.data; // Sorted by total_points
  } catch (error) {
    console.error("Error fetching leaderboard:", error);
    throw error;
  }
}

// Display example (Vue.js)
/*
<template>
  <div class="leaderboard">
    <div v-for="(user, index) in leaderboard" :key="user.id_user" class="user-rank">
      <span class="rank">#{{ index + 1 }}</span>
      <img :src="`${API_BASE_URL}${user.profile_image || '/default-avatar.png'}`" class="avatar" />
      <span class="name">{{ user.name }}</span>
      <span class="points">{{ user.total_points }} pts</span>
    </div>
  </div>
</template>
*/
```

### 5. Articles

```javascript
// Get all articles
async function getArticles() {
  try {
    const response = await api.get("/articles");
    return response.data.data;
  } catch (error) {
    console.error("Error fetching articles:", error);
    throw error;
  }
}

// Get single article
async function getArticle(articleId) {
  try {
    const response = await api.get(`/articles/${articleId}`);
    return response.data.data;
  } catch (error) {
    console.error("Error fetching article:", error);
    throw error;
  }
}
```

### 6. Weekly Points History (for Chart)

```javascript
// Get daily points for last 7 days (for bar chart)
async function getDailyPoints(days = 7) {
  try {
    const response = await api.get(`/me/sessions/daily-points?days=${days}`);
    return response.data.data;
    // Returns: [{ week: "2024-12-24", mission_points: 150, quiz_points: 200, total_points: 350, ... }]
  } catch (error) {
    console.error("Error fetching daily points:", error);
    throw error;
  }
}

// Chart.js example
async function renderPointsChart() {
  const data = await getDailyPoints(7);

  const chartData = {
    labels: data.map((d) => d.week), // ["2024-12-24", "2024-12-25", ...]
    datasets: [
      {
        label: "Mission Points",
        data: data.map((d) => d.mission_points),
        backgroundColor: "#4CAF50",
      },
      {
        label: "Quiz Points",
        data: data.map((d) => d.quiz_points),
        backgroundColor: "#2196F3",
      },
    ],
  };

  // Use chartData with Chart.js or your charting library
}
```

---

## Quiz System (Simplified)

**Important:** Quiz now uses **automatic submission** - no manual session creation needed!

### 1. Get All Quizzes

```javascript
async function getQuizzes() {
  try {
    const response = await api.get("/quizzes");
    return response.data.data;
    /* Returns:
    [{
      id_quiz: 4,
      title: "Kuis Perubahan Iklim",
      category: "Mingguan",
      total_points: 100,
      question_count: 5,
      questions: [...] // nested questions with answers
    }]
    */
  } catch (error) {
    console.error("Error fetching quizzes:", error);
    throw error;
  }
}
```

### 2. Get Quiz Details (with Questions & Answers)

```javascript
async function getQuizById(quizId) {
  try {
    const response = await api.get(`/quizzes/${quizId}`);
    return response.data.data;
    /* Returns full quiz with nested structure:
    {
      id_quiz: 4,
      title: "Kuis Perubahan Iklim",
      questions: [
        {
          id_question: 10,
          content: "What causes climate change?",
          points: 10,
          answers: [
            { id_answer: 1, content: "CO2 emissions", is_correct: true },
            { id_answer: 2, content: "Rain", is_correct: false }
          ]
        }
      ]
    }
    */
  } catch (error) {
    console.error("Error fetching quiz:", error);
    throw error;
  }
}
```

### 3. Submit Answer (Automatic Scoring & Session Creation)

**This is the only endpoint you need for quiz submission!**

```javascript
async function submitAnswer(questionId, answerId) {
  try {
    const response = await api.post("/quizzes/submit-answer", {
      id_question: questionId,
      id_answer: answerId,
    });

    return response.data.data;
    /* Returns:
    {
      is_correct: true,
      points_earned: 10,
      correct_answer: undefined, // only shown if user answered wrong
      session_id: 123
    }
    */
  } catch (error) {
    console.error("Error submitting answer:", error.response?.data);
    throw error;
  }
}
```

### 4. Complete Quiz Flow (Vue.js Example)

```javascript
// Quiz component example
export default {
  data() {
    return {
      quiz: null,
      currentQuestionIndex: 0,
      totalScore: 0,
      results: [],
    };
  },

  async mounted() {
    // Load quiz
    this.quiz = await getQuizById(this.$route.params.id);
  },

  methods: {
    async handleAnswerSubmit(answerId) {
      const question = this.quiz.questions[this.currentQuestionIndex];

      // Submit answer
      const result = await submitAnswer(question.id_question, answerId);

      // Store result
      this.results.push(result);
      this.totalScore += result.points_earned;

      // Show feedback
      if (result.is_correct) {
        alert(`Correct! +${result.points_earned} points`);
      } else {
        alert(`Wrong! The correct answer was: ${result.correct_answer}`);
      }

      // Move to next question
      if (this.currentQuestionIndex < this.quiz.questions.length - 1) {
        this.currentQuestionIndex++;
      } else {
        // Quiz complete!
        this.showResults();
      }
    },

    showResults() {
      alert(`Quiz completed! Total score: ${this.totalScore}`);
      this.$router.push("/leaderboard");
    },
  },
};
```

### 5. Get My Quiz Sessions (History)

```javascript
async function getMySessions() {
  try {
    const response = await api.get("/me/sessions");
    return response.data.data;
    /* Returns history of all quiz attempts:
    [{
      id_session: 1,
      session_type: "quiz",
      total_points: 50,
      start_time: "2024-12-15T10:00:00Z",
      end_time: "2024-12-15T10:15:00Z",
      quiz: { id_quiz: 4, title: "Kuis Perubahan Iklim" }
    }]
    */
  } catch (error) {
    console.error("Error fetching sessions:", error);
    throw error;
  }
}
```

---

## Organization Features

### 1. Organization Login

```javascript
async function loginOrganization(email, password) {
  try {
    const response = await api.post("/auth/org/login", {
      email,
      password,
    });

    localStorage.setItem("token", response.data.data.token);
    localStorage.setItem("org", JSON.stringify(response.data.data.org));

    return response.data;
  } catch (error) {
    console.error("Login error:", error.response?.data);
    throw error;
  }
}

// Get all organizations (organization only)
async function getAllOrganizations() {
  try {
    const response = await api.get("/organizations");
    return response.data.data;
  } catch (error) {
    console.error("Error fetching organizations:", error.response?.data);
    throw error;
  }
}

// Update organization password
async function updateOrganizationPassword(oldPassword, newPassword) {
  try {
    const response = await api.put("/organizations/password", {
      oldPassword,
      newPassword,
    });
    return response.data;
  } catch (error) {
    console.error("Password update error:", error.response?.data);
    throw error;
  }
}
```

### 3. Create Mission (with Image Upload)

```javascript
async function createMission(missionData, coverImage) {
  try {
    const formData = new FormData();
    formData.append("title", missionData.title);
    formData.append("desc", missionData.description);
    formData.append("points", missionData.points);
    formData.append("tags", missionData.tags); // optional
    formData.append("photoCaption", missionData.photoCaption); // optional
    formData.append("authorName", missionData.authorName); // optional
    formData.append("authorRole", missionData.authorRole); // optional
    formData.append("highlights", missionData.highlights); // optional

    if (coverImage) {
      formData.append("coverImage", coverImage); // File object
    }

    const response = await api.post("/missions", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });

    return response.data;
  } catch (error) {
    console.error("Error creating mission:", error.response?.data);
    throw error;
  }
}
```

### 4. Create Quiz (with Nested Questions & Answers)

**Simplified: Create quiz with all questions and answers in one request!**

```javascript
async function createQuizWithQuestions(quizData) {
  try {
    const response = await api.post("/quizzes", {
      title: quizData.title,
      category: quizData.category, // "Harian", "Mingguan", "Bulanan"
      total_points: quizData.totalPoints,
      questions: quizData.questions.map((q) => ({
        content: q.content,
        points: q.points || 10,
        order: q.order,
        answers: q.answers.map((a) => ({
          content: a.content,
          is_correct: a.isCorrect, // true for correct answer
        })),
      })),
    });

    return response.data;
  } catch (error) {
    console.error("Error creating quiz:", error.response?.data);
    throw error;
  }
}

// Example usage:
const newQuiz = {
  title: "Kuis Perubahan Iklim",
  category: "Mingguan",
  totalPoints: 100,
  questions: [
    {
      content: "What causes climate change?",
      points: 10,
      order: 1,
      answers: [
        { content: "CO2 emissions", isCorrect: true },
        { content: "Rain", isCorrect: false },
        { content: "Wind", isCorrect: false },
        { content: "Snow", isCorrect: false },
      ],
    },
    {
      content: "What is renewable energy?",
      points: 10,
      order: 2,
      answers: [
        { content: "Solar and wind power", isCorrect: true },
        { content: "Coal", isCorrect: false },
      ],
    },
  ],
};

await createQuizWithQuestions(newQuiz);
```

### 5. Update Quiz (with Questions)

```javascript
async function updateQuiz(quizId, updates) {
  try {
    const response = await api.put(`/quizzes/${quizId}`, {
      title: updates.title,
      category: updates.category,
      total_points: updates.totalPoints,
      questions: updates.questions?.map((q) => ({
        id_question: q.id, // Include to update, omit to create new
        content: q.content,
        points: q.points,
        order: q.order,
        answers: q.answers.map((a) => ({
          id_answer: a.id, // Include to update, omit to create new
          content: a.content,
          is_correct: a.isCorrect,
        })),
      })),
    });

    return response.data;
  } catch (error) {
    console.error("Error updating quiz:", error.response?.data);
    throw error;
  }
}

// Example: Add 2 new answers to existing question
const quizUpdate = {
  title: "Updated Quiz Title",
  questions: [
    {
      id: 1, // existing question ID
      content: "Updated question?",
      points: 15,
      answers: [
        { id: 1, content: "Updated answer A", isCorrect: true }, // update existing
        { id: 2, content: "Updated answer B", isCorrect: false }, // update existing
        { content: "New answer C", isCorrect: false }, // create new (no id)
        { content: "New answer D", isCorrect: false }, // create new (no id)
      ],
    },
  ],
};

await updateQuiz(4, quizUpdate);
```

### 6. Create Article (with Image)

```javascript
async function createArticle(articleData, coverImage) {
  try {
    const formData = new FormData();
    formData.append("title", articleData.title);
    formData.append("topic", articleData.topic);
    formData.append("description", articleData.description);
    formData.append("content", articleData.content);
    formData.append("photoCaption", articleData.photoCaption); // optional
    formData.append("photoCredit", articleData.photoCredit); // optional
    formData.append("authorName", articleData.authorName); // optional
    formData.append("authorRole", articleData.authorRole); // optional
    formData.append("place", articleData.place); // optional
    formData.append("highlights", articleData.highlights); // optional

    if (coverImage) {
      formData.append("coverImage", coverImage);
    }

    const response = await api.post("/articles", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });

    return response.data;
  } catch (error) {
    console.error("Error creating article:", error.response?.data);
    throw error;
  }
}
```

### 7. Delete Operations

```javascript
// Delete mission
async function deleteMission(missionId) {
  await api.delete(`/missions/${missionId}`);
}

// Delete quiz (cascades to questions/answers)
async function deleteQuiz(quizId) {
  await api.delete(`/quizzes/${quizId}`);
}

// Delete article
async function deleteArticle(articleId) {
  await api.delete(`/articles/${articleId}`);
}
```

---

## Common Patterns

### 1. Error Handling

```javascript
// Global error handler
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Unauthorized - redirect to login
      localStorage.removeItem("token");
      window.location.href = "/login";
    } else if (error.response?.status === 403) {
      alert("You don't have permission to do this");
    } else {
      alert(error.response?.data?.message || "Something went wrong");
    }
    return Promise.reject(error);
  }
);
```

### 2. Image Display Helper

```javascript
function getImageUrl(path) {
  if (!path) return "/default-placeholder.png";
  if (path.startsWith("http")) return path;
  return `${API_BASE_URL}${path}`; // e.g., http://localhost:4000/files/image.jpg
}

// Usage in Vue template:
// <img :src="getImageUrl(user.profile_image)" alt="Profile" />
```

### 3. Date Formatting

```javascript
function formatDate(isoString) {
  const date = new Date(isoString);
  return date.toLocaleDateString("id-ID", {
    day: "numeric",
    month: "long",
    year: "numeric",
  });
}

// Usage: formatDate("2024-12-15T10:00:00Z") → "15 Desember 2024"
```

### 4. Protected Route (Vue Router Example)

```javascript
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem("token");
  const publicPages = ["/login", "/register"];
  const authRequired = !publicPages.includes(to.path);

  if (authRequired && !token) {
    next("/login");
  } else {
    next();
  }
});
```

---

## Quick Reference: Key Endpoints

| Feature               | Method | Endpoint                    | Auth Required |
| --------------------- | ------ | --------------------------- | ------------- |
| **Authentication**    |        |                             |               |
| Register User         | POST   | `/auth/user/register`       | No            |
| Login User            | POST   | `/auth/user/login`          | No            |
| Register Organization | POST   | `/auth/org/register`        | No            |
| Login Organization    | POST   | `/auth/org/login`           | No            |
| **User Features**     |        |                             |               |
| Get Missions          | GET    | `/missions`                 | Yes           |
| Start Mission         | POST   | `/user-missions`            | Yes (user)    |
| Complete Mission      | PUT    | `/user-missions/:id`        | Yes (user)    |
| My Missions           | GET    | `/me/missions`              | Yes (user)    |
| Get Articles          | GET    | `/articles`                 | Yes           |
| Get Leaderboard       | GET    | `/users/leaderboard`        | Yes           |
| Update Profile        | PUT    | `/users/:id`                | Yes (user)    |
| Update User Password  | PUT    | `/users/password`           | Yes (user)    |
| Upload Profile Image  | PUT    | `/users/:id/profile-image`  | Yes (user)    |
| Daily Points          | GET    | `/me/sessions/daily-points` | Yes (user)    |
| **Quiz System**       |        |                             |               |
| Get All Quizzes       | GET    | `/quizzes`                  | Yes           |
| Get Quiz Details      | GET    | `/quizzes/:id`              | Yes           |
| Submit Answer         | POST   | `/quizzes/submit-answer`    | Yes (user)    |
| My Sessions           | GET    | `/me/sessions`              | Yes (user)    |
| **Organization**      |        |                             |               |
| Get Organizations     | GET    | `/organizations`            | Yes (org)     |
| Update Org Password   | PUT    | `/organizations/password`   | Yes (org)     |
| Create Mission        | POST   | `/missions`                 | Yes (org)     |
| Update Mission        | PUT    | `/missions/:id`             | Yes (org)     |
| Delete Mission        | DELETE | `/missions/:id`             | Yes (org)     |
| Create Quiz (nested)  | POST   | `/quizzes`                  | Yes (org)     |
| Update Quiz (nested)  | PUT    | `/quizzes/:id`              | Yes (org)     |
| Delete Quiz           | DELETE | `/quizzes/:id`              | Yes (org)     |
| Create Article        | POST   | `/articles`                 | Yes (org)     |
| Update Article        | PUT    | `/articles/:id`             | Yes (org)     |
| Delete Article        | DELETE | `/articles/:id`             | Yes (org)     |

---

## Important Notes for Frontend

1. **Token Storage**: Store JWT in `localStorage` and add to Authorization header
2. **Auto-Refresh**: Tokens expire after 7 days - implement refresh or re-login
3. **Image Uploads**: Use `FormData` with `multipart/form-data` header (max 5MB)
4. **Quiz Flow**: Use `/quizzes/submit-answer` - no manual session creation needed!
5. **Cascade Delete**: Deleting quiz/mission auto-deletes related data
6. **Date Format**: Send dates as ISO 8601 string (`"2024-12-15T10:00:00Z"`)
7. **Points System**: Automatically calculated from quiz sessions + missions
8. **Error Handling**: Check `response.data.success` boolean
9. **File URLs**: Access via `${API_BASE_URL}/files/filename.jpg`
10. **Swagger Docs**: Available at `/docs` for interactive testing

---

Happy coding! 🚀 For more details, visit the Swagger documentation at `/docs`

---

## Authentication Flow

### 1. Register Organization

```http
POST /auth/org/register HTTP/1.1
Content-Type: application/json

{
  "name": "EcoWorld Foundation",
  "email": "admin@ecoworld.org",
  "password": "SecurePass123!",
  "desc": "Making the world greener, one action at a time"
}
```

**Response:**

```json
{
  "success": true,
  "message": "Organization registered successfully",
  "data": {
    "org": {
      "id_organisasi": 1,
      "name": "EcoWorld Foundation",
      "email": "admin@ecoworld.org",
      "desc": "Making the world greener, one action at a time"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsInJvbGUiOiJvcmciLCJpYXQiOjE3MDA..."
  }
}
```

### 2. Register User

```http
POST /auth/user/register HTTP/1.1
Content-Type: application/json

{
  "name": "Alice",
  "last_name": "Johnson",
  "birth_date": "1995-03-15",
  "email": "alice@example.com",
  "phone": "081234567890",
  "password": "MyPassword456!",
  "profile_image": ""
}
```

**Fields:**

- `name` (required): First name
- `last_name` (optional): Last name
- `birth_date` (optional): Date of birth (format: YYYY-MM-DD)
- `email` (required): Email address
- `phone` (optional): Phone number
- `password` (required): Password
- `profile_image` (optional): Profile image URL, defaults to empty string. Use PUT /users/:id/profile-image to upload

**Response:**

```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id_user": 1,
      "name": "Alice",
      "last_name": "Johnson",
      "birth_date": "1995-03-15T00:00:00.000Z",
      "email": "alice@example.com",
      "phone": "081234567890",
      "profile_image": ""
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNzAw..."
  }
}
```

### 3. Login

```http
POST /auth/user/login HTTP/1.1
Content-Type: application/json

{
  "email": "alice@example.com",
  "password": "MyPassword456!"
}
```

**Response:**

```json
{
  "success": true,
  "message": "User logged in successfully",
  "data": {
    "user": {
      "id_user": 1,
      "name": "Alice Johnson",
      "email": "alice@example.com"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

---

## User Journey

### 1. View Available Missions

```http
GET /missions HTTP/1.1
Authorization: Bearer USER_TOKEN
```

**Response:**

```json
{
  "success": true,
  "message": "Missions retrieved successfully",
  "data": [
    {
      "id_mission": 1,
      "title": "Reduce Plastic Usage",
      "desc": "Complete 10 actions to minimize plastic waste",
      "points": 100,
      "id_creator": 1,
      "creator": {
        "id_organisasi": 1,
        "name": "EcoWorld Foundation",
        "email": "admin@ecoworld.org"
      }
    },
    {
      "id_mission": 2,
      "title": "Energy Conservation Challenge",
      "desc": "Save energy for 7 days straight",
      "points": 150,
      "id_creator": 1,
      "creator": {
        "id_organisasi": 1,
        "name": "EcoWorld Foundation",
        "email": "admin@ecoworld.org"
      }
    }
  ]
}
```

### 2. Start a Mission

```http
POST /user-missions HTTP/1.1
Authorization: Bearer USER_TOKEN
Content-Type: application/json

{
  "id_mission": 1
}
```

**Response:**

```json
{
  "success": true,
  "message": "Mission started successfully",
  "data": {
    "id_working": 1,
    "id_user": 1,
    "id_mission": 1,
    "status": "on_going",
    "points": 0,
    "completed_time": null
  }
}
```

### 3. Complete a Mission

```http
PUT /user-missions/1 HTTP/1.1
Authorization: Bearer USER_TOKEN
Content-Type: application/json

{
  "status": "completed",
  "points": 100,
  "completed_time": "2024-11-22T10:30:00Z"
}
```

**Response:**

```json
{
  "success": true,
  "message": "Mission updated successfully",
  "data": {
    "id_working": 1,
    "id_user": 1,
    "id_mission": 1,
    "status": "completed",
    "points": 100,
    "completed_time": "2024-11-22T10:30:00.000Z"
  }
}
```

### 4. Update Password

```http
PUT /users/password HTTP/1.1
Authorization: Bearer USER_TOKEN
Content-Type: application/json

{
  "oldPassword": "MyPassword456!",
  "newPassword": "NewSecurePass789!"
}
```

**Response:**

```json
{
  "success": true,
  "message": "Password updated successfully",
  "data": null
}
```

### 5. Update User Profile

```http
PUT /users/1 HTTP/1.1
Authorization: Bearer USER_TOKEN
Content-Type: application/json

{
  "name": "Alice",
  "last_name": "Johnson-Smith",
  "email": "alice.new@example.com",
  "phone": "081234567899"
}
```

**Response:**

```json
{
  "success": true,
  "message": "User updated successfully",
  "data": {
    "id_user": 1,
    "name": "Alice",
    "last_name": "Johnson-Smith",
    "email": "alice.new@example.com",
    "phone": "081234567899",
    "profile_image": ""
  }
}
```

**Note:** Users can only update their own profile.

### 6. Upload Profile Image

```bash
# Using curl
curl -X PUT http://localhost:4000/users/1/profile-image \
  -H "Authorization: Bearer USER_TOKEN" \
  -F "profile_image=@./my-photo.jpg"
```

```javascript
// Using JavaScript (Vue.js / React)
const formData = new FormData();
formData.append("profile_image", fileObject); // File from input

const response = await axios.put("/users/1/profile-image", formData, {
  headers: {
    "Content-Type": "multipart/form-data",
    Authorization: `Bearer ${userToken}`,
  },
});
```

**Response:**

```json
{
  "success": true,
  "message": "Profile image uploaded successfully",
  "data": {
    "id_user": 1,
    "name": "Alice",
    "email": "alice@example.com",
    "profile_image": "/files/1702345678903-profile-123.jpg"
  }
}
```

**Note:**

- Max file size: 5MB
- Allowed formats: jpg, jpeg, png, gif, webp
- Users can only upload their own profile image
- Upload rate limit: 10 requests per 15 minutes
- Files accessed via `/files/:filename` endpoint

### 7. View My Missions

```http
GET /me/missions HTTP/1.1
Authorization: Bearer USER_TOKEN
```

**Response:**

```json
{
  "success": true,
  "message": "User missions retrieved successfully",
  "data": [
    {
      "id_working": 1,
      "id_user": 1,
      "id_mission": 1,
      "status": "completed",
      "points": 100,
      "completed_time": "2024-11-22T10:30:00.000Z",
      "mission": {
        "id_mission": 1,
        "title": "Reduce Plastic Usage",
        "desc": "Complete 10 actions to minimize plastic waste",
        "points": 100,
        "id_creator": 1
      }
    }
  ]
}
```

---

## Organization Journey

### 1. Create a Mission

**Updated: Now supports image upload and rich metadata**

```bash
# Using curl
curl -X POST http://localhost:4000/missions \
  -H "Authorization: Bearer ORG_TOKEN" \
  -F "title=Plant Trees Challenge" \
  -F "tags=environment,sustainability" \
  -F "desc=Plant 5 trees in your local community" \
  -F "points=200" \
  -F "coverImage=@./mission-image.jpg" \
  -F "photoCaption=Community tree planting event" \
  -F "authorName=Jane Doe" \
  -F "authorRole=Admin" \
  -F "highlights=Contribute to reforestation efforts"
```

```javascript
// Using JavaScript (Vue.js / React)
const formData = new FormData();
formData.append("title", "Plant Trees Challenge");
formData.append("tags", "environment,sustainability");
formData.append("desc", "Plant 5 trees in your local community");
formData.append("points", "200");
formData.append("coverImage", fileObject); // File from input
formData.append("photoCaption", "Community tree planting event");
formData.append("authorName", "Jane Doe");
formData.append("authorRole", "Admin");
formData.append("highlights", "Contribute to reforestation efforts");

const response = await axios.post("/missions", formData, {
  headers: {
    "Content-Type": "multipart/form-data",
    Authorization: `Bearer ${orgToken}`,
  },
});
```

**Response:**

```json
{
  "success": true,
  "message": "Mission created successfully",
  "data": {
    "id_mission": 3,
    "title": "Plant Trees Challenge",
    "tags": "environment,sustainability",
    "desc": "Plant 5 trees in your local community",
    "cover_image": "/files/1702345678901-123456789.jpg",
    "photo_caption": "Community tree planting event",
    "author_name": "Jane Doe",
    "author_role": "Admin",
    "points": 200,
    "highlights": "Contribute to reforestation efforts",
    "date_created": "2024-11-22T10:00:00.000Z",
    "id_creator": 1
  }
}
```

### 2. Create a Question

**Updated: Questions now belong to Quizzes**

First, create a Quiz:

```http
POST /quizzes HTTP/1.1
Authorization: Bearer ORG_TOKEN
Content-Type: application/json

{
  "title": "Kuis Harian - Hari Ini",
  "category": "Harian",
  "total_points": 100
}
```

**Response:**

```json
{
  "success": true,
  "message": "Quiz created successfully",
  "data": {
    "id_quiz": 1,
    "title": "Kuis Harian - Hari Ini",
    "category": "Harian",
    "total_points": 100,
    "id_creator": 1,
    "created_at": "2024-11-22T10:00:00.000Z"
  }
}
```

Then, create Questions for the Quiz:

```http
POST /questions HTTP/1.1
Authorization: Bearer ORG_TOKEN
Content-Type: application/json

{
  "id_quiz": 1,
  "content": "What is the primary greenhouse gas responsible for climate change?",
  "points": 10,
  "order": 1
}
```

**Response:**

```json
{
  "success": true,
  "message": "Question created successfully",
  "data": {
    "id_question": 1,
    "id_quiz": 1,
    "content": "What is the primary greenhouse gas responsible for climate change?",
    "points": 10,
    "order": 1
  }
}
```

### 3. Create Answers for Question

**Updated: Answers now have is_correct flag**

```http
POST /questions/1/answers HTTP/1.1
Authorization: Bearer ORG_TOKEN
Content-Type: application/json

{
  "content": "Carbon Dioxide (CO2)",
  "is_correct": true
}
```

**Response:**

```json
{
  "success": true,
  "message": "Answer created successfully",
  "data": {
    "id_answer": 1,
    "id_question": 1,
    "content": "Carbon Dioxide (CO2)",
    "is_correct": true
  }
}
```

Create more answers (incorrect ones):

```http
POST /questions/1/answers HTTP/1.1
Authorization: Bearer ORG_TOKEN
Content-Type: application/json

{
  "content": "Oxygen",
  "is_correct": false
}
```

### 4. Create an Article

**Updated: Now supports image upload and rich metadata**

```bash
# Using curl
curl -X POST http://localhost:4000/articles \
  -H "Authorization: Bearer ORG_TOKEN" \
  -F "title=Understanding Carbon Footprint" \
  -F "topic=climate" \
  -F "description=Learn about your environmental impact" \
  -F "content=A carbon footprint is the total amount of greenhouse gases generated by our actions..." \
  -F "coverImage=@./article-cover.jpg" \
  -F "photoCaption=Carbon emissions visualization" \
  -F "photoCredit=John Smith Photography" \
  -F "authorName=Dr. Emily Green" \
  -F "authorRole=Editor" \
  -F "place=Bandung, Indonesia" \
  -F "highlights=Reduce emissions, Save the planet"
```

```javascript
// Using JavaScript (Vue.js / React)
const formData = new FormData();
formData.append("title", "Understanding Carbon Footprint");
formData.append("topic", "climate");
formData.append("description", "Learn about your environmental impact");
formData.append(
  "content",
  "A carbon footprint is the total amount of greenhouse gases..."
);
formData.append("coverImage", fileObject); // File from input
formData.append("photoCaption", "Carbon emissions visualization");
formData.append("photoCredit", "John Smith Photography");
formData.append("authorName", "Dr. Emily Green");
formData.append("authorRole", "Editor");
formData.append("place", "Bandung, Indonesia");
formData.append("highlights", "Reduce emissions, Save the planet");

const response = await axios.post("/articles", formData, {
  headers: {
    "Content-Type": "multipart/form-data",
    Authorization: `Bearer ${orgToken}`,
  },
});
```

**Response:**

```json
{
  "success": true,
  "message": "Article created successfully",
  "data": {
    "id_article": 1,
    "title": "Understanding Carbon Footprint",
    "topic": "climate",
    "description": "Learn about your environmental impact",
    "content": "A carbon footprint is the total amount of greenhouse gases...",
    "cover_image": "/files/1702345678902-987654321.jpg",
    "photo_caption": "Carbon emissions visualization",
    "photo_credit": "John Smith Photography",
    "author_name": "Dr. Emily Green",
    "author_role": "Editor",
    "place": "Bandung, Indonesia",
    "highlights": "Reduce emissions, Save the planet",
    "date_created": "2024-11-22T10:00:00.000Z",
    "id_author": 1
  }
}
```

**Access uploaded images:**

```
http://localhost:4000/files/1702345678902-987654321.jpg
```

**Note:** Files are now securely accessed via `/files/:filename` endpoint with validation.

### 2. Update a Mission

```bash
curl -X PUT http://localhost:4000/missions/3 \
  -H "Authorization: Bearer ORG_TOKEN" \
  -F "title=Updated Plant Trees Challenge" \
  -F "points=250"
```

**Response:**

```json
{
  "success": true,
  "message": "Mission updated successfully",
  "data": {
    "id_mission": 3,
    "title": "Updated Plant Trees Challenge",
    "points": 250
  }
}
```

### 3. Delete a Mission

```http
DELETE /missions/3 HTTP/1.1
Authorization: Bearer ORG_TOKEN
```

**Response:**

```json
{
  "success": true,
  "message": "Mission deleted successfully",
  "data": null
}
```

### 4. Update an Article

```bash
curl -X PUT http://localhost:4000/articles/1 \
  -H "Authorization: Bearer ORG_TOKEN" \
  -F "title=Updated Carbon Footprint Guide" \
  -F "content=Updated content here..."
```

**Response:**

```json
{
  "success": true,
  "message": "Article updated successfully",
  "data": {
    "id_article": 1,
    "title": "Updated Carbon Footprint Guide"
  }
}
```

### 5. Delete an Article

```http
DELETE /articles/1 HTTP/1.1
Authorization: Bearer ORG_TOKEN
```

**Response:**

```json
{
  "success": true,
  "message": "Article deleted successfully",
  "data": null
}
```

### 6. Update a Question

```http
PUT /questions/1 HTTP/1.1
Authorization: Bearer ORG_TOKEN
Content-Type: application/json

{
  "content": "Updated question text?",
  "points": 15
}
```

**Response:**

```json
{
  "success": true,
  "message": "Question updated successfully",
  "data": {
    "id_question": 1,
    "content": "Updated question text?",
    "points": 15
  }
}
```

### 7. Delete a Question

```http
DELETE /questions/1 HTTP/1.1
Authorization: Bearer ORG_TOKEN
```

**Response:**

```json
{
  "success": true,
  "message": "Question deleted successfully",
  "data": null
}
```

### 8. Update/Delete Answers

Update an answer:

```http
PUT /answers/1 HTTP/1.1
Authorization: Bearer ORG_TOKEN
Content-Type: application/json

{
  "content": "Carbon Dioxide (CO₂) - Updated",
  "is_correct": true
}
```

Delete an answer:

```http
DELETE /answers/1 HTTP/1.1
Authorization: Bearer ORG_TOKEN
```

### 9. Get Quizzes with Question Count

```http
GET /quizzes HTTP/1.1
Authorization: Bearer USER_TOKEN
```

**Response:**

```json
{
  "success": true,
  "message": "Quizzes retrieved successfully",
  "data": [
    {
      "id_quiz": 1,
      "title": "Kuis Harian - Hari Ini",
      "category": "Harian",
      "total_points": 100,
      "id_creator": 1,
      "created_at": "2024-11-22T10:00:00.000Z",
      "creator": {
        "id_organisasi": 1,
        "name": "EcoWorld Foundation"
      },
      "questions": [
        {
          "id_question": 1,
          "content": "What is carbon footprint?",
          "answers": [
            {
              "id_answer": 1,
              "content": "Total greenhouse gas emissions",
              "is_correct": true
            }
          ]
        }
      ],
      "question_count": 5
    }
  ]
}
```

### 10. Get Questions by Quiz ID

```http
GET /questions/quiz/1 HTTP/1.1
Authorization: Bearer USER_TOKEN
```

**Response:**

```json
{
  "success": true,
  "message": "Questions retrieved successfully",
  "data": [
    {
      "id_question": 1,
      "id_quiz": 1,
      "content": "What is carbon footprint?",
      "points": 10,
      "order": 1,
      "answers": [
        {
          "id_answer": 1,
          "content": "Total greenhouse gas emissions",
          "is_correct": true
        },
        {
          "id_answer": 2,
          "content": "The size of your shoe",
          "is_correct": false
        }
      ]
    }
  ]
}
```

### 11. Update Organization Password

```http
PUT /organizations/password HTTP/1.1
Authorization: Bearer ORG_TOKEN
Content-Type: application/json

{
  "oldPassword": "SecurePass123!",
  "newPassword": "NewOrgPassword456!"
}
```

**Response:**

```json
{
  "success": true,
  "message": "Password updated successfully",
  "data": null
}
```

### 9. View All Users

```http
GET /users HTTP/1.1
Authorization: Bearer ORG_TOKEN
```

**Response:**

```json
{
  "success": true,
  "message": "Users retrieved successfully",
  "data": [
    {
      "id_user": 1,
      "name": "Alice Johnson",
      "email": "alice@example.com"
    },
    {
      "id_user": 2,
      "name": "Bob Smith",
      "email": "bob@example.com"
    }
  ]
}
```

---

## Leaderboard

### Get User Rankings

```http
GET /users/leaderboard HTTP/1.1
Authorization: Bearer USER_TOKEN
```

**Response:**

```json
{
  "success": true,
  "message": "Leaderboard retrieved successfully",
  "data": [
    {
      "id_user": 1,
      "name": "Alice",
      "email": "alice@example.com",
      "profile_image": "/files/profile-123.jpg",
      "total_points": 350,
      "session_points": 150,
      "mission_points": 200
    },
    {
      "id_user": 2,
      "name": "Bob",
      "email": "bob@example.com",
      "profile_image": "",
      "total_points": 280,
      "session_points": 100,
      "mission_points": 180
    }
  ]
}
```

**Points Breakdown:**

- `total_points`: Combined points from sessions and missions
- `session_points`: Points earned from quiz sessions
- `mission_points`: Points earned from completed missions
- Users are sorted by `total_points` in descending order

---

## Quiz/Session Flow

### 1. Get All Quizzes

```http
GET /quizzes HTTP/1.1
Authorization: Bearer USER_TOKEN
```

**Response:**

```json
{
  "success": true,
  "message": "Quizzes retrieved successfully",
  "data": [
    {
      "id_quiz": 1,
      "title": "Kuis Harian - Hari Ini",
      "category": "Harian",
      "total_points": 100,
      "question_count": 10,
      "created_at": "2024-11-22T10:00:00.000Z"
    },
    {
      "id_quiz": 2,
      "title": "Kuis Mingguan",
      "category": "Mingguan",
      "total_points": 500,
      "question_count": 25,
      "created_at": "2024-11-15T10:00:00.000Z"
    }
  ]
}
```

### 2. Get Questions for a Quiz

```http
GET /questions HTTP/1.1
Authorization: Bearer USER_TOKEN
```

**Response:**

```json
{
  "success": true,
  "message": "Questions retrieved successfully",
  "data": [
    {
      "id_question": 1,
      "id_quiz": 1,
      "content": "What is the primary greenhouse gas responsible for climate change?",
      "points": 10,
      "order": 1,
      "answers": [
        {
          "id_answer": 1,
          "id_question": 1,
          "content": "Carbon Dioxide (CO2)",
          "is_correct": true
        },
        {
          "id_answer": 2,
          "id_question": 1,
          "content": "Oxygen",
          "is_correct": false
        }
      ]
    }
  ]
}
```

### 3. Start a Quiz Session

```http
POST /sessions HTTP/1.1
Authorization: Bearer USER_TOKEN
Content-Type: application/json

{
  "id_answer": 1,
  "total_points": 0
}
```

**Response:**

```json
{
  "success": true,
  "message": "Session created successfully",
  "data": {
    "id_session": 1,
    "start_time": "2024-11-22T10:00:00.000Z",
    "end_time": null,
    "total_points": 0,
    "id_user": 1,
    "id_answer": 1
  }
}
```

### 4. Complete Session

```http
PUT /sessions/1 HTTP/1.1
Authorization: Bearer USER_TOKEN
Content-Type: application/json

{
  "total_points": 50,
  "end_time": "2024-11-22T10:15:00Z"
}
```

**Response:**

```json
{
  "success": true,
  "message": "Session updated successfully",
  "data": {
    "id_session": 1,
    "start_time": "2024-11-22T10:00:00.000Z",
    "end_time": "2024-11-22T10:15:00.000Z",
    "total_points": 50,
    "id_user": 1,
    "id_answer": 1
  }
}
```

### 5. View My Sessions

```http
GET /me/sessions HTTP/1.1
Authorization: Bearer USER_TOKEN
```

**Response:**

```json
{
  "success": true,
  "message": "Sessions retrieved successfully",
  "data": [
    {
      "id_session": 1,
      "start_time": "2024-11-22T10:00:00.000Z",
      "end_time": "2024-11-22T10:15:00.000Z",
      "total_points": 50,
      "id_user": 1,
      "id_answer": 1,
      "answer": {
        "id_answer": 1,
        "points": 10,
        "desc": "Carbon Dioxide (CO2)",
        "id_question": 1
      }
    }
  ]
}
```

---

## Error Responses

### Unauthorized (401)

```json
{
  "success": false,
  "message": "Unauthorized",
  "error": "Unauthorized"
}
```

### Forbidden (403)

```json
{
  "success": false,
  "message": "Forbidden",
  "error": "Forbidden"
}
```

### Not Found (404)

```json
{
  "success": false,
  "message": "User not found",
  "error": "User not found"
}
```

### Bad Request (400)

```json
{
  "success": false,
  "message": "Name, email, and password are required",
  "error": "Name, email, and password are required"
}
```

### Invalid Credentials (401)

```json
{
  "success": false,
  "message": "Invalid email or password",
  "error": "Invalid email or password"
}
```

---

## Tips for Using the API

1. **Always include the Authorization header** for protected routes:

   ```
   Authorization: Bearer YOUR_JWT_TOKEN
   ```

2. **JWT tokens expire after 7 days** - store them securely and refresh when needed

3. **User tokens can only access user endpoints**, org tokens for org endpoints

4. **All timestamps** are in ISO 8601 format

5. **Use Swagger UI** at `/docs` for interactive testing

6. **Check the `success` field** in responses to determine if the request succeeded

7. **Points are accumulated** from missions and quiz sessions

8. **Image uploads** use `multipart/form-data` with max 5MB size (JPEG, JPG, PNG, GIF, WEBP). Upload rate limited to 10 requests per 15 minutes

9. **File access**: Uploaded files accessed via `/files/:filename` endpoint with security validation, not direct static URLs

10. **UPDATE and DELETE operations** require organization role for articles, missions, and questions

11. **Password updates** require the old password for verification

12. **User registration fields**: Only `name`, `email`, and `password` are required. `last_name`, `birth_date`, `phone`, and `profile_image` are optional. `profile_image` defaults to empty string

13. **Profile image upload**: Use PUT /users/:id/profile-image with multipart/form-data. Max 5MB, formats: jpg, jpeg, png, gif, webp. Users can only upload their own image

14. **Quiz system**: Questions belong to Quizzes. Answers have `is_correct` field to mark correct answers

15. **Leaderboard** is automatically calculated from user's quiz sessions and completed missions and includes profile_image

16. **User CRUD**: Users can update their own profile (PUT /users/:id) and delete their own account (DELETE /users/:id). Organizations can delete any user

---

## Complete Flow Example

Here's a complete workflow from organization creating content to user participating:

### Step 1: Organization creates a mission

```bash
POST /missions (ORG_TOKEN)
```

### Step 2: Organization creates quiz and questions

```bash
POST /quizzes (ORG_TOKEN)           # Create quiz (Harian/Mingguan/Bulanan)
POST /questions (ORG_TOKEN)         # Create questions for quiz
POST /questions/:id/answers (ORG_TOKEN)  # Create answers with is_correct flag
```

### Step 3: Organization publishes article

```bash
POST /articles (ORG_TOKEN)
```

### Step 4: User views content

```bash
GET /missions (USER_TOKEN)
GET /quizzes (USER_TOKEN)           # Get quizzes with question counts
GET /questions/quiz/:id (USER_TOKEN) # Get questions for specific quiz
GET /articles (USER_TOKEN)
```

### Step 5: User participates

```bash
POST /user-missions (USER_TOKEN)       # Start mission
POST /sessions (USER_TOKEN)            # Start quiz
PUT /sessions/:id (USER_TOKEN)         # Complete quiz
PUT /user-missions/:id (USER_TOKEN)    # Complete mission
```

### Step 6: User views progress and manages profile

```bash
GET /me/missions (USER_TOKEN)
GET /me/sessions (USER_TOKEN)
GET /users/leaderboard (USER_TOKEN)     # View rankings with profile images
PUT /users/:id (USER_TOKEN)             # Update profile
PUT /users/:id/profile-image (USER_TOKEN) # Upload profile image
```

---

That's it! You now have a complete understanding of how to use the CarbonQuest Gamification API. Happy coding! 🚀
