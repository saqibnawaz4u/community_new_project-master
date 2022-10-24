import 'package:community_new/UI%20SCREENS/Events_new/EventEditNew.dart';
import 'package:community_new/UI%20SCREENS/Organizations/org_tree.dart';
import 'package:community_new/UI%20SCREENS/Users/UserList.dart';
import 'package:community_new/UI%20SCREENS/Users/userStepper.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/Masjids.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/masjidStepper.dart';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../Events_new/Events.dart';



class OrgAdminWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OrgAdminWidgetState();
}

class OrgAdminWidgetState extends State<OrgAdminWidget> {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  static int currentTab = 0;



  final List<TabItem> tabs = [
    TabItem(
      //tabName: "Org Tree",
      icon: MdiIcons.home,
      page: OrgTree(),
    ),
    TabItem(
      // tabName: "Users",
      icon: MdiIcons.account,
      page: UserList(),
    ),
    TabItem(
     // tabName: "Masjids",
      icon: MdiIcons.mosque,
      page: Masjids(),
    ),

    TabItem(
      //tabName: "Events",
      icon: MdiIcons.calendarAlert,
      page: Events(),
    ),
  ];

  OrgAdminWidgetState() {
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
          currentTab==0?null:FloatingActionButton(
            backgroundColor: appColor,
            child: Icon(Icons.add),
            onPressed: (){
              // if(currentTab==0){
              //   Navigator.push(
              //       context, MaterialPageRoute(builder: (context) =>
              //       OrganizationEditnew(
              //         isNew: true,organizationId :0,parentId: 0,)));
              // }

                if(currentTab==1){
              Navigator.push(
              context, MaterialPageRoute(builder: (context) =>
              const userStepper(
              isNew: true,userId :0)));
              }
                else if(currentTab==2){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>
                    EditMasjidStepper(
                      objMasjidAdmin1: [],
                      isNew: true,masjidId: "0",)));
              }

              else  if(currentTab==3){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>
                const EventEditnew(
                    isNew: true,eventId :0)));
              }
            },
          ),
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
      color: Colors.white.withAlpha(255),
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent.withAlpha(0),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: tabs
            .map(
              (e) => _buildItem(
            index: e.getIndex(),
            icon: e.icon,
            //tabName: e.tabName,
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
      {required int index, required IconData icon,}) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _tabColor(index: index),
        ),
        label: ''
    );
  }

  Color _tabColor({required int index}) {
    return OrgAdminWidgetState.currentTab == index ? appColor : Colors.grey;
  }
}

class TabItem {
  // you can customize what kind of information is needed
  // for each tab
  final IconData icon;
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  int _index = 0;
  late Widget _page;
  TabItem({
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
      visible: _index == OrgAdminWidgetState.currentTab,
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