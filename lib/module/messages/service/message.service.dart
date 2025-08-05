import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/global/config.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:japx/japx.dart';

class MessageApiService {
  final String _endpoint = '$baseUrl/chat/chat-messages/queries/contact-users';

  Future<List<dynamic>> getMessages() async {
    try {
      final box = Hive.box('auth');
      final token = box.get('access_token');

      if (token == null) {
        log('No access token found');
        return [];
      }

      final uri = Uri.parse(_endpoint);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/vnd.api+json',
          'Content-Type': 'application/json',
        },
      );

      log('⬅️ Chat Messages Response Status: ${response.statusCode}');
      log('⬅️ Chat Messages Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final japxDecoded = Japx.decode(decoded);

        final data = japxDecoded['data'] as List<dynamic>? ?? [];
        return data;
      } else {
        log('Failed to fetch messages: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Exception in getMessages: $e');
      return [];
    }
  }
}
