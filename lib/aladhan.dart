import 'dart:convert';

import 'package:community_new/models/AladhanModel.dart';
import 'package:community_new/models/aladhan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'api_services/api_services.dart';
import 'constants/styles.dart';

class AdhanScreen extends StatefulWidget {
  final bool? isNew;
  const AdhanScreen({super.key, this.isNew});

  @override
  State<AdhanScreen> createState() => _AdhanScreenState();
}

class _AdhanScreenState extends State<AdhanScreen> {
  showAlertDialog(BuildContext context) {
    // Create button
    Widget yesButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.of(context, rootNavigator: true).pop(false);
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => AccommodationPosting()));
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

  List<Aladhan> aladhan = [];

  _getAdhanData() async {
    print('This is get function');
    // int currentUserId = await prefs.get('userId');
    await ApiServices.fetch(
      'aladhan/getprayertimecity?city=karachi&country=pakistan&method=5',
      // actionName: 'GetForEndUser',
      // param1: currentUserId.toString(),
    ).then((response) {
      setState(() {
        print(jsonDecode(response.body));
        //Iterable list = json.decode(response.body);
//AladhanModel data = AladhanModel.fromMap(response.body);

        // print(data.data!.meta!.timezone.toString());
        //aladhan = list.map((model) => Aladhan.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getAdhanData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          color: appColor,
          onPressed: () {
            showAlertDialog(context);
          },
          icon: Icon(CupertinoIcons.chevron_back),
        ),
        backgroundColor: whiteColor,
        title: widget.isNew == false
            ? Text(
                "Edit",
                style: TextStyle(fontSize: 20, color: appColor),
              )
            : Text(
                "AlAdhan",
                style: TextStyle(fontSize: 20, color: appColor),
              ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: aladhan.length,
          itemBuilder: (_, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aladhan[index].data!.timings!.fajr!,
                ),
                Text(
                  aladhan[index].data!.timings!.dhuhr!,
                ),
                Text(
                  aladhan[index].data!.timings!.asr!,
                ),
                Text(
                  aladhan[index].data!.timings!.maghrib!,
                ),
                Text(
                  aladhan[index].data!.timings!.isha!,
                ),
                Text(
                  "this is masjid data",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// // ignore_for_file: unused_field

// import 'dart:convert';

// import 'package:community_new/UI%20SCREENS/Organizations/org_tree.dart';
// import 'package:community_new/UI%20SCREENS/credentials/log_in.dart';
// import 'package:community_new/models/event.dart';
// import 'package:community_new/models/masjid.dart';
// import 'package:community_new/models/organization.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/cupertino.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:flutter/material.dart';

// import 'models/eidTimings.dart';

// class Bottom extends StatefulWidget {
//   const Bottom({Key? key}) : super(key: key);

//   @override
//   State<Bottom> createState() => _BottomState();
// }

// class _BottomState extends State<Bottom> {
//   // PersistentTabController _controller =
//   //     PersistentTabController(initialIndex: 0);
//   List<EidTiming> eidTimes = [];
//   Future<List<EidTiming>> _getEidTimings() async {
//     final response =
//         await http.get(Uri.parse('http://ijtimaee.com/api/eidtimings'));
//     var data = json.decode(response.body.toString());

//     if (response.statusCode == 200) {
//       for (Map i in data) {
//         eidTimes.add(EidTiming.fromJson(i));
//       }
//       print('responsecode is' + response.statusCode.toString());
//       return eidTimes;
//     } else {
//       return eidTimes;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//           future: _getEidTimings(),
//           builder: (_, snapshot) {
//             if (!snapshot.hasData) {

//               return Text('Loading');
//             } else {
//               return ListView.builder(itemBuilder: (_, index) {
//                 return Container(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(eidTimes[index].salahTime.toString()),
//                       Text('Hello This is Api'),
//                       Text(eidTimes[index].salahCounter.toString()),
//                     ],
//                   ),
//                 );
//               });
//             }
//             ;
//           }),
//     );
//   }

//   List<Widget> _buildScreens() {
//     return [
//       LogIn(),
//       OrgTree(),
//     ];
//   }

//   List<PersistentBottomNavBarItem> _navBarsItems() {
//     return [
//       PersistentBottomNavBarItem(
//         icon: Icon(CupertinoIcons.home),
//         title: ("Home"),
//         activeColorPrimary: CupertinoColors.activeBlue,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//       PersistentBottomNavBarItem(
//         icon: Icon(CupertinoIcons.settings),
//         title: ("Settings"),
//         activeColorPrimary: CupertinoColors.activeBlue,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//     ];
//   }
// }
