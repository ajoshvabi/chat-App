import 'package:chat_app/module/auth/service/auth.service.dart';
import 'package:chat_app/module/auth/view/enter_otp_screen.dart';
import 'package:chat_app/module/messages/view/messages.view.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AuthController with ChangeNotifier {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String countryCode = "+91";
  AuthApiService service = AuthApiService();

  assignCountryCode(String value) {
    countryCode = value;
    notifyListeners();
  }

  Future<void> sendOtp(BuildContext context) async {
    final phone = phoneController.text.trim();
    final fullPhone = '$countryCode$phone';

    if (phone.isEmpty ||
        phone.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      _showMessage(context, "Enter a valid 10-digit phone number");
      return;
    }

    try {
      final result = await service.sendOtp(fullPhone);

      if (result['success'] == true) {
        _showMessage(context, result['message']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EnterOtpScreen()),
        );
        debugPrint("✅ OTP Response: ${result['data']}");
      } else {
        _showMessage(context, result['message']);
        debugPrint("API Error: ${result['message']}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
      _showMessage(context, "Something went wrong. Please try again.");
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    final phone = phoneController.text.trim();
    final otpText = otpController.text.trim();

    if (otpText.isEmpty ||
        otpText.length != 6 ||
        !RegExp(r'^\d{6}$').hasMatch(otpText)) {
      _showMessage(context, "Enter a valid 6-digit OTP");
      return;
    }

    final otp = int.parse(otpText);
    final fullPhone = '$countryCode$phone';

    // You can customize deviceMeta as needed or collect dynamically
    final deviceMeta = {
      "type": "web",
      "device-name": "HP Pavilion 14-EP0068TU",
      "device-os-version": "Linux x86_64",
      "browser": "Mozilla Firefox Snap for Ubuntu (64-bit)",
      "browser_version": "112.0.2",
      "user-agent":
          "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0",
      "screen_resolution": "1600x900",
      "language": "en-GB",
    };

    try {
      final result = await service.verifyOtp(
        phone: fullPhone,
        otp: otp,
        deviceMeta: deviceMeta,
      );

      if (result['success'] == true) {
        _showMessage(context, result['message']);
        final accessToken = result['data']?['auth_status']?['access_token'];
        final userId = result['data']?['id'];

        if (accessToken != null) {
          final box = Hive.box('auth');
          await box.put('access_token', accessToken);

          if (userId != null) {
            await box.put('user_id', userId);
            debugPrint("✅ User ID saved in Hive");
          }

          debugPrint("✅ Access token saved in Hive");
        }

        _showMessage(context, result['message']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MessagesViewScreen()),
        );
        debugPrint("✅ OTP Verified: ${result['data']}");

        debugPrint("✅ OTP Verified: ${result['data']}");
      } else {
        _showMessage(context, result['message']);
        debugPrint("❌ Verify OTP Error: ${result['message']}");
      }
    } catch (e) {
      debugPrint("Exception in verifyOtp: $e");
      _showMessage(context, "Something went wrong. Please try again.");
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
