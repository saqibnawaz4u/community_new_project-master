import 'dart:ffi';

import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';

Widget customRow({
  IconData? icon,
  String? text,
  double? size,
  Color? iconcolor,
  textColor,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Row(
      children: [
        Icon(
          icon,
          size: size,
          color: iconcolor,
        ),
        SizedBox(
          width: 20.0,
        ),
        Text(
          text.toString(),
          style: TextStyle(
            color: textColor,
            fontSize: 15.0,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    ),
  );
}
