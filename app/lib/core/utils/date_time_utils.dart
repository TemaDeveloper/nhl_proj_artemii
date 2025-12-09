class DateTimeUtils {
  DateTimeUtils._(); 

  static DateRange getTodayDateRange() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return DateRange(
      start: startOfDay.toUtc(),
      end: endOfDay.toUtc(),
    );
  }

  /// Get start and end of a specific date.
  static DateRange getDateRange(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return DateRange(
      start: startOfDay.toUtc(),
      end: endOfDay.toUtc(),
    );
  }

  /// Check if a DateTime is today in local timezone.
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    final localDate = dateTime.toLocal();
    
    return localDate.year == now.year &&
           localDate.month == now.month &&
           localDate.day == now.day;
  }

  /// Format time for display (e.g., "3:30 PM").
  static String formatTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final hour = local.hour > 12 ? local.hour - 12 : (local.hour == 0 ? 12 : local.hour);
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    
    return '$hour:$minute $period';
  }

  /// Format date for display (e.g., "Dec 7, 2025").
  static String formatDate(DateTime dateTime) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final local = dateTime.toLocal();
    
    return '${months[local.month - 1]} ${local.day}, ${local.year}';
  }
}

/// Simple class to hold a date range.
class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({required this.start, required this.end});
}