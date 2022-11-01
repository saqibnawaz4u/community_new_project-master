import 'dart:convert';

import 'package:community_new/UI%20SCREENS/Events_new/Events.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/masjidStepper.dart';
import 'package:community_new/models/UserEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '../../api_services/api_services.dart';
import '../../constants/styles.dart';

class UsereventDetails extends StatefulWidget {
  final String? imageUrlEvent, eventName, discription;
  final bool? isNew;
  final int? eventId, userId;
  const UsereventDetails({
    Key? key,
    this.eventId,
    this.userId,
    this.discription,
    this.isNew,
    this.eventName,
    this.imageUrlEvent,
  }) : super(key: key);

  @override
  State<UsereventDetails> createState() => _UsereventDetailsState();
}

class _UsereventDetailsState extends State<UsereventDetails> {
  String currentRole = //'admin';
      prefs.getString('role_name');

  UserEvents userEvents = UserEvents();

  getUserEvents() async {
    var response =
        await http.get(Uri.parse("http://ijtimaee.com/api/enduserevents"));

    if (response.statusCode == 200) {
      userEvents = UserEvents.fromJson(jsonDecode(response.body));
      print(response.statusCode);
      // print(userEvents.statusCode);
      // setState(() {
      //   _isloading = false;
      // });
    }
  }

  //saving data
  Future<void> _regEvent(UserEvents userEvents) async {
    // final isValid = _form.currentState!.validate();
    // if (isValid) {
    // if (widget.isNew!) {
    await ApiServices.postendUserEvents(userEvents);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("userEvent Added Successfully"),
    ));
    // }
    //  else {
    //   await ApiServices.postendUserEventsbyId(
    //       widget.userId.toString(), userEvents);
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text("userevent Updated Successfully"),
    //   ));
    // }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text("Please fill form correctly"),
    //   ));
    // }
  }

  @override
  void initState() {
    getUserEvents();
    // TODO: implement initState
    super.initState();
  }

  int currentUserId = prefs.get('userId');

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    List<GlobalKey<FormState>> formKeys = [
      GlobalKey<FormState>(),
      GlobalKey<FormState>()
    ];
    return
        // GestureDetector(
        // onVerticalDragUpdate: (details) {},
        // onHorizontalDragUpdate: (details) {
        //   if (details.delta.direction > 0) {
        //     Navigator.pop(context);
        //   }
        // },
        // child:
        Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 400,
              child: Stack(
                children: [
                  Image.asset(
                    widget.imageUrlEvent.toString(),
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (
                              context,
                            ) =>
                                        Events())),
                            child: Container(
                              height: 25,
                              width: 25,
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset('assets/icons/arrow.svg'),
                            ),
                          ),
                          Container(
                            height: 25,
                            width: 25,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: appColor,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset('assets/icons/mark.svg'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // DetailsAppBar(house: house),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.eventName.toString(),
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            //ContentIntro(house: house),
            // const SizedBox(height: 20),
            // const HouseInfo(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.discription.toString(),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            userEvents.user_Id == currentUserId
                ? Text('Attendies List')
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        UserEvents userEvents;
                        userEvents = UserEvents(
                          event_Id: widget.eventId,
                          user_Id: widget.userId,
                        );

                        await _regEvent(userEvents);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        primary: appColor,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
            // NestedTabBar(nestedTabbarView: [
            //   Form(key: formKeys[0], child: Container()),
            //   Form(key: formKeys[1], child: Container()),
            // ], frmNested: _form, tabbarbarLength: 2)
          ],
        ),
      ),
      //),
    );
  }
}

class NestedTabBarUser extends StatefulWidget {
  final List<Widget> nestedTabbarView;
  final int tabbarbarLength;
  final GlobalKey<FormState> frmNested;
  NestedTabBarUser(
      {Key? key,
      required this.nestedTabbarView,
      required this.frmNested,
      required this.tabbarbarLength})
      : super(key: key);
  @override
  _NestedTabBarUserState createState() => _NestedTabBarUserState();
}

class _NestedTabBarUserState extends State<NestedTabBarUser>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<NestedTabBarUser> {
  late TabController _tabController;
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
      print('Has focus: $myFocusNode.hasFocus');
    });
    _tabController = TabController(
        length: widget.tabbarbarLength, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    _tabController.notifyListeners();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView(
      padding: EdgeInsets.only(left: 15, right: 15),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child:
              // TabBar(
              //  indicatorWeight: 0.001,
              //   controller: _tabController,
              //   labelColor: appColor,
              //   labelPadding: EdgeInsets.only(left:2,right: 2),
              //   unselectedLabelColor: Colors.black54,
              //   isScrollable: false,
              //   //indicatorColor: appColor,
              //   // indicatorPadding: EdgeInsets.symmetric(horizontal: 25),
              //   // labelPadding: EdgeInsets.symmetric(horizontal: 25),
              //   tabs: <Widget>[
              //     _tabController.index==0?
              //     Container(
              //         height: 42,
              //         decoration: BoxDecoration(
              //             color:appColor,//:appColor,
              //             borderRadius: BorderRadius.circular(25)
              //         ),
              //         child:Center(
              //           child: const Text('Accommodation Details',style: TextStyle(
              //               color: whiteColor,fontSize: 12
              //           ),
              //             //style: appcolorTextStylebold,
              //           ),
              //         )):
              //     Tab(
              //       text: "Accommodation Details",
              //     ),
              //     _tabController.index==1?
              //     Container(
              //         height: 42,
              //         decoration: BoxDecoration(
              //             color:appColor,//:appColor,
              //             borderRadius: BorderRadius.circular(25)
              //         ),
              //         child:Center(
              //           child: const Text('Address',style: TextStyle(
              //               color: whiteColor,fontSize: 12
              //           ),
              //             //style: appcolorTextStylebold,
              //           ),
              //         )):
              //     Tab(
              //       text: "Address",
              //     ),
              //
              //   ],
              // ),
              Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: whiteColor,
                border: Border.all(color: appColor)),
            child: TabBar(
              indicatorWeight: 0.01,
              controller: _tabController,
              labelColor: appColor,
              labelPadding: EdgeInsets.only(left: 2, right: 2),
              unselectedLabelColor: Colors.black54,
              // indicatorPadding: EdgeInsets.symmetric(horizontal: 25),
              // labelPadding: EdgeInsets.symmetric(horizontal: 25),
              tabs: <Widget>[
                _tabController.index == 0
                    ? Container(
                        height: 42,
                        decoration: BoxDecoration(
                            color: appColor, //:appColor,
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: const Text(
                            'Attendie',
                            style: TextStyle(color: whiteColor, fontSize: 12),
                            //style: appcolorTextStylebold,
                          ),
                        ))
                    : Tab(
                        text: "Details",
                      ),
                _tabController.index == 1
                    ? Container(
                        height: 42,
                        decoration: BoxDecoration(
                            color: appColor, //:appColor,
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: const Text(
                            'Address',
                            style: TextStyle(color: whiteColor, fontSize: 12),
                            //style: appcolorTextStylebold,
                          ),
                        ))
                    : Tab(
                        text: "Address",
                      ),
              ],
            ),
          ),
        ),
        Form(
          key: widget.frmNested,
          child: Container(
              height: screenHeight * 1,
              child: TabBarView(
                controller: _tabController,
                children: widget.nestedTabbarView,
              )),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
