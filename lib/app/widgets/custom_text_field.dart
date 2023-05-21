import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';

class CustomTextField extends StatelessWidget {
  final bool? isNumber;
  final bool? obscure;
  final bool? isPassword;
  final TextEditingController controller;
  final String hintText;
  final Widget? icon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.isNumber = false,
    this.obscure = false,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFF7F8F9),
        border: Border.all(color: Color(0xFF569F00)),
      ),
      child: TextFormField(
        inputFormatters: isNumber!
            ? [
                LengthLimitingTextInputFormatter(12),
                FilteringTextInputFormatter.digitsOnly,
              ]
            : [],
        obscureText: isPassword! ? obscure! : false,
        controller: controller,
        style: TextStyle(
          color: Colors.black,
        ),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: ListTextStyle.textStyleGray,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          suffixIcon: icon ?? icon,
        ),
      ),
    );
  }
}
