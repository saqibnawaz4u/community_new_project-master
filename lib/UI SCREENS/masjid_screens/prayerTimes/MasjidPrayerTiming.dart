import 'dart:convert';
import 'package:community_new/UI%20SCREENS/create_accomodation/widgets/search_input.dart';
import 'package:community_new/UI%20SCREENS/credentials/log_in.dart';
import 'package:community_new/models/UserEvent.dart';
import 'package:community_new/models/jummaTimings.dart';
import 'package:community_new/models/ramadanTimes.dart';
import 'package:community_new/widgets/genericAppBar.dart';
import 'package:community_new/widgets/genericDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../api_services/api_services.dart';
import '../../../constants/styles.dart';
import 'package:http/http.dart' as http;
import '../../../models/UserMasjids.dart';
import '../../../models/eidTimings.dart';
import '../../../models/masjid.dart';
import '../../../provider/FavouriteItemProvider.dart';
import '../../create_accomodation/screens/home/chat.dart';
import '../../notifications/notification_screen.dart';
import 'masjid prayer Times details.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MasjidPrayerTiming extends StatefulWidget {
  final int? masjid_id;
  MasjidPrayerTiming({
    this.masjid_id,
  });
  @override
  MasjidPrayerTimingState createState() => new MasjidPrayerTimingState();
}

