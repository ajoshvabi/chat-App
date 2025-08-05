import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/global/config.dart';
import 'package:http/http.dart' as http;
import 'package:japx/japx.dart';

class AuthApiService {
  final Uri _url = Uri.parse(
    '$baseUrl/auth/registration-otp-codes/actions/phone/send-otp',
  );
  final Uri _verifyOtpUrl = Uri.parse(
    '$baseUrl/auth/registration-otp-codes/actions/phone/verify-otp',
  );
  Future<Map<String, dynamic>> sendOtp(String fullPhone) async {
    final body = jsonEncode({
      "data": {
        "type": "registration_otp_codes",
        "attributes": {"phone": fullPhone},
      },
    });

    final response = await http.post(
      _url,
      headers: {
        "Content-Type": "application/vnd.api+json",
        "Accept": "application/vnd.api+json",
      },
      body: body,
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 && decoded['status'] == true) {
      return {
        "success": true,
        "message": decoded['message'] ?? "OTP sent successfully",
        "data": decoded['data'],
      };
    }

    return {
      "success": false,
      "message": decoded['errors']?[0]?['detail'] ?? "Failed to send OTP.",
      "data": decoded['errors'],
    };
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required int otp,
    required Map<String, dynamic> deviceMeta,
  }) async {
    final body = jsonEncode({
      "data": {
        "type": "registration_otp_codes",
        "attributes": {"phone": phone, "otp": otp, "device_meta": deviceMeta},
      },
    });

    log("➡️ Verify OTP Request Body: $body");

    final response = await http.post(
      _verifyOtpUrl,
      headers: {
        "Content-Type": "application/vnd.api+json",
        "Accept": "application/vnd.api+json",
      },
      body: body,
    );

    log("⬅️ Verify OTP Response Body: ${response.body}");

    final decoded = jsonDecode(response.body);
    final japxDecoded = Japx.decode(decoded);

    if (response.statusCode == 200) {
      final message = japxDecoded['message'] ?? "OTP verified successfully";
      final data = japxDecoded['data'];

      return {"success": true, "message": message, "data": data};
    }
    final error =
        japxDecoded['errors']?[0]?['detail'] ?? "Failed to verify OTP.";

    return {"success": false, "message": error, "data": japxDecoded['errors']};
  }
}
