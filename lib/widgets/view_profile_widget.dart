import 'package:community_new/UI%20SCREENS/profile_Directory/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/styles.dart';

class ViewProfileListTile extends StatelessWidget {
  const ViewProfileListTile({Key? key}) : super(key: key);
  final String firstName="FirstName",lastName="LastName";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListTile(
        title: Row(children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: IconButton(onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>  const ChoosingProfile()));
            },
                icon: const Icon(Icons.person,color: Colors.black,)),),widthSizedBox8,

          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(firstName,style: whiteTextStyleNormal,),
                    Text(lastName,style: whiteTextStyleNormal,),
                  ],),
                Align(
                  alignment: Alignment.bottomLeft,
                  child:InkWell(
                    child: const Text("View Profile",style:whiteTextStyleNormal),
                    onTap: (){},),
                )
              ]
          ),

        ],)
      ),
    );
  }
}

