// import 'package:community_new/UI%20SCREENS/create_accomodation/screens/postAccomodation.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import '../../../../constants/styles.dart';

// class AccCategories extends StatefulWidget {
//   final bool? isNew;
//   const AccCategories({
//     super.key,
//     this.isNew,
//   });

//   @override
//   State<AccCategories> createState() => _CategoriesState();
// }

// class _CategoriesState extends State<AccCategories> {
//   List<String> forRent = [
//     'long term rentals',
//     'short term rentals',
//     'room rentals',
//     'storage, parking for rent',
//     'commercial, office space for rent',
//   ];
//   List<String> forsale = [
//     'real state services',
//   ];
//   showAlertDialog(BuildContext context) {
//     // Create button
//     Widget yesButton = TextButton(
//         onPressed: () {
//           Navigator.pop(context);
//           Navigator.of(context, rootNavigator: true).pop(false);
//           // Navigator.push(context,
//           //     MaterialPageRoute(builder: (context) => AccommodationPosting()));
//         },
//         child: Text(
//           'yes',
//           style: TextStyle(color: appColor),
//         ));
//     Widget noButton = TextButton(
//         onPressed: () {
//           Navigator.of(context, rootNavigator: true).pop(false);
//         },
//         child: Text(
//           'no',
//           style: TextStyle(color: appColor),
//         ));

//     // Create AlertDialog
//     AlertDialog alert = AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       title: Text("Alert"),
//       content: Text("Are you sure you want to go back?"),
//       actions: [
//         yesButton,
//         noButton,
//       ],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           color: appColor,
//           onPressed: () {
//             showAlertDialog(context);
//           },
//           icon: Icon(CupertinoIcons.chevron_back),
//         ),
//         backgroundColor: whiteColor,
//         title: widget.isNew == false
//             ? Text(
//                 "Edit",
//                 style: TextStyle(fontSize: 20, color: appColor),
//               )
//             : Text(
//                 "Select Category",
//                 style: TextStyle(fontSize: 20, color: appColor),
//               ),
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: 10.0,
//         ),
//         height: MediaQuery.of(context).size.height,
//         width: double.infinity,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 10.0,
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 10.0),
//                 width: MediaQuery.of(context).size.width,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   // border: Border(
//                   //   bottom: BorderSide(
//                   //     color: Colors.grey,
//                   //     width: 1,
//                   //   ),
//                   // ),
//                   borderRadius: BorderRadius.circular(30.0),
//                   color: Color(0xffddc2ae),
//                 ),
//                 padding: EdgeInsets.only(
//                   top: 15.0,
//                   bottom: 10,
//                   left: 20,
//                 ),
//                 child: Text(
//                   ' CATEGORIES',
//                   style: TextStyle(color: textColor),
//                 ),
//               ),
//               Container(
//                 color: whiteColor,
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading: Icon(
//                         Icons.list,
//                         color: appColor,
//                       ),
//                       title: Text(
//                         'All Ads',
//                         style: TextStyle(
//                           color: appColor,
//                           fontSize: 15.0,
//                         ),
//                       ),
//                     ),
//                     // Divider(),
//                     ExpansionTile(
//                       leading: Icon(
//                         Icons.home_filled,
//                         color: appColor,
//                       ),
//                       title: Text(
//                         'real estate',
//                         style: TextStyle(
//                           color: appColor,
//                           fontSize: 15.0,
//                         ),
//                       ),
//                       trailing: Text(''),
//                       children: [
//                         // Divider(),
//                         ExpansionTile(
//                             title: Text(
//                               'for rent',
//                               style: TextStyle(
//                                 color: appColor,
//                                 fontSize: 15.0,
//                               ),
//                             ),
//                             leading: Icon(
//                               Icons.keyboard_arrow_down,
//                             ),
//                             trailing: Text(''),
//                             iconColor: appColor,
//                             collapsedIconColor: appColor,
//                             expandedCrossAxisAlignment:
//                                 CrossAxisAlignment.stretch,
//                             // maintainState: true,
//                             childrenPadding: EdgeInsets.only(
//                               left: 50.0,
//                             ),
//                             children: [
//                               Container(
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.2,
//                                 child: ListView.builder(
//                                     itemCount: forRent.length,
//                                     itemBuilder: (_, index) {
//                                       return InkWell(
//                                         onTap: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       PostAccommodation(
//                                                         isNew: true,
//                                                         category: forRent[index]
//                                                             .toString(),
//                                                       )));
//                                         },
//                                         child: Container(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(forRent[index]),
//                                               Divider(),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     }),
//                               )
//                             ]),
//                         // Divider(),
//                         ExpansionTile(
//                           title: Text(
//                             'for sale',
//                             style: TextStyle(
//                               color: appColor,
//                               fontSize: 15.0,
//                             ),
//                           ),
//                           leading: Icon(
//                             Icons.keyboard_arrow_down,
//                           ),
//                           trailing: Text(''),
//                           iconColor: appColor,
//                           collapsedIconColor: appColor,
//                           expandedCrossAxisAlignment:
//                               CrossAxisAlignment.stretch,
//                           childrenPadding: EdgeInsets.only(
//                             left: 50.0,
//                           ),
//                           children: [
//                             Container(
//                               height: MediaQuery.of(context).size.height * 0.2,
//                               child: ListView.builder(
//                                   itemCount: forsale.length,
//                                   itemBuilder: (_, index) {
//                                     return InkWell(
//                                       onTap: () {
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     PostAccommodation(
//                                                       isNew: true,
//                                                       category: forsale[index]
//                                                           .toString(),
//                                                     )));
//                                       },
//                                       child: Container(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(forsale[index]),
//                                             Divider(),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
