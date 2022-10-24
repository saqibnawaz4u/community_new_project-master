import 'dart:convert';

import 'package:community_new/UI%20SCREENS/masjid_screens/prayerTimes/masjid%20prayer%20Times%20details.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/ramadanTimes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../api_services/api_services.dart';
import '../../models/eidTimings.dart';
import '../../models/event.dart';
import '../Events_new/usereventDetail.dart';

class masjidDetails extends StatefulWidget {
  final String? name,
      description,
      website,
      city,
      country,
      location,
      state,
      fajr,
      duhr,
      asr,
      maghrib,
      isha,
      firstJuma,
      secondJuma;
  final int? ram_sno, eid_sno, format, masjidId;
  final String? startDate, endDate;
  final String? takberat, lec_time, salah_time;
  const masjidDetails(
      {Key? key,
      this.name,
      this.description,
      this.format,
      this.startDate,
      this.ram_sno,
      this.eid_sno,
      this.endDate,
      this.takberat,
      this.lec_time,
      this.salah_time,
      this.masjidId,
      this.state,
      this.country,
      this.city,
      this.location,
      this.website,
      this.fajr,
      this.duhr,
      this.asr,
      this.maghrib,
      this.isha,
      this.firstJuma,
      this.secondJuma})
      : super(key: key);

  @override
  State<masjidDetails> createState() => _masjidDetailsState();
}

