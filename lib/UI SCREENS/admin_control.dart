import 'package:community_new/UI%20SCREENS/Users/UserList.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/prayerTimes/MasjidPrayerTiming.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/Masjids.dart';
import 'package:community_new/UI%20SCREENS/roles/Roles.dart';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Events_new/Events.dart';
import 'Menues/oldMenus/home_screen.dart';


class ControlNavigation extends StatefulWidget {
  const ControlNavigation({Key? key}) : super(key: key);

  @override
  State<ControlNavigation> createState() => _ControlNavigationState();
}

class _ControlNavigationState extends State<ControlNavigation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: appColor,
        child: Icon(Icons.home,color: blackColor,),
        onPressed: () {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) =>   MyHomeOld()));
          },
      ),
      backgroundColor: Colors.transparent,
      body: Scaffold(
        backgroundColor:whiteColor,

        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const Align(
                alignment: Alignment.topCenter,
                child: Text('Navigator',style: TextStyle(color: blackColor),)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      appColor,
                      Colors.white,
                      Colors.lightBlueAccent,
                      Colors.blue
                    ],
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 25,right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height/16,
                      width: MediaQuery.of(context).size.width,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        24))),
                            elevation: 2,
                          primary: Colors.blueGrey,
                          onPrimary: whiteColor
                        ),
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>   UserList()));
                          },
                          child: Text("Users",style: whiteTextStyleNormalButtons,)),
                    ),midPadding2,
                    Container(
                      height: MediaQuery.of(context).size.height/16,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          24))),
                              elevation: 2,
                              primary: Colors.blueAccent,
                              onPrimary: whiteColor
                          ),
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>   Events()));
                          },
                          child: Text("Events",style: whiteTextStyleNormalButtons,)),
                    ),midPadding2,
                    Container(
                      height: MediaQuery.of(context).size.height/16,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          24))),
                              elevation: 2,
                              primary: Colors.blue.shade200,
                              onPrimary: whiteColor
                          ),
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>  const Masjids()));
                          },
                          child: Text("Masjids",style: whiteTextStyleNormalButtons,)),
                    ),midPadding2,
                    Container(
                      height: MediaQuery.of(context).size.height/16,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          24))),
                              elevation: 2,
                              primary: Colors.blue.shade600,
                              onPrimary: whiteColor
                          ),
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>   MasjidPrayerTiming()));
                          },
                          child: Text("Masjid Prayer Times",style: whiteTextStyleNormalButtons,)),
                    ),midPadding2,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/16,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          24))),
                              elevation: 2,
                              primary: Colors.lightBlueAccent,
                              onPrimary: whiteColor
                          ),
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>   Roles()));
                          },
                          child: Text("Roles",style: whiteTextStyleNormalButtons,)),
                    ),midPadding2,
                  ],
                ),
              ),
            ),
          )
        ],),
      ),
    );
  }
}
