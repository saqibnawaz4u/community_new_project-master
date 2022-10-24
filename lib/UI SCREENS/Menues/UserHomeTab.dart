import 'package:community_new/UI%20SCREENS/Events_new/Events.dart';
import 'package:community_new/UI%20SCREENS/Organizations/org_tree.dart';
import 'package:community_new/UI%20SCREENS/Users/UserList.dart';
import 'package:community_new/UI%20SCREENS/business_screens/creating_new_business.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/creating_accomodation.dart';
import 'package:community_new/UI%20SCREENS/create_new_products/creating_products.dart';
import 'package:community_new/UI%20SCREENS/creating_new_jobs/create_job.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/Masjids.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/styles.dart';
import 'constantMenu.dart';


class UserHomeTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserHomeTabState();
}

class UserHomeTabState extends State<UserHomeTab> {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  static int currentTab = 0;

  // list tabs here
  final List<TabItem> tabs = [
    TabItem(
      tabName: "Accomodation",
      icon: FontAwesomeIcons.bed,
      page: Events(),
    ),
    TabItem(
      tabName: "Business",
      icon: FontAwesomeIcons.businessTime,
      page: CreatingBusinessScreen(),
    ),
    TabItem(
      tabName: "Products",
      icon: FontAwesomeIcons.productHunt,
      page: CreatingProductScreen(),
    ),
    TabItem(
      tabName: "Job",
      icon: FontAwesomeIcons.user,
      page: CreatingJobScreen(),
    ),
    TabItem(
      tabName: "Masjids",
      icon: FontAwesomeIcons.mosque,
      page: Masjids(),
    ),
    TabItem(
      tabName: "Users",
      icon: FontAwesomeIcons.users,
      page: UserList(),
    ),

  ];

  UserHomeTabState() {
    // indexing is necessary for proper funcationality
    // of determining which tab is active
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

  // sets current tab index
  // and update state
  void _selectTab(int index) {
    if (index == currentTab) {
      // pop to first route
      // if the user taps on the active tab
      tabs[index].key.currentState!.popUntil((route) => route.isFirst);
    } else {
      // update the state
      // in order to repaint
      setState(() => currentTab = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope handle android back btn
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await tabs[currentTab].key.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (currentTab != 0) {
            // select 'main' tab
            _selectTab(0);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      // this is the base scaffold
      // don't put appbar in here otherwise you might end up
      // with multiple appbars on one screen
      // eventually breaking the app
      child: Scaffold(
        // indexed stack shows only one child
        body: IndexedStack(
          index: currentTab,
          children: tabs.map((e) => e.page).toList(),
        ),
        // Bottom navigation
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
    return Container(
      decoration:const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),

      ),
      child: ClipRRect(
        borderRadius:const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          elevation: 5,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
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
    );
  }

  BottomNavigationBarItem _buildItem(
      {required int index, required IconData icon, required String tabName}) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _tabColor(index: index),
        ),
        label: tabName
    );
  }

  Color _tabColor({required int index}) {
    return UserHomeTabState.currentTab == index ? appColor : Colors.grey;
  }
}

class TabItem {
  // you can customize what kind of information is needed
  // for each tab
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

  // I was getting a weird warning when using getters and setters for _index
  // so I converted them to functions

  // used to set the index of this tab
  // which will be used in identifying if this tab is active
  void setIndex(int i) {
    _index = i;
  }

  int getIndex() => _index;

// adds a wrapper around the page widgets for visibility
// visibility widget removes unnecessary problems
// like interactivity and animations when the page is inactive
  Widget get page {
    return Visibility(
      // only paint this page when currentTab is active
      visible: _index == UserHomeTabState.currentTab,
      // important to preserve state while switching between tabs
      maintainState: true,
      child: Navigator(
        // key tracks state changes
        key: key,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (_) => _page,
          );
        },
      ),
    );
  }
}
