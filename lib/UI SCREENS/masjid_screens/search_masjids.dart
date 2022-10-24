// import 'dart:convert';
//
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//
// import '../../api_services/api_services.dart';
// import '../../constants/styles.dart';
// import '../../main.dart';
// import '../../models/masjid.dart';
// import '../../models/user.dart';
// import '../credentials/log_in.dart';
//
//
//
// class SearchMasjids extends StatefulWidget {
//
//    SearchMasjids({Key? key}) : super(key: key);
//
//   @override
//   _SearchMasjidsState createState() => _SearchMasjidsState();
// }
//
// class _SearchMasjidsState extends State<SearchMasjids> with
//     SingleTickerProviderStateMixin{
//
//   static List<Masjid> masjids = [] ;
//
// _getMasjid() async{
//   ApiServices.fetch (
//       'masjid',
//       actionName:  null,
//       param1: null )
//       .then ( (response) {
//     setState ( () {
//       try {
//         //errorController.text = "";
//         Iterable list = json.decode ( response.body );
//         //print ( response.body );
//         newmasjids =
//             list.map ( (model) => Masjid.fromJson ( model ) ).toList ( );
//         // print(masjids[0].Id);
//         //  errorController.text="test";
//       }
//       on Exception catch (e) {
//         //errorController.text = "wow : " + e.toString ( );
//       }
//     } );
//   });
// }
//
//  List<Masjid> newmasjids =List.from(masjids);
//  void onItemChanged(String value) {
//    setState(() {
//      newmasjids = masjids
//          .where((string) => string.Name!.toLowerCase().
//      contains(value.toLowerCase())).toList();
//    });
//
//
//  }
//   // This function is called whenever the text field changes
//   // void _runFilter(String enteredKeyword) {
//   //  // List<Masjid> results = [];
//   //   if (enteredKeyword.isEmpty) {
//   //     // if the search field is empty or only contains white-space, we'll display all users
//   //     newmasjids=masjids;
//   //   } else{
//   //     newmasjids=masjids
//   //         .where((user) =>
//   //         user.Name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
//   //         .toList();
//   //   }
//   //
//   //   // Refresh the UI
//   //   setState(() {
//   //     newmasjids=masjids;
//   //   });
//   // }
//
//    TabController? _tabController;
//
//
//   @override
//   initState() {
//     // at the beginning, all users are shown
//     super.initState();
//     _getMasjid();
//     _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
//     _tabController!.addListener(_handleTabIndex);
//   }
//   @override
//   void dispose() {
//     _tabController!.removeListener(_handleTabIndex);
//     _tabController!.dispose();
//     super.dispose();
//   }
//
//   void _handleTabIndex() {
//     setState(() {});
//   }
// TextEditingController searchController = TextEditingController();
//   //bool _starVisible=false;
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: backgroundColor,
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(70.0),
//           child: AppBar(
//             actions: [
//               IconButton(onPressed: ()
//               {
//                 Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
//                     builder: (_) =>const SplashScreenWidget(
//                         appName: 'Muslim Community',
//                         loadingText: 'Logging out',
//                         widget: LogIn())));
//               },
//                   icon: Icon(Icons.logout))
//             ],
//             shape:const RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(
//                 bottom: Radius.circular(12),
//               ),
//             ),
//             backgroundColor: appColor,
//             bottom:  TabBar(
//               controller: _tabController,
//               indicatorColor: whiteColor,
//               labelColor: whiteColor,
//               indicatorSize: TabBarIndicatorSize.label,
//               tabs: [
//                 Text("All Masajid",style: whiteTextStyleNormalTabbar,),
//                 Text('My Masajid',style: whiteTextStyleNormalTabbar,),
//               ],
//             ),
//           ),
//         ),
//         body: TabBarView(
//           controller: _tabController,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: searchController,
//                     onChanged:(value)=>onItemChanged(value),
//                     decoration:  InputDecoration(
//                         border:  OutlineInputBorder(
//                           borderRadius:  BorderRadius.circular(8.0),
//                           borderSide:const BorderSide(
//                             color: appColor,
//                           ),
//                           //borderSide: BorderSide.none
//                         ),
//                         filled: true,
//                         fillColor: whiteColor,
//                         labelStyle: TextStyle(color: appColor),
//                         labelText: 'Search Masajid',
//                         suffixIcon: Icon(Icons.search,color: appColor,)),
//                   ),
//                   Expanded(
//                     child: newmasjids.isNotEmpty
//                         ? ListView.builder(
//                       itemCount: newmasjids.length,
//                       itemBuilder: (context, index) =>
//                           Card(
//                             //key: ValueKey(masjids[index].Id),
//                             color: appColor,
//                             elevation: 4,
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             child: ListTile(
//                               trailing:IconButton (
//                                 color:Colors.amberAccent,
//                                 icon: Icon (
//                                     //newmasjids[index].isSelected==true
//                                         ? MdiIcons.star
//                                         : MdiIcons.starOutline ),
//                                 onPressed: () {
//                                   // setState ( () {
//                                   //   _starVisible =
//                                   //   !_starVisible;
//                                   // } );
//                                   for (int i = 0; i < newmasjids.length; i++) {
//                                     setState(() {
//                                       if (index == i) {
//                                         //newmasjids[index].isSelected;
//                                         // _tabController!.addListener(() {
//                                         //   widget.masjidsend!.add(Masjid(
//                                         //     Name: masjids[index].Name.toString(),
//                                         //   ));
//                                         // });
//                                         // masjids[index].isSelected!=true?
//                                         //   ScaffoldMessenger.of(context)
//                                         //           .showSnackBar(SnackBar(
//                                         //         content: Text(
//                                         //             "${masjids[index].Name.toString()} "
//                                         //             "added to my masajid"),
//                                         //       )):
//                                         //
//                                         //
//                                         //         ScaffoldMessenger.of(context)
//                                         //             .showSnackBar(SnackBar(
//                                         //           content: Text(
//                                         //               "${masjids[index].Name.toString()}"
//                                         //               " is already added to my masajid"),
//                                         //         ));
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(SnackBar(
//                                           content: Text(
//                                               "${newmasjids[index].Name.toString()} "
//                                                   "added to my masajid"),
//                                         ));
//                                           }
//
//                                       // else {
//                                          //the condition to change the highlighted item
//                                       //   masjids[i].isSelected = false;
//                                       // }
//                                     });
//                                   }
//                                   // if(masjids[index].isSelected==true) {
//                                   //       ScaffoldMessenger.of(context)
//                                   //           .showSnackBar(SnackBar(
//                                   //         content: Text(
//                                   //             "${masjids[index].Name.toString()}"
//                                   //             " is already added to my masajid"),
//                                   //       ));
//                                   //     }
//                                       // _tabController!.animateTo ( (_tabController!.index + 1) % 2 );
//
//                                   //_tabController!.animateTo(int.parse(masjids[index].Name.toString()));
//                                   // Navigator.push(context, MaterialPageRoute(
//                                   //   builder: (context)=>
//                                   //       SearchMasjids(
//                                   //         str:masjids[index].Name.toString(), ),
//                                   // ));
//                                 },
//                               ),
//                               title: Text(newmasjids[index].Name.toString()),
//                               subtitle: Text(
//                                   newmasjids[index].Description.toString()),
//                             ),
//                           ),
//                     )
//                         : const Text(
//                       'No results found',
//                       style: TextStyle(fontSize: 24),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//            ListView.builder(
//               //primary: false,
//                 shrinkWrap: true,
//                 itemCount:newmasjids.length,
//                 //itemCount: widget.selectedindex!.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(left:15.0,right: 15,top: 2),
//                     child:
//                     newmasjids[index].isSelected==true?
//                     Card(
//                         elevation: 10,
//                         color: whiteColor,
//                         child: Column(
//                           children: [
//                             ListTile(
//                               //title: Text('hello'),
//                               title: Text(newmasjids[index].Name.toString()),
//                             ),
//                           ],
//                         )):Container()
//                   );
//                 }
//             ),
//           ],
//         )
//       ),
//     );
//   }
// }