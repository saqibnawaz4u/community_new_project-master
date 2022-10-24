// import 'dart:convert';

// import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/favouriteScreen.dart';
// import 'package:community_new/models/accommodationPosting.dart';
// import 'package:flutter/material.dart';

// import '../../../api_services/api_services.dart';
// import '../models/house.dart';
// import '../screens/details/details.dart';
// import '../screens/postAccomodation.dart';
// import 'circle_icon_button.dart';

// class BestOffer extends StatefulWidget {

//   final Function runFilter;
//   BestOffer({Key? key,required this.runFilter}) : super(key: key);

//   @override
//   State<BestOffer> createState() => _BestOfferState();
// }

// class _BestOfferState extends State<BestOffer> {

  
//   // List<AccommodationPosting> getaccPosting = [];

//   // _getaccommodation() async {
//   //   {
//   //     ApiServices.fetch(
//   //       'accommodationposting',
//   //     ) //current user id will pass here
//   //         .then((response) {
//   //       setState(() {
//   //         try {
//   //           Iterable list = json.decode(response.body);
//   //           //print ( response.body );
//   //           getaccPosting = list
//   //               .map((model) => AccommodationPosting.fromJson(model))
//   //               .toList();
//   //           // print(masjids[0].Id);
//   //           //  .text="test";
//   //         } on Exception catch (e) {}
//   //       });
//   //     });
//   //   }
//   // }

 

//   void initState() {
//     super.initState();

    
//     // _getaccommodation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       primary: false,
//       itemCount: getaccPosting.length,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => PostAccommodation(
//                       isNew: false,
//                       accId: getaccPosting[index].id,
//                     )));
//           },
//           child: Container(
//             margin: const EdgeInsets.only(bottom: 10),
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Stack(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 150,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage('assets/images/offer01.jpeg'),
//                           fit: BoxFit.cover,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           getaccPosting[index].forRentBy.toString(),
//                           style:
//                               Theme.of(context).textTheme.headline1!.copyWith(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           getaccPosting[index].location.toString(),
//                           style:
//                               Theme.of(context).textTheme.bodyText1!.copyWith(
//                                     fontSize: 14,
//                                   ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Positioned(
//                     right: 0,
//                     child: CircleIconButton(
//                       iconUrl: 'assets/icons/heart.svg',
//                       color: Colors.grey,
//                     ))
//               ],
//             ),
//           ),
//         );
//       },
//     );
  
//   }
// }
