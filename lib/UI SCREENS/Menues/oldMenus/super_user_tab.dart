import 'package:community_new/UI%20SCREENS/Users/UserList.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/Masjids.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Organizations/org_tree.dart';


class SuperUserTabsOld extends StatefulWidget {

  SuperUserTabsOld({Key? key,}) : super(key: key);

  @override
  _SuperUserTabsOldState createState() => _SuperUserTabsOldState();
}

class _SuperUserTabsOldState extends State<SuperUserTabsOld > {
  int _selectedIndex = 0;
  static  List<Widget> _widgetOptions = <Widget> [
    //OrgTree(),
    OrgTree(),
    UserList(),Masjids(),
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
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey.shade400,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Organizations',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.users),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.mosque),
              label: 'Masjids',
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
}
