import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

enum QuizCategory { harian, mingguan, bulanan, other }

class CooldownWindow {
  final DateTime start;
  final DateTime end;

  const CooldownWindow({required this.start, required this.end});

  bool contains(DateTime utcTime) {
    final t = utcTime.toUtc();
    return !t.isBefore(start) && t.isBefore(end);
  }
}

class CooldownHelper {
  static tz.Location? _jakarta;
  static bool _initialized = false;

  static void ensureInitialized() {
    if (_initialized) return;
    tz.initializeTimeZones();
    _jakarta = tz.getLocation('Asia/Jakarta');
    _initialized = true;
  }

  static tz.Location get _loc {
    ensureInitialized();
    return _jakarta!;
  }

  static QuizCategory parseCategory(String? category) {
    switch ((category ?? '').trim().toLowerCase()) {
      case 'harian':
        return QuizCategory.harian;
      case 'mingguan':
        return QuizCategory.mingguan;
      case 'bulanan':
        return QuizCategory.bulanan;
      default:
        return QuizCategory.other;
    }
  }

  static CooldownWindow? getWindow(QuizCategory category, {DateTime? nowUtc}) {
    if (category == QuizCategory.other) return null;

    final now = tz.TZDateTime.from((nowUtc ?? DateTime.now()).toUtc(), _loc);

    switch (category) {
      case QuizCategory.harian:
        final start = tz.TZDateTime(_loc, now.year, now.month, now.day);
        final end = start.add(const Duration(days: 1));
        return CooldownWindow(start: start.toUtc(), end: end.toUtc());

      case QuizCategory.mingguan:
        final dayStart = tz.TZDateTime(_loc, now.year, now.month, now.day);
        final daysFromMonday = now.weekday - DateTime.monday;
        final start = dayStart.subtract(Duration(days: daysFromMonday));
        final end = start.add(const Duration(days: 7));
        return CooldownWindow(start: start.toUtc(), end: end.toUtc());

      case QuizCategory.bulanan:
        final start = tz.TZDateTime(_loc, now.year, now.month, 1);
        final end = now.month == 12
            ? tz.TZDateTime(_loc, now.year + 1, 1, 1)
            : tz.TZDateTime(_loc, now.year, now.month + 1, 1);
        return CooldownWindow(start: start.toUtc(), end: end.toUtc());

      case QuizCategory.other:
        return null;
    }
  }

  static Duration? remaining(QuizCategory category, {DateTime? nowUtc}) {
    final w = getWindow(category, nowUtc: nowUtc);
    if (w == null) return null;

    final now = (nowUtc ?? DateTime.now()).toUtc();
    final diff = w.end.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }

  static const List<String> _shortMonths = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Ags',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  static const List<String> _longMonths = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static String? getNextAvailableLabel(QuizCategory category) {
    final w = getWindow(category);
    if (w == null) return null;

    final endJkt = tz.TZDateTime.from(w.end, _loc);

    switch (category) {
      case QuizCategory.harian:
        return 'Tersedia kembali besok pukul 00:00 WIB';

      case QuizCategory.mingguan:
        return 'Tersedia kembali Senin, '
            '${endJkt.day} ${_shortMonths[endJkt.month]} '
            'pukul 00:00 WIB';

      case QuizCategory.bulanan:
        return 'Tersedia kembali 1 ${_longMonths[endJkt.month]} '
            '${endJkt.year} pukul 00:00 WIB';

      case QuizCategory.other:
        return null;
    }
  }

  static String getLimitSnackbarTitle(QuizCategory category) {
    switch (category) {
      case QuizCategory.harian:
        return 'Kuis Harian Sudah Dikerjakan';
      case QuizCategory.mingguan:
        return 'Kuis Mingguan Sudah Dikerjakan';
      case QuizCategory.bulanan:
        return 'Kuis Bulanan Sudah Dikerjakan';
      case QuizCategory.other:
        return 'Kuis Sudah Dikerjakan';
    }
  }
}
