import 'package:dimple/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField<T> extends StatelessWidget {
  final ValueChanged<T>? onChanged;
  final TextEditingController controller;
  final String labelText;
  final bool isNumber;
  final double? width;
  final double? height;
  final bool autofocus;
  final String? hintText;

  const CustomTextFormField({
    super.key,
    this.onChanged,
    required this.controller,
    required this.labelText,
    this.isNumber = false,
    this.width = 135,
    this.height = 50,
    this.autofocus = false,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(
        color: Color(0xFFF3F2F2),
        width: 1.0,
      ),
    );

    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(labelText.isNotEmpty)
        Text(
          labelText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          width: width,
          height: height,
          child: TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            cursorColor: PRIMARY_COLOR,
            autofocus: autofocus,
            onChanged: (value) {
              if (onChanged != null) {
                if (isNumber) {
                  final parsedValue = double.tryParse(value);
                  if (parsedValue != null) {
                    onChanged!(parsedValue as T);
                  }
                } else {
                  onChanged!(value as T);
                }
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              fillColor: Color(0xFFFBFBFB),
              filled: false,
              border: baseBorder,
              enabledBorder: baseBorder,
              focusedBorder: baseBorder.copyWith(
                borderSide: baseBorder.borderSide.copyWith(
                  color: PRIMARY_COLOR,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}