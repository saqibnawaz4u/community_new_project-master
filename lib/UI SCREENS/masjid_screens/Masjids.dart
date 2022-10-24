import 'dart:convert';
import 'package:community_new/UI%20SCREENS/credentials/log_in.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/masjidTimeline.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/masjid.dart';
import 'package:community_new/models/ramadanTimes.dart';
import 'package:community_new/widgets/genericAppBar.dart';
import 'package:community_new/widgets/genericDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../api_services/api_services.dart';
import '../../models/eidTimings.dart';
import 'masjidStepper.dart';

var errorController = TextEditingController();

class Masjids extends StatefulWidget {
  const Masjids({Key? key}) : super(key: key);
  @override
  MasjidsState createState() => MasjidsState();
}

class MasjidsState extends State<Masjids> {
  final ApiServices apiService = ApiServices();
  //MasjidModel? masjid;
  List<Masjid> masjids = [];
  List<RamadanTimes> ramadanTimes = [];
  List<EidTimings> eidTimes = [];
  List<Masjid> copiedmasjids = [];
  late List data;
  // String url = "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/tutorials/files/cats.json";
  // List imagesUrl = [];
  // Future<String> fetchDataFromApi() async {
  //   var jsonData = await http.get(Uri.parse("https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/tutorials/files/cats.json")
  //       );
  //   var fetchData = jsonDecode(jsonData.body);
  //   setState(() {
  //     data = fetchData;
  //     data.forEach((element) {
  //       imagesUrl.add(element['url']);
  //     });
  //   });
  //   return "Success";
  // }
  _getMasjid() async {
    String currentRole = //'admin';
        await prefs.getString('role_name');
    int currentUserId = await prefs.get('userId');
    if (currentRole == 'SuperAdmin') {
      ApiServices.fetch('masjid', actionName: null, param1: null)
          .then((response) {
        setState(() {
          try {
            errorController.text = "";
            Iterable list = json.decode(response.body);
            //print ( response.body );
            masjids = list.map((model) => Masjid.fromJson(model)).toList();
            // print(masjids[0].Id);
            //  errorController.text="test";
          } on Exception catch (e) {
            errorController.text = "wow : " + e.toString();
          }
        });
      });
    } else if (currentRole == 'OrgAdmin') {
      ApiServices.fetch('masjid',
              actionName: 'getfororgadmin', param1: currentUserId.toString())
          .then((response) {
        setState(() {
          try {
            errorController.text = "";
            Iterable list = json.decode(response.body);
            //print ( response.body );
            masjids = list.map((model) => Masjid.fromJson(model)).toList();
            // print(masjids[0].Id);
            //  errorController.text="test";
          } on Exception catch (e) {
            errorController.text = "wow : " + e.toString();
          }
        });
      });
    } else if (currentRole == 'MasjidAdmin') {
      ApiServices.fetch('masjid',
              actionName: 'getformasjidadmin', param1: currentUserId.toString())
          .then((response) {
        setState(() {
          try {
            errorController.text = "";
            Iterable list = json.decode(response.body);
            //print ( response.body );
            masjids = list.map((model) => Masjid.fromJson(model)).toList();
            // print(masjids[0].Id);
            //  .text="test";
          } on Exception catch (e) {
            errorController.text = "wow : " + e.toString();
          }
        });
      });
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

  _getEidTimings() async {
    int currentUserId = await prefs.get('userId');
    await ApiServices.fetch(
      'eidtimings',
      // actionName: 'GetForEndUser',
      // param1: currentUserId.toString(),
    ).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(response.body);
        eidTimes = list.map((model) => EidTimings.fromJson(model)).toList();
      });
    });
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
  void initState() {
    //    print("hhhh");
    _getMasjid();
    _getEidTimings();
    _getTaraveeh();
    copiedmasjids = masjids;
    super.initState();
    // fetchDataFromApi();
    //selectedRole=roles[1];
  }

  final searchcntrl = TextEditingController();
  String currentUserName = prefs.get('userName');
  String currentRole = prefs.getString('role_name');
  bool isGrid = true;
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => SystemNavigator.pop(), // <-- SEE HERE
                child: new Text(
                  'Yes',
                  style: TextStyle(color: appColor),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text(
                  'No',
                  style: TextStyle(color: appColor),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    //  errorController.text='how';
    //   _getMasjid ( );
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: appColor,
        //   child: Icon(Icons.add,color: whiteColor,),
        //   onPressed: () {  Navigator.push(
        //       context, MaterialPageRoute(builder: (context) =>
        //       EditMasjid(isNew: true,masjidId: "0",))); },
        // ),

        drawer: currentRole == 'SuperAdmin'
            ? genericDrawerForSA()
            : currentRole == 'MasjidAdmin'
                ? genericDrawerForMA()
                : genericDrawerForOA(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: genericAppBarForSA(
            appbarTitle: 'Masjids',
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    onChanged: (value) => _runFilter(value),
                    controller: searchcntrl,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      // fillColor: whiteColor,
                      // filled: true,
                      hintText: 'Search masjid by name',
                      prefixIconColor: appColor,
                      suffixIconColor: appColor,
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.tune),
                      ),
                      border: const OutlineInputBorder(
                          //borderSide: BorderSide.none
                          ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: whiteColor,
        body: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     onChanged: (value) => _runFilter(value),
            //     controller: searchcntrl,
            //     decoration: InputDecoration(
            //       fillColor: whiteColor,
            //       filled: true,
            //       hintText: 'Search masjid by name',
            //       prefixIconColor: appColor,
            //       suffixIconColor: appColor,
            //       prefixIcon: Icon(Icons.search),
            //       suffixIcon: IconButton(
            //         onPressed: (){},
            //         icon: Icon(Icons.filter_alt_outlined),),
            //       border: const OutlineInputBorder(
            //           borderSide: BorderSide.none
            //         //borderSide: BorderSide.none
            //       ),
            //     ),
            //     keyboardType: TextInputType.text,
            //   ),
            // ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    if (isGrid == true) {
                      setState(() {
                        isGrid = false;
                      });
                    } else if (isGrid == false) {
                      setState(() {
                        isGrid = true;
                      });
                    }
                  },
                  icon: isGrid == false
                      ? Icon(Icons.list)
                      : Icon(Icons.grid_on_outlined)),
            ),
            masjids.isEmpty
                ? Center(child: Text('Empty'))
                : isGrid
                    ?
                    // Expanded(
                    //     child: ListView.builder(
                    //         itemCount: copiedmasjids.isEmpty?masjids.length:copiedmasjids.length,
                    //         itemBuilder:  (_, index) {
                    //           return Column(
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.only(left:15.0,right: 15),
                    //                 child: Card(
                    //                     shape: RoundedRectangleBorder(
                    //                         borderRadius: BorderRadius.circular(8)
                    //                     ),
                    //                     color: Colors.white,
                    //                     elevation: 2.0,
                    //                     child: Column(
                    //                       children: [
                    //                         ListTile(
                    //                           subtitle: Text(masjids[index]
                    //                               .Description
                    //                               .toString()),
                    //                           onTap: null,
                    //                           leading: const CircleAvatar(
                    //                             radius: 20,
                    //                             backgroundImage: AssetImage('assets/user.png'),
                    //                           ),
                    //                           title: Row(
                    //                             children: [
                    //                               copiedmasjids.isEmpty?Text(masjids[index].Name.toString())
                    //                                   :Text(copiedmasjids[index].Name.toString()),
                    //                               const Spacer(),
                    //                               ElevatedButton(
                    //                                   style: crudButtonStyle,
                    //                                   onPressed: () {
                    //                                     Navigator.push(
                    //                                         context,
                    //                                         MaterialPageRoute(
                    //                                             builder: (context) =>
                    //                                                 EditMasjidStepper(
                    //                                                     isNew:
                    //                                                     false,
                    //                                                     masjidId: masjids[
                    //                                                     index]
                    //                                                         .Id
                    //                                                         .toString())));
                    //                                   },
                    //                                   child:Image.asset('assets/edit.png',color: appColor,)),
                    //                               widthSizedBox,
                    //                               ElevatedButton(
                    //                                   style: crudButtonStyle,
                    //                                   onPressed: () async {
                    //                                     await apiService.deleteFn(
                    //                                         int.parse(masjids[index]
                    //                                             .Id
                    //                                             .toString()),
                    //                                         'masjid');
                    //                                     ScaffoldMessenger.of(
                    //                                         context)
                    //                                         .showSnackBar(
                    //                                         const SnackBar(
                    //                                             content: Text(
                    //                                                 "Masjid Deleted Successfully")));
                    //                                     Navigator.push(
                    //                                         context,
                    //                                         MaterialPageRoute(
                    //                                           builder: (context) =>
                    //                                               Masjids(),
                    //                                         ));
                    //                                   },
                    //                                   child: deleteIcon),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     )),
                    //               )
                    //             ],
                    //           );
                    //         })
                    // )

                    Expanded(
                        child: ListView.builder(
                            itemCount: copiedmasjids.isEmpty
                                ? masjids.length
                                : copiedmasjids.length,
                            itemBuilder: (context, index) {
                              return index > 3
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: false)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    masjidDetails(
                                                      name:
                                                          masjids[index].Name ==
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
                                                      city:
                                                          masjids[index].City ==
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
                                                          : masjids[index].Fajr,
                                                      duhr: masjids[index]
                                                                  .Duhr ==
                                                              null
                                                          ? ""
                                                          : masjids[index].Duhr,
                                                      asr: masjids[index].Asr ==
                                                              null
                                                          ? ""
                                                          : masjids[index].Asr,
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
                                                          : masjids[index].Isha,
                                                      // firstJuma: masjids[index]
                                                      //             .FirstJuma ==
                                                      //         null
                                                      //     ? ""
                                                      //     : masjids[index]
                                                      //         .FirstJuma,
                                                      // secondJuma: masjids[index]
                                                      //             .SecondJuma ==
                                                      //         null
                                                      //     ? ""
                                                      // : masjids[index]
                                                      //     .SecondJuma,
                                                      startDate: ramadanTimes[
                                                                      index]
                                                                  .startDate ==
                                                              null
                                                          ? ''
                                                          : ramadanTimes[index]
                                                              .startDate,
                                                      endDate: ramadanTimes[
                                                                      index]
                                                                  .endDate ==
                                                              null
                                                          ? ''
                                                          : ramadanTimes[index]
                                                              .endDate,
                                                      format: ramadanTimes[
                                                                      index]
                                                                  .format ==
                                                              null
                                                          ? 2
                                                          : ramadanTimes[index]
                                                              .format,
                                                      ram_sno: ramadanTimes[
                                                                      index]
                                                                  .sNo ==
                                                              null
                                                          ? 1
                                                          : ramadanTimes[index]
                                                              .sNo,
                                                      // takberat: eidTimes[index]
                                                      //             .takbeeratTime ==
                                                      //         null
                                                      //     ? ''
                                                      //     : eidTimes[index]
                                                      //         .takbeeratTime,
                                                      // lec_time: eidTimes[index]
                                                      //             .lectureTime ==
                                                      //         null
                                                      //     ? ''
                                                      //     : eidTimes[index]
                                                      //         .lectureTime,
                                                      // salah_time: eidTimes[index]
                                                      //             .salahTime ==
                                                      //         null
                                                      //     ? ''
                                                      //     : eidTimes[index].salahTime,
                                                      // eid_sno:
                                                      //     eidTimes[index].sNo == null
                                                      //         ? 2
                                                      //         : eidTimes[index].sNo,
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
                                                      CrossAxisAlignment.start,
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
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          )
                                                        : Text(
                                                            copiedmasjids[index]
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
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                    const SizedBox(height: 10),
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
                                                                  fontSize: 12,
                                                                ),
                                                          )
                                                        : Text(
                                                            copiedmasjids[index]
                                                                    .City
                                                                    .toString() +
                                                                '\n',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                right: 0,
                                                child: Row(
                                                  children: [
                                                    PopupMenuButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      itemBuilder: (context) {
                                                        return [
                                                          _buildPopupMenuItem(
                                                              //'Edit',
                                                              'assets/edit.png',
                                                              //Icons.edit,
                                                              'edit'),
                                                          _buildPopupMenuItem(
                                                              //'Delete',
                                                              'assets/delete.png',
                                                              //Icons.delete_outline,
                                                              'delete'),
                                                        ];
                                                      },
                                                      onSelected: (value) {
                                                        if (value == 'edit') {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          EditMasjidStepper(
                                                                            objMasjidAdmin1:
                                                                                masjids[index].Masjid_admin,
                                                                            isNew:
                                                                                false,
                                                                            masjidId:
                                                                                masjids[index].Id.toString(),
                                                                          )));
                                                        } else if (value ==
                                                            'delete') {
                                                          // await
                                                          apiService.deleteFn(
                                                              int.parse(masjids[
                                                                      index]
                                                                  .Id
                                                                  .toString()),
                                                              'masjid');
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          "Masjid Deleted Successfully")));
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Masjids(),
                                                              ));
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                            }),
                      )
                    : Expanded(
                        child: GridView.builder(
                            padding: EdgeInsets.all(4),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemCount: copiedmasjids.isEmpty
                                ? masjids.length
                                : copiedmasjids.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 2.0, right: 2, bottom: 2),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: false)
                                        .push(MaterialPageRoute(
                                            builder: (context) => masjidDetails(
                                                  name: masjids[index]
                                                      .Name
                                                      .toString(),
                                                  description: masjids[index]
                                                              .Description ==
                                                          null
                                                      ? ''
                                                      : masjids[index]
                                                          .Description
                                                          .toString(),
                                                  country: masjids[index]
                                                      .Country
                                                      .toString(),
                                                  city: masjids[index]
                                                      .City
                                                      .toString(),
                                                  location: masjids[index]
                                                      .Location
                                                      .toString(),
                                                  fajr: masjids[index].Fajr ==
                                                          null
                                                      ? ""
                                                      : masjids[index].Fajr,
                                                  duhr: masjids[index].Duhr ==
                                                          null
                                                      ? ""
                                                      : masjids[index].Duhr,
                                                  asr:
                                                      masjids[index].Asr == null
                                                          ? ""
                                                          : masjids[index].Asr,
                                                  maghrib: masjids[index]
                                                              .Maghrib ==
                                                          null
                                                      ? ""
                                                      : masjids[index].Maghrib,
                                                  isha: masjids[index].Isha ==
                                                          null
                                                      ? ""
                                                      : masjids[index].Isha,
                                                  // firstJuma: masjids[index]
                                                  //             .FirstJuma ==
                                                  //         null
                                                  //     ? ""
                                                  //     : masjids[index]
                                                  //         .FirstJuma,
                                                  // secondJuma: masjids[index]
                                                  //             .SecondJuma ==
                                                  //         null
                                                  //     ? ""
                                                  //     : masjids[index]
                                                  //         .SecondJuma,
                                                  // startDate: ramadanTimes[index]
                                                  //             .startDate ==
                                                  //         null
                                                  //     ? ''
                                                  //     : ramadanTimes[index]
                                                  //         .startDate,
                                                  // endDate: ramadanTimes[index]
                                                  //             .endDate ==
                                                  //         null
                                                  //     ? ''
                                                  //     : ramadanTimes[index]
                                                  //         .endDate,
                                                  // format: ramadanTimes[index]
                                                  //             .format ==
                                                  //         null
                                                  //     ? 2
                                                  //     : ramadanTimes[index]
                                                  //         .format,
                                                  // ram_sno: ramadanTimes[index]
                                                  //             .sNo ==
                                                  //         null
                                                  //     ? 1
                                                  //     : ramadanTimes[index].sNo,
                                                )));
                                  },
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: Colors.white,
                                      elevation: 2.0,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0, right: 3),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Expanded(
                                                  flex: 1,
                                                  child: Text(''),
                                                ),
                                                const Expanded(
                                                  child: CircleAvatar(
                                                      radius: 25,
                                                      backgroundImage:
                                                          AssetImage(
                                                              'assets/user.png')
                                                      // NetworkImage(
                                                      //   imagesUrl[index],
                                                      //  // fit: BoxFit.cover,
                                                      // )
                                                      ),
                                                ),
                                                widthSizedBox12,
                                                Expanded(
                                                  child: PopupMenuButton(
                                                    position:
                                                        PopupMenuPosition.under,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    itemBuilder: (context) {
                                                      return [
                                                        _buildPopupMenuItem(
                                                            //'Edit',
                                                            'assets/edit.png',
                                                            //Icons.edit,
                                                            'edit'),
                                                        _buildPopupMenuItem(
                                                            //'Delete',
                                                            'assets/delete.png',
                                                            //Icons.delete_outline,
                                                            'delete'),
                                                      ];
                                                    },
                                                    onSelected: (value) {
                                                      if (value == 'edit') {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => EditMasjidStepper(
                                                                    objMasjidAdmin1:
                                                                        masjids[index]
                                                                            .Masjid_admin,
                                                                    isNew:
                                                                        false,
                                                                    masjidId: masjids[
                                                                            index]
                                                                        .Id
                                                                        .toString())));
                                                      } else if (value ==
                                                          'delete') {
                                                        // await
                                                        apiService.deleteFn(
                                                            int.parse(masjids[
                                                                    index]
                                                                .Id
                                                                .toString()),
                                                            'masjid');
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "Masjid Deleted Successfully")));
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Masjids(),
                                                            ));
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          midPadding2,
                                          copiedmasjids.isEmpty
                                              ? Text(
                                                  masjids[index]
                                                      .Name
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis)
                                              : Text(
                                                  copiedmasjids[index]
                                                      .Name
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                          midPadding2,
                                          Text(
                                            masjids[index]
                                                .Description
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            }))
          ],
        ),
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      String imageUrl,
      // IconData iconData,
      String position) {
    return PopupMenuItem(
      value: position,
      child: Container(
          width: 50,
          child: Center(
            child: Image.asset(
              imageUrl,
              color: appColor,
            ),
          )),
      //Text(title),
    );
  }
}

