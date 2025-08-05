import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:japx/japx.dart';

class ChatApiService {
  Future<List<Map<String, dynamic>>> fetchChatMessages({
    required String senderId,
    required String receiverId,
  }) async {
    try {
      final url =
          'https://test.myfliqapp.com/api/v1/chat/chat-messages/queries/chat-between-users/$senderId/$receiverId';
      final box = Hive.box('auth');
      final token = box.get('access_token');

      if (token == null) {
        log('No access token found');
      }
      log(url);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/vnd.api+json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = Japx.decode(jsonDecode(response.body));

        log("Raw chat API response: ${response.body}");
        log("Decoded chat data: $decoded");

        final data = decoded['data'] as List;
        List<Map<String, dynamic>> messages = [];
        for (final message in data) {
          messages.add({
            'id': message['id'],
            'sender_id': message['sender_id'],
            'receiver_id': message['receiver_id'],
            'message': message['message'],
            'sent_at': message['sent_at'],
          });
        }
        return messages;
      } else {
        throw Exception(
          'Failed to load chat messages: HTTP ${response.statusCode}',
        );
      }
    } catch (e, stacktrace) {
      log('Error fetching chat messages: $e');
      log('Stacktrace: $stacktrace');
      rethrow;
    }
  }
}
