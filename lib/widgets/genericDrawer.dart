import 'package:community_new/UI%20SCREENS/Events_new/Events.dart';
import 'package:community_new/UI%20SCREENS/dashboard/Dashboard.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/fav_masjid.dart';
import 'package:community_new/UI%20SCREENS/updateProfile/UpdateProfile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../UI SCREENS/Menues/RSSTab.dart';
import '../UI SCREENS/credentials/log_in.dart';
import '../constants/styles.dart';

class genericDrawerForUser extends StatefulWidget {
  const genericDrawerForUser({Key? key}) : super(key: key);

  @override
  State<genericDrawerForUser> createState() => _genericDrawerForUserState();
}

class _genericDrawerForUserState extends State<genericDrawerForUser> {
  String currentUserName = prefs.get('userName');
  String currentUserEmail = prefs.get('email');
  int currentindex = 0;
  int currentUserId = prefs.get('userId');
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: whiteColor,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            // decoration: BoxDecoration(
            //   color: Color(0xffd08e63),
            //   border: Border(
            //     bottom: BorderSide(color: Colors.grey),
            //   ),
            // ),
            child: Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: 10.0,
              //   vertical: 10.0,
              // ),
              decoration: BoxDecoration(
                color: Color(0xffd08e63),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                  midPadding2,
                  Text(
                    currentUserName,
                    style: TextStyle(color: whiteColor, fontSize: 14),
                  ),
                  midPadding2,
                  Text(
                    currentUserEmail,
                    style: TextStyle(color: whiteColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => updateProfile(
                                isNew: false,
                              )));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffddc2ae),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('View Profile',
                      style: TextStyle(
                        color: Color(0xff93573c),
                      )),
                ),
              ),
              SizedBox(
                height: 300,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(builder: (_) => LogIn()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffddc2ae),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xff93573c),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // GridView(
          //   primary: false,
          //   shrinkWrap: true,
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2, childAspectRatio: 2),
          //   children: [
          //     cardOfDrawer(
          //         'Dashboard',
          //         FontAwesomeIcons.home,
          //         appColor,
          //         HomeTabState.currentTab == 0
          //             ? () {}
          //             : () {
          //                 // Navigator.of(context).push(MaterialPageRoute(
          //                 //     builder: (_) => Dashboard()
          //                 // ));
          //                 // setState(() {
          //                 //   HomeTabState.currentTab=0;
          //                 //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
          //                 // });
          //               }),
          //     cardOfDrawer(
          //         'Prayer time', FontAwesomeIcons.pray, appColor, () {}),
          //     cardOfDrawer('Accommodation', MdiIcons.bed, appColor, () {}),
          //     cardOfDrawer('Notifications', MdiIcons.bell, appColor, () {}),
          //     cardOfDrawer('Messages', MdiIcons.chat, appColor, () {}),
          //     cardOfDrawer('Events', MdiIcons.calendarAlert, appColor, () {
          //       Navigator.push(
          //           context, MaterialPageRoute(builder: (context) => Events()));
          //     }),
          //     cardOfDrawer('My Masajids', Icons.favorite, appColor, () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => Fav_masajids()));
          //     }),
          //     cardOfDrawer(
          //         'Update Profile', Icons.mode_edit_outline_outlined, appColor,
          //         () {
          //       Navigator.of(context, rootNavigator: false)
          //           .push(MaterialPageRoute(
          //               builder: (_) => updateProfile(
          //                     isNew: false,
          //                     userId: currentUserId,
          //                   )));
          //     }),
          //     cardOfDrawer('Log out', Icons.logout, Colors.red, () {
          //       Navigator.of(context, rootNavigator: true)
          //           .push(MaterialPageRoute(builder: (_) => LogIn()));
          //     }),
          //   ],
          // )
        ],
      ),
    );
  }

  Widget cardOfDrawer(
    final String title,
    final IconData icon,
    final Color iconclr,
    final VoidCallback onpressed,
  ) {
    return GestureDetector(
      onTap: onpressed,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: whiteColor,
        elevation: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconclr,
            ),
            midPadding2,
            Text(title),
          ],
        ),
      ),
    );
  }
}

class genericDrawerForMA extends StatefulWidget {
  const genericDrawerForMA({Key? key}) : super(key: key);

  @override
  State<genericDrawerForMA> createState() => _genericDrawerForMAState();
}

