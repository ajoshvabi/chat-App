import 'dart:developer';

import 'package:chat_app/module/chat/service/chat.service.dart';
import 'package:flutter/material.dart';

class ChatController with ChangeNotifier {
  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;

  final ChatApiService apiService = ChatApiService();

  Future<void> loadMessages(String senderId, String receiverId) async {
    log("Strat Api");
    isLoading = true;
    notifyListeners();

    try {
      messages = await apiService.fetchChatMessages(
        // senderId: "224",
        // receiverId: "220",
        senderId: senderId,
        receiverId: receiverId,
      );
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
