import 'package:chat_app/module/auth/view/send_otp.view.dart';
import 'package:chat_app/module/welcome/widgets/login_button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/loginImage.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 109.h),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: Color(0XffE6446E),
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              width: 33.w,
                              height: 22.h,
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/loginIcon.svg",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(6.5.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 43.w),
                        child: Text(
                          textAlign: TextAlign.center,
                          "Connect. Meet. Love.\n With Fliq Dating",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 31.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      LoginButtonsWidget(
                        text: "Sign in with Google",
                        textColor: Color(0xFF2E0E16),
                        color: Colors.white,
                        icons: "assets/icons/google.svg",
                      ),
                      Gap(16.h),
                      LoginButtonsWidget(
                        text: "Sign in with Facebook",
                        textColor: Colors.white,
                        color: Color(0xFF3B5998),
                        icons: "assets/icons/facebook.svg",
                      ),
                      Gap(16.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SendOtpScreen(),
                            ),
                          );
                        },
                        child: LoginButtonsWidget(
                          text: "Sign in with phone number",
                          textColor: Colors.white,
                          color: Color(0xFFE6446E),
                          icons: "assets/icons/phonee.svg",
                        ),
                      ),
                      Gap(24.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            text: 'By signing up, you agree to our ',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                  decorationThickness: 1.5,
                                ),
                              ),
                              TextSpan(
                                text: '. See how we use your data in our ',
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                  decorationThickness: 1.5,
                                ),
                              ),
                              TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                      Gap(25.h),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
