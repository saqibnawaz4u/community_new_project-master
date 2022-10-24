//
// import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/favouriteScreen.dart';
// import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/searchFilter.dart';
// import 'package:community_new/UI%20SCREENS/create_accomodation/screens/postAccomodation.dart';
// import 'package:community_new/UI%20SCREENS/masjid_screens/fav_masjid.dart';
// import 'package:community_new/constants/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../../../widgets/add_screen_text_field.dart';
// import '../../widgets/custom_app_bar.dart';
// import 'chat.dart';
// import 'home2.dart';
//
//
// class newonetochk extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => newonetochkState();
// }
//
// class newonetochkState extends State<newonetochk> {
//   // this is static property so other widget throughout the app
//   // can access it simply by AppState.currentTab
//   static int currentTab = 0;
//
//
//   final List<TabItem> tabs = [
//     TabItem(
//       //tabName: "Org Tree",
//       icon: currentTab==0?SvgPicture.asset('assets/icons/home.svg',color: appColor,)
//       :Image.asset('assets/icons/homeunfill.png',color: appColor,),
//       page: home2(),
//     ),
//     TabItem(
//       // tabName: "Users",
//       icon:SvgPicture.asset('assets/icons/search1.svg',color: appColor,),
//       page: searching(),
//     ),
//     TabItem(
//       // tabName: "Masjids",
//       icon: newonetochkState.currentTab==2? SvgPicture.asset('assets/icons/notifill.svg',color: appColor,)
//           :Image.asset('assets/icons/notification.png',color: appColor,),
//       page: Center(child: Text('notification Page', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
//     ),
//
//     TabItem(
//       //tabName: "Events",
//       icon:currentTab==3? SvgPicture.asset('assets/icons/chatfill.svg',color: appColor,)
//           :SvgPicture.asset('assets/icons/chatunfill.svg',color: appColor,),
//       page:  ChatPage(),
//     ),
//   TabItem(
//   //tabName: "Events",
//   icon: currentTab==4?SvgPicture.asset('assets/icons/favunfill1.svg',color:appColor,):
//                   SvgPicture.asset('assets/icons/favunfill1.svg',color:appColor,),
//        page:   favouriteScreen(),
//   ),
//   ];
//
//   newonetochkState() {
//     // indexing is necessary for proper funcationality
//     // of determining which tab is active
//     tabs.asMap().forEach((index, details) {
//       details.setIndex(index);
//     });
//   }
//
//   // sets current tab index
//   // and update state
//   void _selectTab(int index) {
//     if (index == currentTab) {
//       // pop to first route
//       // if the user taps on the active tab
//       tabs[index].key.currentState!.popUntil((route) => route.isFirst);
//     } else {
//       // update the state
//       // in order to repaint
//       setState(() => currentTab = index);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // WillPopScope handle android back btn
//     return WillPopScope(
//       onWillPop: () async {
//         final isFirstRouteInCurrentTab =
//         !await tabs[currentTab].key.currentState!.maybePop();
//         if (isFirstRouteInCurrentTab) {
//           // if not on the 'main' tab
//           if (currentTab != 0) {
//             // select 'main' tab
//             _selectTab(0);
//             // back button handled by app
//             return false;
//           }
//         }
//         // let system handle back button if we're on the first route
//         return isFirstRouteInCurrentTab;
//       },
//
//       child: SafeArea(
//         bottom: false,
//         child: Theme(
//                 data: ThemeData(
//         backgroundColor: const Color(0xFFF5F6F6),
//         primaryColor: appColor,
//         colorScheme: ColorScheme.fromSwatch().copyWith(
//           secondary: appColor,
//         ),
//         textTheme: TextTheme(
//           headline1: const TextStyle(
//             color: Color(0xFF100E34),
//           ),
//           bodyText1: TextStyle(
//             color: const Color(0xFF100E34).withOpacity(0.5),
//           ),
//         ),
//       ),
//           child: Scaffold(
//             resizeToAvoidBottomInset: false,
//             extendBody: true,
//             floatingActionButton:currentTab==0?FloatingActionButton(
//               backgroundColor: appColor,
//               child: Icon(Icons.add),
//               onPressed: (){
//                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
//                     PostAccommodation(isNew: true,)));
//               },
//             ):null,
//             backgroundColor: whiteColor,
//             body: IndexedStack(
//               index: currentTab,
//               children: tabs.map((e) => e.page).toList(),
//             ),
//             // Bottom navigation
//             bottomNavigationBar: BottomNavigation(
//               onSelectTab: _selectTab,
//               tabs: tabs,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class BottomNavigation extends StatelessWidget {
//   BottomNavigation({
//     required this.onSelectTab,
//     required this.tabs,
//   });
//   final ValueChanged<int> onSelectTab;
//   final List<TabItem> tabs;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 25),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 1,
//             blurRadius: 2,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(top:8.0),
//         child: BottomNavigationBar(
//           elevation: 0,backgroundColor: Colors.transparent,
//           type: BottomNavigationBarType.fixed,
//           items: tabs
//               .map(
//                 (e) => _buildItem(
//               index: e.getIndex(),
//               icon: e.icon,
//               //tabName: e.tabName,
//             ),
//           )
//               .toList(),
//           onTap: (index) => onSelectTab(
//             index,
//           ),
//         ),
//       ),
//     );
//   }
//   BottomNavigationBarItem _buildItem(
//       {required int index, required Widget icon,}) {
//     return BottomNavigationBarItem(
//         icon: icon,
//         label: ''
//     );
//   }
//
//   Color _tabColor({required int index}) {
//     return newonetochkState.currentTab == index ? appColor : Colors.grey;
//   }
// }
//
// class TabItem {
//   // you can customize what kind of information is needed
//   // for each tab
//   final Widget icon;
//   final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
//   int _index = 0;
//   late Widget _page;
//   TabItem({
//     required this.icon,
//     required Widget page,
//   }) {
//     _page = page;
//   }
//
//   // I was getting a weird warning when using getters and setters for _index
//   // so I converted them to functions
//
//   // used to set the index of this tab
//   // which will be used in identifying if this tab is active
//   void setIndex(int i) {
//     _index = i;
//   }
//
//   int getIndex() => _index;
//
// // adds a wrapper around the page widgets for visibility
// // visibility widget removes unnecessary problems
// // like interactivity and animations when the page is inactive
//   Widget get page {
//     return Visibility(
//       // only paint this page when currentTab is active
//       visible: _index == newonetochkState.currentTab,
//       // important to preserve state while switching between tabs
//       maintainState: true,
//       child: Navigator(
//         // key tracks state changes
//         key: key,
//         onGenerateRoute: (routeSettings) {
//           return MaterialPageRoute(
//             builder: (_) => _page,
//           );
//         },
//       ),
//     );
//   }
// }
//
// class searching extends StatefulWidget {
//   const searching({Key? key}) : super(key: key);
//
//   @override
//   State<searching> createState() => _searchingState();
// }
//
// class _searchingState extends State<searching> {
//   int? _locationindex;
//
//   var Locations = <String>[
//     'North America',
//     'South America',
//     'Calgary',
//   ];
//    @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: AlertDialog(
//         contentPadding: EdgeInsets.only(left: 10,right: 10,top: 10),
//         actionsPadding: EdgeInsets.only(top: 200,bottom: 10),
//         actions: [
//           // Container(
//           //   width: MediaQuery.of(context).size.width,
//           //   height: MediaQuery.of(context).size.height/16,
//           //   child: ElevatedButton(
//           //       style: ElevatedButton.styleFrom(
//           //           primary: appColor, // background
//           //           onPrimary: Colors.white,
//           //           shape: const RoundedRectangleBorder(
//           //               borderRadius: BorderRadius.all(Radius.circular(20))
//           //           )// foreground
//           //       ),
//           //             onPressed: (){},
//           //       child: const Text('Search')
//           //
//           //   ),
//           // ),
//
//         ],
//         title: Text('Location'),
//         backgroundColor: whiteColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         content: Container(
//           height: MediaQuery.of(context).size.height/14,
//           decoration: BoxDecoration(
//               color: whiteColor,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.grey)
//             // shape: RoundedRectangleBorder(
//             //   borderRadius: BorderRadius.circular(8),)
//           ),
//           child: Padding(
//             padding: const EdgeInsets.only(left:10.0,right: 10,top: 5),
//             child: DropdownButton<String>(
//               isExpanded: true,
//               value: _locationindex == null ? null : Locations[_locationindex!],
//               hint: Text('Select',style: TextStyle(color: blackColor),),
//               dropdownColor: whiteColor,
//               focusColor: whiteColor,
//               underline: Text(""),
//               elevation: 16,
//               style: const TextStyle(color: blackColor),
//               onChanged: (value) {
//                 setState(() {
//                   _locationindex = Locations.indexOf(value!);
//                 });
//               },
//               items: Locations.map((String value) {
//                 return new DropdownMenuItem<String>(
//                   value: value,
//                   child: new Text(value),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//
//       ),
//     );
//   }
// }
//
//
// // class Home extends StatefulWidget {
// //   const Home({Key? key}) : super(key: key);
// //
// //   @override
// //   State<Home> createState() => _HomeState();
// // }
// //
// // class _HomeState extends State<Home> {
// //   int _selectedIndex = 0;
// //   static  List<Widget> _widgetOptions = <Widget>[
// //     home2(),
// //     SearchFilter(),
// //     Text('notification Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
// //     ChatPage(),
// //     favouriteScreen(),
// //   ];
// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Theme(
// //       data: ThemeData(
// //         backgroundColor: const Color(0xFFF5F6F6),
// //         primaryColor: appColor,
// //         colorScheme: ColorScheme.fromSwatch().copyWith(
// //           secondary: appColor,
// //         ),
// //         textTheme: TextTheme(
// //           headline1: const TextStyle(
// //             color: Color(0xFF100E34),
// //           ),
// //           bodyText1: TextStyle(
// //             color: const Color(0xFF100E34).withOpacity(0.5),
// //           ),
// //         ),
// //       ),
// //       child: Scaffold(
// //           floatingActionButton:_selectedIndex==0?FloatingActionButton(
// //             backgroundColor: appColor,
// //             child: Icon(Icons.add),
// //             onPressed: (){
// //               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
// //                   PostAccommodation(isNew: true,)));
// //             },
// //           ):null,
// //           backgroundColor: whiteColor,
// //           appBar: _selectedIndex==3?null: CustomAppBar(),
// //           body: Center(
// //             child: _widgetOptions.elementAt(_selectedIndex),
// //           ),
// //           bottomNavigationBar:Container(
// //             //padding: const EdgeInsets.symmetric(vertical: 5),
// //             margin: const EdgeInsets.only(bottom: 25),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(30),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.grey.withOpacity(0.3),
// //                   spreadRadius: 1,
// //                   blurRadius: 2,
// //                   offset: const Offset(0, 2),
// //                 ),
// //               ],
// //             ),
// //             child: Padding(
// //               padding: const EdgeInsets.only(top:8.0),
// //               child: BottomNavigationBar(
// //                 currentIndex: _selectedIndex,
// //                 onTap: _onItemTapped,
// //                 type: BottomNavigationBarType.fixed,
// //                 elevation: 0,backgroundColor: Colors.transparent,
// //                 items: [
// //                   BottomNavigationBarItem(icon:_selectedIndex==0?
// //                   SvgPicture.asset('assets/icons/home.svg',color: appColor,)
// //                       :Image.asset('assets/icons/homeunfill.png',color: appColor,),
// //                       label: ''),
// //                   BottomNavigationBarItem(icon:
// //                   SvgPicture.asset('assets/icons/search1.svg',color: appColor,)
// //                       ,label: ''),
// //                   BottomNavigationBarItem(icon: _selectedIndex==2?
// //                   SvgPicture.asset('assets/icons/notifill.svg',color: appColor,)
// //                       :Image.asset('assets/icons/notification.png',color: appColor,)
// //                       ,label: ''),
// //                   BottomNavigationBarItem(icon:
// //                   _selectedIndex==3?SvgPicture.asset('assets/icons/chatfill.svg',color: appColor,)
// //                       :SvgPicture.asset('assets/icons/chatunfill.svg',color: appColor,)
// //                       ,label: ''),
// //                   BottomNavigationBarItem(icon:_selectedIndex==4?
// //                   Image.asset('assets/icons/favfill.png',color: appColor,):
// // //                   SvgPicture.asset('assets/icons/favunfill1.svg',color:appColor,),
// //                       label: '',tooltip: 'favourite')
// //                 ],
// //               ),
// //             ),
// //           )
// //       ),
// //     );
// //   }
// // }