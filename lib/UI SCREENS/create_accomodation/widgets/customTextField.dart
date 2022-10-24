import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';

Widget customTextField({
  String? text,
  TextEditingController? controller,
  TextInputType? inputType,
  bool? obscureText,
  Icon? icon,
  IconButton? suffixIcon,
  int? length,
}) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.black54, blurRadius: 1.0, offset: Offset(0.0, 0.75))
      ],
      color: whiteColor,
    ),
    child: TextFormField(
      keyboardType: TextInputType.multiline,
      controller: controller,
      maxLines: 10,
      minLines: 1,
      maxLength: length,
      obscureText: false,
      decoration: InputDecoration(
        hintText: text!,
        prefixIcon: icon,
        suffixIcon: suffixIcon,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          // fontSize: 10.0,
        ),
      ),
    ),
  );
}
