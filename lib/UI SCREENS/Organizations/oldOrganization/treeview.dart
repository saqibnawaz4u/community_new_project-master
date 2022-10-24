//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:tree_view/tree_view.dart';
//
//
// class TestPage extends StatefulWidget {
//   @override
//   _TestPageState createState() => _TestPageState();
// }
//
// class _TestPageState extends State<TestPage> {
//   String responseBody =
//       '{ "id": 0,"name": "A","children": [{  "id": 1, "name": "Aa",'
//       '"children": [{"id": 2,"name": "Aa1","children": null}]},'
//       '{ "id": 3, "name": "Ab","children": [{"id": 4,"name": "Ab1",'
//       '"children": null},{"id": 5,"name": "Ab2","children": null}]}]}';
//
//   @override
//   Widget build(BuildContext context) {
//     Map mapBody = jsonDecode(responseBody);
//
//     return SafeArea(
//     child: Scaffold(
//     body: printGroupTree(
//     mapBody,
//     ),
//     ),
//     );
//     }
//
//   Widget printGroupTree(
//       Map group, {
//         double level=0,
//       }) {
//     if (group['children'] != null) {
//       List<Widget> subGroups = [];
//     for (Map subGroup in group['children']) {
//     subGroups.add(
//     printGroupTree(
//     subGroup,
//     level: level + 1,
//     ),
//     );
//     }
//     return TreeViewChild(
//       startExpanded: true,
//       onTap: (){},
//       children: subGroups,
//       parent: Column(children: [
//         // Card(
//         //   child: ListTile(
//         //     onTap: (){},
//         //     title: Text(group['id'].toString()),
//         //   subtitle:   Text(group['children'].toString()),
//         //   ),
//         // )
//         Card(
//           child: ListTile(
//             title: Text("id : "+group['id'].toString()),
//             subtitle: Text("childrens : "+group['children'].toString()),
//           ),
//         ),
//
//       ],)
//     );
//     } else {
//     return _card(
//     group['children'],
//     level * 20,
//     );
//     }
//   }
//   Widget _card(
//       String groupName,
//       double leftPadding,
//       ) {
//     return Container(
//       padding: EdgeInsets.only(
//         left: leftPadding + 5,
//         right: 20,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(50.0),
//       ),
//       height: 100,
//       child: Row(
//         children: <Widget>[
//           Container(
//             width: 250,
//             child: Row(
//               children: <Widget>[
//                 Container(
//                   height: 70,
//                   width: 70,
//
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//
//               ],
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
// }