class MasjidPrayerTimingState extends State<MasjidPrayerTiming>
    with SingleTickerProviderStateMixin {
  final ApiServices apiService = ApiServices();
  //MasjidModel? masjid;
  List<Masjid> masjids = [];
  List<UserMasjids>? selectedendUserMasjids = [];
  List<RamadanTimes> ramadanTimes = [];
  List<Masjid> copiedmasjids = [];
  List<bool> isChecked = [];
  var masjid = Masjid();

  var endusermasajids = UserMasjids();
  bool isSelected(int? p_Id) {
    if (selectedendUserMasjids == null) return false;
    for (int i = 0; i < selectedendUserMasjids!.length; i++)
      if (selectedendUserMasjids?[i].masjidid == p_Id) return true;
    return false;
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  // void _onLoading() async{
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   copiedmasjids.add((copiedmasjids.length+1);
  //   if(mounted)
  //   setState(() {

  //   });
  //   _refreshController.loadComplete();
  // }

  // List<String> images=[
  //   'assets/bilalmasjid.png',
  //   'assets/darussalam.png',
  //    'assets/bilalmasjid.png',
  //    'assets/bilalmasjid.png',
  //   'assets/darussalam.png',
  //   'assets/darussalam.png',
  // ];
  _getMasjid() async {
    int currentUserId = await prefs.get('userId');
    await ApiServices.fetch('masjid',
            actionName: 'GetForEndUser', param1: currentUserId.toString())
        .then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print('Masjids Data' + response.body);
        masjids = list.map((model) => Masjid.fromJson(model)).toList();
      });
    });
  }

  _getendUserFavMasjid() async {
    String currentRole = await prefs.getString('role_name');
    int currentUserId = await prefs.get('userId');
    ApiServices.fetch('endusermasjids',
            actionName: currentUserId.toString(), param1: null)
        .whenComplete(() => setState(() {}))
        .whenComplete(() => setState(() {}))
        .then((response) {
      setState(() {
        try {
          //errorController.text = "";
          Iterable list = json.decode(response.body);
          //print ( response.body );
          selectedendUserMasjids =
              list.map((model) => UserMasjids.fromJson(model)).toList();
          // print(masjids[0].Id);
          //  errorController.text="test";
        } on Exception catch (e) {
          //errorController.text = "wow : " + e.toString ( );
        }
      });
    });
    isChecked = await List<bool>.filled(masjids.length, false);
    for (int i = 0; i < masjids.length; i++) {
      //if(isSelected(users[i].Id)){
      isChecked[i] = isSelected(masjids[i].Id);
    }
  }

  _getTaraveeh() async {
    int currentUserId = await prefs.get('userId');
    await ApiServices.fetch(
      'ramadantimes',
      // actionName: 'GetForEndUser',
      // param1: currentUserId.toString(),
    ).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(response.body);
        ramadanTimes =
            list.map((model) => RamadanTimes.fromJson(model)).toList();
      });
    });
  }

  List<EidTimings> eidTimes = [];
  _getEidTimings() async {
    int currentUserId = await prefs.get('userId');
    await ApiServices.fetch(
      'eidtimings',
      //  actionName: 'GetForEndUser', param1: currentUserId.toString()
    ).then((response) {
      setState(() {
        Iterable list = json.decode(response.body.toString());
        print('Status Code is $response.statusCode');
        print('eid timings' + response.body);
        print('Hello This is eid timing');
        eidTimes = list.map((model) => EidTimings.fromJson(model)).toList();
      });
    });
  }

  // List<JummaTimings> jummaList = [];
  // _getJummaTimings() async {
  //   int currentUserId = await prefs.get('userId');
  //   await ApiServices.fetch(
  //     'jummatimings',
  //     //  actionName: 'GetForEndUser', param1: currentUserId.toString()
  //   ).then((response) {
  //     setState(() {
  //       Iterable list = json.decode(response.body.toString());
  //       print('Status Code is $response.statusCode');
  //       print('eid timings' + response.body);
  //       print('Hello This is eid timing');
  //       jummaList = list.map((model) => JummaTimings.fromJson(model)).toList();
  //     });
  //   });
  // }

  // Future<List<EidTiming>> _getEidTimings() async {
  //   final response =
  //       await http.get(Uri.parse('http://ijtimaee.com/api/eidtimings'));
  //   var data = json.decode(response.body.toString());
  //
  //   if (response.statusCode == 200) {
  //     for (Map i in data) {
  //       eidTimes.add(EidTiming.fromJson(i));
  //     }
  //     print('responsecode is' + response.statusCode.toString());
  //     return eidTimes;
  //   } else {
  //     return eidTimes;
  //   }
  // }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = masjids.removeAt(oldindex);
      masjids.insert(newindex, items);
    });
  }

  void reorderRamadanData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = ramadanTimes.removeAt(oldindex);
      ramadanTimes.insert(newindex, items);
    });
  }

  void reorderEidData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = eidTimes.removeAt(oldindex);
      eidTimes.insert(newindex, items);
    });
  }

  TabController? _tabController;

  void sorting() {
    setState(() {
      masjids.sort();
      ramadanTimes.sort();
      eidTimes.sort();
    });
  }

  @override
  void initState() {
    //    print("hhhh");
    _getMasjid();
    _getTaraveeh();
    _getEidTimings();
    _getendUserFavMasjid();
    copiedmasjids = masjids;
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_handleTabIndex);
    //selectedRole=roles[1];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
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

  void _runFilter(String enteredKeyword) async {
    List<Masjid> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = await masjids;
    } else {
      results = await masjids
          .where((masjid) =>
              masjid.Name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
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
    final favouriteItemProvider = Provider.of<FavouriteItemProvider>(context);
    return DefaultTabController(
        length: 2,
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            drawer: genericDrawerForUser(),
            backgroundColor: backgroundColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(90),
              child: genericAppBarForUser(
                isSubScreen: false,
                notificationPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NotificationScreen()));
                },
                chatPress: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChatPage()));
                },
                txtfield: SearchInput(
                  isPrayerTime: true,
                  onChanged: (value) => _runFilter(value!),
                ),
                bottom: TabBar(
                  labelColor: appColor,
                  unselectedLabelColor: Colors.grey, //offWhite,
                  padding: EdgeInsets.only(top: 1),
                  indicatorSize: TabBarIndicatorSize.label,

                  indicatorColor: whiteColor,
                  controller: _tabController,
                  tabs: [
                    _tabController!.index == 0
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xffd08e63),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'My Masjids',
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 2.0,
                                    offset: Offset(0.0, 0.75))
                              ],
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'My Masjids',
                              style: TextStyle(
                                color: Color(0xff93573c),
                              ),
                            ),
                          ),

                    _tabController!.index == 1
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xffd08e63),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'All Masjids',
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 2.0,
                                    offset: Offset(0.0, 0.75))
                              ],
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'All Masjids',
                              style: TextStyle(
                                color: Color(0xff93573c),
                              ),
                            ),
                          ),

                    // Text(
                    //   "My Masjids",
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    // Text(
                    //   'All Masjids',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                  ],
                ),
              ),
            ),
            body: Container(
              color: whiteColor,
              child: TabBarView(
                controller: _tabController,
                children: [
                  selectedendUserMasjids!.isEmpty
                      ? Center(child: Text('empty'))
                      : SmartRefresher(
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          child: ReorderableListView.builder(
                            shrinkWrap: true,
                            primary: true,
                            itemCount: //4,
                                selectedendUserMasjids!.length,
                            onReorder: reorderData,
                            itemBuilder: ((context, index) {
                              return isSelected(
                                      selectedendUserMasjids![index].masjidid)
                                  ? Padding(
                                      key: ValueKey(masjids[index]),
                                      padding: const EdgeInsets.only(
                                        // bottom: 10,
                                        left: 10.0,
                                        right: 10.0,
                                        top: 2.0,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        // color: whiteColor,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: whiteColor,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Colors.black54,
                                              blurRadius: 2.0,
                                              offset: Offset(0.0, 0.75),
                                            )
                                          ],
                                          // image:const DecorationImage(
                                          //     image: AssetImage('assets/mosque.png'),
                                          //     fit:BoxFit.cover
                                          // ),
                                          //   //color: appColor.withOpacity(0.5)
                                        ),
                                        child: Column(
                                          children: [
                                            midPadding2,
                                            ListTile(
                                              onTap: () {
                                                print('Going to Details page');
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        masjidPrayerTimeDetails(
                                                      isprayerTime: false,
                                                      name: masjids[index]
                                                          .Name
                                                          .toString(),
                                                      fajr: masjids[index]
                                                          .Fajr
                                                          .toString(),
                                                      duhr: masjids[index]
                                                          .Duhr
                                                          .toString(),
                                                      asr: masjids[index]
                                                          .Asr
                                                          .toString(),
                                                      maghrib: masjids[index]
                                                          .Maghrib
                                                          .toString(),
                                                      isha: masjids[index]
                                                          .Isha
                                                          .toString(),
                                                      desc: masjids[index]
                                                          .Description
                                                          .toString(),
                                                      address: masjids[index]
                                                          .AddressLine1,
                                                      masjidId:
                                                          masjids[index].Id,
                                                      // eid_Sno: eidTimes[index].sNo,
                                                      // takberat_time: eidTimes[index].takbeeratTime,
                                                      // lec_time: eidTimes[index].lectureTime,
                                                      // salah_time: eidTimes[index].salahTime,
                                                      // startDate:
                                                      //     ramadanTimes[index].startDate == null
                                                      //         ? ''
                                                      //         : ramadanTimes[index].startDate,
                                                      // endDate:
                                                      //     ramadanTimes[index].endDate == null
                                                      //         ? ''
                                                      //         : ramadanTimes[index].endDate,
                                                      // format: ramadanTimes[index].format == null
                                                      //     ? 1
                                                      //     : ramadanTimes[index].format,
                                                      // Sno: ramadanTimes[index].sNo == null
                                                      //     ? 5
                                                      //     : ramadanTimes[index].sNo,
                                                      city: masjids[index].City,
                                                      capacity: masjids[index]
                                                          .capacity,
                                                      country: masjids[index]
                                                          .Country,
                                                      // first_juma:
                                                      //     masjids[index].Id==jummaList[0].masjidId?jummaList[0].iqamaTime:
                                                      //     '',
                                                      // sec_juma:
                                                      //     masjids[index].Id==jummaList[0].masjidId?
                                                    ),
                                                  ),
                                                );
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) => masjidPrayerTimeDetails(
                                                //       isprayerTime: false,
                                                //       name: masjids[index].Name.toString(),
                                                //       fajr: masjids[index].Fajr.toString(),
                                                //       duhr: masjids[index].Duhr.toString(),
                                                //       asr: masjids[index].Asr.toString(),
                                                //       maghrib: masjids[index].Maghrib.toString(),
                                                //       isha: masjids[index].Isha.toString(),
                                                //       desc: masjids[index].Description.toString(),
                                                //       address: masjids[index].AddressLine1,
                                                //       startDate: ramadanTimes[index].startDate == null
                                                //           ? ''
                                                //           : ramadanTimes[index].startDate,
                                                //       endDate: ramadanTimes[index].endDate == null
                                                //           ? ''
                                                //           : ramadanTimes[index].endDate,
                                                //       format: ramadanTimes[index].format == null
                                                //           ? 1
                                                //           : ramadanTimes[index].format,
                                                //       Sno: ramadanTimes[index].sNo == null
                                                //           ? 5
                                                //           : ramadanTimes[index].sNo,
                                                //       takberat_time:
                                                //           eidTimes[index].takbeeratTime == null
                                                //               ? ''
                                                //               : eidTimes[index].takbeeratTime,
                                                //       salah_time: eidTimes[index].salahTime == null
                                                //           ? ''
                                                //           : eidTimes[index].salahTime,
                                                //       eid_Sno: eidTimes[index].sNo == null
                                                //           ? 5
                                                //           : eidTimes[index].sNo,
                                                //       lec_time: eidTimes[index].lectureTime == null
                                                //           ? ''
                                                //           : eidTimes[index].lectureTime,
                                                //       // masjidId: eidTimes[index].masjidId,
                                                //       juma: masjids[index].FirstJuma == null
                                                //           ? ''
                                                //           : masjids[index].FirstJuma,
                                                //       capacity: masjids[index].capacity,
                                                //       city: masjids[index].City,
                                                //       country: masjids[index].Country,
                                                //     ),
                                                //   ),
                                                // );
                                              },
                                              title: copiedmasjids.isEmpty
                                                  ? Text(
                                                      masjids[index]
                                                              .Name
                                                              .toString() +
                                                          " Masjid\n",
                                                      style: const TextStyle(
                                                          color: appColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      copiedmasjids[index]
                                                              .Name
                                                              .toString() +
                                                          " Masjid\n",
                                                      style: const TextStyle(
                                                          color: appColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                              subtitle: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        width: 80,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xffd08e63),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  right: 8,
                                                                  top: 4,
                                                                  bottom: 4),
                                                          child: Text(
                                                            'Fajr  \n' +
                                                                masjids[index]
                                                                    .Fajr
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 12),
                                                          ),
                                                        )),
                                                    widthSizedBox,
                                                    Container(
                                                        width: 80,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xffd08e63),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  right: 8,
                                                                  top: 4,
                                                                  bottom: 4),
                                                          child: Text(
                                                            'Duhr  \n' +
                                                                masjids[index]
                                                                    .Duhr
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 12),
                                                          ),
                                                        )),
                                                    widthSizedBox,
                                                    Container(
                                                        width: 80,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xffd08e63),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  right: 8,
                                                                  top: 4,
                                                                  bottom: 4),
                                                          child: Text(
                                                            'Asr  \n' +
                                                                masjids[index]
                                                                    .Asr
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 12),
                                                          ),
                                                        )),
                                                    widthSizedBox,
                                                    Container(
                                                        width: 80,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xffd08e63),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  right: 8,
                                                                  top: 4,
                                                                  bottom: 4),
                                                          child: Text(
                                                            'Maghrib  \n' +
                                                                masjids[index]
                                                                    .Maghrib
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 12),
                                                          ),
                                                        )),
                                                    widthSizedBox,
                                                    Container(
                                                      width: 80,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffd08e63),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                      //color:  Colors.white.withOpacity(0.4),
                                                      //Colors.white.withOpacity(0.5),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                right: 8,
                                                                top: 4,
                                                                bottom: 4),
                                                        child: Text(
                                                          'Isha  \n' +
                                                              masjids[index]
                                                                  .Isha
                                                                  .toString(),
                                                          style: TextStyle(
                                                              color: whiteColor,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            midPadding2,
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container();
                            }),
                          ),
                        ),
                  Container(
                    child: ReorderableListView.builder(
                        itemCount: //4,
                            copiedmasjids.isEmpty
                                ? masjids.length
                                : copiedmasjids.length,
                        onReorder: reorderData,
                        itemBuilder: ((context, index) {
                          return Consumer<FavouriteItemProvider>(
                              key: ValueKey(masjids[index]),
                              builder: (context, value, child) {
                                return index > 3
                                    ? Container(
                                        key: ValueKey(masjids[index]),
                                      )
                                    : Padding(
                                        key: ValueKey(masjids[index]),
                                        padding: const EdgeInsets.only(
                                          // bottom: 10,
                                          left: 10.0,
                                          right: 10.0,
                                          top: 2.0,
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          // color: whiteColor,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: whiteColor,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                color: Colors.black54,
                                                blurRadius: 2.0,
                                                offset: Offset(0.0, 0.75),
                                              )
                                            ],
                                            // image:const DecorationImage(
                                            //     image: AssetImage('assets/mosque.png'),
                                            //     fit:BoxFit.cover
                                            // ),
                                            //   //color: appColor.withOpacity(0.5)
                                          ),
                                          child: Column(
                                            children: [
                                              midPadding2,
                                              ListTile(
                                                onTap: () {
                                                  print(
                                                      'Going to Details page');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          masjidPrayerTimeDetails(
                                                        isprayerTime: false,
                                                        name: masjids[index]
                                                            .Name
                                                            .toString(),
                                                        fajr: masjids[index]
                                                            .Fajr
                                                            .toString(),
                                                        duhr: masjids[index]
                                                            .Duhr
                                                            .toString(),
                                                        asr: masjids[index]
                                                            .Asr
                                                            .toString(),
                                                        maghrib: masjids[index]
                                                            .Maghrib
                                                            .toString(),
                                                        isha: masjids[index]
                                                            .Isha
                                                            .toString(),
                                                        desc: masjids[index]
                                                            .Description
                                                            .toString(),
                                                        address: masjids[index]
                                                            .AddressLine1,
                                                        masjidId:
                                                            masjids[index].Id,
                                                        // eid_Sno: eidTimes[index].sNo,
                                                        // takberat_time: eidTimes[index].takbeeratTime,
                                                        // lec_time: eidTimes[index].lectureTime,
                                                        // salah_time: eidTimes[index].salahTime,
                                                        // startDate:
                                                        //     ramadanTimes[index].startDate == null
                                                        //         ? ''
                                                        //         : ramadanTimes[index].startDate,
                                                        // endDate:
                                                        //     ramadanTimes[index].endDate == null
                                                        //         ? ''
                                                        //         : ramadanTimes[index].endDate,
                                                        // format: ramadanTimes[index].format == null
                                                        //     ? 1
                                                        //     : ramadanTimes[index].format,
                                                        // Sno: ramadanTimes[index].sNo == null
                                                        //     ? 5
                                                        //     : ramadanTimes[index].sNo,
                                                        city:
                                                            masjids[index].City,
                                                        capacity: masjids[index]
                                                            .capacity,
                                                        country: masjids[index]
                                                            .Country,
                                                        // first_juma:
                                                        //     masjids[index].Id==jummaList[0].masjidId?jummaList[0].iqamaTime:
                                                        //     '',
                                                        // sec_juma:
                                                        //     masjids[index].Id==jummaList[0].masjidId?
                                                      ),
                                                    ),
                                                  );
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) => masjidPrayerTimeDetails(
                                                  //       isprayerTime: false,
                                                  //       name: masjids[index].Name.toString(),
                                                  //       fajr: masjids[index].Fajr.toString(),
                                                  //       duhr: masjids[index].Duhr.toString(),
                                                  //       asr: masjids[index].Asr.toString(),
                                                  //       maghrib: masjids[index].Maghrib.toString(),
                                                  //       isha: masjids[index].Isha.toString(),
                                                  //       desc: masjids[index].Description.toString(),
                                                  //       address: masjids[index].AddressLine1,
                                                  //       startDate: ramadanTimes[index].startDate == null
                                                  //           ? ''
                                                  //           : ramadanTimes[index].startDate,
                                                  //       endDate: ramadanTimes[index].endDate == null
                                                  //           ? ''
                                                  //           : ramadanTimes[index].endDate,
                                                  //       format: ramadanTimes[index].format == null
                                                  //           ? 1
                                                  //           : ramadanTimes[index].format,
                                                  //       Sno: ramadanTimes[index].sNo == null
                                                  //           ? 5
                                                  //           : ramadanTimes[index].sNo,
                                                  //       takberat_time:
                                                  //           eidTimes[index].takbeeratTime == null
                                                  //               ? ''
                                                  //               : eidTimes[index].takbeeratTime,
                                                  //       salah_time: eidTimes[index].salahTime == null
                                                  //           ? ''
                                                  //           : eidTimes[index].salahTime,
                                                  //       eid_Sno: eidTimes[index].sNo == null
                                                  //           ? 5
                                                  //           : eidTimes[index].sNo,
                                                  //       lec_time: eidTimes[index].lectureTime == null
                                                  //           ? ''
                                                  //           : eidTimes[index].lectureTime,
                                                  //       // masjidId: eidTimes[index].masjidId,
                                                  //       juma: masjids[index].FirstJuma == null
                                                  //           ? ''
                                                  //           : masjids[index].FirstJuma,
                                                  //       capacity: masjids[index].capacity,
                                                  //       city: masjids[index].City,
                                                  //       country: masjids[index].Country,
                                                  //     ),
                                                  //   ),
                                                  // );
                                                },
                                                title: copiedmasjids.isEmpty
                                                    ? Text(
                                                        masjids[index]
                                                                .Name
                                                                .toString() +
                                                            " Masjid\n",
                                                        style: const TextStyle(
                                                            color: appColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text(
                                                        copiedmasjids[index]
                                                                .Name
                                                                .toString() +
                                                            " Masjid\n",
                                                        style: const TextStyle(
                                                            color: appColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                subtitle: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          width: 80,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xffd08e63),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0,
                                                                    right: 8,
                                                                    top: 4,
                                                                    bottom: 4),
                                                            child: Text(
                                                              'Fajr  \n' +
                                                                  masjids[index]
                                                                      .Fajr
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color:
                                                                      whiteColor,
                                                                  fontSize: 12),
                                                            ),
                                                          )),
                                                      widthSizedBox,
                                                      Container(
                                                          width: 80,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xffd08e63),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0,
                                                                    right: 8,
                                                                    top: 4,
                                                                    bottom: 4),
                                                            child: Text(
                                                              'Duhr  \n' +
                                                                  masjids[index]
                                                                      .Duhr
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color:
                                                                      whiteColor,
                                                                  fontSize: 12),
                                                            ),
                                                          )),
                                                      widthSizedBox,
                                                      Container(
                                                          width: 80,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xffd08e63),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0,
                                                                    right: 8,
                                                                    top: 4,
                                                                    bottom: 4),
                                                            child: Text(
                                                              'Asr  \n' +
                                                                  masjids[index]
                                                                      .Asr
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color:
                                                                      whiteColor,
                                                                  fontSize: 12),
                                                            ),
                                                          )),
                                                      widthSizedBox,
                                                      Container(
                                                          width: 80,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xffd08e63),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0,
                                                                    right: 8,
                                                                    top: 4,
                                                                    bottom: 4),
                                                            child: Text(
                                                              'Maghrib  \n' +
                                                                  masjids[index]
                                                                      .Maghrib
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color:
                                                                      whiteColor,
                                                                  fontSize: 12),
                                                            ),
                                                          )),
                                                      widthSizedBox,
                                                      Container(
                                                        width: 80,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xffd08e63),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                        //color:  Colors.white.withOpacity(0.4),
                                                        //Colors.white.withOpacity(0.5),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  right: 8,
                                                                  top: 4,
                                                                  bottom: 4),
                                                          child: Text(
                                                            'Isha  \n' +
                                                                masjids[index]
                                                                    .Isha
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                trailing: IconButton(
                                                  key: ValueKey(masjids[index]),
                                                  onPressed: () async {
                                                    isSelected(index);
                                                    //masjids[index].Id
                                                    //bool? chkedValue;
                                                    //isChecked[index]=chkedValue!;
                                                    int currentUserId =
                                                        await prefs
                                                            .get('userId');
                                                    if (value.selectedItem
                                                        .contains(index)) {
                                                      value.removeItem(index);
                                                      await apiService
                                                          .deleteendUserMaterial(
                                                              'endusermasjids',
                                                              currentUserId,
                                                              masjids[index]
                                                                  .Id);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              content: Text(masjids[
                                                                          index]
                                                                      .Name
                                                                      .toString() +
                                                                  " Deleted Successfully")));
                                                    } else {
                                                      //isChecked[index]=true;
                                                      value.addItem(index);
                                                      var postEndUserMasjid =
                                                          UserMasjids(
                                                              userId:
                                                                  currentUserId,
                                                              masjidid:
                                                                  masjids[index]
                                                                      .Id);
                                                      await ApiServices
                                                          .postendUsermasjid(
                                                              postEndUserMasjid);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        duration: Duration(
                                                            seconds: 1),
                                                        content: Text(masjids[
                                                                    index]
                                                                .Name
                                                                .toString() +
                                                            " added to your wish list"),
                                                      ));
                                                    }
                                                  },
                                                  icon: Icon(
                                                    value.selectedItem.contains(
                                                                index) ||
                                                            isSelected(
                                                                masjids[index]
                                                                    .Id)
                                                        //(masjids[index].Id==6)
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              midPadding2,
                                            ],
                                          ),
                                        ),
                                      );
                              });
                        })),
                  ),
                ],
              ),
            ),
            // Container(
            //   child: Text('null sound error will resovled soon'),)
          ),
        ));

    // DragAndDropList(
    //   masjids.length,
    //   itemBuilder: (BuildContext context, index) {
    //     return Padding(
    //       padding: const EdgeInsets.only(left:10.0,right: 10,top: 5,bottom: 5),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius. circular(10),
    //           image:const DecorationImage(
    //               image: AssetImage('assets/mosque.png'),
    //               fit:BoxFit.cover
    //           ),
    //           //color: appColor.withOpacity(0.5)
    //         ),
    //         child: Column(
    //           children: [
    //             midPadding2,
    //             ListTile(
    //               title:
    //               Center(
    //                 child: Text(masjids[index].Name.toString()+" Masjid",
    //                   style:const TextStyle(color: whiteColor,
    //                       fontWeight: FontWeight.bold),),
    //               ),
    //               subtitle: Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                 Card(
    //                   color:  Colors.white.withOpacity(0.4),
    //                     //Colors.white.withOpacity(0.5),
    //                   child: Padding(
    //                     padding: const EdgeInsets.only(left:8.0,right: 8,
    //                         top: 4,bottom: 4),
    //                     child: Text('Fajr : \n'+ masjids[index].Fajr.toString()),
    //                   )
    //                 ),
    //                 const Spacer(),
    //                 Card(
    //                     color:  Colors.white.withOpacity(0.4),
    //                     //color: Colors.white,
    //                     //Colors.white.withOpacity(0.5),
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(left:8.0,right: 8,
    //                           top: 4,bottom: 4),
    //                       child: Text('Duhr : \n'+ masjids[index].Duhr.toString()),
    //                     )
    //                 ),const Spacer(),
    //                 Card(
    //                     color:  Colors.white.withOpacity(0.4),
    //                    // color: Colors.white,
    //                     //Colors.white.withOpacity(0.5),
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(left:8.0,right: 8,
    //                           top: 4,bottom: 4),
    //                       child: Text('Asr : \n'+ masjids[index].Asr.toString()),
    //                     )
    //                 ),const Spacer(),
    //                 Card(
    //                     color:  Colors.white.withOpacity(0.4),
    //                     //color: Colors.white,
    //                     //Colors.white.withOpacity(0.5),
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(left:8.0,right: 8,
    //                           top: 4,bottom: 4),
    //                       child: Text('Maghrib : \n'+ masjids[index].Maghrib.toString()),
    //                     )
    //                 ),const Spacer(),
    //                 Card(
    //                     color:  Colors.white.withOpacity(0.4),
    //                     //color: Colors.white,
    //                      //Colors.white.withOpacity(0.5),
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(left:8.0,right: 8,
    //                           top: 4,bottom: 4),
    //                       child: Text('Isha : \n'+ masjids[index].Isha.toString()),
    //                     )
    //                 ),],),
    //             ),
    //             midPadding2,
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    //   onDragFinish: (before, after) {
    //     Masjid data = masjids[before];
    //     //items.removeAt(before);
    //     masjids.insert(after, data);
    //   },
    //   canDrag: (index) {
    //     return index < masjids.length; //disable drag for index 3
    //   },
    //   canBeDraggedTo: (from, to) {
    //     return to < masjids.length;
    //   },
    //   dragElevation: 8.0,
    // ),
  }
}
