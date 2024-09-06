import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UITime {
  String timeInAgo(Timestamp time) {
    final difference = DateTime.now().difference(time.toDate());

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's ago' : ' ago'}';
    } else if (difference.inDays < 30) {
      return 'last week';
    } else if (difference.inDays < 60) {
      return 'last month';
    } else if (difference.inDays < 90) {
      return '2 months ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  String timeAccordingToWeek(Timestamp timestamp) {
    DateTime time = timestamp.toDate();
    DateTime now = DateTime.now();
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    DateTime startOfYesterday = startOfToday.subtract(const Duration(days: 1));
    DateTime startOfWeek =
        startOfToday.subtract(Duration(days: now.weekday - 1));

    if (time.isAfter(startOfToday)) {
      return "Today";
    } else if (time.isAfter(startOfYesterday)) {
      return "Yesterday";
    } else if (time.isAfter(startOfWeek)) {
      return DateFormat.EEEE().format(time); // Day of the week, e.g., "Monday"
    } else {
      return DateFormat.yMMMd().format(time); // Date, e.g., "Aug 25, 2024"
    }
  }

  String formatTime(Timestamp timestamp) {
    DateTime time = timestamp.toDate();
    //return DateFormat.jm().format(time); // Formats the time as "3:45 PM"
    return DateFormat.Hm()
        .format(time); // Formats the time as "14:30" (24-hour format)
  }
}
