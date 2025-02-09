import 'package:dimple/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const double SCROLL_THRESHOLD = 620.0;
const double TAB_OPACITY_RANGE = 100.0;
const double SECTION_VISIBILITY_TOP = 180.0;
const double SECTION_VISIBILITY_BOTTOM = -100.0;

class AppTextStyles {
  static TextStyle heading1 = TextStyle(
    fontFamily: 'SUIT',
    fontWeight: FontWeight.bold,
    fontSize: 30.sp,
    height: 42 / 30,
  );

  static TextStyle heading2 = TextStyle(
    fontFamily: 'SUIT',
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
    height: 34 / 24,
  );

  static TextStyle title = TextStyle(
    fontFamily: 'SUIT',
    fontWeight: FontWeight.bold,
    fontSize: 20.sp,
    height: 28 / 20,
  );

  static TextStyle subtitle = TextStyle(
    fontFamily: 'SUIT',
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
    height: 22 / 16,
  );

  static TextStyle body1 = TextStyle(
    fontFamily: 'SUIT',
    fontWeight: FontWeight.bold,
    fontSize: 14.sp,
    height: 20 / 14,
  );

  static TextStyle body2 = TextStyle(
    fontFamily: 'SUIT',
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    height: 18 / 14,
  );

  static TextStyle caption1 = TextStyle(
    fontFamily: 'SUIT',
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    height: 18 / 14,
  );

  static TextStyle caption2 = TextStyle(
    fontFamily: 'SUIT',
    fontWeight: FontWeight.w600,
    fontSize: 12.sp,
    height: 16 / 12,
  );

  static const TextStyle caption3 = TextStyle(
    fontFamily: 'SUIT',
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 16 / 10,
  );

  static TextStyle splashTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20.sp,
    color: WHITE100_COLOR,
  );
}

const baseBorder = BorderSide(
  width: 1,
  color: GRAY200_COLOR,
);
