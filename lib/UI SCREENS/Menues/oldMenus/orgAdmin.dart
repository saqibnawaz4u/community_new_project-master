import 'package:community_new/UI%20SCREENS/Events_new/Events.dart';
import 'package:community_new/UI%20SCREENS/Organizations/oldOrganization/OrganizationList.dart';
import 'package:community_new/UI%20SCREENS/Organizations/org_tree.dart';
import 'package:community_new/UI%20SCREENS/Users/UserList.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/Masjids.dart';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class orgAdminOld extends StatefulWidget {
  final String? loginUser;
  orgAdminOld({Key? key,this.loginUser}) : super(key: key);

  @override
  _orgAdminOldState createState() => _orgAdminOldState();
}

class _orgAdminOldState extends State<orgAdminOld > {

  int _selectedIndex = 0;
  static  List<Widget> _widgetOptions = <Widget>[
    OrgTree(),
    Masjids(),UserList(),Events(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius:const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
            backgroundColor: Colors.red,
            unselectedItemColor: Colors.grey.shade400,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Organization',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.mosque),
                label: 'Masjids',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.users),
                label: 'Org Users',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.calendarCheck),
                label: 'Events',
              ),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            iconSize: 24,
            onTap: _onItemTapped,
            elevation: 10
        ),
      ),
    );
  }
}
