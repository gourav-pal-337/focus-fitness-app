class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.isUser,
  });

  final String id;
  final String message;
  final DateTime timestamp;
  final bool isUser;

  String get formattedTime {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}

