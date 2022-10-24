import 'dart:convert';
import 'package:community_new/UI%20SCREENS/create_accomodation/widgets/search_input.dart';
import 'package:community_new/UI%20SCREENS/dashboard/eventScreen.dart';
import 'package:community_new/UI%20SCREENS/dashboard/prayer_times_update.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/widgets/genericAppBar.dart';
import 'package:community_new/widgets/genericDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../api_services/api_services.dart';
import '../../models/RSS.dart';
import '../create_accomodation/screens/home/chat.dart';
import '../credentials/log_in.dart';
import '../notifications/notification_screen.dart';
import 'masjidContactUpdate.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static DateTime dateToday = DateTime.now();
  static String date = dateToday.toString().substring(0, 10);

  List<RSS> rss_List = [
    // RSS(
    //   id: 1,
    //   source_id: 4,
    //   source_module: 'communityevent',
    //   rSStype: '',
    //   crud: 'new',
    //   description: 'added an event',
    //   entry_date:date
    // ),
    // RSS(
    //     id: 2,
    //     source_id: 7,
    //     source_module: 'communityevent',
    //     rSStype: '',
    //     crud: 'update',
    //     description: 'updated an event',
    //     entry_date:date
    // ),
    // RSS(
    //     id: 3,
    //     source_id: 7,
    //     source_module: 'masjid',
    //     rSStype: '',
    //     crud: 'new',
    //     description: 'added salah time',
    //     entry_date:date
    // ),
    //   RSS(
    //       id: 4,
    //       source_id: 17,
    //       source_module: 'masjid',
    //       rSStype: '',
    //       crud: 'update',
    //       description: 'updated salah time',
    //       entry_date:date
    //   )
  ];
  RSS rss = RSS();
  getRSS() async {
    int currentUserId = await prefs.get('userId');
    await ApiServices.fetch('rssfeed',
            actionName: 'GetRssFeedByUserID', param1: currentUserId.toString())
        .whenComplete(() => setState(() {}))
        .then((response) {
      setState(() {
        try {
          Iterable list = json.decode(response.body);
          rss_List = list.map((model) => RSS.fromJson(model)).toList();
        } on Exception catch (e) {}
      });
    });
  }

  int compareElement(RSS a, RSS b) =>
      a.entry_date!.toLowerCase().compareTo(b.entry_date!.toLowerCase());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    copiedmasjids = rss_List;
    getRSS();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text(
                  'No',
                  style: TextStyle(color: appColor),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(), // <-- SEE HERE
                child: new Text(
                  'Yes',
                  style: TextStyle(color: appColor),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  //  List<RSS> dashboard=[];
  List<RSS> copiedmasjids = [];
  void _runFilter(String enteredKeyword) async {
    List<RSS> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = await rss_List;
    } else {
      results = await rss_List
          .where((data) => data.user_Name!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      copiedmasjids = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    rss_List.sort(compareElement);
    //getRSS();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        top: true,
        child: Scaffold(
            drawer: genericDrawerForUser(),
            backgroundColor: whiteColor,
            // floatingActionButton: FloatingActionButton(
            //   backgroundColor: appColor,
            //   onPressed: (){},
            //   child: Icon(Icons.add),
            //
            // ),
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: genericAppBarForUser(
                  isSubScreen: false,
                  notificationPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                  chatPress: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ChatPage()));
                  },
                  txtfield: SizedBox(
                    height: 40,
                    child: Theme(
                      data: ThemeData(
                        colorScheme: ThemeData().colorScheme.copyWith(
                              primary: appColor,
                            ),
                      ),
                      child: TextFormField(
                        onChanged: (value) => _runFilter(value),
                        // controller: _controller,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: EdgeInsets.all(0),
                          // fillColor: whiteColor,
                          // filled: true,
                          hintText: 'Search here...',
                          prefixIconColor: appColor,
                          suffixIconColor: appColor,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.tune_outlined,
                              color: appColor,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                )),
            body: rss_List.isEmpty
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: whiteColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(),
                        Container(
                          child: Text(
                            'Loading... Please wait',
                            style: TextStyle(color: appColor),
                          ),
                        ),
                        CircularProgressIndicator(
                          backgroundColor: whiteColor,
                          color: appColor,
                        )
                      ],
                    ))
                : ListView.builder(
                    itemCount: copiedmasjids.isEmpty
                        ? rss_List.length
                        : copiedmasjids.length,
                    itemBuilder: (context, index) {
                      return
                          //  titleRow(
                          //      masjidName:masjids[0].Name.toString(),
                          //      description: rss_List[0].description.toString(),
                          //      entryDate: rss_List[0].entry_date.toString()),
                          //  midPadding2,midPadding2,
                          //
                          //  ListtileDate(
                          //    //source_id: eventobj.Id.toString(),
                          //    imagepath: 'assets/nwsc.png',
                          //      sourcename: events[0].name.toString(),
                          //      entryDate: rss_List[0].entry_date.toString(),
                          //      location: events[0].location.toString(),
                          //      description: events[0].description.toString()),
                          //
                          //  midPadding2,midPadding2,
                          //
                          //  titleRow(
                          //      masjidName:masjids[1].Name.toString(),
                          //      description: rss_List[1].description.toString(),
                          //      entryDate: rss_List[1].entry_date.toString()),
                          //  midPadding2,midPadding2,
                          //  ListtileDate(
                          //    //source_id: events[0].Id.toString(),
                          //    imagepath: 'assets/bilalmasjid.png',
                          //      sourcename: events[1].name.toString(),
                          //      entryDate: rss_List[1].entry_date.toString(),
                          //      location: events[1].location.toString(),
                          //      description: events[1].description.toString()),
                          //
                          //  midPadding2,midPadding2,
                          //
                          // Container(
                          //   color: Colors.blue.shade50.withOpacity(0.5),
                          //   child: Column(
                          //     children: [
                          //     titleRow(
                          //         masjidName:masjids[2].Name.toString(),
                          //         description: rss_List[2].description.toString(),
                          //         entryDate: rss_List[2].entry_date.toString()),
                          //     midPadding2,midPadding2,
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //       children: [
                          //         salahTimes(
                          //           prayerTimes: Text(masjids[2].Fajr.toString()),
                          //           PrayerLetter: 'f',),
                          //         salahTimes(
                          //           prayerTimes:  Text(masjids[2].Duhr.toString()),
                          //           PrayerLetter: 'Z',),
                          //         salahTimes(
                          //           prayerTimes: Text(masjids[2].Asr.toString()),
                          //           PrayerLetter: 'A',),
                          //         salahTimes(
                          //           prayerTimes:  Text(masjids[2].Maghrib.toString()),
                          //           PrayerLetter: 'M',),
                          //         salahTimes(
                          //           prayerTimes:  Text(masjids[2].Isha.toString()),
                          //           PrayerLetter: 'I',)
                          //       ],),
                          //       midPadding2
                          //   ],),
                          // ),
                          // midPadding2,
                          //showing_feed(),

                          rss_List[index].source_module == 'COMMUNITYEVENT'
                              ? EevntAddScreen(
                                  name: copiedmasjids.isEmpty
                                      ? rss_List[index].user_Name != null
                                          ? ''
                                          : rss_List[index].user_Name.toString()
                                      : copiedmasjids[index].user_Name!,
                                  title: rss_List[index].title == null
                                      ? ''
                                      : rss_List[index].title.toString(),
                                  //date: rss_List[index].entry_date.toString(),
                                  image: ClipRRect(
                                      // borderRadius:const BorderRadius.all(Radius.circular(8)),
                                      child: Image.asset(
                                    'assets/bilalmasjid.png',
                                    width: MediaQuery.of(context).size.width,
                                  )),
                                  descrtiption:
                                      rss_List[index].description.toString(),
                                  event_id: int.parse(
                                      rss_List[index].source_id.toString()),
                                )
                              : rss_List[index].source_module == 'MASJID' &&
                                      rss_List[index].rSStype ==
                                          'PRAYERTIMECHANGE'
                                  ? PrayerTimesAdd(
                                      prayertimes: Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffddc2ae),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8,
                                                    top: 4,
                                                    bottom: 4),
                                                child: Text(
                                                  'Fajr\n' +
                                                      rss_List[index]
                                                          .fajr
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: blueColor,
                                                      fontSize: 12),
                                                ),
                                              )),
                                          widthSizedBox8,
                                          Container(
                                              width: 80,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffddc2ae),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8,
                                                    top: 4,
                                                    bottom: 4),
                                                child: Text(
                                                  'Duhr\n' +
                                                      rss_List[index]
                                                          .duhr
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: blueColor,
                                                      fontSize: 12),
                                                ),
                                              )),
                                          widthSizedBox8,
                                          Container(
                                              width: 80,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffddc2ae),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8,
                                                    top: 4,
                                                    bottom: 4),
                                                child: Text(
                                                  'Asr\n' +
                                                      rss_List[index]
                                                          .asr
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: blueColor,
                                                      fontSize: 12),
                                                ),
                                              )),
                                          widthSizedBox8,
                                          Container(
                                              width: 80,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffddc2ae),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8,
                                                    top: 4,
                                                    bottom: 4),
                                                child: Text(
                                                  'Maghrib\n' +
                                                      rss_List[index]
                                                          .maghrib
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: blueColor,
                                                      fontSize: 12),
                                                ),
                                              )),
                                          widthSizedBox8,
                                          Container(
                                              width: 80,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffddc2ae),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8,
                                                    top: 4,
                                                    bottom: 4),
                                                child: Text(
                                                  'Isha\n' +
                                                      rss_List[index]
                                                          .isha
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: blueColor,
                                                      fontSize: 12),
                                                ),
                                              )),
                                        ],
                                      ),
                                      // date: rss_List[index].entry_date.toString(),
                                      name: copiedmasjids.isEmpty
                                          ? (rss_List[index].user_Name == null
                                              ? ''
                                              : rss_List[index]
                                                  .user_Name
                                                  .toString())
                                          : copiedmasjids[index]
                                              .user_Name
                                              .toString(),
                                      title: rss_List[index].title == null
                                          ? ''
                                          : rss_List[index].title.toString(),
                                      description: rss_List[index]
                                          .description
                                          .toString(),
                                      masjid_id: //rss_List[index].source_id!,
                                          int.parse(rss_List[index]
                                              .source_id
                                              .toString()),
                                    )
                                  : rss_List[index].source_module == 'MASJID' ||
                                          rss_List[index].rSStype ==
                                              'CONTACTINFOCHANGED'
                                      ? masjidContactUpdate(
                                          date: rss_List[index]
                                              .entry_date
                                              .toString(),
                                          title: rss_List[index].title == null
                                              ? ''
                                              : rss_List[index]
                                                  .title
                                                  .toString(),
                                          name: copiedmasjids.isEmpty
                                              ? (rss_List[index].user_Name ==
                                                      null
                                                  ? ''
                                                  : rss_List[index]
                                                      .user_Name
                                                      .toString())
                                              : copiedmasjids[index]
                                                  .user_Name
                                                  .toString(),
                                          description: rss_List[index]
                                              .description
                                              .toString(),
                                          masjid_id: //rss_List[index].source_id!,
                                              int.parse(rss_List[index]
                                                  .source_id
                                                  .toString()),
                                        )
                                      : Container(
                                          child: Text('Nothing to show here'),
                                        );

                      // PrayerTimesAdd(
                      // masjid_id: int.parse(rss_List[2].source_id.toString()),
                      // masjidName: masjids[2].Name.toString(),
                      // description: rss_List[2].description.toString(),
                      // entryDate: rss_List[2].entry_date.toString(),
                      // prayerTimes:
                      // Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // children: [
                      // salahTimes(
                      // prayerTimes: Text(masjids[2].Fajr.toString()),
                      // PrayerLetter: 'F',),
                      // salahTimes(
                      // prayerTimes:  Text(masjids[2].Duhr.toString()),
                      // PrayerLetter: 'Z',),
                      // salahTimes(
                      // prayerTimes: Text(masjids[2].Asr.toString()),
                      // PrayerLetter: 'A',),
                      // salahTimes(
                      // prayerTimes:  Text(masjids[2].Maghrib.toString()),
                      // PrayerLetter: 'M',),
                      // salahTimes(
                      // prayerTimes:  Text(masjids[2].Isha.toString()),
                      // PrayerLetter: 'I',)
                      // ],), );
                    })),
      ),
    );
  }
//   Widget salahTimes({
//   required Widget prayerTimes,
//     required String PrayerLetter,
// }){
//    return Column(
//      children: [
//      CircleAvatar(
//        child: Text(PrayerLetter),
//      ),
//      midPadding2,
//      prayerTimes
//    ],);
//   }
//
//   Widget titleRow(
//   {
//   required String masjidName,
//     required String description,
//     required String entryDate,
// }
//       ){
//     return Padding(
//       padding: const EdgeInsets.only(left:15.0,right: 15,top: 15),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.grey.shade200,
//             child: Icon(Icons.person),
//           ),
//           widthSizedBox8,
//           Text(
//             masjidName,
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           widthSizedBox8,
//           Text(description),
//           Spacer(),
//           Text(entryDate)
//         ],
//       ),
//     );
//   }
//
//   Widget ListtileDate({
//   required String sourcename,
//     required String entryDate,
//     required String location,
//     required String description,
//     required String imagepath,
//     //required String source_id
// })
// {
//   return ListTile(
//       leading: Image.asset(imagepath),
//       title: Text(sourcename),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(entryDate),
//           Text(location + ': ' + description),
//         ],
//       ),
//     );
//   }
}
