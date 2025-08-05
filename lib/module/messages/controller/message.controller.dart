import 'dart:developer';

import 'package:chat_app/module/messages/service/message.service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class MessageController with ChangeNotifier {
  final MessageApiService service = MessageApiService();
  bool isLoading = false;
  List<dynamic> _chatUsersResponse = [];
  List<dynamic> get chatUsersResponse => _chatUsersResponse;

  List<Map<String, dynamic>> chats = [];

  messageOnInit() async {
    isLoading = true;
    notifyListeners();
    await getMessages();
    isLoading = false;
    notifyListeners();
  }

  String formatTime(String input) {
    final dt = DateTime.parse(input.split('.').first);
    return DateFormat.jm().format(dt);
  }

  Future<void> getMessages() async {
    final messages = await service.getMessages();
    if (messages.isNotEmpty) {
      _chatUsersResponse = messages;
      mapApiDataToChats(_chatUsersResponse);
      notifyListeners();
    }
  }

  void mapApiDataToChats(List<dynamic> customersJson) {
    chats = customersJson.map((customer) {
      return {
        "id": customer['id'] ?? '',
        "image": customer['profile_photo_url'] ?? 'assets/default_avatar.png',
        "name": customer['name'] ?? 'Unknown',
        "time": customer['message_received_from_partner_at'] ?? '',
      };
    }).toList();

    log("Mapped Chats Data: $chats");
  }

  String? getUserIdFromHive() {
    final box = Hive.box('auth');
    return box.get('user_id');
  }
}
