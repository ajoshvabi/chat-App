import 'package:chat_app/module/auth/controller/auth_controller.dart';
import 'package:chat_app/module/auth/widgets/auth_button.widget.dart';
import 'package:chat_app/module/auth/widgets/phone_textfield.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 39.h,
            left: 25.w,
            right: 25.w,
            bottom: 25.h,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 36.h,
                      width: 36.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ],
              ),
              Gap(26.h),
              Text(
                textAlign: TextAlign.center,
                "Enter your phone \nnumber",
                style: GoogleFonts.jost(
                  color: Color(0xFF2E0E16),
                  fontWeight: FontWeight.w600,
                  fontSize: 28.sp,
                ),
              ),
              Gap(32.h),
              PhoneTextField(),
              Gap(8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Fliq will send you a text with a verification code.",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Consumer<AuthController>(
                builder: (context, authCtrl, _) {
                  return GestureDetector(
                    onTap: () {
                      authCtrl.sendOtp(context);
                    },
                    child: AuthButton(text: "Next"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
