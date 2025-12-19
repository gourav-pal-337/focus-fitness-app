import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppTextStyle {
  static const String montserat = "Montserrat";
  static const String lato = 'Lato';
  static const String defaultFontFamily = lato;

  // 48px Text Styles
  static TextStyle text48Regular = TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w400, // regular
    height: 1.22, // 44px
    letterSpacing: -0.72, // -2%
    fontFamily: defaultFontFamily,
  );

  static TextStyle text48Medium = TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w500, // medium
    height: 1.22, // 44px
    letterSpacing: -0.72, // -2%
    fontFamily: defaultFontFamily,
  );

  static TextStyle text48SemiBold = TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.22, // 44px
    letterSpacing: -0.72, // -2%
    fontFamily: defaultFontFamily,
  );

  static TextStyle text48Bold = TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w700, // bold
    height: 1.22, // 44px
    letterSpacing: -0.72, // -2%
    fontFamily: defaultFontFamily,
  );

  // 36px Text Styles
  static TextStyle text36Regular = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w400, // regular
    height: 1.22, // 44px
    letterSpacing: -0.72, // -2%
    fontFamily: defaultFontFamily,
  );

  static TextStyle text36Medium = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w500, // medium
    height: 1.22, // 44px
    letterSpacing: -0.72, // -2%
    fontFamily: defaultFontFamily,
  );

  static TextStyle text36SemiBold = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.22, // 44px
    letterSpacing: -0.72, // -2%
    fontFamily: defaultFontFamily,
  );

  static TextStyle text36Bold = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w700, // bold
    height: 1.22, // 44px
    letterSpacing: -0.72, // -2%
    fontFamily: defaultFontFamily,
  );
  
  // 32px Text Styles
  static TextStyle text32Regular = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w400, // regular
    height: 1.27, // 38px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text32Medium = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w500, // medium
    height: 1.27, // 38px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text32SemiBold = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.27, // 38px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text32Bold = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700, // bold
    height: 1.27, // 38px
    fontFamily: defaultFontFamily,
  );



  // 28px Text Styles
  static TextStyle text28Regular = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w400, // regular
    height: 1.33, // 32px
    fontFamily: defaultFontFamily,
  );
  static TextStyle text28Medium = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w500, // medium
    height: 1.33, // 32px
    fontFamily: defaultFontFamily,
  );
  static TextStyle text28SemiBold = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.33, // 32px
    fontFamily: defaultFontFamily,
  );
  static TextStyle text28Bold = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700, // bold
    height: 1.33, // 32px
    fontFamily: defaultFontFamily,
  );


  // 24px Text Styles
  static TextStyle text24Regular = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w400, // regular
    height: 1.33, // 32px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text24Medium = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500, // medium
    height: 1.33, // 32px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text24SemiBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.33, // 32px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text24Bold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700, // bold
    height: 1.33, // 32px
    fontFamily: defaultFontFamily,
  );

  // 20px Text Styles
  static TextStyle text20Regular = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400, // regular
    height: 1.5, // 30px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text20Medium = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500, // medium
    height: 1.5, // 30px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text20SemiBold = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.5, // 30px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text20Bold = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700, // bold
    height: 1.5, // 30px
    fontFamily: defaultFontFamily,
  );

  // 18px Text Styles
  static TextStyle text18Regular = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400, // regular
    height: 1.56, // 28px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text18Medium = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500, // medium
    height: 1.56, // 28px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text18SemiBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.56, // 28px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text18Bold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700, // bold
    height: 1.56, // 28px
    fontFamily: defaultFontFamily,
  );

  // 16px Text Styles
  static TextStyle text16Regular = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400, // regular
    height: 1.5, // 24px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text16Medium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500, // medium
    height: 1.5, // 24px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text16SemiBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.5, // 24px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text16Bold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700, // bold
    height: 1.5, // 24px
    fontFamily: defaultFontFamily,
  );

  // 14px Text Styles
  static TextStyle text14Regular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400, // regular
    height: 0.71, // 10px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text14Medium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500, // medium
    height: 1.43, // 20px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text14SemiBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.43, // 20px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text14Bold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700, // bold
    height: 1.43, // 20px
    fontFamily: defaultFontFamily,
  );

  // 12px Text Styles
  static TextStyle text12Regular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400, // regular
    height: 1.5, // 18px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text12Medium = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500, // medium
    height: 1.5, // 18px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text12SemiBold = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.5, // 18px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text12Bold = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700, // bold
    height: 1.5, // 18px
    fontFamily: defaultFontFamily,
  );
  
  
  // 10px Text Styles
  static TextStyle text10Regular = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400, // regular
    height: 1.5, // 18px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text10Medium = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500, // medium
    height: 1.5, // 18px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text10SemiBold = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.5, // 18px
    fontFamily: defaultFontFamily,
  );

  static TextStyle text10Bold = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700, // bold
    height: 1.5, // 18px
    fontFamily: defaultFontFamily,
  );
  
}