import 'dart:convert';

import '../core/api_service.dart';

class DailyPoint {
  final String week;
  final int missionPoints;
  final int quizPoints;
  final int totalPoints;
  final int missionsCompleted;
  final int quizzesCompleted;

  DailyPoint({
    required this.week,
    required this.missionPoints,
    required this.quizPoints,
    required this.totalPoints,
    required this.missionsCompleted,
    required this.quizzesCompleted,
  });

  factory DailyPoint.fromJson(Map<String, dynamic> json) {
    return DailyPoint(
      week: json['week'] ?? '',
      missionPoints: json['mission_points'] ?? 0,
      quizPoints: json['quiz_points'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
      missionsCompleted: json['missions_completed'] ?? 0,
      quizzesCompleted: json['quizzes_completed'] ?? 0,
    );
  }

  /// Fetch daily points from API
  static Future<List<DailyPoint>> fetchDailyPoints({
    required String? token,
    required int days,
  }) async {
    try {
      print('📊 Fetching daily points for $days days...');
      final response = await ApiService.get(
        '/me/sessions/daily-points?days=$days',
        token: token,
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> pointsJson = jsonData['data'] ?? [];

        print('✅ Loaded ${pointsJson.length} daily points');
        final points = pointsJson
            .map((json) => DailyPoint.fromJson(json))
            .toList();

        return points;
      } else {
        throw Exception('Failed to load daily points: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching daily points: $e');
      throw Exception('Error fetching daily points: $e');
    }
  }
}
