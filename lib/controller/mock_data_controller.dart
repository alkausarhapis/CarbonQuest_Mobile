import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/daily_points.dart';
import '../view/widgets/weekly_chart_widget.dart';

class MockDataController extends GetxController {
  static const String _mockEnabledKey = 'mock_data_enabled';
  static const String _mockTotalPointsKey = 'mock_data_total_points';
  static const String _mockTodayPointsKey = 'mock_data_today_points';
  static const String _mockWeeklyKey = 'mock_data_weekly';

  final RxBool isMockEnabled = false.obs;
  final RxInt mockTotalPoints = 0.obs;
  final RxInt mockTodayPoints = 0.obs;
  final RxList<ChartData> mockWeeklyData = <ChartData>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    isMockEnabled.value = prefs.getBool(_mockEnabledKey) ?? false;
    mockTotalPoints.value = prefs.getInt(_mockTotalPointsKey) ?? 1500;
    mockTodayPoints.value = prefs.getInt(_mockTodayPointsKey) ?? 75;

    final weeklyJson = prefs.getString(_mockWeeklyKey);
    if (weeklyJson != null) {
      final List<dynamic> decoded = json.decode(weeklyJson);
      mockWeeklyData.value = decoded
          .map((e) => ChartData(
                value: (e['value'] as num).toDouble(),
                label: e['label'] as String,
                isHighlighted: e['is_highlighted'] as bool? ?? false,
              ))
          .toList();
    } else {
      _generateDefaultWeekly();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mockEnabledKey, isMockEnabled.value);
    await prefs.setInt(_mockTotalPointsKey, mockTotalPoints.value);
    await prefs.setInt(_mockTodayPointsKey, mockTodayPoints.value);

    final weeklyJson = json.encode(
      mockWeeklyData
          .map((e) => {
                'value': e.value,
                'label': e.label,
                'is_highlighted': e.isHighlighted,
              })
          .toList(),
    );
    await prefs.setString(_mockWeeklyKey, weeklyJson);
  }

  void _generateDefaultWeekly() {
    final now = DateTime.now();
    mockWeeklyData.value = List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      final day = date.day.toString();
      final value = [45, 60, 30, 85, 70, 95, 50][i].toDouble();
      return ChartData(
        value: value,
        label: day,
        isHighlighted: value >= 75,
      );
    });
  }

  Future<void> setMockEnabled(bool value) async {
    isMockEnabled.value = value;
    await _saveToPrefs();
  }

  Future<void> setMockTotalPoints(int value) async {
    mockTotalPoints.value = value;
    await _saveToPrefs();
  }

  Future<void> setMockTodayPoints(int value) async {
    mockTodayPoints.value = value;
    await _saveToPrefs();
  }

  Future<void> generateDefaultMockData() async {
    mockTotalPoints.value = 1500;
    mockTodayPoints.value = 75;
    _generateDefaultWeekly();
    isMockEnabled.value = true;
    await _saveToPrefs();
  }

  Future<void> clearMockData() async {
    mockTotalPoints.value = 0;
    mockTodayPoints.value = 0;
    mockWeeklyData.clear();
    isMockEnabled.value = false;
    await _saveToPrefs();
  }

  List<DailyPoint> getMockDailyPoints(int days) {
    final now = DateTime.now();
    return List.generate(days, (i) {
      final date = now.subtract(Duration(days: days - 1 - i));
      return DailyPoint(
        week: date.toIso8601String(),
        missionPoints: [20, 30, 10, 40, 25, 50, 15][i % 7],
        quizPoints: [25, 30, 20, 45, 45, 45, 35][i % 7],
        totalPoints: [45, 60, 30, 85, 70, 95, 50][i % 7],
        missionsCompleted: [1, 2, 0, 3, 1, 2, 1][i % 7],
        quizzesCompleted: [2, 2, 1, 3, 3, 3, 2][i % 7],
      );
    });
  }
}
