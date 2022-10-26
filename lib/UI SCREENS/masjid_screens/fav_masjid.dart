import 'dart:convert';

import 'package:community_new/UI%20SCREENS/notifications/notification_screen.dart';
import 'package:community_new/models/eidTimings.dart';
import 'package:community_new/models/ramadanTimes.dart';
import 'package:community_new/provider/FavouriteItemProvider.dart';
import 'package:community_new/models/UserMasjids.dart';
import 'package:community_new/widgets/genericAppBar.dart';
import 'package:community_new/widgets/genericDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../api_services/api_services.dart';
import '../../constants/styles.dart';

import '../../models/masjid.dart';
import '../create_accomodation/screens/home/chat.dart';
import 'masjidTimeline.dart';

class Fav_masajids extends StatefulWidget {
  @override
  State<Fav_masajids> createState() => _Fav_masajidsState();
}

class _Fav_masajidsState extends State<Fav_masajids>
    with SingleTickerProviderStateMixin {
  final ApiServices apiService = ApiServices();
  List<Masjid> masjids = [];
  List<Masjid> copiedmasjids = [];
  List<RamadanTimes> ramadanTimes = [];
  // List<EidTimings> eidTImes = [];
  //List<UserMasjids> endUsermasjids=[];
  var masjid = Masjid();
  List<bool> isChecked = [];
  List<UserMasjids>? selectedendUserMasjids = [];
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

  final _controller = TextEditingController();
  _getMasjid() async {
    ApiServices.fetch('masjid', actionName: null, param1: null)
        .whenComplete(() => setState(() {}))
        .then((response) {
      setState(() {
        try {
          //errorController.text = "";
          Iterable list = json.decode(response.body);
          //print ( response.body );
          masjids = list.map((model) => Masjid.fromJson(model)).toList();
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
    ApiServices.fetch('ramadantimes', actionName: null, param1: null)
        .whenComplete(() => setState(() {}))
        .then((response) {
      setState(() {
        try {
          //errorController.text = "";
          Iterable list = json.decode(response.body);
          print(response.body);
          ramadanTimes =
              list.map((model) => RamadanTimes.fromJson(model)).toList();
          // print(masjids[0].Id);
          //  errorController.text="test";
        } on Exception catch (e) {
          //errorController.text = "wow : " + e.toString ( );
        }
      });
    });
    isChecked = await List<bool>.filled(ramadanTimes.length, false);
    for (int i = 0; i < ramadanTimes.length; i++) {
      //if(isSelected(users[i].Id)){
      isChecked[i] = isSelected(ramadanTimes[i].sNo);
    }
  }

  // _getEidTimings() async {
  //   ApiServices.fetch('eidtimings', actionName: null, param1: null)
  //       .whenComplete(() => setState(() {}))
  //       .then((response) {
  //     setState(() {
  //       try {
  //         //errorController.text = "";
  //         Iterable list = json.decode(response.body);
  //         print(response.body);
  //         eidTImes = list.map((model) => EidTimings.fromJson(model)).toList();
  //         // print(masjids[0].Id);
  //         //  errorController.text="test";
  //       } on Exception catch (e) {
  //         //errorController.text = "wow : " + e.toString ( );
  //       }
  //     });
  //   });
  //   isChecked = await List<bool>.filled(eidTImes.length, false);
  //   for (int i = 0; i < eidTImes.length; i++) {
  //     //if(isSelected(users[i].Id)){
  //     isChecked[i] = isSelected(eidTImes[i].sNo);
  //   }
  // }

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

  TabController? _tabController;
  void _runFilter(String enteredKeyword) async {
    List<Masjid> results = [];
    if (enteredKeyword.isEmpty) {
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

  @override
  void initState() {
    // TODO: implement initState
    _getMasjid();
    _getendUserFavMasjid();
    _getTaraveeh();
    // _getEidTimings();
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favouriteItemProvider = Provider.of<FavouriteItemProvider>(context);
    print('build');
    return DefaultTabController(
        length: 2,
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            drawer: genericDrawerForUser(),
            backgroundColor: whiteColor,
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
                        controller: _controller,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: EdgeInsets.all(0),
                          // fillColor: whiteColor,
                          // filled: true,
                          hintText: 'Search masjids by name',
                          prefixIconColor: appColor,
                          suffixIconColor: appColor,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.tune,
                              color: appColor,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
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
                )),
            body:
                // ClipRRect(
                //   borderRadius:const BorderRadius.only(
                //       topLeft: Radius.circular(40),
                //       topRight: Radius.circular(40)),
                //   child:
                Container(
              color: whiteColor,
              child: TabBarView(
                controller: _tabController,
                children: [
                  selectedendUserMasjids!.isEmpty
                      ? Text('empty')
                      : ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: selectedendUserMasjids!.length,
                          itemBuilder: (context, i) {
                            return isSelected(
                                    selectedendUserMasjids![i].masjidid)
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context,
                                              rootNavigator: false)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  masjidDetails(
                                                    name:
                                                        masjids[i].Name == null
                                                            ? ''
                                                            : masjids[i]
                                                                .Name
                                                                .toString(),
                                                    description: masjids[i]
                                                                .Description ==
                                                            null
                                                        ? ''
                                                        : masjids[i]
                                                            .Description
                                                            .toString(),
                                                    country:
                                                        masjids[i].Country ==
                                                                null
                                                            ? ''
                                                            : masjids[i]
                                                                .Country
                                                                .toString(),
                                                    city:
                                                        masjids[i].City == null
                                                            ? ''
                                                            : masjids[i]
                                                                .City
                                                                .toString(),
                                                    location:
                                                        masjids[i].Location ==
                                                                null
                                                            ? ''
                                                            : masjids[i]
                                                                .Location
                                                                .toString(),
                                                    state:
                                                        masjids[i].State == null
                                                            ? ''
                                                            : masjids[i]
                                                                .State
                                                                .toString(),
                                                    website: 'website',
                                                    fajr:
                                                        masjids[i].Fajr == null
                                                            ? ""
                                                            : masjids[i].Fajr,
                                                    duhr:
                                                        masjids[i].Duhr == null
                                                            ? ""
                                                            : masjids[i].Duhr,
                                                    asr: masjids[i].Asr == null
                                                        ? ""
                                                        : masjids[i].Asr,
                                                    maghrib: masjids[i]
                                                                .Maghrib ==
                                                            null
                                                        ? ""
                                                        : masjids[i].Maghrib,
                                                    isha:
                                                        masjids[i].Isha == null
                                                            ? ""
                                                            : masjids[i].Isha,
                                                    // firstJuma: masjids[i]
                                                    //             .FirstJuma ==
                                                    //         null
                                                    //     ? ""
                                                    //     : masjids[i]
                                                    //         .FirstJuma,
                                                    // secondJuma: masjids[i]
                                                    //             .SecondJuma ==
                                                    //         null
                                                    //     ? ""
                                                    //     : masjids[i]
                                                    //         .SecondJuma,
                                                    masjidId:
                                                        masjids[i].Id == null
                                                            ? 1
                                                            : masjids[i].Id,
                                                    // startDate: ramadanTimes[i]
                                                    //             .startDate ==
                                                    //         null
                                                    //     ? ''
                                                    //     : ramadanTimes[i]
                                                    //         .startDate,
                                                    // endDate: ramadanTimes[i]
                                                    //             .endDate ==
                                                    //         null
                                                    //     ? ''
                                                    //     : ramadanTimes[i]
                                                    //         .endDate,
                                                    // format: ramadanTimes[i]
                                                    //             .format ==
                                                    //         null
                                                    //     ? 2
                                                    //     : ramadanTimes[i]
                                                    //         .format,
                                                    // ram_sno: ramadanTimes[i]
                                                    //             .sNo ==
                                                    //         null
                                                    //     ? 1
                                                    //     : ramadanTimes[i].sNo,
                                                    // takberat: eidTImes[i]
                                                    //             .takbeeratTime ==
                                                    //         null
                                                    //     ? ''
                                                    //     : eidTImes[i]
                                                    //         .takbeeratTime,
                                                    // lec_time: eidTImes[i]
                                                    //             .lectureTime ==
                                                    //         null
                                                    //     ? ''
                                                    //     : eidTImes[i]
                                                    //         .lectureTime,
                                                    // salah_time: eidTImes[i]
                                                    //             .salahTime ==
                                                    //         null
                                                    //     ? ''
                                                    //     : eidTImes[i].salahTime,
                                                    // eid_sno:
                                                    //     eidTImes[i].sNo == null
                                                    //         ? 2
                                                    //         : eidTImes[i].sNo,
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      // child: isSelected(selectedendUserMasjids![i].masjidid)?
                                      // Card(
                                      //     shape: const RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.all(
                                      //             Radius.circular(12))),
                                      //     elevation: 5,
                                      //     color: whiteColor,
                                      //     child: Column(
                                      //       children: [
                                      //         ListTile(
                                      //           //title: Text('hello'),
                                      //           title: Text(masjids[i].Name.toString()),
                                      //
                                      //         ),
                                      //       ],
                                      //     ))
                                      child: Stack(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 150,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/darussalam.jpg'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  copiedmasjids.isEmpty
                                                      ? Text(
                                                          masjids[i]
                                                              .Name
                                                              .toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline1!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                        )
                                                      : Text(
                                                          copiedmasjids[i]
                                                              .Name
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline1!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                        ),
                                                  const SizedBox(height: 10),
                                                  copiedmasjids.isEmpty
                                                      ? Text(
                                                          masjids[i]
                                                                  .City
                                                                  .toString() +
                                                              '\n',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                        )
                                                      : Text(
                                                          copiedmasjids[i]
                                                                  .City
                                                                  .toString() +
                                                              '\n',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container();
                          }),
                  Column(
                    children: [
                      // Container(
                      //   color: whiteColor,//appColor,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left:15.0,right: 15,bottom: 10,top: 10),
                      //     child: SizedBox(
                      //       height: 50,
                      //       child: Theme(
                      //         data: ThemeData(
                      //           colorScheme: ThemeData().colorScheme.copyWith(
                      //             primary: appColor,
                      //           ),
                      //         ),
                      //         child: TextFormField(
                      //           onChanged: (value) => _runFilter(value),
                      //           controller: _controller,
                      //           decoration: InputDecoration(
                      //             border: new OutlineInputBorder(
                      //             ),
                      //             contentPadding: EdgeInsets.all(0),
                      //             // fillColor: whiteColor,
                      //             // filled: true,
                      //             hintText: 'Search masjids by name',
                      //             prefixIconColor: appColor,
                      //             suffixIconColor: appColor,
                      //             prefixIcon: Icon(Icons.search),
                      //             suffixIcon: IconButton(
                      //               onPressed: () {},
                      //               icon: Icon(Icons.filter_alt_outlined),
                      //             ),
                      //
                      //           ),
                      //           keyboardType: TextInputType.text,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      masjids.isEmpty
                          ? const Text('empty')
                          :
                          // Expanded(
                          //   child: ListView.builder(
                          //     itemCount: copiedmasjids.isEmpty?masjids.length:copiedmasjids.length,
                          //     itemBuilder: (context, index) {
                          //       return Consumer<FavouriteItemProvider>(
                          //           builder: (context, value, child) {
                          //         return Padding(
                          //           padding: const EdgeInsets.only(left: 15.0,right: 15,top: 4),
                          //           child: Card(
                          //             shape: const RoundedRectangleBorder(
                          //                 borderRadius: BorderRadius.all(Radius.circular(12))
                          //             ),
                          //             color: whiteColor,
                          //             elevation: 2,
                          //             child: ListTile(
                          //                 title: copiedmasjids.isEmpty?
                          //                 Text(masjids[index].Name.toString()):Text(copiedmasjids[index].Name.toString()),
                          //                 subtitle:copiedmasjids.isEmpty?
                          //                 Text(masjids[index].Location.toString()):Text(copiedmasjids[index].Location.toString()),
                          //                 trailing:IconButton(
                          //                   onPressed: () async{
                          //                     isSelected(index);     //masjids[index].Id
                          //                     //bool? chkedValue;
                          //                     //isChecked[index]=chkedValue!;
                          //                     int currentUserId = await prefs.get ( 'userId' );
                          //                    if(value.selectedItem.contains(index))
                          //                    {
                          //                      value.removeItem(index);
                          //                      await apiService.deleteendUserMaterial
                          //                        ('endusermasjids',currentUserId,masjids[index].Id);
                          //                      ScaffoldMessenger.of(context)
                          //                          .showSnackBar( SnackBar(
                          //                        duration: Duration(seconds: 1),
                          //                          content:  Text(masjids[index].Name.toString()
                          //                              +" Deleted Successfully")));
                          //                    }else{
                          //                      //isChecked[index]=true;
                          //                      value.addItem(index);
                          //                      var postEndUserMasjid = UserMasjids(
                          //                        userId: currentUserId,
                          //                        masjidid: masjids[index].Id
                          //                      );
                          //                      await ApiServices.postendUsermasjid(postEndUserMasjid);
                          //                      ScaffoldMessenger.of(context)
                          //                          .showSnackBar(  SnackBar(
                          //                        duration: Duration(seconds: 1),
                          //                        content:Text(masjids[index].Name.toString()
                          //                            +" added to your wish list"),));
                          //                    }
                          //
                          //                   },
                          //                   icon: Icon (
                          //                     value.selectedItem.contains(index)||
                          //                     isSelected(masjids[index].Id)
                          //                     //(masjids[index].Id==6)
                          //                         ? Icons.favorite
                          //                         : Icons.favorite_border,
                          //                     color: Colors.red,
                          //                   ),
                          //                 )
                          //             ),
                          //           ),
                          //         );
                          //       });
                          //     },
                          //   ),
                          // ),

                          Expanded(
                              child: ListView.builder(
                                  itemCount: copiedmasjids.isEmpty
                                      ? masjids.length
                                      : copiedmasjids.length,
                                  itemBuilder: (context, index) {
                                    return Consumer<FavouriteItemProvider>(
                                        builder: (context, value, child) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: false)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      masjidDetails(
                                                        name: masjids[index]
                                                                    .Name ==
                                                                null
                                                            ? ''
                                                            : masjids[index]
                                                                .Name
                                                                .toString(),
                                                        description: masjids[
                                                                        index]
                                                                    .Description ==
                                                                null
                                                            ? ''
                                                            : masjids[index]
                                                                .Description
                                                                .toString(),
                                                        country: masjids[index]
                                                                    .Country ==
                                                                null
                                                            ? ''
                                                            : masjids[index]
                                                                .Country
                                                                .toString(),
                                                        city: masjids[index]
                                                                    .City ==
                                                                null
                                                            ? ''
                                                            : masjids[index]
                                                                .City
                                                                .toString(),
                                                        location: masjids[index]
                                                                    .Location ==
                                                                null
                                                            ? ''
                                                            : masjids[index]
                                                                .Location
                                                                .toString(),
                                                        state: masjids[index]
                                                                    .State ==
                                                                null
                                                            ? ''
                                                            : masjids[index]
                                                                .State
                                                                .toString(),
                                                        website: 'website',
                                                        fajr: masjids[index]
                                                                    .Fajr ==
                                                                null
                                                            ? ""
                                                            : masjids[index]
                                                                .Fajr,
                                                        duhr: masjids[index]
                                                                    .Duhr ==
                                                                null
                                                            ? ""
                                                            : masjids[index]
                                                                .Duhr,
                                                        asr: masjids[index]
                                                                    .Asr ==
                                                                null
                                                            ? ""
                                                            : masjids[index]
                                                                .Asr,
                                                        maghrib: masjids[index]
                                                                    .Maghrib ==
                                                                null
                                                            ? ""
                                                            : masjids[index]
                                                                .Maghrib,
                                                        isha: masjids[index]
                                                                    .Isha ==
                                                                null
                                                            ? ""
                                                            : masjids[index]
                                                                .Isha,
                                                        masjidId: masjids[index]
                                                                    .Id ==
                                                                null
                                                            ? 1
                                                            : masjids[index].Id,
                                                        // firstJuma: masjids[index]
                                                        //             .FirstJuma ==
                                                        //         null
                                                        //     ? ""
                                                        //     : masjids[
                                                        //             index]
                                                        //         .FirstJuma,
                                                        // secondJuma: masjids[index]
                                                        //             .SecondJuma ==
                                                        //         null
                                                        //     ? ""
                                                        //     : masjids[
                                                        //             index]
                                                        //         .SecondJuma,
                                                        // startDate: ramadanTimes[index]
                                                        //             .startDate ==
                                                        //         null
                                                        //     ? ''
                                                        //     : ramadanTimes[
                                                        //             index]
                                                        //         .startDate,
                                                        // endDate: ramadanTimes[index]
                                                        //             .endDate ==
                                                        //         null
                                                        //     ? ''
                                                        //     : ramadanTimes[
                                                        //             index]
                                                        //         .endDate,
                                                        // format: ramadanTimes[index]
                                                        //             .format ==
                                                        //         null
                                                        //     ? 2
                                                        //     : ramadanTimes[
                                                        //             index]
                                                        //         .format,
                                                        // ram_sno: ramadanTimes[index]
                                                        //             .sNo ==
                                                        //         null
                                                        //     ? 1
                                                        //     : ramadanTimes[
                                                        //             index]
                                                        //         .sNo,
                                                      )));
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Stack(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 150,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/darussalam.jpg'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      copiedmasjids.isEmpty
                                                          ? Text(
                                                              masjids[index]
                                                                  .Name
                                                                  .toString(),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline1!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                            )
                                                          : Text(
                                                              copiedmasjids[
                                                                      index]
                                                                  .Name
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline1!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                            ),
                                                      const SizedBox(
                                                          height: 10),
                                                      copiedmasjids.isEmpty
                                                          ? Text(
                                                              masjids[index]
                                                                      .City
                                                                      .toString() +
                                                                  '\n',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                            )
                                                          : Text(
                                                              copiedmasjids[
                                                                          index]
                                                                      .City
                                                                      .toString() +
                                                                  '\n',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                            ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  IconButton(
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
                                                      value.selectedItem
                                                                  .contains(
                                                                      index) ||
                                                              isSelected(
                                                                  masjids[index]
                                                                      .Id)
                                                          //(masjids[index].Id==6)
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });

                                    //   Padding(
                                    //   padding: const EdgeInsets.only(
                                    //       left: 8.0, right: 8, top: 5),
                                    //   child: Card(
                                    //       shape: RoundedRectangleBorder(
                                    //           borderRadius: BorderRadius.circular(8)
                                    //       ),
                                    //       color: Colors.white,
                                    //       elevation: 10.0,
                                    //       child: Column(
                                    //         children: [
                                    //           ListTile(
                                    //             leading:const CircleAvatar(
                                    //               radius: 25,
                                    //               backgroundImage: AssetImage('assets/darussalam.jpg'),
                                    //             ),
                                    //             subtitle: Text(
                                    //               events[index]
                                    //                   .description
                                    //                   .toString() +
                                    //                   '\n',
                                    //               textAlign:
                                    //               TextAlign.justify,
                                    //             ),
                                    //             onTap: null,
                                    //             title: Row(
                                    //               children: [
                                    //                 Text(events[index]
                                    //                     .name
                                    //                     .toString() ),
                                    //                 const Spacer(),
                                    //                 currentRole=='User'?
                                    //                 IconButton(
                                    //                   onPressed: () async{
                                    //                     if(favouriteItemProvider.selectedItem.contains(index))
                                    //                     {
                                    //                       favouriteItemProvider.removeItem(index);
                                    //                       ScaffoldMessenger.of(context)
                                    //                           .showSnackBar( SnackBar(
                                    //                           content:  Text(events[index].name.toString()
                                    //                               +" Deleted Successfully")));
                                    //                     }else{
                                    //                       favouriteItemProvider.addItem(index);
                                    //                       ScaffoldMessenger.of(context)
                                    //                           .showSnackBar(  SnackBar(
                                    //                         content:Text(events[index].name.toString()
                                    //                             +" added "),));
                                    //                     }
                                    //
                                    //                   },
                                    //                   icon: Icon(
                                    //                     favouriteItemProvider.selectedItem.contains(index)
                                    //                     ||isSelected(events[index].Id)
                                    //                         ? Icons.favorite
                                    //                         : Icons.favorite_border,
                                    //                     color: Colors.red,
                                    //                   ),
                                    //                 )
                                    //                     :ElevatedButton(
                                    //                     style:
                                    //                     crudButtonStyle,
                                    //                     onPressed: () {
                                    //                       Navigator.push(
                                    //                           context,
                                    //                           MaterialPageRoute(
                                    //                               builder: (context) => EventEditnew(
                                    //                                   isNew:
                                    //                                   false,
                                    //                                   eventId:
                                    //                                   events[index].Id)));
                                    //                     },
                                    //                     child: const FaIcon(FontAwesomeIcons.edit,
                                    //                       color: Color(0xFF8BBAF0),size: size,)),
                                    //                 currentRole=='User'?
                                    //                 Container()
                                    //                     :
                                    //                 ElevatedButton(
                                    //                     style:
                                    //                     crudButtonStyle,
                                    //                     onPressed:
                                    //                         () async {
                                    //                       await apiService.deleteFn(
                                    //                           int.parse(events[
                                    //                           index]
                                    //                               .Id
                                    //                               .toString()),
                                    //                           'communityevent');
                                    //                       ScaffoldMessenger
                                    //                           .of(
                                    //                           context)
                                    //                           .showSnackBar(
                                    //                           const SnackBar(
                                    //                               content:
                                    //                               Text("Event Deleted Successfully")));
                                    //                       Navigator.push(
                                    //                           context,
                                    //                           MaterialPageRoute(
                                    //                             builder:
                                    //                                 (context) =>
                                    //                                 Events(),
                                    //                           ));
                                    //                     },
                                    //                     child: deleteIcon),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       )),
                                    // );
                                  }),
                            )
                    ],
                  ),

                  // //endUsermasjids.isEmpty?Text('empty'):
                  //  ListView.builder(
                  //    itemCount: selectedendUserMasjids!.length,
                  //     //selectedendUserMasjids!.length,
                  //    //favouriteItemProvider.selectedItem.length,
                  //    itemBuilder: (context, index) {
                  //      return Consumer<FavouriteItemProvider>(
                  //          builder: (context, value, child) {
                  //            return Padding(
                  //              padding: const EdgeInsets.only(left: 8.0,right: 8,top: 4),
                  //              child: selectedendUserMasjids!.isNotEmpty
                  //                 // &&
                  //                     //favouriteItemProvider.selectedItem.contains(index)
                  //                    ?
                  //                   Card(
                  //                shape: const RoundedRectangleBorder(
                  //                    borderRadius: BorderRadius.all(Radius.circular(12))
                  //                ),
                  //                color: whiteColor,
                  //                elevation: 5,
                  //                child: ListTile(
                  //                    title: Text(masjids[index].Name.toString()),
                  //                    trailing:IconButton(
                  //                      onPressed: () {
                  //                        if(value.selectedItem.contains(index))
                  //                        {
                  //                          value.removeItem(index);
                  //                        }else{
                  //                          value.addItem(index);
                  //                        }
                  //
                  //                      },
                  //                      icon: Icon (
                  //                       isSelected(selectedendUserMasjids![index].masjidid)
                  //                           ||value.selectedItem.contains(index)//||_isFav==true
                  //                            ? Icons.favorite
                  //                            : Icons.favorite_border,
                  //                        color: Colors.red,
                  //                      ),
                  //                    )
                  //                ),
                  //              ):Text('emptyyyyy'),
                  //            );
                  //          });
                  //    },
                  //  ),

                  // isSelected(masjid.Id)!=true||
                  //selectedendUserMasjids!.isEmpty?Text('empty'):
                ],
              ),
            ),
          ),
        ));
  }
}
