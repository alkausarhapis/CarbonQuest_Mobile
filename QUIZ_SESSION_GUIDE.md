# Quiz & Session API - Frontend Integration Guide

Dokumentasi ini menjelaskan alur penggunaan endpoint Quiz dan Session untuk frontend Flutter dan VueJS.

## 🔗 Base URL

```
https://carbonquest-api.bintangap.my.id
```

## 🔐 Autentikasi

Semua endpoint memerlukan JWT token di header:

```
Authorization: Bearer <your_jwt_token>
```

---

## 📋 Quiz Flow

### 1. Ambil Daftar Quiz

**Endpoint:** `GET /quizzes`  
**Role:** User atau Organization

```javascript
// VueJS (axios)
const response = await axios.get("/quizzes", {
  headers: { Authorization: `Bearer ${token}` },
});
const quizzes = response.data.data;
```

```dart
// Flutter (http)
final response = await http.get(
  Uri.parse('$baseUrl/quizzes'),
  headers: {'Authorization': 'Bearer $token'},
);
final quizzes = jsonDecode(response.body)['data'];
```

**Response:**

```json
{
  "success": true,
  "data": [
    {
      "id_quiz": 1,
      "title": "Kuis Perubahan Iklim",
      "category": "Mingguan",
      "question_count": 5
    }
  ]
}
```

---

### 2. Ambil Detail Quiz dengan Pertanyaan

**Endpoint:** `GET /quizzes/:id`  
**Role:** User atau Organization

```javascript
// VueJS
const response = await axios.get(`/quizzes/${quizId}`, {
  headers: { Authorization: `Bearer ${token}` },
});
const quiz = response.data.data;
```

```dart
// Flutter
final response = await http.get(
  Uri.parse('$baseUrl/quizzes/$quizId'),
  headers: {'Authorization': 'Bearer $token'},
);
final quiz = jsonDecode(response.body)['data'];
```

**Response:**

```json
{
  "success": true,
  "data": {
    "id_quiz": 1,
    "title": "Kuis Perubahan Iklim",
    "category": "Mingguan",
    "questions": [
      {
        "id_question": 1,
        "content": "Apa penyebab utama perubahan iklim?",
        "order": 1,
        "answers": [
          { "id_answer": 1, "content": "Emisi gas rumah kaca", "points": 10 },
          { "id_answer": 2, "content": "Pembalakan liar", "points": 5 },
          { "id_answer": 3, "content": "Polusi air", "points": 0 }
        ]
      }
    ]
  }
}
```

> ⚠️ **Penting:** Setiap jawaban memiliki `points` tersendiri. Tidak ada konsep "benar/salah" - user mendapat poin sesuai jawaban yang dipilih.

---

### 3. Submit Jawaban Quiz (Per Pertanyaan)

**Endpoint:** `POST /quizzes/submit-answer`  
**Role:** User only

Setiap kali user memilih jawaban, kirim ke backend:

```javascript
// VueJS
const response = await axios.post(
  "/quizzes/submit-answer",
  {
    id_question: 1,
    id_answer: 3, // ID jawaban yang dipilih user
  },
  {
    headers: { Authorization: `Bearer ${token}` },
  }
);

const result = response.data.data;
// result.points_earned = 10
// result.session_id = 123
```

```dart
// Flutter
final response = await http.post(
  Uri.parse('$baseUrl/quizzes/submit-answer'),
  headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  },
  body: jsonEncode({
    'id_question': 1,
    'id_answer': 3,
  }),
);
final result = jsonDecode(response.body)['data'];
```

**Response:**

```json
{
  "success": true,
  "message": "Answer submitted successfully",
  "data": {
    "points_earned": 10,
    "session_id": 123
  }
}
```

---

## 📊 Session Endpoints

### 1. Ambil Semua Session User

**Endpoint:** `GET /me/sessions`  
**Role:** User only

Menampilkan riwayat semua quiz yang pernah dijawab user.

```javascript
// VueJS
const response = await axios.get("/me/sessions", {
  headers: { Authorization: `Bearer ${token}` },
});
const sessions = response.data.data;
```

```dart
// Flutter
final response = await http.get(
  Uri.parse('$baseUrl/me/sessions'),
  headers: {'Authorization': 'Bearer $token'},
);
final sessions = jsonDecode(response.body)['data'];
```

**Response:**

```json
{
  "success": true,
  "data": [
    {
      "id_session": 123,
      "start_time": "2024-12-22T10:00:00.000Z",
      "end_time": "2024-12-22T10:05:00.000Z",
      "total_points": 10,
      "session_type": "quiz",
      "quiz": { "id_quiz": 1, "title": "Kuis Perubahan Iklim" },
      "answer": { "id_answer": 3, "content": "Emisi gas rumah kaca" }
    }
  ]
}
```

