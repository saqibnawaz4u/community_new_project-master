import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';

class BottomSheetData extends StatelessWidget {
  const BottomSheetData({Key? key,required this.iconButton,required this.text}) : super(key: key);
final IconButton iconButton;
final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       iconButton,
        Text(text)
      ],
    );
  }
}
