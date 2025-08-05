import 'package:chat_app/module/auth/controller/auth_controller.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authCtr, child) => Container(
        padding: EdgeInsets.only(left: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Color(0xFFD5CFD0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24.h,
              width: 24.w,
              child: SvgPicture.asset("assets/icons/phoneOtp.svg"),
            ),
            SizedBox(
              width: 50.w,
              child: CountryCodePicker(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                onChanged: (code) {
                  authCtr.assignCountryCode(code.dialCode.toString());
                },
                initialSelection: 'IN',
                favorite: ['+91', 'IN'],
                showFlag: false,
                showDropDownButton: false,
                textStyle: GoogleFonts.poppins(
                  color: Color(0Xff2E0E16),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
                alignLeft: false,
                dialogTextStyle: TextStyle(fontSize: 16.sp),
                flagWidth: 0,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Color(0xFFD5CFD0)),
            Divider(color: Colors.red, thickness: 20),
            Expanded(
              child: TextFormField(
                controller: authCtr.phoneController,
                maxLength: 10,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2E0E16),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: "Enter phone number",
                  border: InputBorder.none,
                  isDense: true,
                  counterText: '',
                ),
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