class _genericDrawerForMAState extends State<genericDrawerForMA> {
  String currentUserName = prefs.get('userName');
  String currentUserEmail = prefs.get('email');
  int currentUserId = prefs.get('userId');
  int currentindex = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: whiteColor,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            // decoration: BoxDecoration(
            //     color: whiteColor,
            //     border: Border(bottom: BorderSide(color: Colors.grey))),
            child: Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: 10.0,
              //   vertical: 10.0,
              // ),
              decoration: BoxDecoration(
                color: Color(0xffd08e63),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                  midPadding2,
                  Text(
                    currentUserName,
                    style: TextStyle(color: whiteColor, fontSize: 14),
                  ),
                  midPadding2,
                  Text(
                    currentUserEmail,
                    style: TextStyle(color: whiteColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => updateProfile(
                                isNew: false,
                              )));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffddc2ae),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('View Profile',
                      style: TextStyle(
                        color: Color(0xff93573c),
                      )),
                ),
              ),
              SizedBox(
                height: 300,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(builder: (_) => LogIn()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffddc2ae),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xff93573c),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // GridView(
          //   primary: false,
          //   shrinkWrap: true,
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2, childAspectRatio: 2),
          //   children: [
          //     cardOfDrawer('Masjids', MdiIcons.mosque, appColor, () {}),
          //     cardOfDrawer('Users', MdiIcons.account, appColor, () {}),
          //     cardOfDrawer('Events', MdiIcons.calendarAlert, appColor, () {}),
          //     cardOfDrawer('Set Time', MdiIcons.calendar, appColor, () {}),
          //     cardOfDrawer(
          //         'Update Profile', Icons.mode_edit_outline_outlined, appColor,
          //         () {
          //       Navigator.of(context, rootNavigator: false)
          //           .push(MaterialPageRoute(
          //               builder: (_) => updateProfile(
          //                     isNew: false,
          //                     userId: currentUserId,
          //                   )));
          //     }),
          //     cardOfDrawer('Log out', Icons.logout, Colors.red, () {
          //       Navigator.of(context, rootNavigator: true)
          //           .push(MaterialPageRoute(builder: (_) => LogIn()));
          //     }),
          //   ],
          // )
        ],
      ),
    );
  }

  Widget cardOfDrawer(
    final String title,
    final IconData icon,
    final Color iconclr,
    final VoidCallback onpressed,
  ) {
    return GestureDetector(
      onTap: onpressed,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: whiteColor,
        elevation: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconclr,
            ),
            midPadding2,
            Text(title),
          ],
        ),
      ),
    );
  }
}

class genericDrawerForSA extends StatefulWidget {
  const genericDrawerForSA({Key? key}) : super(key: key);

  @override
  State<genericDrawerForSA> createState() => _genericDrawerForSAState();
}

class _genericDrawerForSAState extends State<genericDrawerForSA> {
  String currentUserName = prefs.get('userName');
  String currentUserEmail = prefs.get('email');
  int currentindex = 0;
  int currentUserId = prefs.get('userId');
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: whiteColor,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            // decoration: BoxDecoration(
            //     color: whiteColor,
            //     border: Border(bottom: BorderSide(color: Colors.grey))),
            child: Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: 10.0,
              //   vertical: 10.0,
              // ),
              decoration: BoxDecoration(
                color: Color(0xffd08e63),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                  midPadding2,
                  Text(
                    currentUserName,
                    style: TextStyle(color: whiteColor, fontSize: 14),
                  ),
                  midPadding2,
                  Text(
                    currentUserEmail,
                    style: TextStyle(color: whiteColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => updateProfile(
                                isNew: false,
                                userId: currentUserId,
                              )));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffddc2ae),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('View Profile',
                      style: TextStyle(
                        color: Color(0xff93573c),
                      )),
                ),
              ),
              SizedBox(
                height: 300,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(builder: (_) => LogIn()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffddc2ae),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xff93573c),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // GridView(
          //   primary: false,
          //   shrinkWrap: true,
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       childAspectRatio: 2
          //   ),
          //   children: [
          //     // cardOfDrawer('Organizations',MdiIcons.home,appColor,
          //     //         (){}),
          //     // cardOfDrawer('Users',MdiIcons.account,appColor,(){}),
          //     // cardOfDrawer('Masjids',MdiIcons.mosque,appColor,(){}),
          //     // cardOfDrawer('Events',MdiIcons.calendarAlert,appColor,(){}),
          //     // cardOfDrawer('Accommodations',MdiIcons.bed,appColor,(){}),
          //     // cardOfDrawer('Update Profile',Icons.mode_edit_outline_outlined,appColor,(){
          //     //   Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
          //     //       builder: (_) => updateProfile(isNew: false,userId: currentUserId,)
          //     //   ));}),
          // cardOfDrawer('Log out',Icons.logout,Colors.red,(){
          //   Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          //       builder: (_) => LogIn()
          //   ));}),
          //   ],
          // )
        ],
      ),
    );
  }

  Widget cardOfDrawer(
    final String title,
    final IconData icon,
    final Color iconclr,
    final VoidCallback onpressed,
  ) {
    return GestureDetector(
      onTap: onpressed,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: whiteColor,
        elevation: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconclr,
            ),
            midPadding2,
            Text(title),
          ],
        ),
      ),
    );
  }
}

