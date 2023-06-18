import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';

class CustomTextField extends StatelessWidget {
  final bool? isNumber;
  final bool? obscure;
  final bool? isPassword;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? icon;
  final bool? isWithBorder;
  final int? maxLines;
  final VoidCallback? onTap;
  final String? title;
  final String? value;
  final String? validator;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.icon,
    this.isNumber = false,
    this.obscure = false,
    this.isPassword = false,
    this.maxLines,
    this.isWithBorder = true,
    this.onTap,
    this.title,
    this.value,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFF7F8F9),
        border: Border.all(color: isWithBorder! ? Color(0xFF569F00) : Colors.transparent),
      ),
      child: onTap != null
          ? GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        value != "" ? value! : title!,
                        style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14, color: value != "" ? Colors.black : Colors.grey),
                      ),
                    ),
                    SizedBox(width: 10),
                    Spacer(),
                    icon ?? SizedBox.shrink()
                  ],
                ),
              ),
            )
          : TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
              maxLines: maxLines ?? 1,
              showCursor: true,
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
              validator: (value) {
                if (value!.isEmpty) {
                  return validator;
                }
              },
            ),
    );
  }
}
