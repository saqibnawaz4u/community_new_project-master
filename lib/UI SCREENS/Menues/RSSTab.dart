// ignore_for_file: unused_import

import 'package:community_new/UI%20SCREENS/Events_new/Events.dart';
import 'package:community_new/UI%20SCREENS/Users/UserList.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/chat.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/home.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/home2.dart';
import 'package:community_new/UI%20SCREENS/dashboard/Dashboard.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/prayerTimes/MasjidPrayerTiming.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/Masjids.dart';
// import 'package:community_new/UI%20SCREENS/masjid_screens/ramadanTimes/ramadanTimes.dart';
import 'package:community_new/models/ramadanTimes.dart';
import 'package:community_new/widgets/genericDrawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/styles.dart';
import '../credentials/log_in.dart';
import '../masjid_screens/fav_masjid.dart';
import '../notifications/notification_screen.dart';

class HomeTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  static int currentTab = 0;
  final List<TabItem> tabs = [
    TabItem(
      tabName: "",
      icon: MdiIcons.home,
      page: Dashboard(),
    ),
    TabItem(
      tabName: "",
      icon: MdiIcons.clockOutline,
      page: MasjidPrayerTiming(),
    ),

    TabItem(
      tabName: "",
      icon: MdiIcons.bed,
      page: home2(),
    ),
    // TabItem(
    //   tabName: "",
    //   icon:MdiIcons.bell,
    //   page: NotificationScreen()
    // ),
    // TabItem(
    //   tabName: "",
    //   icon:MdiIcons.chat,
    //   page: ChatPage(),
    // ),
    TabItem(
      tabName: "",
      icon: MdiIcons.calendarAlert,
      page: Events(),
    ),
    TabItem(
      tabName: "",
      icon: MdiIcons.mosque,
      page: Fav_masajids(),
    ),
    //TabItem(
    // tabName: "",
    // icon: Icons.more_vert,
    // icon: PopupMenuButton(
    //   icon: Icon(Icons.more_vert),
    //   itemBuilder: (_) => <PopupMenuItem<String>>[
    //     new PopupMenuItem<String>(
    //         child: const Text('test1'), value: 'test1'),
    //     new PopupMenuItem<String>(
    //         child: const Text('test2'), value: 'test2'),
    //   ],
    // ),
    //  page: moreItems()
    //),
  ];

  HomeTabState() {
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

  void _selectTab(int index) {
    if (index == currentTab) {
      if (index == 5) {
        tabs[index].key.currentState!.popUntil((route) => route.isFirst);
      } else {
        tabs[index].key.currentState!.popUntil((route) => route.isCurrent);
      }
    } else {
      setState(() {
        currentTab = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await tabs[currentTab].key.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (currentTab != 0) {
            _selectTab(0);

            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentTab,
          children: tabs.map((e) => e.page).toList(),
        ),
        bottomNavigationBar: BottomNavigation(
          onSelectTab: _selectTab,
          tabs: tabs,
        ),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  BottomNavigation({
    required this.onSelectTab,
    required this.tabs,
  });
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: whiteColor,
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
          child: BottomNavigationBar(
            backgroundColor: whiteColor,
            elevation: 0,
            type: BottomNavigationBarType.shifting,
            items: tabs
                .map(
                  (e) => _buildItem(
                    index: e.getIndex(),
                    icon: e.icon,
                    tabName: e.tabName,
                  ),
                )
                .toList(),
            onTap: (index) => onSelectTab(
              index,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(
      {required int index, required IconData icon, required String tabName}) {
    return BottomNavigationBarItem(
        backgroundColor: appColor,
        icon: index == 0
            ? Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Icon(
                  icon,
                  color: _tabColor(index: index),
                ),
              )
            : Icon(
                icon,
                color: _tabColor(index: index),
              ),
        // icon: icon,
        label: tabName);
  }

  Color _tabColor({required int index}) {
    return HomeTabState.currentTab == index ? Color(0xffd08e63) : Colors.grey;
  }
}

class TabItem {
  final String tabName;
  final IconData icon;
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  int _index = 0;
  late Widget _page;
  TabItem({
    required this.tabName,
    required this.icon,
    required Widget page,
  }) {
    _page = page;
  }

  void setIndex(int i) {
    _index = i;
  }

  int getIndex() => _index;

  Widget get page {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: Visibility(
        visible: _index == HomeTabState.currentTab,
        maintainState: true,
        child: Navigator(
          key: key,
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(
              builder: (_) => _page,
            );
          },
        ),
      ),
    );
  }
}

class moreItems extends StatefulWidget {
  const moreItems({Key? key}) : super(key: key);

  @override
  State<moreItems> createState() => _moreItemsState();
}

class _moreItemsState extends State<moreItems> {
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

  String currentUserName = prefs.get('userName');
  Widget moreItem() {
    return Drawer(
      backgroundColor: whiteColor,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  color: whiteColor,
                  border: Border(bottom: BorderSide(color: Colors.grey))),
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
                    style: TextStyle(color: blackColor, fontSize: 14),
                  ),
                  midPadding2,
                  Text(
                    'email@gmail.com',
                    style: TextStyle(color: blackColor, fontSize: 14),
                  ),
                ],
              )),
          GridView(
            primary: false,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 2),
            children: [
              cardOfDrawer('Events', MdiIcons.calendarAlert, appColor, () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Events()));
              }),
              cardOfDrawer('My Masajids', Icons.favorite, appColor, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Fav_masajids()));
              }),
              cardOfDrawer('Log out', Icons.logout, Colors.red, () {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(builder: (_) => LogIn()));
              }),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return moreItem();
  }
}
