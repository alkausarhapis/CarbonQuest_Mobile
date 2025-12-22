import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/api_service.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String? profileImage;
  final int totalPoints;
  final int sessionPoints;
  final int missionPoints;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.totalPoints,
    required this.sessionPoints,
    required this.missionPoints,
  });

  String get avatarUrl {
    if (profileImage == null || profileImage!.isEmpty) {
      return 'https://i.pravatar.cc/150?u=$email';
    }
    if (profileImage!.startsWith('http')) {
      return profileImage!;
    }
    final fullUrl = 'https://carbonquest-api.bintangap.my.id$profileImage';
    return fullUrl;
  }

  String get level {
    if (totalPoints >= 2500) return 'Master Hijau';
    if (totalPoints >= 2000) return 'Ahli Lingkungan';
    if (totalPoints >= 1500) return 'Pejuang Iklim';
    if (totalPoints >= 1000) return 'Aktivis Bumi';
    if (totalPoints >= 500) return 'Pemula Peduli';
    return 'Pemula';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_user'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'],
      totalPoints: json['total_points'] ?? 0,
      sessionPoints: json['session_points'] ?? 0,
      missionPoints: json['mission_points'] ?? 0,
    );
  }

  static Future<List<User>> fetchLeaderboard({String? token}) async {
    try {
      final response = await ApiService.get('/users/leaderboard', token: token);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> usersJson = jsonData['data'] ?? [];

        final List<User> users = [];
        for (var userJson in usersJson) {
          final userId = userJson['id_user'];

          try {
            final userDetailResponse = await ApiService.get(
              '/users/$userId',
              token: token,
            );

            if (userDetailResponse.statusCode == 200) {
              final userDetailJson = json.decode(userDetailResponse.body);
              final userData = userDetailJson['data'];

              final user = User(
                id: userId ?? 0,
                name: userData['name'] ?? userJson['name'] ?? '',
                email: userData['email'] ?? userJson['email'] ?? '',
                profileImage: userData['profile_image'],
                totalPoints: userJson['total_points'] ?? 0,
                sessionPoints: userJson['session_points'] ?? 0,
                missionPoints: userJson['mission_points'] ?? 0,
              );
              users.add(user);
            } else {
              debugPrint(
                'Failed to fetch profile for user $userId, using leaderboard data only',
              );
              users.add(User.fromJson(userJson));
            }
          } catch (e) {
            debugPrint('Error fetching profile for user $userId: $e');
            users.add(User.fromJson(userJson));
          }
        }

        debugPrint('Successfully loaded ${users.length} users with profiles');
        return users;
      } else {
        throw Exception('Failed to load leaderboard: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching leaderboard: $e');
    }
  }
}
