import 'package:community_new/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListTileInProfileScreen extends StatelessWidget {
  const ListTileInProfileScreen({Key? key, required this.icon,
  required this.text
  }) : super(key: key);
final Icon icon;
final String text;
  @override
  Widget build(BuildContext context) {
    return ListTile(
          title: Row(children: [
            icon,
            widthSizedBox8,
            Text(text)
          ],),
    );
  }
}
