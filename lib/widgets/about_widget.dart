import 'package:community_new/UI%20SCREENS/profile_Directory/profile_screen.dart';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutWidget extends StatefulWidget {
  const AboutWidget({Key? key}) : super(key: key);

  @override
  State<AboutWidget> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutWidget> {
  String firstName="FirstName";
  String lastName = "lastName";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            },
              icon:const Icon(Icons.arrow_back),
            ),
            IconButton(onPressed: (){},
              icon: FaIcon(FontAwesomeIcons.pen,size: 20,),
              color: appColor,)
          ],),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade200,
            child: IconButton(onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>  const ChoosingProfile()));
            },
                icon: const Icon(Icons.person,color: Colors.black,size: 35,)),),
          midPadding2,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(firstName,),
              Text(lastName,),
            ],),
        ],
      ),
    );
  }
}
