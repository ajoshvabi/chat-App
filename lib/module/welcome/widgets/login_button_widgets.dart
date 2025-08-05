import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButtonsWidget extends StatelessWidget {
  final Color? color, textColor;
  final String icons, text;
  const LoginButtonsWidget({
    super.key,
    required this.text,
    required this.textColor,
    required this.color,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(45.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 24.h,
            width: 24.w,
            child: Center(child: SvgPicture.asset(icons)),
          ),
          Gap(4.w),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
