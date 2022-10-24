import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const whiteTextStyle =
    TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.normal);
const blkTextStyle24 =
    TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.normal);
const whiteTextStyleNormal =
    TextStyle(color: Colors.white, fontWeight: FontWeight.normal);
const BlackTextStyleNormal =
    TextStyle(color: Colors.black, fontWeight: FontWeight.normal);
const BlackTextStyleBold18 =
    TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18);
const greyTextStyleNormal = TextStyle(
  color: Colors.grey,
  fontWeight: FontWeight.normal,
);
const midPadding = Padding(padding: EdgeInsets.all(8));
const midPadding2 = Padding(padding: EdgeInsets.only(top: 8));
const topPadding10 = Padding(padding: EdgeInsets.only(top: 10));
const topPadding12 = Padding(padding: EdgeInsets.only(top: 12));
const topPadding14 = Padding(padding: EdgeInsets.only(top: 14));
const topPadding16 = Padding(padding: EdgeInsets.only(top: 16));
const topPadding18 = Padding(padding: EdgeInsets.only(top: 18));

const widthSizedBox = SizedBox(
  width: 5,
);
const widthSizedBox8 = SizedBox(
  width: 8,
);
const backgroundColor = Color(0xFFF6F9FB);
const appColor = Color(
    0xff2c2e36); //#003F37 dark green color   //8BBAF0 BLUE CLR OF APP//lightgreen 108677
const blackColor = Color(0xFF000000);
const buttonColor = Color(0xFF5CB3FF);
const whiteColor = Color(0xFFFFFFFF);
const offWhite = Color(0xFFFFFAF6);
const greyicon = Color(0xFF576C79);
const deleteColor = Color(0xFFFF0000);
const addColor = Color(0xFF000000);
const LightBlueColor = Color(0xFFBBD9FA);
const blueColor = Color(0xFF000000);
const textColor = Color(0xff93573c);
const containerPrayerTime = Color(0xffddc2ae);
// Colors.green.shade50;
const assignText = Color(0xFFABB0BE);
const assignButton = Color(0xFFF6F9FB);
const BlackTextStyleNormal16 =
    TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16);
const widthSizedBox12 = SizedBox(
  width: 12,
);
const whiteTextStyleNormalButtons =
    TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16);
const whiteTextStyleNormalTabbar =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18);
const whiteTextStyleNormalTabbar16 =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16);
const appcolorTextStylebold =
    TextStyle(color: appColor, fontWeight: FontWeight.bold, fontSize: 18);
const appcolorTextStylenormal = TextStyle(
  color: appColor,
);
const double size = 18;
ButtonStyle? crudButtonStyle = ElevatedButton.styleFrom(
    shape: CircleBorder(), primary: whiteColor, onPrimary: appColor);
Icon deleteIcon = Icon(
  CupertinoIcons.delete,
  color: deleteColor,
  size: size,
);
FaIcon editIcon = FaIcon(
  FontAwesomeIcons.edit,
  color: Color(0xFF8BBAF0),
  size: size,
);
const appbarShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(
    bottom: Radius.circular(12),
  ),
);
var prefs;

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14),
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
    // border: Border(
    //   top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    // ),

    );
