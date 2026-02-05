import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/models/chat_message_model.dart';

class ChatSupportProvider extends ChangeNotifier {
  final List<ChatMessageModel> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  List<ChatMessageModel> get messages => _messages;
  TextEditingController get messageController => _messageController;

  ChatSupportProvider() {
    _initializeMessages();
  }

  void _initializeMessages() {
    // Initial user message
    _messages.add(
      ChatMessageModel(
        id: '1',
        message:
            'Subject: Charged twice for monthly subscription\nHi, I was charged twice for my Focus Fusio monthly subscription. Can you help?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isUser: true,
      ),
    );

    // Support agent messages
    _messages.add(
      ChatMessageModel(
        id: '2',
        message:
            'Thanks! I checked your billing details and I can confirm two payments were processed today, about a minute apart.\nThis sometimes happens if the initial transaction doesn\'t immediately update. I can issue a refund for the duplicate charge.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isUser: false,
      ),
    );

    _messages.add(
      ChatMessageModel(
        id: '3',
        message:
            '✓ Refund to your original payment method\nor\n✓ App credit added to your account',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isUser: false,
      ),
    );
  }

  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    final newMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message.trim(),
      timestamp: DateTime.now(),
      isUser: true,
    );

    _messages.add(newMessage);
    _messageController.clear();
    notifyListeners();

    // Simulate support agent response after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _addSupportResponse();
    });
  }

  void _addSupportResponse() {
    final responses = [
      'I understand your concern. Let me help you with that.',
      'Thank you for reaching out. I\'m looking into this for you.',
      'I\'ve processed your request. You should see the changes shortly.',
    ];

    final randomResponse =
        responses[DateTime.now().millisecond % responses.length];

    final supportMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: randomResponse,
      timestamp: DateTime.now(),
      isUser: false,
    );

    _messages.add(supportMessage);
    notifyListeners();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
