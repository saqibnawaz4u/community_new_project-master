import 'package:community_new/UI%20SCREENS/Organizations/edit_organizationnew.dart';
import 'package:community_new/UI%20SCREENS/Organizations/org_tree.dart';
import 'package:community_new/UI%20SCREENS/Users/UserList.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/accommodationTypeSA.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/Masjids.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/masjidStepper.dart';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Events_new/EventEditNew.dart';
import '../Events_new/Events.dart';
import '../Organizations/orgStepper.dart';
import '../Users/userStepper.dart';

class superUserTab extends StatefulWidget {
  superUserTab({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => superUserTabState();
}

class superUserTabState extends State<superUserTab> {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  static int currentTab = 0;

  // list tabs here
  final List<TabItem> tabs = [
    TabItem(
      // tabName: "Org Tree",
      icon: MdiIcons.home,
      page: OrgTree(),
    ),
    TabItem(
      //tabName: "Users",
      icon: MdiIcons.account,
      page: UserList(),
    ),
    TabItem(
      // tabName: "Masjids",
      icon: MdiIcons.mosque,
      page: Masjids(),
    ),
    TabItem(
      // tabName: "Masjids",
      icon: MdiIcons.calendarAlert,
      page: Events(),
    ),
    TabItem(
      // tabName: "Masjids",
      icon: MdiIcons.bed,
      page: accommodationTypeSuperAdmin(index: 0),
    ),
  ];

  superUserTabState() {
    // indexing is necessary for proper funcationality
    // of determining which tab is active
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

  // sets current tab index
  // and update state
  showAlertDialog(BuildContext context) {
    // Create button
    Widget yesButton = TextButton(
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          //     Masjids()));
          Navigator.of(context, rootNavigator: true).popUntil((route) {
            return route.isCurrent;
          });
          // Navigator.of(context, rootNavigator: false)
          //     .pop(true);
        },
        child: Text(
          'yes',
          style: TextStyle(color: appColor),
        ));
    Widget noButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop(false);
        },
        child: Text(
          'no',
          style: TextStyle(color: appColor),
        ));

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text("Alert"),
      content: Text("Are you sure you want to go back?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _selectTab(int index) {
    if (index == currentTab) {
      // pop to first route
      // if the user taps on the active tab
      tabs[index].key.currentState!.popUntil((route) {
        if (route.isCurrent) {
          showAlertDialog(context);
        } else if (route.isFirst == route.isCurrent) {
          return false;
        }
        return route.isCurrent;
      });
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
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: appColor,
            child: Icon(Icons.add),
            onPressed: () {
              if (currentTab == 0) {
                // Navigator.of(context,rootNavigator: false).push(
                //     MaterialPageRoute(builder: (context) =>
                //     stepper(
                //       isNew: true,organizationId :0,parentId: 0,)));
                Navigator.of(context, rootNavigator: false)
                    .push(MaterialPageRoute(
                        builder: (context) => stepper(
                              isNew: true,
                              organizationId: 0,
                              parentId: 0,
                            ),
                        maintainState: true));
              } else if (currentTab == 1) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        const userStepper(isNew: true, userId: 0)));
              } else if (currentTab == 2) {
                Navigator.of(context).push(MaterialPageRoute(
                    maintainState: true,
                    builder: (context) => EditMasjidStepper(
                          objMasjidAdmin1: [],
                          isNew: true,
                          masjidId: "0",
                        )));
              } else if (currentTab == 3) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        EventEditnew(isNew: true, eventId: 0)));
              }
            },
          ),
          //indexed stack shows only one child
          body: IndexedStack(
            index: currentTab,
            children: tabs.map((e) => e.page).toList(),
          ),
          // Bottom navigation
          bottomNavigationBar:
              // BottomAppBar(
              //   color: Colors.white.withAlpha(255),
              //   shape: CircularNotchedRectangle(),
              //   child: Padding(
              //     padding: const EdgeInsets.only(left:15.0,right: 15),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       mainAxisSize: MainAxisSize.max,
              //       children: <Widget>[
              //         IconButton(
              //           icon: Icon(
              //             FontAwesomeIcons.home,
              //             color:_tabColor(index: 1)
              //           ),
              //           onPressed: () {
              //             //_view.onFilterClicked();
              //             Navigator.push(context,
              //                 MaterialPageRoute(builder:
              //                     (context) => OrgTree()
              //                 )
              //             );
              //           },
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(left:100.0),
              //           child: IconButton(
              //             icon: Icon(
              //               FontAwesomeIcons.users,
              //               color:_tabColor(index: 2)
              //             ),
              //             onPressed: () {
              //              // _view.onSearchClicked();
              //               UserList();
              //             },
              //           ),
              //         ),
              //         IconButton(
              //           icon: Icon(
              //             FontAwesomeIcons.mosque,
              //             color:_tabColor(index: 3)
              //           ),
              //           onPressed: () {
              //            // _view.onSearchClicked();
              //             Navigator.push(context,
              //                 MaterialPageRoute(builder:
              //                     (context) => Masjids()
              //                 )
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // )

              Theme(
            data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent),
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
      color: Colors.white.withAlpha(255),
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          child: BottomNavigationBar(
            backgroundColor: appColor,
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
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem({
    required int index,
    required IconData icon,
  }) {
    return BottomNavigationBarItem(
        backgroundColor: appColor,
        icon: index == 0
            ? Icon(
                icon,
                color: _tabColor(index: index),
              )
            : index == 1
                ? Icon(
                    icon,
                    color: _tabColor(index: index),
                  )
                : index == 2
                    ? Icon(
                        icon,
                        color: _tabColor(index: index),
                      )
                    : Icon(
                        icon,
                        color: _tabColor(index: index),
                      ),
        label: '');
  }

  Color _tabColor({required int index}) {
    return superUserTabState.currentTab == index
        ? Color(0xffd08e63)
        : Colors.grey;
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
      visible: _index == superUserTabState.currentTab,
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