---

### 2. Ambil Daily Points History

**Endpoint:** `GET /me/sessions/daily-points`  
**Role:** User only

Menampilkan statistik poin harian untuk chart/grafik.

```javascript
// VueJS
const response = await axios.get("/me/sessions/daily-points", {
  params: { days: 7 }, // Jumlah hari (default: 7)
  headers: { Authorization: `Bearer ${token}` },
});
const dailyPoints = response.data.data;
```

```dart
// Flutter
final response = await http.get(
  Uri.parse('$baseUrl/me/sessions/daily-points?days=7'),
  headers: {'Authorization': 'Bearer $token'},
);
final dailyPoints = jsonDecode(response.body)['data'];
```

**Response:**

```json
{
  "success": true,
  "data": [
    {
      "week": "2024-12-22",
      "mission_points": 50,
      "quiz_points": 30,
      "total_points": 80,
      "missions_completed": 2,
      "quizzes_completed": 3
    },
    {
      "week": "2024-12-21",
      "mission_points": 100,
      "quiz_points": 45,
      "total_points": 145,
      "missions_completed": 4,
      "quizzes_completed": 5
    }
  ]
}
```

---

## 🎮 Complete Quiz Flow Example

### VueJS (Composition API)

```javascript
import { ref } from "vue";
import axios from "axios";

const currentQuestion = ref(0);
const totalPoints = ref(0);
const quiz = ref(null);

// 1. Load quiz
async function loadQuiz(quizId) {
  const res = await axios.get(`/quizzes/${quizId}`);
  quiz.value = res.data.data;
}

// 2. Submit answer and move to next
async function submitAnswer(answerId) {
  const question = quiz.value.questions[currentQuestion.value];

  const res = await axios.post("/quizzes/submit-answer", {
    id_question: question.id_question,
    id_answer: answerId,
  });

  totalPoints.value += res.data.data.points_earned;
  currentQuestion.value++;

  if (currentQuestion.value >= quiz.value.questions.length) {
    // Quiz selesai
    alert(`Quiz selesai! Total poin: ${totalPoints.value}`);
  }
}
```

### Flutter

```dart
class QuizScreen extends StatefulWidget {
  final int quizId;
  QuizScreen({required this.quizId});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map<String, dynamic>? quiz;
  int currentQuestion = 0;
  int totalPoints = 0;

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }

  Future<void> loadQuiz() async {
    final response = await http.get(
      Uri.parse('$baseUrl/quizzes/${widget.quizId}'),
      headers: {'Authorization': 'Bearer $token'},
    );
    setState(() {
      quiz = jsonDecode(response.body)['data'];
    });
  }

  Future<void> submitAnswer(int answerId) async {
    final question = quiz!['questions'][currentQuestion];

    final response = await http.post(
      Uri.parse('$baseUrl/quizzes/submit-answer'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_question': question['id_question'],
        'id_answer': answerId,
      }),
    );

    final result = jsonDecode(response.body)['data'];
    setState(() {
      totalPoints += result['points_earned'] as int;
      currentQuestion++;
    });

    if (currentQuestion >= quiz!['questions'].length) {
      // Quiz selesai
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Quiz Selesai!'),
          content: Text('Total poin: $totalPoints'),
        ),
      );
    }
  }
}
```

---

## 📈 Daily Points Chart Example (VueJS with Chart.js)

```javascript
import { Chart } from "chart.js";

async function loadDailyChart() {
  const res = await axios.get("/me/sessions/daily-points?days=7");
  const data = res.data.data;

  new Chart(document.getElementById("pointsChart"), {
    type: "bar",
    data: {
      labels: data.map((d) => d.week),
      datasets: [
        {
          label: "Quiz Points",
          data: data.map((d) => d.quiz_points),
          backgroundColor: "#4CAF50",
        },
        {
          label: "Mission Points",
          data: data.map((d) => d.mission_points),
          backgroundColor: "#2196F3",
        },
      ],
    },
  });
}
```

---

## 🔑 Key Points

| Aspek            | Detail                                                    |
| ---------------- | --------------------------------------------------------- |
| **Scoring**      | Setiap jawaban punya `points` sendiri (bukan benar/salah) |
| **Submit**       | Kirim per pertanyaan, bukan sekaligus                     |
| **Session**      | Otomatis dibuat saat submit answer                        |
| **Daily Points** | Gabungan dari quiz + mission points                       |
