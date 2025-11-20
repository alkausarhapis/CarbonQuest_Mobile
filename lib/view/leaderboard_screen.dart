import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/auth_controller.dart';
import '../core/styles/app_color.dart';
import '../model/users.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColor.primary.color,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _shareLeaderboard() async {
    try {
      final currentUser = _authController.currentUser.value;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan login terlebih dahulu')),
        );
        return;
      }

      final userRank = UsersData.leaderboard.indexWhere(
        (user) => user.name == currentUser.fullName,
      );

      final rankText = userRank != -1
          ? '#${userRank + 1}'
          : 'Belum masuk peringkat';
      final topUsers = UsersData.getTopUsers(3);

      final shareText =
          '''🌱 CarbonQuest Leaderboard 🌱

Saya ${currentUser.fullName}!
Peringkat: $rankText

🏆 Top 3:
1️⃣ ${topUsers.isNotEmpty ? '${topUsers[0].name} - ${topUsers[0].points} pts' : '-'}
2️⃣ ${topUsers.length > 1 ? '${topUsers[1].name} - ${topUsers[1].points} pts' : '-'}
3️⃣ ${topUsers.length > 2 ? '${topUsers[2].name} - ${topUsers[2].points} pts' : '-'}

Bergabunglah dengan CarbonQuest dan kurangi jejak karbon Anda! 🌍''';

      final result = await Share.share(
        shareText,
        subject: 'CarbonQuest Leaderboard',
      );

      if (result.status == ShareResultStatus.success) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Berhasil dibagikan!')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topThree = UsersData.getTopUsers(3);
    final restUsers = UsersData.leaderboard.skip(3).take(7).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _shareLeaderboard,
        backgroundColor: AppColor.primary.color,
        child: const Icon(Icons.share, color: Colors.white),
      ),
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.primary.color,
                  AppColor.primary.color.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(IconsaxPlusBold.cup, color: Colors.amber, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Papan Peringkat',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(IconsaxPlusBold.cup, color: Colors.amber, size: 28),
                  ],
                ),
              ),
            ),
          ),
          // Podium
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.primary.color.withValues(alpha: 0.8),
                  Colors.grey[50]!,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _buildPodium(topThree),
            ),
          ),
          // Rest of users
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: restUsers.length,
              itemBuilder: (context, index) {
                return _buildUserCard(restUsers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(List<User> topThree) {
    if (topThree.length < 3) return const SizedBox();

    final first = topThree[0];
    final second = topThree[1];
    final third = topThree[2];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Second Place
        _buildPodiumItem(
          user: second,
          height: 140,
          color: Colors.grey[400]!,
          rank: 2,
        ),
        const SizedBox(width: 12),
        // First Place
        _buildPodiumItem(
          user: first,
          height: 180,
          color: Colors.amber,
          rank: 1,
        ),
        const SizedBox(width: 12),
        // Third Place
        _buildPodiumItem(
          user: third,
          height: 120,
          color: Colors.brown[400]!,
          rank: 3,
        ),
      ],
    );
  }

  Widget _buildPodiumItem({
    required User user,
    required double height,
    required Color color,
    required int rank,
  }) {
    return Column(
      children: [
        // Crown for first place
        if (rank == 1)
          Icon(IconsaxPlusBold.crown, color: Colors.amber, size: 40),
        // Avatar
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 4),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: rank == 1 ? 40 : 35,
            backgroundImage: NetworkImage(user.avatarUrl),
            backgroundColor: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 8),
        // Name
        SizedBox(
          width: 100,
          child: Text(
            user.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: rank == 1 ? 14 : 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Points
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${user.points} pts',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColor.primary.color,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Podium
        Container(
          width: 100,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color, color.withValues(alpha: 0.7)],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '#$rank',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(User user) {
    final rank = UsersData.leaderboard.indexOf(user) + 1;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColor.primary.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(user.avatarUrl),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 16),
          // Name and Level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.eco, size: 14, color: Colors.green[600]),
                    const SizedBox(width: 4),
                    Text(
                      user.level,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Points
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.points}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary.color,
                ),
              ),
              Text(
                'points',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
