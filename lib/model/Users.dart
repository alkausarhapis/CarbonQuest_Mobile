class User {
  final String id;
  final String name;
  final String avatarUrl;
  final int points;
  final String level;

  User({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.points,
    required this.level,
  });
}

class UsersData {
  static final List<User> leaderboard = [
    User(
      id: '1',
      name: 'Andi Wijaya',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      points: 2850,
      level: 'Master Hijau',
    ),
    User(
      id: '2',
      name: 'Siti Nurhaliza',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      points: 2720,
      level: 'Expert Eco',
    ),
    User(
      id: '3',
      name: 'Budi Santoso',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
      points: 2580,
      level: 'Expert Eco',
    ),
    User(
      id: '4',
      name: 'Rina Kartika',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      points: 2350,
      level: 'Eco Warrior',
    ),
    User(
      id: '5',
      name: 'Dimas Prasetyo',
      avatarUrl: 'https://i.pravatar.cc/150?img=15',
      points: 2180,
      level: 'Eco Warrior',
    ),
    User(
      id: '6',
      name: 'Maya Lestari',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      points: 2050,
      level: 'Eco Enthusiast',
    ),
    User(
      id: '7',
      name: 'Rudi Hermawan',
      avatarUrl: 'https://i.pravatar.cc/150?img=60',
      points: 1920,
      level: 'Eco Enthusiast',
    ),
    User(
      id: '8',
      name: 'Dewi Sartika',
      avatarUrl: 'https://i.pravatar.cc/150?img=23',
      points: 1785,
      level: 'Green Starter',
    ),
    User(
      id: '9',
      name: 'Arif Rahman',
      avatarUrl: 'https://i.pravatar.cc/150?img=68',
      points: 1650,
      level: 'Green Starter',
    ),
    User(
      id: '10',
      name: 'Lisa Handayani',
      avatarUrl: 'https://i.pravatar.cc/150?img=41',
      points: 1520,
      level: 'Green Starter',
    ),
  ];

  static User? getUserById(String id) {
    try {
      return leaderboard.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<User> getTopUsers(int count) {
    return leaderboard.take(count).toList();
  }
}