class genericDrawerForOA extends StatefulWidget {
  const genericDrawerForOA({Key? key}) : super(key: key);

  @override
  State<genericDrawerForOA> createState() => _genericDrawerForOAState();
}

class _genericDrawerForOAState extends State<genericDrawerForOA> {
  String currentUserName = prefs.get('userName');
  String currentUserEmail = prefs.get('email');
  int currentindex = 0;
  int currentUserId = prefs.get('userId');
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: whiteColor,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            // decoration: BoxDecoration(
            //     color: whiteColor,
            //     border: Border(bottom: BorderSide(color: Colors.grey))),
            child: Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: 10.0,
              //   vertical: 10.0,
              // ),
              decoration: BoxDecoration(
                color: Color(0xffd08e63),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                  midPadding2,
                  Text(
                    currentUserName,
                    style: TextStyle(color: whiteColor, fontSize: 14),
                  ),
                  midPadding2,
                  Text(
                    currentUserEmail,
                    style: TextStyle(color: whiteColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          GridView(
            primary: false,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 2),
            children: [
              cardOfDrawer('Organizations', MdiIcons.home, appColor, () {}),
              cardOfDrawer('Users', MdiIcons.account, appColor, () {}),
              cardOfDrawer('Masjids', MdiIcons.mosque, appColor, () {}),
              cardOfDrawer('Events', MdiIcons.calendarAlert, appColor, () {}),
              cardOfDrawer(
                  'Update Profile', Icons.mode_edit_outline_outlined, appColor,
                  () {
                Navigator.of(context, rootNavigator: false)
                    .push(MaterialPageRoute(
                        builder: (_) => updateProfile(
                              isNew: false,
                              userId: currentUserId,
                            )));
              }),
              cardOfDrawer('Log out', Icons.logout, Color(0xff93573c), () {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(builder: (_) => LogIn()));
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget cardOfDrawer(
    final String title,
    final IconData icon,
    final Color iconclr,
    final VoidCallback onpressed,
  ) {
    return GestureDetector(
      onTap: onpressed,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: whiteColor,
        elevation: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconclr,
            ),
            midPadding2,
            Text(title),
          ],
        ),
      ),
    );
  }
}

// ListView(
// // Important: Remove any padding from the ListView.
// padding: EdgeInsets.zero,
// children: [
// DrawerHeader(
// decoration: BoxDecoration(
// color: appColor,
// ),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// SizedBox(height: 15,),
// CircleAvatar(
// radius: 30,
// backgroundImage: AssetImage('assets/user.png'),
// ),
// midPadding2,
// Text(currentUserName,style: TextStyle(color: whiteColor,fontSize: 16),),
// midPadding2,
// Text('email@gmail.com',style: TextStyle(color: whiteColor,fontSize: 16),),
// ],
// )
// ),
// ListTile(
// leading: Icon(
// FontAwesomeIcons.home,color: appColor,
// ),
// title: const Text('Dashboard'),
// onTap: () {
// Navigator.pop(context);
// },
// ),
// ListTile(
// leading: Icon(
// FontAwesomeIcons.pray,color: appColor,
// ),
// title: const Text('Prayer time'),
// onTap: () {
// Navigator.pop(context);
// },
// ),
// ListTile(
// leading: Icon(
// MdiIcons.bed,color: appColor,
// ),
// title: const Text('Accomodation'),
// onTap: () {
// Navigator.pop(context);
// },
// ),
// ListTile(
// leading: Icon(
// MdiIcons.calendarAlert,color: appColor,
// ),
// title: const Text('Events'),
// onTap: () {
// Navigator.pop(context);
// },
// ),
// ListTile(
// leading: Icon(
// Icons.favorite,color: appColor,
// ),
// title: const Text('My Masajids'),
// onTap: () {
// Navigator.pop(context);
// },
// ),
// Divider(thickness: 1,),
// ListTile(
// leading: Icon(
// Icons.logout,color: Colors.red,
// ),
// title: const Text('Logout'),
// onTap: (){
// Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
// builder: (_) => LogIn()
// ));
// },
// ),
// ],
// ),