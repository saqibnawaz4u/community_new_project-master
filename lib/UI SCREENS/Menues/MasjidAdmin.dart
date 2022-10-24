import 'package:community_new/UI%20SCREENS/Events_new/Events.dart';
import 'package:community_new/UI%20SCREENS/Organizations/org_tree.dart';
import 'package:community_new/UI%20SCREENS/Users/UserList.dart';
import 'package:community_new/UI%20SCREENS/Users/userStepper.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/Masjids.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/masjidStepper.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/yearlyIqamaTime.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/styles.dart';
import '../Events_new/EventEditNew.dart';


class MasjidAdminTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MasjidAdminTabState();
}

class MasjidAdminTabState extends State<MasjidAdminTab> {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  static int currentTab = 0;

  // list tabs here
  final List<TabItem> tabs = [
    TabItem(
      tabName: "",
      icon: MdiIcons.mosque,
      page: Masjids(),
    ),
    TabItem(
      tabName: "",
      icon: MdiIcons.account,
      page: UserList(),
    ),
    TabItem(
      tabName: "",
      icon: MdiIcons.calendarAlert,
      page: Events(),
    ),
    TabItem(
      tabName: "",
      icon: MdiIcons.timelapse,
      page: yearlyIqamaTime(),
    ),
  ];

  MasjidAdminTabState() {
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
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          floatingActionButton:
          currentTab==3?null:FloatingActionButton(
            backgroundColor: appColor,
            child: Icon(Icons.add),
            onPressed: (){
              if(currentTab==0){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>
                    EditMasjidStepper(
                      objMasjidAdmin1: [],
                      isNew: true,masjidId: "0",)));
              }
              else  if(currentTab==1){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>
                const userStepper(
                    isNew: true,userId :0)));
              }
              else  if(currentTab==2){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>
                const EventEditnew(
                    isNew: true,eventId :0)));
              }

            },
          ),
          // indexed stack shows only one child
          body: IndexedStack(
            index: currentTab,
            children: tabs.map((e) => e.page).toList(),
          ),
          // Bottom navigation
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent
            ),
            child: BottomNavigation(
              onSelectTab: _selectTab,
              tabs: tabs,
            ),
          ),
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
     // color: Theme.of(context).primaryColor.withAlpha(255),
      color: Colors.white.withAlpha(255),
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent.withAlpha(0),
       // backgroundColor:Theme.of(context).primaryColor.withAlpha(0),
        elevation: 0,
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
    );
  }

  BottomNavigationBarItem _buildItem(
      {required int index, required IconData icon, required String tabName}) {
    return BottomNavigationBarItem(
        icon:
        // index==0?Padding(
        //   padding: const EdgeInsets.only(left:80.0),
        //   child: Icon(
        //     icon,
        //     color: _tabColor(index: index),
        //   ),
        // ): index==1?Icon(
        //   icon,
        //   color: Colors.transparent,
        // ):
        Icon(
          icon,
          color: _tabColor(index: index),
        ),
        label: tabName
    );
  }

  Color _tabColor({required int index}) {
    return MasjidAdminTabState.currentTab == index ? appColor : Colors.grey;
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
      visible: _index == MasjidAdminTabState.currentTab,
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