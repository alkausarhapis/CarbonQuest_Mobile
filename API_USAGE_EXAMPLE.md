# API Usage Examples

This document provides practical examples of how to use the CarbonQuest Gamification API.

## Table of Contents

1. [Authentication Flow](#authentication-flow)
2. [User Journey](#user-journey)
3. [Organization Journey](#organization-journey)
4. [Quiz/Session Flow](#quiz-session-flow)

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
