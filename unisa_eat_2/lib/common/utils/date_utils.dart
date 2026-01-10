class DateUtils {

  static DateTime getInitialDate() {
    final today = DateTime.now();
    if (today.weekday >= 1 && today.weekday <= 5) {
      return today;
    }
    final daysToSubtract = today.weekday == 6 ? 1 : 2;
    return today.subtract(Duration(days: daysToSubtract));
  }

  static String formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

}