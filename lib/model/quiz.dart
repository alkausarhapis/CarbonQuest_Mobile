import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/api_service.dart';

class Answer {
  final int idAnswer;
  final int idQuestion;
  final String content;
  final bool isCorrect;

  Answer({
    required this.idAnswer,
    required this.idQuestion,
    required this.content,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      idAnswer: json['id_answer'] ?? 0,
      idQuestion: json['id_question'] ?? 0,
      content: json['content'] ?? '',
      isCorrect: json['is_correct'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_answer': idAnswer,
      'id_question': idQuestion,
      'content': content,
      'is_correct': isCorrect,
    };
  }
}

class Question {
  final int idQuestion;
  final int idQuiz;
  final String content;
  final int points;
  final int order;
  final List<Answer> answers;

  Question({
    required this.idQuestion,
    required this.idQuiz,
    required this.content,
    required this.points,
    required this.order,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final answersJson = json['answers'] as List<dynamic>? ?? [];
    final answers = answersJson.map((a) => Answer.fromJson(a)).toList();

    return Question(
      idQuestion: json['id_question'] ?? 0,
      idQuiz: json['id_quiz'] ?? 0,
      content: json['content'] ?? '',
      points: json['points'] ?? 0,
      order: json['order'] ?? 0,
      answers: answers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_question': idQuestion,
      'id_quiz': idQuiz,
      'content': content,
      'points': points,
      'order': order,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

class Quiz {
  final int idQuiz;
  final String title;
  final String category;
  final int totalPoints;
  final int idCreator;
  final DateTime createdAt;
  final int questionCount;
  List<Question>? questions;

  Quiz({
    required this.idQuiz,
    required this.title,
    required this.category,
    required this.totalPoints,
    required this.idCreator,
    required this.createdAt,
    required this.questionCount,
    this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    List<Question>? questions;
    if (json['questions'] != null) {
      final questionsJson = json['questions'] as List<dynamic>;
      questions = questionsJson.map((q) => Question.fromJson(q)).toList();
    }

    return Quiz(
      idQuiz: json['id_quiz'] ?? 0,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      totalPoints: json['total_points'] ?? 0,
      idCreator: json['id_creator'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      questionCount: json['question_count'] ?? 0,
      questions: questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_quiz': idQuiz,
      'title': title,
      'category': category,
      'total_points': totalPoints,
      'id_creator': idCreator,
      'created_at': createdAt.toIso8601String(),
      'question_count': questionCount,
      if (questions != null)
        'questions': questions!.map((q) => q.toJson()).toList(),
    };
  }

  static Future<List<Quiz>> fetchQuizzes({String? token}) async {
    try {
      final response = await ApiService.get('/quizzes', token: token);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> quizzesJson = jsonData['data'] ?? [];

        return quizzesJson.map((json) => Quiz.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load quizzes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching quizzes: $e');
    }
  }

  static Future<Quiz> fetchQuizById(int quizId, {String? token}) async {
    try {
      final endpoint = '/quizzes/$quizId';
      debugPrint('Fetching quiz from: $endpoint');

      final response = await ApiService.get(endpoint, token: token);

      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final quizJson = jsonData['data'];

        if (quizJson == null) {
          throw Exception('Quiz data not found in response');
        }

        final quiz = Quiz.fromJson(quizJson);

        if (quiz.questions == null || quiz.questions!.isEmpty) {
          throw Exception(
            'Kuis ini belum memiliki pertanyaan. Silakan pilih kuis lain atau coba lagi nanti.',
          );
        }

        debugPrint('Loaded quiz with ${quiz.questions!.length} questions');
        return quiz;
      } else if (response.statusCode == 404) {
        throw Exception('Kuis tidak ditemukan');
      } else {
        throw Exception('Gagal memuat kuis (Error ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching quiz: $e');
    }
  }

  static Future<List<Question>> fetchQuizQuestions(
    int quizId, {
    String? token,
  }) async {
    try {
      final endpoint = '/questions/quiz/$quizId';

      final response = await ApiService.get(endpoint, token: token);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> questionsJson = jsonData['data'] ?? [];

        return questionsJson.map((json) => Question.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception(
          'Kuis ini belum memiliki pertanyaan. Silakan pilih kuis lain atau coba lagi nanti.',
        );
      } else {
        throw Exception(
          'Gagal memuat pertanyaan (Error ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  static Future<Map<String, dynamic>> submitAnswer(
    int questionId,
    int answerId, {
    required String token,
  }) async {
    try {
      final response = await ApiService.post('/quizzes/submit-answer', {
        'id_question': questionId,
        'id_answer': answerId,
      }, token: token);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['data'];
      } else {
        throw Exception('Failed to submit answer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting answer: $e');
    }
  }

  static Future<bool> isQuizCompleted(
    int quizId, {
    required String token,
  }) async {
    try {
      final quiz = await fetchQuizById(quizId, token: token);
      final questionCount = quiz.questions?.length ?? 0;

      if (questionCount == 0) return false;

      final response = await ApiService.get('/me/sessions', token: token);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> sessionsJson = jsonData['data'] ?? [];

        final quizSessions = sessionsJson.where((session) {
          final answer = session['answer'];
          if (answer != null && answer['question'] != null) {
            final question = answer['question'];
            return question['id_quiz'] == quizId;
          }
          return false;
        }).toList();

        return quizSessions.length >= questionCount;
      }

      return false;
    } catch (e) {
      debugPrint('Error checking quiz completion: $e');
      return false;
    }
  }
}

class QuizSession {
  final int idSession;
  final DateTime startTime;
  final DateTime? endTime;
  final int totalPoints;
  final int idUser;
  final int idAnswer;

  QuizSession({
    required this.idSession,
    required this.startTime,
    this.endTime,
    required this.totalPoints,
    required this.idUser,
    required this.idAnswer,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      idSession: json['id_session'] ?? 0,
      startTime: DateTime.tryParse(json['start_time'] ?? '') ?? DateTime.now(),
      endTime: json['end_time'] != null
          ? DateTime.tryParse(json['end_time'])
          : null,
      totalPoints: json['total_points'] ?? 0,
      idUser: json['id_user'] ?? 0,
      idAnswer: json['id_answer'] ?? 0,
    );
  }

  static Future<QuizSession?> startSession(
    int answerId, {
    required String token,
  }) async {
    try {
      final response = await ApiService.post('/sessions', {
        'id_answer': answerId,
        'total_points': 0,
      }, token: token);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return QuizSession.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to start session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error starting session: $e');
    }
  }

  static Future<QuizSession?> completeSession(
    int sessionId,
    int totalPoints, {
    required String token,
  }) async {
    try {
      final response = await ApiService.put('/sessions/$sessionId', {
        'total_points': totalPoints,
        'end_time': DateTime.now().toIso8601String(),
      }, token: token);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return QuizSession.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to complete session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error completing session: $e');
    }
  }
}
