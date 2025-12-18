import 'dart:convert';

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
      print('🖼️ User $name: Using pravatar (profileImage is empty)');
      return 'https://i.pravatar.cc/150?u=$email';
    }
    if (profileImage!.startsWith('http')) {
      print('🖼️ User $name: Using full URL: $profileImage');
      return profileImage!;
    }
    final fullUrl = 'https://carbonquest-api.bintangap.my.id$profileImage';
    print('🖼️ User $name: Constructed URL: $fullUrl');
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
    print('🔍 Full JSON object: $json');
    final profileImg = json['profile_image'];
    print('👤 Parsing user: ${json['name']} - profile_image: $profileImg');
    print('📋 Available keys: ${json.keys.toList()}');

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

  /// Fetch leaderboard from API
  static Future<List<User>> fetchLeaderboard({String? token}) async {
    try {
      print('📡 Fetching leaderboard from API...');
      final response = await ApiService.get('/users/leaderboard', token: token);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> usersJson = jsonData['data'] ?? [];

        print('✅ Parsing ${usersJson.length} users...');

        // Fetch full user details for each user to get profile_image
        final List<User> users = [];
        for (var userJson in usersJson) {
          final userId = userJson['id_user'];
          print('🔍 Fetching profile for user ID: $userId');

          try {
            final userDetailResponse = await ApiService.get(
              '/users/$userId',
              token: token,
            );

            if (userDetailResponse.statusCode == 200) {
              final userDetailJson = json.decode(userDetailResponse.body);
              final userData = userDetailJson['data'];

              print(
                '📸 User ${userData['name']} profile_image: ${userData['profile_image']}',
              );

              // Merge leaderboard data with profile data
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
              // If fetching user details fails, create user without profile_image
              print(
                '⚠️ Failed to fetch profile for user $userId, using leaderboard data only',
              );
              users.add(User.fromJson(userJson));
            }
          } catch (e) {
            print('⚠️ Error fetching profile for user $userId: $e');
            users.add(User.fromJson(userJson));
          }
        }

        print('✅ Successfully loaded ${users.length} users with profiles');
        return users;
      } else {
        throw Exception('Failed to load leaderboard: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching leaderboard: $e');
      throw Exception('Error fetching leaderboard: $e');
    }
  }
}
