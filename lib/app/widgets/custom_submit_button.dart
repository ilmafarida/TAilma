import 'package:flutter/material.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';

class CustomSubmitButton extends StatelessWidget {
  final VoidCallback onTap;
  final double width;
  final double height;
  final String text;
  const CustomSubmitButton({
    super.key,
    required this.onTap,
    this.width = double.infinity,
    this.height = 52,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(ListColor.colorButtonGreen),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: ListTextStyle.textStyleGray.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
