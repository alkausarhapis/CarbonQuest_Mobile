import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/auth_controller.dart';
import '../controller/leaderboard_controller.dart';
import '../core/styles/app_color.dart';
import '../model/users.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final AuthController _authController = Get.find<AuthController>();
  late final LeaderboardController _leaderboardController;

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

    if (Get.isRegistered<LeaderboardController>()) {
      _leaderboardController = Get.find<LeaderboardController>();
    } else {
      _leaderboardController = Get.put(LeaderboardController());
    }
  }

  Future<void> _shareLeaderboard() async {
    try {
      final currentUser = _authController.currentUser.value;
      if (currentUser == null) {
        return;
      }

      final userRank = _leaderboardController.currentUserRank.value;
      final rankText = userRank != null
          ? '#$userRank'
          : 'Belum masuk peringkat';
      final topUsers = _leaderboardController.getTopUsers(3);

      final shareText =
          '''🌱 CarbonQuest Leaderboard 🌱

Saya ${currentUser.fullName}!
Peringkat: $rankText

🏆 Top 3:
1️⃣ ${topUsers.isNotEmpty ? '${topUsers[0].name} - ${topUsers[0].totalPoints} pts' : '-'}
2️⃣ ${topUsers.length > 1 ? '${topUsers[1].name} - ${topUsers[1].totalPoints} pts' : '-'}
3️⃣ ${topUsers.length > 2 ? '${topUsers[2].name} - ${topUsers[2].totalPoints} pts' : '-'}

Bergabunglah dengan CarbonQuest dan kurangi jejak karbon Kamu! 🌍''';

      final result = await Share.share(
        shareText,
        subject: 'CarbonQuest Leaderboard',
      );

      if (result.status == ShareResultStatus.success) {
        Get.snackbar(
          'Berhasil',
          'Leaderboard berhasil dibagikan!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Leaderboard gagal dibagikan!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      debugPrint('Error sharing leaderboard: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _shareLeaderboard,
        backgroundColor: AppColor.primary.color,
        child: const Icon(Icons.share, color: Colors.white),
      ),
      body: Obx(() {
        if (_leaderboardController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.primary.color),
          );
        }

        if (_leaderboardController.leaderboard.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.leaderboard_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada data leaderboard',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final topThree = _leaderboardController.getTopUsers(3);
        final restUsers = _leaderboardController.leaderboard
            .skip(3)
            .take(7)
            .toList();

        return Column(
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
              child: RefreshIndicator(
                onRefresh: () => _leaderboardController.loadLeaderboard(),
                color: AppColor.primary.color,
                backgroundColor: Colors.white,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: restUsers.length,
                  itemBuilder: (context, index) {
                    final currentUserId = _authController.currentUser.value?.id;
                    final isCurrentUser =
                        currentUserId == restUsers[index].id.toString();
                    return _buildUserCard(
                      restUsers[index],
                      index + 4,
                      isCurrentUser,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPodium(List<User> topThree) {
    if (topThree.isEmpty) return const SizedBox();

    final currentUserId = _authController.currentUser.value?.id;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Second Place (if exists)
        if (topThree.length >= 2)
          _buildPodiumItem(
            user: topThree[1],
            height: 140,
            color: Colors.grey[400]!,
            rank: 2,
            isCurrentUser: currentUserId == topThree[1].id.toString(),
          ),
        if (topThree.length >= 2) const SizedBox(width: 12),
        // First Place
        _buildPodiumItem(
          user: topThree[0],
          height: 180,
          color: Colors.amber,
          rank: 1,
          isCurrentUser: currentUserId == topThree[0].id.toString(),
        ),
        if (topThree.length >= 3) const SizedBox(width: 12),
        // Third Place (if exists)
        if (topThree.length >= 3)
          _buildPodiumItem(
            user: topThree[2],
            height: 120,
            color: Colors.brown[400]!,
            rank: 3,
            isCurrentUser: currentUserId == topThree[2].id.toString(),
          ),
      ],
    );
  }

  Widget _buildPodiumItem({
    required User user,
    required double height,
    required Color color,
    required int rank,
    bool isCurrentUser = false,
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
            onBackgroundImageError: (exception, stackTrace) {
              debugPrint('❌ Error loading image for ${user.name}: $exception');
            },
          ),
        ),
        const SizedBox(height: 8),
        // Name
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(
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
              if (isCurrentUser) ...[
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Kamu',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
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
            '${user.totalPoints} pts',
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

  Widget _buildUserCard(User user, int rank, bool isCurrentUser) {
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
            onBackgroundImageError: (exception, stackTrace) {
              debugPrint('Error loading image for ${user.name}: $exception');
            },
          ),
          const SizedBox(width: 16),
          // Name and Level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isCurrentUser)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primary.color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Kamu',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${user.totalPoints}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary.color,
                ),
              ),
              Text(
                'pts',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
