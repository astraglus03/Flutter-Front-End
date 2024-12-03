import 'package:dimple/common/const/colors.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? fontSize;

  const SubmitButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.fontSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null ? width : MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: PRIMARY_COLOR,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}