// masjids.isEmpty
// ? Center(child: Text('Empty with Error: ' + errorController.text))
// : GridView.builder(
// gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
// (crossAxisCount: 2),
// itemCount: masjids.length,
// itemBuilder: (context, index) {
// return Column(
// children: [
// Card(
// color: Colors.white,
// elevation: 1.0,
// child: Column(
// children: [
// ListTile(
// subtitle: Text(masjids[index].Description.toString()),
// onTap: null,
// leading:  Text(masjids[index].Id.toString()),
// title: Row(
// children: [
// Text(masjids[index].Name.toString()),
// const Spacer(),
// ElevatedButton(
// style: crudButtonStyle,
// onPressed: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => EditMasjid(
// isNew: false,
// masjidId: masjids[index]
//     .Id.toString()
// )));
// },
// child: editIcon),
// widthSizedBox,
// ElevatedButton(
// style: crudButtonStyle,
// onPressed: () async {
// await apiService.deleteFn(int.parse(
// masjids[index].Id.toString()),'masjid');
// ScaffoldMessenger.of(context)
//     .showSnackBar(const SnackBar(
// content:  Text("Masjid Deleted Successfully")));
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// Masjids(),
// ));
// },
// child: deleteIcon),
// ],
// ),
// ),
//
// ],
// ))
// ],);
// })
