import 'package:community_new/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/home/home2.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);
  showAlertDialog(BuildContext context) {
    // Create button
    Widget yesButton = TextButton(

        onPressed: (){
          Navigator.of(context, rootNavigator: true)
              .pop(true);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>
              home2()));
        },
        child: Text('yes',style: TextStyle(
            color: appColor
        ),));
    Widget noButton =   TextButton(onPressed: (){
      Navigator.of(context, rootNavigator: true)
          .pop(false);
    },
        child: Text('no',style: TextStyle(
            color: appColor
        ),));

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      title: Text("Alert"),
      content: Text("Are you sure you want to go back?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                showAlertDialog(context);
              },
              icon: Icon(CupertinoIcons.chevron_left,color: appColor,)
            ),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.jpeg'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
