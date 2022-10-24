// import 'package:flutter/material.dart';

// import '../../../../constants/styles.dart';

// class FilterList extends StatefulWidget {
//   FilterList(
//       {this.noofBathrooms,
//       this.noofBedrooms,
//       this.untilityIncluded,
//       this.accessibleWahshroms,
//       this.aggrementType,
//       this.appliances,
//       this.barrierFreeEntrance,
//       this.forRentBy,
//       this.furnished,
//       this.parkingIncluded,
//       this.personalOutdoorSpaces,
//       this.petFriendly,
//       this.smookingPermitted,
//       this.visualAids,
//       Key? key})
//       : super(key: key);

//   final String? noofBathrooms;
//   final String? noofBedrooms;
//   final String? untilityIncluded;
//   final String? parkingIncluded;
//   final String? furnished;
//   final String? appliances;
//   final String? petFriendly;
//   final String? aggrementType;
//   final String? barrierFreeEntrance;
//   final String? visualAids;
//   final String? accessibleWahshroms;
//   final String? personalOutdoorSpaces;
//   final String? smookingPermitted;
//   final String? forRentBy;

//   @override
//   State<FilterList> createState() => _FilterListState();
// }

// class _FilterListState extends State<FilterList> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Filter accomudation',
//         ),
//         titleTextStyle: TextStyle(color: Colors.black),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: ListView(
//           children: [
//             Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: whiteColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Stack(
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 150,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage('assets/darussalam.jpg'),
//                             fit: BoxFit.cover,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.appliances!,
//                             style:
//                                 Theme.of(context).textTheme.headline1!.copyWith(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             widget.parkingIncluded!,
//                             style:
//                                 Theme.of(context).textTheme.bodyText1!.copyWith(
//                                       fontSize: 12,
//                                     ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                       right: -5,
//                       child: Row(
//                         children: [
//                           PopupMenuButton(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             itemBuilder: (context) {
//                               return [
//                                 _buildPopupMenuItem(
//                                     //'Edit',
//                                     'assets/edit.png',
//                                     //Icons.edit,
//                                     'edit'),
//                                 _buildPopupMenuItem(
//                                     //'Delete',
//                                     'assets/delete.png',
//                                     //Icons.delete_outline,
//                                     'delete'),
//                               ];
//                             },
//                             // onSelected: (value) {
//                             //   if(value=='edit'){
//                             //     Navigator.push(
//                             //         context,
//                             //         MaterialPageRoute(
//                             //             builder: (context) => EditMasjidStepper(
//                             //               objMasjidAdmin1: masjids[index].Masjid_admin,
//                             //               isNew: false,
//                             //               masjidId:  masjids[index].Id.toString(),
//                             //             )));
//                             //   }
//                             //   else if(value=='delete'){
//                             //     // await
//                             //     apiService.deleteFn(int.parse(
//                             //         masjids[index].Id.toString()),'masjid');
//                             //     ScaffoldMessenger.of(context)
//                             //         .showSnackBar(const SnackBar(
//                             //         content:  Text("Masjid Deleted Successfully")));
//                             //     Navigator.push(
//                             //         context,
//                             //         MaterialPageRoute(
//                             //           builder: (context) =>
//                             //               Masjids(),
//                             //         ));
//                             //   }
//                             // },
//                           ),
//                         ],
//                       ))
//                 ],
//               ),
//             ),

//             // Container(

//             //   child: Column(
//             //     children: [
//             //       Text(
//             //         widget.noofBathrooms!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       Text(
//             //         widget.noofBedrooms!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       Text(
//             //         widget.untilityIncluded!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       Text(
//             //         widget.parkingIncluded!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       Text(
//             //         widget.appliances!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       Text(
//             //         widget.furnished!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       Text(
//             //         widget.petFriendly!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       Text(
//             //         widget.barrierFreeEntrance!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       Text(
//             //         widget.visualAids!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       Text(
//             //         widget.accessibleWahshroms!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       Text(
//             //         widget.personalOutdoorSpaces!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       Text(
//             //         widget.smookingPermitted!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //       Text(
//             //         widget.forRentBy!,
//             //         style: TextStyle(
//             //           fontSize: 15.0,
//             //           fontWeight: FontWeight.normal,
//             //           color: Colors.black,
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   PopupMenuItem _buildPopupMenuItem(
//       String imageUrl,
//       // IconData iconData,
//       String position) {
//     return PopupMenuItem(
//       value: position,
//       child: Container(
//           width: 50,
//           child: Center(
//             child: Image.asset(
//               imageUrl,
//               color: appColor,
//             ),
//           )),
//       //Text(title),
//     );
//   }
// }
