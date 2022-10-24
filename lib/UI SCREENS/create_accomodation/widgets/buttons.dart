import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';

Widget customEmailBtn([VoidCallback? onPress, String? text]) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        primary: appColor,
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          text!,
          style: TextStyle(
            color: whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

Widget customCallBtn([VoidCallback? onPress1, String? text]) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: ElevatedButton(
      onPressed: onPress1,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: appColor,
          ),
        ),
        primary: Colors.white,
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          text!,
          style: TextStyle(
            color: appColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
