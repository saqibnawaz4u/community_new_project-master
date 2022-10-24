import 'package:community_new/UI%20SCREENS/Users/UserList.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/creating_accomodation.dart';
import 'package:community_new/UI%20SCREENS/creating_new_jobs/create_job.dart';
import 'package:community_new/UI%20SCREENS/credentials/log_in.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/Masjids.dart';
import 'package:community_new/widgets/bottom_sheet_data.dart';
import 'package:community_new/UI%20SCREENS/business_screens/creating_new_business.dart';
import 'package:community_new/UI%20SCREENS/create_new_products/creating_products.dart';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Events_new/EventEditNew.dart';
import '../../credentials/sign_up.dart';

class MyHomeOld extends StatefulWidget {

   MyHomeOld({Key? key,}) : super(key: key);

  @override
  _MyHomeOldState createState() => _MyHomeOldState();
}

class _MyHomeOldState extends State<MyHomeOld > {

  int _selectedIndex = 0;
  static  List<Widget> _widgetOptions = <Widget>[
    CreatingAccommodationScreen(),
    CreatingBusinessScreen(),CreatingProductScreen(),
    CreatingJobScreen(),UserList(),Masjids()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert =  AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      title: Column(
        children: [
          OutlineButtonWidget(
            color: appColor,
            buttonText: "Create Event", routing: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) =>   EventEditnew(eventId: 0, isNew: true)));
          },),
          OutlineButtonWidget(
            color: appColor,
            buttonText: "Post a job listing", routing: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) =>   CreatingJobScreen()));
          },),
          OutlineButtonWidget(
            color: appColor,
            buttonText: "List a Product", routing: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) =>   CreatingProductScreen()));
          },),
          OutlineButtonWidget(
            color: appColor,
            buttonText: "Post Accommodation Listing", routing: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) =>   CreatingAccommodationScreen()));
          },),
        ],
      )
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
    return Scaffold(
      bottomSheet: _selectedIndex==4? _buildBottomSheet(context):null,
      floatingActionButton: _selectedIndex == 0 ?FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(CupertinoIcons.add),
        onPressed: () {
          showAlertDialog(context);
        },):null,
      // appBar: _selectedIndex==0?AppBar(
      //     leading: IconButton(onPressed: (){}, icon: const Icon(Icons.search),),
      //     actions: [
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: CircleAvatar(
      //           backgroundColor: Colors.grey.shade200,
      //           child: IconButton(onPressed: (){
      //             Navigator.push(
      //                 context, MaterialPageRoute(builder: (context) =>  const ChoosingProfile()));
      //           },
      //               icon: const Icon(Icons.person,color: Colors.black,)),),
      //       )
      //     ],
      //     backgroundColor:appbarColor
      // ):null,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey.shade400,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'My Community',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.event),
               label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.comments),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'More',
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          iconSize: 24,
          onTap: _onItemTapped,
          elevation: 5
      ),
    );
  }

     _buildBottomSheet(BuildContext context) {
      return Container(
        height : 300.0,
        width: MediaQuery.of(context).size.width,
        color  : backgroundColor,
        child  : Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.only(
                  topLeft:  Radius.circular(20.0),
                  topRight:  Radius.circular(20.0),
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BottomSheetData(
                      iconButton:  IconButton(color: appColor,
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>  const LogIn()));
                          },
                          icon: const Icon(Icons.store)),
                      text: "Marketplace",
                    ),
                    BottomSheetData(
                      iconButton:  IconButton(color: appColor,
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>  const CreatingJobScreen()));
                          },
                          icon: const Icon(Icons.work)),
                      text: "Jobs",
                    )
                  ],),midPadding2,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BottomSheetData(
                      iconButton:  IconButton(color: appColor,
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>  const CreatingAccommodationScreen()));
                          },
                          icon: const Icon(Icons.hotel)),
                      text: "Accommodations",
                    ),
                    BottomSheetData(
                      iconButton:  IconButton(color: appColor,
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>  const signUp()));
                          },
                          icon: const Icon(Icons.spa)),
                      text: "Funeral Services",
                    )
                  ],)
              ],
            )
        ),
      );
    }}


class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget({Key? key,required this.buttonText,
    required this.routing,this.color}) : super(key: key);
  final String buttonText;
  final VoidCallback routing;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width/1.5,
      height: MediaQuery.of(context).size.height/15,
      child: OutlinedButton(
        onPressed: () {
          routing();
        },
        style: ElevatedButton.styleFrom(
            primary: color, // background
            //onPrimary: color,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))
            )// foreground
        ),
        child: Text(buttonText,style: const TextStyle(color: Colors.black),),
      ),
    );
  }
}