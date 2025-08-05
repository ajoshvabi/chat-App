import 'package:chat_app/module/auth/controller/auth_controller.dart';
import 'package:chat_app/module/auth/widgets/auth_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class EnterOtpScreen extends StatefulWidget {
  const EnterOtpScreen({super.key});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  @override
  void initState() {
    super.initState();
    SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(25.w, 39.h, 25.w, 0),
          child: Consumer<AuthController>(
            builder: (context, authCtr, child) => Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
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
                  "Enter your verification\ncode",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF2E0E16),
                    fontWeight: FontWeight.w600,
                    fontSize: 24.sp,
                    height: 1.2,
                  ),
                ),
                Gap(30.h),
                Row(
                  children: [
                    Text(
                      "+91 ${authCtr.phoneController.text}. ",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF2E0E16),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Edit',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E0E16),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(28.h),
                AutofillGroup(
                  child: PinCodeTextField(
                    enablePinAutofill: true,
                    autoDisposeControllers: false,
                    appContext: context,
                    controller: authCtr.otpController,
                    length: 6,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12.r),
                      fieldHeight: 55.h,
                      fieldWidth: 55.w,
                      activeColor: Colors.black,
                      selectedColor: Colors.grey.shade400,
                      inactiveColor: Colors.grey.shade300,
                      borderWidth: 1.5,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    onChanged: (value) {},
                    enableActiveFill: true,
                  ),
                ),
                Gap(12.h),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Didn’t get anything? No worries, let’s try again",
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF96848B),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Resent',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Color(0xFF38A6F7),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    authCtr.verifyOtp(context);
                  },
                  child: AuthButton(text: "Verify"),
                ),
                Gap(16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