class _masjidDetailsState extends State<masjidDetails>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();

  late TabController _tabController;

  final ApiServices apiService = ApiServices();
  Event? event;
  List<Event> events = [];
  List<RamadanTimes> ramadanTimes = [];
  List<EidTimings> eidTimes = [];
  List<Event> copiedListEvents = [];
  _getEvent() async {
    String currentRole = //'admin';
        await prefs.getString('role_name');
    int currentUserId = await prefs.get('userId');

    if (currentRole == 'SuperAdmin') {
      ApiServices.fetch('communityevent', actionName: null, param1: null)
          .then((response) {
        setState(() {
          try {
            Iterable list = json.decode(response.body);
            //print ( response.body );
            events = list.map((model) => Event.fromJson(model)).toList();
            // print(masjids[0].Id);
            //  errorController.text="test";
          } on Exception catch (e) {}
        });
      });
    } else if (currentRole == 'OrgAdmin') {
      ApiServices.fetch('communityevent',
              actionName: 'getfororgadmin', param1: currentUserId.toString())
          .then((response) {
        setState(() {
          try {
            Iterable list = json.decode(response.body);
            events = list.map((model) => Event.fromJson(model)).toList();
          } on Exception catch (e) {}
        });
      });
    } else if (currentRole == 'MasjidAdmin') {
      ApiServices.fetch('communityevent',
              actionName: 'getformasjidadmin', param1: currentUserId.toString())
          .then((response) {
        setState(() {
          try {
            Iterable list = json.decode(response.body);
            events = list.map((model) => Event.fromJson(model)).toList();
          } on Exception catch (e) {}
        });
      });
    } else if (currentRole == 'User') {
      ApiServices.fetch('communityevent',
              actionName: 'Getforenduser', //'GetEventsForEndUserMasjidsEvents',
              param1: currentUserId.toString())
          .whenComplete(() => setState(() {}))
          .then((response) {
        setState(() {
          try {
            Iterable list = json.decode(response.body);
            events = list.map((model) => Event.fromJson(model)).toList();
          } on Exception catch (e) {}
        });
      });
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
    // isChecked = await List<bool>.filled(ramadanTimes.length, false);
    // for (int i = 0; i < ramadanTimes.length; i++) {
    //   //if(isSelected(users[i].Id)){
    //   isChecked[i] = isSelected(ramadanTimes[i].sNo);
    // }
  }

  _getEidTimings() async {
    ApiServices.fetch('eidtimings', actionName: null, param1: null)
        .whenComplete(() => setState(() {}))
        .then((response) {
      setState(() {
        try {
          //errorController.text = "";
          Iterable list = json.decode(response.body);
          print(response.body);
          eidTimes = list.map((model) => EidTimings.fromJson(model)).toList();
          // print(masjids[0].Id);
          //  errorController.text="test";
        } on Exception catch (e) {
          //errorController.text = "wow : " + e.toString ( );
        }
      });
    });
    // isChecked = await List<bool>.filled(ramadanTimes.length, false);
    // for (int i = 0; i < ramadanTimes.length; i++) {
    //   //if(isSelected(users[i].Id)){
    //   isChecked[i] = isSelected(ramadanTimes[i].sNo);
    // }
  }

  @override
  void initState() {
    super.initState();
    _getEvent();
    _getTaraveeh();
    _getEidTimings();
    _tabController = TabController(length: 1, vsync: this, initialIndex: 0);
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
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              CupertinoIcons.chevron_back,
              color: appColor,
            )),
      ),
      body: ListView(
        children: [
          Image.asset(
            'assets/bilalmasjid.png',
            fit: BoxFit.fill,
          ),
          midPadding2,
          Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15, top: 4, bottom: 4),
            child: Text(
              widget.description.toString(),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          NestedTabBar(tabbarbarLength: 4, frmNested: _form, nestedTabbarView: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.description.toString()),
                  midPadding2,
                  Text(
                    'Country',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.country.toString()),
                  midPadding2,
                  Text(
                    'State',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.state.toString()),
                  midPadding2,
                  Text(
                    'City',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.city.toString()),
                  midPadding2,
                  Text(
                    'Website',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.website.toString()),
                  midPadding2,
                  Text(
                    'Founded',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('2022'),
                  midPadding2
                ],
              ),
            ),
            masjidPrayerTimeDetails(
              name: '',
              fajr: widget.fajr,
              duhr: widget.duhr,
              asr: widget.asr,
              maghrib: widget.maghrib,
              isha: widget.isha,
              // first_juma: widget.firstJuma,
              // sec_juma: widget.secondJuma,
              isprayerTime: true,
              // format: widget.format,
              // Sno: widget.ram_sno,
              // startDate: widget.startDate,
              // endDate: widget.endDate,
              masjidId: widget.masjidId,
              // eid_Sno: widget.eid_sno,
              // takberat_time: widget.takberat,
              // lec_time: widget.lec_time,
              // salah_time: widget.salah_time,
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: copiedListEvents.isEmpty
                    ? events.length
                    : copiedListEvents.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UsereventDetails(
                            eventName: events[index].name.toString(),
                            discription: events[index].description.toString(),
                            imageUrlEvent: 'assets/darussalam.jpg',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8),
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
                                    image: AssetImage('assets/darussalam.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  copiedListEvents.isEmpty
                                      ? Text(
                                          events[index].name.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        )
                                      : Text(
                                          copiedListEvents[index]
                                              .name
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                  const SizedBox(height: 10),
                                  copiedListEvents.isEmpty
                                      ? Text(
                                          events[index].description.toString() +
                                              '\n',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                fontSize: 12,
                                              ),
                                        )
                                      : Text(
                                          copiedListEvents[index]
                                                  .description
                                                  .toString() +
                                              '\n',
                                          style: Theme.of(context)
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
                        ],
                      ),
                    ),
                  );
                }),
            Container(
              child: Center(child: Text('To be Developed')),
            ),
          ]),
        ],
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  final List<Widget> nestedTabbarView;
  final int tabbarbarLength;
  final GlobalKey<FormState> frmNested;
  NestedTabBar(
      {Key? key,
      required this.nestedTabbarView,
      required this.frmNested,
      required this.tabbarbarLength})
      : super(key: key);
  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<NestedTabBar> {
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
      shrinkWrap: true,
      primary: false,
      children: <Widget>[
        midPadding2,
        midPadding2,
        Container(
          decoration: BoxDecoration(
              color: whiteColor, border: Border.all(color: Colors.grey)),
          child: TabBar(
            labelPadding: EdgeInsets.only(left: 2, right: 2),
            controller: _tabController,
            indicatorColor: appColor,
            labelColor: appColor,
            unselectedLabelColor: Colors.black54,
            isScrollable: false,
            // indicatorPadding: EdgeInsets.symmetric(horizontal: 25),
            // labelPadding: EdgeInsets.symmetric(horizontal: 25),
            tabs: <Widget>[
              Tab(
                text: "About",
              ),
              Tab(
                text: "Prayer Times",
              ),
              Tab(
                text: "Events",
              ),
              Tab(
                text: "Education",
              ),
            ],
          ),
        ),
        Container(
          height: 10,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade200,
        ),
        Form(
          key: widget.frmNested,
          child: Container(
              height: _tabController.index == 2
                  ? screenHeight * 0.8
                  : screenHeight * 0.7,
              width: double.infinity,
              //margin: EdgeInsets.only(left: 16.0, right: 16.0),
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
