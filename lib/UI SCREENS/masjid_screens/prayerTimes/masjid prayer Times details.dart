// ignore_for_file: unused_import

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:community_new/UI%20SCREENS/masjid_screens/yearlyIqamaTime.dart';
import 'package:community_new/models/YearlyIqamaTime.dart';
import 'package:community_new/models/jummaTimings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../api_services/api_services.dart';
import '../../../constants/styles.dart';
import '../../../models/eidTimings.dart';
import '../../../models/masjid.dart';
import '../../../models/ramadanTimes.dart';

class masjidPrayerTimeDetails extends StatefulWidget {
  final String? name,
      fajr,
      duhr,
      asr,
      maghrib,
      isha,
      desc,
      address,
      first_juma,
      sec_juma,
      city,
      country;
  final String? startDate, endDate, takberat_time, lec_time, salah_time;
  final int? capacity, Sno, format, eid_Sno, masjidId;
  final bool isprayerTime;
  const masjidPrayerTimeDetails({
    Key? key,
    required this.isprayerTime,
    this.name,
    this.fajr,
    this.format,
    this.duhr,
    this.Sno,
    this.masjidId,
    this.asr,
    this.maghrib,
    this.isha,
    this.desc,
    this.address,
    this.eid_Sno,
    this.first_juma,
    this.sec_juma,
    this.capacity,
    this.startDate,
    this.takberat_time,
    this.lec_time,
    this.salah_time,
    this.endDate,
    this.city,
    this.country,
  }) : super(key: key);

  @override
  State<masjidPrayerTimeDetails> createState() =>
      _masjidPrayerTimeDetailsState();
}

class _masjidPrayerTimeDetailsState extends State<masjidPrayerTimeDetails>
    with SingleTickerProviderStateMixin {
  ScrollController? scrollController;
  int _page = 0;
  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int _limit = 8;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;
  bool _visible = true;

  // This holds the posts fetched from the server
  List _posts = [];

  // This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    // try {
    //   final res =
    //   await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));
    //   setState(() {
    //     _posts = json.decode(res.body);
    //   });
    // } catch (err) {
    //   if (kDebugMode) {
    //     print('Something went wrong');
    //   }
    // }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        // final res =
        // await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));

        //final List fetchedPosts = json.decode(res.body);
        // if (fetchedPosts.isNotEmpty) {
        //   setState(() {
        //     _posts.addAll(fetchedPosts);
        //   });
        // }
        {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  List<Masjid> masjids = [];
  _getMasjid() async {
    int currentUserId = await prefs.get('userId');
    await ApiServices.fetch('masjid',
            actionName: 'GetForEndUser', param1: currentUserId.toString())
        .then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(response.body);
        masjids = list.map((model) => Masjid.fromJson(model)).toList();
      });
    });
  }

  List<RamadanTimes> ramadanTimes = [];
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
      // actionName: 'GetForEndUser', param1: currentUserId.toString()
    ).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(response.body);
        eidTimes = list.map((model) => EidTimings.fromJson(model)).toList();
      });
    });
  }

  List<JummaTimings> jummaList = [];
  _getJummaTimings() async {
    int currentUserId = await prefs.get('userId');
    await ApiServices.fetch(
      'jummatimings',
      // actionName: 'GetForEndUser', param1: currentUserId.toString()
    ).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(response.body);
        jummaList = list.map((model) => JummaTimings.fromJson(model)).toList();
      });
    });
  }

  List<YearlyIqamaTime> yearlyList = [];
  _getYearlyTimings() async {
    int currentUserId = await prefs.get('userId');
    await ApiServices.fetch(
      'yearlyiqamatime',
      // actionName: 'GetForEndUser', param1: currentUserId.toString()
    ).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(response.body);
        yearlyList =
            list.map((model) => YearlyIqamaTime.fromJson(model)).toList();
      });
    });
  }
  // Future<List<EidTimings>> _getEidTimings() async {
  //   final response =
  //       await http.get(Uri.parse('http://ijtimaee.com/api/eidtimings'));
  //   var data = json.decode(response.body.toString());

  //   if (response.statusCode == 200) {
  //     for (Map i in data) {
  //       eidTimes.add(EidTimings.fromJson(i));
  //     }
  //     print('responsecode is' + response.statusCode.toString());
  //     return eidTimes;
  //   } else {
  //     return eidTimes;
  //   }
  // }

  TabController? _tabController;

  // The controller for the ListView
  late ScrollController _controller;
  bool dayTime = false;
  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    scrollController!.addListener(() => setState(() {}));
    _tabController = TabController(length: 6, vsync: this);
    _tabController!.addListener(_handleTabIndex);
    _firstLoad();
    _getMasjid();
    _getTaraveeh();
    _getEidTimings();
    _getJummaTimings();
    _getYearlyTimings();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    scrollController!.dispose();
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var flexibleSpaceWidget = SliverAppBar(
      toolbarHeight: widget.isprayerTime == true ? 0 : 40,
      actions: [
        widget.isprayerTime == true
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Calendar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ))
      ],
      expandedHeight: widget.isprayerTime == true ? 2 : 250.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(widget.name.toString(), textScaleFactor: 1),
        background: widget.isprayerTime == true
            ? Container(
                color: Colors.grey.shade200,
              )
            : Image.asset(
                'assets/bilalmasjid.png',
                fit: BoxFit.fill,
              ),
      ),
      leading: widget.isprayerTime == true
          ? Container()
          : IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(CupertinoIcons.chevron_back)),
    );

    return DefaultTabController(
        length: 6,
        child: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                flexibleSpaceWidget,
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      isScrollable: true,
                      labelColor: appColor,
                      unselectedLabelColor: Colors.black26,
                      indicatorColor: appColor,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                          text: "Today",
                        ),
                        Tab(text: "Weekly"),
                        Tab(text: "Jumma"),
                        Tab(
                          text: 'Yearly',
                        ),
                        Tab(
                          text: 'Ramadan Times',
                        ),
                        Tab(
                          text: 'Eid Timings',
                        )
                      ],
                    ),
                  ),
                  // pinned: true,
                ),
              ];
            },
            body: new TabBarView(children: <Widget>[
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DataTable(
                        columnSpacing: MediaQuery.of(context).size.width / 2.5,
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Color(0xffddc2ae)),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Prayers',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Iqama Time',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                        rows: <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('Fajr')),
                              DataCell(Text(widget.fajr.toString())),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('Duhr')),
                              DataCell(Text(widget.duhr.toString())),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('Asr')),
                              DataCell(Text(widget.asr.toString())),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('Maghrib')),
                              DataCell(Text(widget.maghrib.toString())),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('Isha')),
                              DataCell(Text(widget.isha.toString())),
                            ],
                          ),
                          // DataRow(
                          //   cells: <DataCell>[
                          //     DataCell(Text('First Juma')),
                          //     DataCell(Text(widget.juma.toString())),
                          //   ],
                          // ),
                          // DataRow(
                          //   cells: <DataCell>[
                          //     DataCell(Text('Second Juma')),
                          //     DataCell(Text(widget.juma.toString())),
                          //   ],
                          // ),
                        ],
                      ),
                      // Divider(
                      //   color: Colors.grey,
                      // ),
                      // widget.isprayerTime == true
                      //     ? Container()
                      //     : detailRow(
                      //         title1: 'City : ',
                      //         value1: widget.city,
                      //         title2: 'Country : ',
                      //         value2: widget.country,
                      //       ),
                      // widget.isprayerTime == true
                      //     ? Container()
                      //     : detailRow(
                      //         title1: 'Description :\n',
                      //         value1: widget.desc,
                      //         title2: '   Capacity : ',
                      //         value2: widget.capacity == null
                      //             ? ''
                      //             : widget.capacity.toString(),
                      //       ),
                      // widget.isprayerTime == true
                      //     ? Container()
                      //     : detailRow(
                      //         title1: 'Address : ',
                      //         value1: widget.address,
                      //       ),
                    ],
                  ),
                ),
              ),
              Container(
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Color(0xffddc2ae)),
                    columnSpacing: widget.fajr == null ||
                            widget.fajr == '' ||
                            widget.duhr == '' ||
                            widget.duhr == null ||
                            widget.asr == '' ||
                            widget.asr == null ||
                            widget.maghrib == null ||
                            widget.maghrib == '' ||
                            widget.isha == '' ||
                            widget.isha == null
                        ? 20
                        : 13,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Days',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Fajr',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Duhr',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Asr',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Maghrib',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Isha',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Monday')),
                          DataCell(Text(widget.fajr.toString())),
                          DataCell(Text(widget.duhr.toString())),
                          DataCell(Text(widget.asr.toString())),
                          DataCell(Text(
                            widget.maghrib.toString(),
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
                          )),
                          DataCell(Text(widget.isha.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Tuesday')),
                          DataCell(Text(widget.fajr.toString())),
                          DataCell(Text(widget.duhr.toString())),
                          DataCell(Text(widget.asr.toString())),
                          DataCell(Text(
                            widget.maghrib.toString(),
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
                          )),
                          DataCell(Text(widget.isha.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Wednesday')),
                          DataCell(Text(widget.fajr.toString())),
                          DataCell(Text(widget.duhr.toString())),
                          DataCell(Text(widget.asr.toString())),
                          DataCell(Text(
                            widget.maghrib.toString(),
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
                          )),
                          DataCell(Text(widget.isha.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Thursday')),
                          DataCell(Text(widget.fajr.toString())),
                          DataCell(Text(widget.duhr.toString())),
                          DataCell(Text(widget.asr.toString())),
                          DataCell(Text(
                            widget.maghrib.toString(),
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
                          )),
                          DataCell(Text(widget.isha.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Friday')),
                          DataCell(Text(widget.fajr.toString())),
                          DataCell(Text(widget.duhr.toString())),
                          DataCell(Text(widget.asr.toString())),
                          DataCell(Text(
                            widget.maghrib.toString(),
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
                          )),
                          DataCell(Text(widget.isha.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Saturday')),
                          DataCell(Text(widget.fajr.toString())),
                          DataCell(Text(widget.duhr.toString())),
                          DataCell(Text(widget.asr.toString())),
                          DataCell(Text(
                            widget.maghrib.toString(),
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
                          )),
                          DataCell(Text(widget.isha.toString())),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Sunday')),
                          DataCell(Text(widget.fajr.toString())),
                          DataCell(Text(widget.duhr.toString())),
                          DataCell(Text(widget.asr.toString())),
                          DataCell(Text(
                            widget.maghrib.toString(),
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
                          )),
                          DataCell(Text(widget.isha.toString())),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  // color: Colors.blue,
                  child: ListView.builder(
                      itemCount: jummaList.length,
                      primary: true,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return DataTable(
                          columnSpacing: MediaQuery.of(context).size.width / 35,
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Color(0xffddc2ae)),
                          columns: <DataColumn>[
                            DataColumn(
                              label: Text(
                                'Jumma',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Lecture Time',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Khutba Time',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Iqama Time',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                          rows: <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('${index + 1}')),
                                DataCell(
                                  widget.masjidId == jummaList[index].masjidId
                                      ? Text(
                                          jummaList[index]
                                              .lectureTime
                                              .toString(),
                                        )
                                      : Text(''),
                                ),
                                DataCell(
                                  widget.masjidId == jummaList[index].masjidId
                                      ? Text(
                                          jummaList[index]
                                              .khutbaTime
                                              .toString(),
                                        )
                                      : Text(''),
                                ),
                                DataCell(
                                  widget.masjidId == jummaList[index].masjidId
                                      ? Text(
                                          jummaList[index].iqamaTime.toString(),
                                        )
                                      : Text(''),
                                ),
                              ],
                            ),
                            // DataRow(
                            //   cells: <DataCell>[
                            //     DataCell(Text('2nd')),
                            //     DataCell(
                            //       widget.masjidId ==
                            //               jummaList[index].masjidId
                            //           ? Text(
                            //               jummaList[index]
                            //                   .lectureTime
                            //                   .toString(),
                            //             )
                            //           : Text(''),
                            //     ),
                            //     DataCell(
                            //       widget.masjidId ==
                            //               jummaList[index].masjidId
                            //           ? Text(
                            //               jummaList[index]
                            //                   .khutbaTime
                            //                   .toString(),
                            //             )
                            //           : Text(''),
                            //     ),
                            //     DataCell(
                            //       widget.masjidId ==
                            //               jummaList[index].masjidId
                            //           ? Text(
                            //               jummaList[index]
                            //                   .iqamaTime
                            //                   .toString(),
                            //             )
                            //           : Text(''),
                            //     ),
                            //   ],
                            // ),
                            // // // DataRow(
                            //   cells: <DataCell>[
                            //     DataCell(Text('Asr')),
                            //     DataCell(Text(widget.asr.toString())),
                            //   ],
                            // ),
                            // DataRow(
                            //   cells: <DataCell>[
                            //     DataCell(Text('Maghrib')),
                            //     DataCell(Text(widget.maghrib.toString())),
                            //   ],
                            // ),
                            // DataRow(
                            //   cells: <DataCell>[
                            //     DataCell(Text('Isha')),
                            //     DataCell(Text(widget.isha.toString())),
                            //   ],
                            // ),
                            // DataRow(
                            //   cells: <DataCell>[
                            //     DataCell(Text('First Juma')),
                            //     DataCell(Text(widget.juma.toString())),
                            //   ],
                            // ),
                            // DataRow(
                            //   cells: <DataCell>[
                            //     DataCell(Text('Second Juma')),
                            //     DataCell(Text(widget.juma.toString())),
                            //   ],
                            // ),
                          ],
                        );
                      })),
              Container(
                  child: ListView.builder(
                      itemCount: yearlyList.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return Column(
                          children: [
                            DataTable(
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Color(0xffddc2ae)),
                              // columnSpacing: widget.fajr == null ||
                              //         widget.fajr == '' ||
                              //         widget.duhr == '' ||
                              //         widget.duhr == null ||
                              //         widget.asr == '' ||
                              //         widget.asr == null ||
                              //         widget.maghrib == null ||
                              //         widget.maghrib == '' ||
                              //         widget.isha == '' ||
                              //         widget.isha == null
                              //     ? 25
                              //     : 18,
                              columnSpacing: 20,
                              columns: <DataColumn>[
                                // DataColumn(
                                //   label: Text(
                                //     'Month',
                                //     style: TextStyle(fontStyle: FontStyle.italic),
                                //   ),
                                // ),
                                DataColumn(
                                  label: SizedBox(
                                    child: widget.masjidId ==
                                            yearlyList[index].masjidId
                                        ? Text(
                                            yearlyList[index]
                                                .monthName
                                                .toString(),
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          )
                                        : Text(''),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Fajr',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Duhr',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Asr',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Maghrib',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Isha',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                              rows: <DataRow>[
                                DataRow(
                                  cells: <DataCell>[
                                    // DataCell(Text('January')),
                                    DataCell(widget.masjidId ==
                                            yearlyList[index].masjidId
                                        ? Text(
                                            yearlyList[index]
                                                .dateRange
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 10.0,
                                            ),
                                          )
                                        : Text('')),
                                    DataCell(widget.masjidId ==
                                            yearlyList[index].masjidId
                                        ? Text(
                                            yearlyList[index].fajar.toString(),
                                            style: TextStyle(
                                              fontSize: 10.0,
                                            ),
                                          )
                                        : Text('')),
                                    DataCell(widget.masjidId ==
                                            yearlyList[index].masjidId
                                        ? Text(
                                            yearlyList[index].zuhar.toString(),
                                            style: TextStyle(
                                              fontSize: 10.0,
                                            ),
                                          )
                                        : Text('')),
                                    DataCell(widget.masjidId ==
                                            yearlyList[index].masjidId
                                        ? Text(
                                            yearlyList[index].asr.toString(),
                                            style: TextStyle(
                                              fontSize: 10.0,
                                            ),
                                          )
                                        : Text('')),
                                    DataCell(widget.masjidId ==
                                            yearlyList[index].masjidId
                                        ? Text(
                                            yearlyList[index]
                                                .maghrib
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 10.0,
                                            ),
                                          )
                                        : Text('')),
                                    DataCell(widget.masjidId ==
                                            yearlyList[index].masjidId
                                        ? Text(
                                            yearlyList[index].isha.toString(),
                                            style: TextStyle(
                                              fontSize: 10.0,
                                            ),
                                          )
                                        : Text('')),
                                  ],
                                ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     // DataCell(Text('January')),
                                //     DataCell(widget.masjidId ==
                                //             yearlyList[index].masjidId
                                //         ? Text(
                                //             yearlyList[index]
                                //                 .dateRange
                                //                 .toString(),
                                //             style: TextStyle(
                                //               fontSize: 10.0,
                                //             ),
                                //           )
                                //         : Text('')),
                                //     DataCell(widget.masjidId ==
                                //             yearlyList[index].masjidId
                                //         ? Text(
                                //             yearlyList[index].fajar.toString(),
                                //             style: TextStyle(
                                //               fontSize: 10.0,
                                //             ),
                                //           )
                                //         : Text('')),
                                //     DataCell(widget.masjidId ==
                                //             yearlyList[index].masjidId
                                //         ? Text(
                                //             yearlyList[index].zuhar.toString(),
                                //             style: TextStyle(
                                //               fontSize: 10.0,
                                //             ),
                                //           )
                                //         : Text('')),
                                //     DataCell(widget.masjidId ==
                                //             yearlyList[index].masjidId
                                //         ? Text(
                                //             yearlyList[index].asr.toString(),
                                //             style: TextStyle(
                                //               fontSize: 10.0,
                                //             ),
                                //           )
                                //         : Text('')),
                                //     DataCell(widget.masjidId ==
                                //             yearlyList[index].masjidId
                                //         ? Text(
                                //             yearlyList[index]
                                //                 .maghrib
                                //                 .toString(),
                                //             style: TextStyle(
                                //               fontSize: 10.0,
                                //             ),
                                //           )
                                //         : Text('')),
                                //     DataCell(widget.masjidId ==
                                //             yearlyList[index].masjidId
                                //         ? Text(
                                //             yearlyList[index].isha.toString(),
                                //             style: TextStyle(
                                //               fontSize: 10.0,
                                //             ),
                                //           )
                                //         : Text('')),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     // DataCell(Text('January')),
                                //     DataCell(widget.masjidId ==
                                //             yearlyList[index].masjidId
                                //         ? Text(
                                //             yearlyList[index]
                                //                 .dateRange
                                //                 .toString(),
                                //             style: TextStyle(
                                //               fontSize: 10.0,
                                //             ),
                                //           )
                                //         : Text('')),
                                //     DataCell(widget.masjidId ==
                                //             yearlyList[index].masjidId
                                //         ? Text(
                                //             yearlyList[index].fajar.toString(),
                                //             style: TextStyle(
                                //               fontSize: 10.0,
                                //             ),
                                //           )
                                //         : Text('')),
                                //     DataCell(widget.masjidId ==
                                //             yearlyList[index].masjidId
                                //         ? Text(
                                //             yearlyList[index].zuhar.toString(),
                                //             style: TextStyle(
                                //               fontSize: 10.0,
                                //             ),
                                //           )
                                //         : Text('')),
                                //     DataCell(widget.masjidId ==
                                //             yearlyList[index].masjidId
                                //         ? Text(
                                //             yearlyList[index].asr.toString(),
                                //             style: TextStyle(
                                //               fontSize: 10.0,
                                //             ),
                                //           )
                                //         : Text('')),
                                //     DataCell(widget.masjidId ==
                                //             yearlyList[index].masjidId
                                //         ? Text(
                                //             yearlyList[index]
                                //                 .maghrib
                                //                 .toString(),
                                //             style: TextStyle(
                                //               fontSize: 10.0,
                                //             ),
                                //           )
                                //         : Text('')),
                                //     DataCell(widget.masjidId ==
                                //             yearlyList[index].masjidId
                                //         ? Text(
                                //             yearlyList[index].isha.toString(),
                                //             style: TextStyle(
                                //               fontSize: 10.0,
                                //             ),
                                //           )
                                //         : Text('')),
                                //   ],
                                // ), // DataRow(
                                // //   cells: <DataCell>[
                                //     DataCell(Text('February')),
                                //     DataCell(Text('01 to 10')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('February')),
                                //     DataCell(Text('11 to 20')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('February')),
                                //     DataCell(Text('21 to 28')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('March')),
                                //     DataCell(Text('01 to 13')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('March')),
                                //     DataCell(Text('14 to 20')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('March')),
                                //     DataCell(Text('21 to 31')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('April')),
                                //     DataCell(Text('01 to 12')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('April')),
                                //     DataCell(Text('13 to 20')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('April')),
                                //     DataCell(Text('21 to 30')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('May')),
                                //     DataCell(Text('01 to 10')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('May')),
                                //     DataCell(Text('11 to 20')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('May')),
                                //     DataCell(Text('21 to 31')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('June')),
                                //     DataCell(Text('01 to 10')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('June')),
                                //     DataCell(Text('11 to 20')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('June')),
                                //     DataCell(Text('21 to 30')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('July')),
                                //     DataCell(Text('01 to 10')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('July')),
                                //     DataCell(Text('11 to 20')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('July')),
                                //     DataCell(Text('21 to 31')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('August')),
                                //     DataCell(Text('01 to 10')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('August')),
                                //     DataCell(Text('11 to 20')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('August')),
                                //     DataCell(Text('21 to 31')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('September')),
                                //     DataCell(Text('01 to 10')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('September')),
                                //     DataCell(Text('11 to 20')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('September')),
                                //     DataCell(Text('21 to 30')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('October')),
                                //     DataCell(Text('01 to 10')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('October')),
                                //     DataCell(Text('11 to 20')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('October')),
                                //     DataCell(Text('21 to 31')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('November')),
                                //     DataCell(Text('01 to 10')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('November')),
                                //     DataCell(Text('11 to 20')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('November')),
                                //     DataCell(Text('21 to 30')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('December')),
                                //     DataCell(Text('01 to 10')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('December')),
                                //     DataCell(Text('11 to 20')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                                // DataRow(
                                //   cells: <DataCell>[
                                //     DataCell(Text('Decembet')),
                                //     DataCell(Text('21 to 31')),
                                //     DataCell(Text(widget.fajr.toString())),
                                //     DataCell(Text(widget.duhr.toString())),
                                //     DataCell(Text(widget.asr.toString())),
                                //     DataCell(Text(widget.maghrib.toString())),
                                //     DataCell(Text(widget.isha.toString())),
                                //   ],
                                // ),
                              ],
                            ),
                            // DataTable(
                            //   headingRowColor: MaterialStateColor.resolveWith(
                            //       (states) => Color(0xffddc2ae)),
                            //   // columnSpacing: widget.fajr == null ||
                            //   //         widget.fajr == '' ||
                            //   //         widget.duhr == '' ||
                            //   //         widget.duhr == null ||
                            //   //         widget.asr == '' ||
                            //   //         widget.asr == null ||
                            //   //         widget.maghrib == null ||
                            //   //         widget.maghrib == '' ||
                            //   //         widget.isha == '' ||
                            //   //         widget.isha == null
                            //   //     ? 25
                            //   //     : 18,
                            //   columnSpacing: 20,
                            //   columns: const <DataColumn>[
                            //     // DataColumn(
                            //     //   label: Text(
                            //     //     'Month',
                            //     //     style: TextStyle(fontStyle: FontStyle.italic),
                            //     //   ),
                            //     // ),
                            //     DataColumn(
                            //       label: SizedBox(
                            //         child: Text(
                            //           'Feb',
                            //           style: TextStyle(fontStyle: FontStyle.italic),
                            //         ),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Fajr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Duhr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Asr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Maghrib',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Isha',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //   ],
                            //   rows: <DataRow>[
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(widget.masjidId == yearlyList[3].masjidId
                            //             ? Text(
                            //                 yearlyList[3].dateRange.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[3].masjidId
                            //             ? Text(
                            //                 yearlyList[3].fajar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[3].masjidId
                            //             ? Text(
                            //                 yearlyList[3].zuhar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[3].masjidId
                            //             ? Text(
                            //                 yearlyList[3].asr.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[3].masjidId
                            //             ? Text(
                            //                 yearlyList[3].maghrib.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[3].masjidId
                            //             ? Text(
                            //                 yearlyList[3].isha.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(widget.masjidId == yearlyList[4].masjidId
                            //             ? Text(
                            //                 yearlyList[4].dateRange.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[4].masjidId
                            //             ? Text(
                            //                 yearlyList[4].fajar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[4].masjidId
                            //             ? Text(
                            //                 yearlyList[4].zuhar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[4].masjidId
                            //             ? Text(
                            //                 yearlyList[4].asr.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[4].masjidId
                            //             ? Text(
                            //                 yearlyList[4].maghrib.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[4].masjidId
                            //             ? Text(
                            //                 yearlyList[4].isha.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(widget.masjidId == yearlyList[5].masjidId
                            //             ? Text(
                            //                 yearlyList[5].dateRange.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[5].masjidId
                            //             ? Text(
                            //                 yearlyList[5].fajar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[5].masjidId
                            //             ? Text(
                            //                 yearlyList[5].zuhar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[5].masjidId
                            //             ? Text(
                            //                 yearlyList[5].asr.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[5].masjidId
                            //             ? Text(
                            //                 yearlyList[5].maghrib.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[5].masjidId
                            //             ? Text(
                            //                 yearlyList[5].isha.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //       ],
                            //     ), // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('21 to 28')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('01 to 13')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('14 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('01 to 12')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('13 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('Decembet')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),
                            // DataTable(
                            //   headingRowColor: MaterialStateColor.resolveWith(
                            //       (states) => Color(0xffddc2ae)),
                            //   // columnSpacing: widget.fajr == null ||
                            //   //         widget.fajr == '' ||
                            //   //         widget.duhr == '' ||
                            //   //         widget.duhr == null ||
                            //   //         widget.asr == '' ||
                            //   //         widget.asr == null ||
                            //   //         widget.maghrib == null ||
                            //   //         widget.maghrib == '' ||
                            //   //         widget.isha == '' ||
                            //   //         widget.isha == null
                            //   //     ? 25
                            //   //     : 18,
                            //   columnSpacing: 20,
                            //   columns: const <DataColumn>[
                            //     // DataColumn(
                            //     //   label: Text(
                            //     //     'Month',
                            //     //     style: TextStyle(fontStyle: FontStyle.italic),
                            //     //   ),
                            //     // ),
                            //     DataColumn(
                            //       label: SizedBox(
                            //         child: Text(
                            //           'Mar',
                            //           style: TextStyle(fontStyle: FontStyle.italic),
                            //         ),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Fajr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Duhr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Asr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Maghrib',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Isha',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //   ],
                            //   rows: <DataRow>[
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(widget.masjidId == yearlyList[6].masjidId
                            //             ? Text(
                            //                 yearlyList[6].dateRange.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[6].masjidId
                            //             ? Text(
                            //                 yearlyList[6].fajar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[6].masjidId
                            //             ? Text(
                            //                 yearlyList[6].zuhar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[6].masjidId
                            //             ? Text(
                            //                 yearlyList[6].asr.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[6].masjidId
                            //             ? Text(
                            //                 yearlyList[6].maghrib.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[6].masjidId
                            //             ? Text(
                            //                 yearlyList[6].isha.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(widget.masjidId == yearlyList[7].masjidId
                            //             ? Text(
                            //                 yearlyList[7].dateRange.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[7].masjidId
                            //             ? Text(
                            //                 yearlyList[7].fajar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[7].masjidId
                            //             ? Text(
                            //                 yearlyList[7].zuhar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[7].masjidId
                            //             ? Text(
                            //                 yearlyList[7].asr.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[7].masjidId
                            //             ? Text(
                            //                 yearlyList[7].maghrib.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[7].masjidId
                            //             ? Text(
                            //                 yearlyList[7].isha.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(widget.masjidId == yearlyList[8].masjidId
                            //             ? Text(
                            //                 yearlyList[8].dateRange.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[8].masjidId
                            //             ? Text(
                            //                 yearlyList[8].fajar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[8].masjidId
                            //             ? Text(
                            //                 yearlyList[8].zuhar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[8].masjidId
                            //             ? Text(
                            //                 yearlyList[8].asr.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[8].masjidId
                            //             ? Text(
                            //                 yearlyList[8].maghrib.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[8].masjidId
                            //             ? Text(
                            //                 yearlyList[8].isha.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //       ],
                            //     ), // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('21 to 28')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('01 to 13')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('14 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('01 to 12')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('13 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('Decembet')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),
                            // DataTable(
                            //   headingRowColor: MaterialStateColor.resolveWith(
                            //       (states) => Color(0xffddc2ae)),
                            //   // columnSpacing: widget.fajr == null ||
                            //   //         widget.fajr == '' ||
                            //   //         widget.duhr == '' ||
                            //   //         widget.duhr == null ||
                            //   //         widget.asr == '' ||
                            //   //         widget.asr == null ||
                            //   //         widget.maghrib == null ||
                            //   //         widget.maghrib == '' ||
                            //   //         widget.isha == '' ||
                            //   //         widget.isha == null
                            //   //     ? 25
                            //   //     : 18,
                            //   columnSpacing: 20,
                            //   columns: const <DataColumn>[
                            //     // DataColumn(
                            //     //   label: Text(
                            //     //     'Month',
                            //     //     style: TextStyle(fontStyle: FontStyle.italic),
                            //     //   ),
                            //     // ),
                            //     DataColumn(
                            //       label: SizedBox(
                            //         child: Text(
                            //           'April',
                            //           style: TextStyle(fontStyle: FontStyle.italic),
                            //         ),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Fajr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Duhr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Asr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Maghrib',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Isha',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //   ],
                            //   rows: <DataRow>[
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(widget.masjidId == yearlyList[9].masjidId
                            //             ? Text(
                            //                 yearlyList[9].dateRange.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[9].masjidId
                            //             ? Text(
                            //                 yearlyList[9].fajar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[9].masjidId
                            //             ? Text(
                            //                 yearlyList[9].zuhar.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[9].masjidId
                            //             ? Text(
                            //                 yearlyList[9].asr.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[9].masjidId
                            //             ? Text(
                            //                 yearlyList[9].maghrib.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //         DataCell(widget.masjidId == yearlyList[9].masjidId
                            //             ? Text(
                            //                 yearlyList[9].isha.toString(),
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                 ),
                            //               )
                            //             : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[10].masjidId
                            //                 ? Text(
                            //                     yearlyList[10].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[10].masjidId
                            //                 ? Text(
                            //                     yearlyList[10].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[10].masjidId
                            //                 ? Text(
                            //                     yearlyList[10].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[10].masjidId
                            //                 ? Text(
                            //                     yearlyList[10].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[10].masjidId
                            //                 ? Text(
                            //                     yearlyList[10].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[10].masjidId
                            //                 ? Text(
                            //                     yearlyList[10].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[11].masjidId
                            //                 ? Text(
                            //                     yearlyList[11].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[11].masjidId
                            //                 ? Text(
                            //                     yearlyList[11].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[11].masjidId
                            //                 ? Text(
                            //                     yearlyList[11].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[11].masjidId
                            //                 ? Text(
                            //                     yearlyList[11].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[11].masjidId
                            //                 ? Text(
                            //                     yearlyList[11].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[11].masjidId
                            //                 ? Text(
                            //                     yearlyList[11].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ), // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('21 to 28')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('01 to 13')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('14 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('01 to 12')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('13 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('Decembet')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),
                            // DataTable(
                            //   headingRowColor: MaterialStateColor.resolveWith(
                            //       (states) => Color(0xffddc2ae)),
                            //   // columnSpacing: widget.fajr == null ||
                            //   //         widget.fajr == '' ||
                            //   //         widget.duhr == '' ||
                            //   //         widget.duhr == null ||
                            //   //         widget.asr == '' ||
                            //   //         widget.asr == null ||
                            //   //         widget.maghrib == null ||
                            //   //         widget.maghrib == '' ||
                            //   //         widget.isha == '' ||
                            //   //         widget.isha == null
                            //   //     ? 25
                            //   //     : 18,
                            //   columnSpacing: 20,
                            //   columns: const <DataColumn>[
                            //     // DataColumn(
                            //     //   label: Text(
                            //     //     'Month',
                            //     //     style: TextStyle(fontStyle: FontStyle.italic),
                            //     //   ),
                            //     // ),
                            //     DataColumn(
                            //       label: SizedBox(
                            //         child: Text(
                            //           'May',
                            //           style: TextStyle(fontStyle: FontStyle.italic),
                            //         ),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Fajr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Duhr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Asr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Maghrib',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Isha',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //   ],
                            //   rows: <DataRow>[
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[12].masjidId
                            //                 ? Text(
                            //                     yearlyList[12].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[12].masjidId
                            //                 ? Text(
                            //                     yearlyList[12].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[12].masjidId
                            //                 ? Text(
                            //                     yearlyList[12].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[12].masjidId
                            //                 ? Text(
                            //                     yearlyList[12].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[12].masjidId
                            //                 ? Text(
                            //                     yearlyList[12].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[12].masjidId
                            //                 ? Text(
                            //                     yearlyList[12].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[13].masjidId
                            //                 ? Text(
                            //                     yearlyList[13].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[13].masjidId
                            //                 ? Text(
                            //                     yearlyList[13].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[13].masjidId
                            //                 ? Text(
                            //                     yearlyList[13].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[13].masjidId
                            //                 ? Text(
                            //                     yearlyList[13].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[13].masjidId
                            //                 ? Text(
                            //                     yearlyList[13].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[13].masjidId
                            //                 ? Text(
                            //                     yearlyList[13].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[14].masjidId
                            //                 ? Text(
                            //                     yearlyList[14].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[14].masjidId
                            //                 ? Text(
                            //                     yearlyList[14].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[14].masjidId
                            //                 ? Text(
                            //                     yearlyList[14].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[14].masjidId
                            //                 ? Text(
                            //                     yearlyList[14].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[14].masjidId
                            //                 ? Text(
                            //                     yearlyList[14].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[14].masjidId
                            //                 ? Text(
                            //                     yearlyList[14].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ), // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('21 to 28')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('01 to 13')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('14 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('01 to 12')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('13 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('Decembet')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),
                            // DataTable(
                            //   headingRowColor: MaterialStateColor.resolveWith(
                            //       (states) => Color(0xffddc2ae)),
                            //   // columnSpacing: widget.fajr == null ||
                            //   //         widget.fajr == '' ||
                            //   //         widget.duhr == '' ||
                            //   //         widget.duhr == null ||
                            //   //         widget.asr == '' ||
                            //   //         widget.asr == null ||
                            //   //         widget.maghrib == null ||
                            //   //         widget.maghrib == '' ||
                            //   //         widget.isha == '' ||
                            //   //         widget.isha == null
                            //   //     ? 25
                            //   //     : 18,
                            //   columnSpacing: 20,
                            //   columns: const <DataColumn>[
                            //     // DataColumn(
                            //     //   label: Text(
                            //     //     'Month',
                            //     //     style: TextStyle(fontStyle: FontStyle.italic),
                            //     //   ),
                            //     // ),
                            //     DataColumn(
                            //       label: SizedBox(
                            //         child: Text(
                            //           'June',
                            //           style: TextStyle(fontStyle: FontStyle.italic),
                            //         ),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Fajr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Duhr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Asr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Maghrib',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Isha',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //   ],
                            //   rows: <DataRow>[
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[15].masjidId
                            //                 ? Text(
                            //                     yearlyList[15].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[15].masjidId
                            //                 ? Text(
                            //                     yearlyList[15].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[15].masjidId
                            //                 ? Text(
                            //                     yearlyList[15].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[15].masjidId
                            //                 ? Text(
                            //                     yearlyList[15].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[15].masjidId
                            //                 ? Text(
                            //                     yearlyList[15].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[15].masjidId
                            //                 ? Text(
                            //                     yearlyList[15].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[16].masjidId
                            //                 ? Text(
                            //                     yearlyList[16].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[16].masjidId
                            //                 ? Text(
                            //                     yearlyList[16].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[16].masjidId
                            //                 ? Text(
                            //                     yearlyList[16].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[16].masjidId
                            //                 ? Text(
                            //                     yearlyList[16].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[16].masjidId
                            //                 ? Text(
                            //                     yearlyList[16].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[16].masjidId
                            //                 ? Text(
                            //                     yearlyList[16].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[17].masjidId
                            //                 ? Text(
                            //                     yearlyList[17].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[17].masjidId
                            //                 ? Text(
                            //                     yearlyList[17].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[17].masjidId
                            //                 ? Text(
                            //                     yearlyList[17].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[17].masjidId
                            //                 ? Text(
                            //                     yearlyList[17].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[17].masjidId
                            //                 ? Text(
                            //                     yearlyList[17].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[17].masjidId
                            //                 ? Text(
                            //                     yearlyList[17].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ), // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('21 to 28')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('01 to 13')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('14 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('01 to 12')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('13 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('Decembet')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),
                            // DataTable(
                            //   headingRowColor: MaterialStateColor.resolveWith(
                            //       (states) => Color(0xffddc2ae)),
                            //   // columnSpacing: widget.fajr == null ||
                            //   //         widget.fajr == '' ||
                            //   //         widget.duhr == '' ||
                            //   //         widget.duhr == null ||
                            //   //         widget.asr == '' ||
                            //   //         widget.asr == null ||
                            //   //         widget.maghrib == null ||
                            //   //         widget.maghrib == '' ||
                            //   //         widget.isha == '' ||
                            //   //         widget.isha == null
                            //   //     ? 25
                            //   //     : 18,
                            //   columnSpacing: 20,
                            //   columns: const <DataColumn>[
                            //     // DataColumn(
                            //     //   label: Text(
                            //     //     'Month',
                            //     //     style: TextStyle(fontStyle: FontStyle.italic),
                            //     //   ),
                            //     // ),
                            //     DataColumn(
                            //       label: SizedBox(
                            //         child: Text(
                            //           'July',
                            //           style: TextStyle(fontStyle: FontStyle.italic),
                            //         ),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Fajr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Duhr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Asr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Maghrib',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Isha',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //   ],
                            //   rows: <DataRow>[
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[18].masjidId
                            //                 ? Text(
                            //                     yearlyList[18].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[18].masjidId
                            //                 ? Text(
                            //                     yearlyList[18].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[18].masjidId
                            //                 ? Text(
                            //                     yearlyList[18].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[18].masjidId
                            //                 ? Text(
                            //                     yearlyList[18].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[18].masjidId
                            //                 ? Text(
                            //                     yearlyList[18].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[18].masjidId
                            //                 ? Text(
                            //                     yearlyList[18].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[19].masjidId
                            //                 ? Text(
                            //                     yearlyList[19].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[19].masjidId
                            //                 ? Text(
                            //                     yearlyList[19].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[19].masjidId
                            //                 ? Text(
                            //                     yearlyList[19].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[19].masjidId
                            //                 ? Text(
                            //                     yearlyList[19].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[19].masjidId
                            //                 ? Text(
                            //                     yearlyList[19].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[19].masjidId
                            //                 ? Text(
                            //                     yearlyList[19].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[20].masjidId
                            //                 ? Text(
                            //                     yearlyList[20].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[20].masjidId
                            //                 ? Text(
                            //                     yearlyList[20].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[20].masjidId
                            //                 ? Text(
                            //                     yearlyList[20].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[20].masjidId
                            //                 ? Text(
                            //                     yearlyList[20].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[20].masjidId
                            //                 ? Text(
                            //                     yearlyList[20].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[20].masjidId
                            //                 ? Text(
                            //                     yearlyList[20].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ), // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('21 to 28')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('01 to 13')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('14 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('01 to 12')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('13 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('Decembet')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),
                            // DataTable(
                            //   headingRowColor: MaterialStateColor.resolveWith(
                            //       (states) => Color(0xffddc2ae)),
                            //   // columnSpacing: widget.fajr == null ||
                            //   //         widget.fajr == '' ||
                            //   //         widget.duhr == '' ||
                            //   //         widget.duhr == null ||
                            //   //         widget.asr == '' ||
                            //   //         widget.asr == null ||
                            //   //         widget.maghrib == null ||
                            //   //         widget.maghrib == '' ||
                            //   //         widget.isha == '' ||
                            //   //         widget.isha == null
                            //   //     ? 25
                            //   //     : 18,
                            //   columnSpacing: 20,
                            //   columns: const <DataColumn>[
                            //     // DataColumn(
                            //     //   label: Text(
                            //     //     'Month',
                            //     //     style: TextStyle(fontStyle: FontStyle.italic),
                            //     //   ),
                            //     // ),
                            //     DataColumn(
                            //       label: SizedBox(
                            //         child: Text(
                            //           'Aug',
                            //           style: TextStyle(fontStyle: FontStyle.italic),
                            //         ),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Fajr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Duhr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Asr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Maghrib',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Isha',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //   ],
                            //   rows: <DataRow>[
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[21].masjidId
                            //                 ? Text(
                            //                     yearlyList[21].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[21].masjidId
                            //                 ? Text(
                            //                     yearlyList[21].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[21].masjidId
                            //                 ? Text(
                            //                     yearlyList[21].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[21].masjidId
                            //                 ? Text(
                            //                     yearlyList[21].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[21].masjidId
                            //                 ? Text(
                            //                     yearlyList[21].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[21].masjidId
                            //                 ? Text(
                            //                     yearlyList[21].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[22].masjidId
                            //                 ? Text(
                            //                     yearlyList[22].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[22].masjidId
                            //                 ? Text(
                            //                     yearlyList[22].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[22].masjidId
                            //                 ? Text(
                            //                     yearlyList[22].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[22].masjidId
                            //                 ? Text(
                            //                     yearlyList[22].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[22].masjidId
                            //                 ? Text(
                            //                     yearlyList[22].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[22].masjidId
                            //                 ? Text(
                            //                     yearlyList[22].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[23].masjidId
                            //                 ? Text(
                            //                     yearlyList[23].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[23].masjidId
                            //                 ? Text(
                            //                     yearlyList[23].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[23].masjidId
                            //                 ? Text(
                            //                     yearlyList[23].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[23].masjidId
                            //                 ? Text(
                            //                     yearlyList[23].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[23].masjidId
                            //                 ? Text(
                            //                     yearlyList[23].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[23].masjidId
                            //                 ? Text(
                            //                     yearlyList[23].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ), // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('21 to 28')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('01 to 13')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('14 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('01 to 12')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('13 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('Decembet')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),
                            // DataTable(
                            //   headingRowColor: MaterialStateColor.resolveWith(
                            //       (states) => Color(0xffddc2ae)),
                            //   // columnSpacing: widget.fajr == null ||
                            //   //         widget.fajr == '' ||
                            //   //         widget.duhr == '' ||
                            //   //         widget.duhr == null ||
                            //   //         widget.asr == '' ||
                            //   //         widget.asr == null ||
                            //   //         widget.maghrib == null ||
                            //   //         widget.maghrib == '' ||
                            //   //         widget.isha == '' ||
                            //   //         widget.isha == null
                            //   //     ? 25
                            //   //     : 18,
                            //   columnSpacing: 20,
                            //   columns: const <DataColumn>[
                            //     // DataColumn(
                            //     //   label: Text(
                            //     //     'Month',
                            //     //     style: TextStyle(fontStyle: FontStyle.italic),
                            //     //   ),
                            //     // ),
                            //     DataColumn(
                            //       label: SizedBox(
                            //         child: Text(
                            //           'Sep',
                            //           style: TextStyle(fontStyle: FontStyle.italic),
                            //         ),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Fajr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Duhr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Asr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Maghrib',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Isha',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //   ],
                            //   rows: <DataRow>[
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[24].masjidId
                            //                 ? Text(
                            //                     yearlyList[24].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[24].masjidId
                            //                 ? Text(
                            //                     yearlyList[24].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[24].masjidId
                            //                 ? Text(
                            //                     yearlyList[24].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[24].masjidId
                            //                 ? Text(
                            //                     yearlyList[24].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[24].masjidId
                            //                 ? Text(
                            //                     yearlyList[24].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[24].masjidId
                            //                 ? Text(
                            //                     yearlyList[24].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[25].masjidId
                            //                 ? Text(
                            //                     yearlyList[25].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[25].masjidId
                            //                 ? Text(
                            //                     yearlyList[25].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[25].masjidId
                            //                 ? Text(
                            //                     yearlyList[25].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[25].masjidId
                            //                 ? Text(
                            //                     yearlyList[25].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[25].masjidId
                            //                 ? Text(
                            //                     yearlyList[25].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[25].masjidId
                            //                 ? Text(
                            //                     yearlyList[25].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[26].masjidId
                            //                 ? Text(
                            //                     yearlyList[26].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[26].masjidId
                            //                 ? Text(
                            //                     yearlyList[26].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[26].masjidId
                            //                 ? Text(
                            //                     yearlyList[26].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[26].masjidId
                            //                 ? Text(
                            //                     yearlyList[26].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[26].masjidId
                            //                 ? Text(
                            //                     yearlyList[26].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[26].masjidId
                            //                 ? Text(
                            //                     yearlyList[26].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ), // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('21 to 28')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('01 to 13')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('14 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('01 to 12')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('13 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('Decembet')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),
                            // DataTable(
                            //   headingRowColor: MaterialStateColor.resolveWith(
                            //       (states) => Color(0xffddc2ae)),
                            //   // columnSpacing: widget.fajr == null ||
                            //   //         widget.fajr == '' ||
                            //   //         widget.duhr == '' ||
                            //   //         widget.duhr == null ||
                            //   //         widget.asr == '' ||
                            //   //         widget.asr == null ||
                            //   //         widget.maghrib == null ||
                            //   //         widget.maghrib == '' ||
                            //   //         widget.isha == '' ||
                            //   //         widget.isha == null
                            //   //     ? 25
                            //   //     : 18,
                            //   columnSpacing: 20,
                            //   columns: const <DataColumn>[
                            //     // DataColumn(
                            //     //   label: Text(
                            //     //     'Month',
                            //     //     style: TextStyle(fontStyle: FontStyle.italic),
                            //     //   ),
                            //     // ),
                            //     DataColumn(
                            //       label: SizedBox(
                            //         child: Text(
                            //           'Oct',
                            //           style: TextStyle(fontStyle: FontStyle.italic),
                            //         ),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Fajr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Duhr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Asr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Maghrib',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Isha',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //   ],
                            //   rows: <DataRow>[
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[27].masjidId
                            //                 ? Text(
                            //                     yearlyList[27].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[27].masjidId
                            //                 ? Text(
                            //                     yearlyList[27].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[27].masjidId
                            //                 ? Text(
                            //                     yearlyList[27].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[27].masjidId
                            //                 ? Text(
                            //                     yearlyList[27].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[27].masjidId
                            //                 ? Text(
                            //                     yearlyList[27].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[27].masjidId
                            //                 ? Text(
                            //                     yearlyList[27].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[28].masjidId
                            //                 ? Text(
                            //                     yearlyList[28].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[28].masjidId
                            //                 ? Text(
                            //                     yearlyList[28].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[28].masjidId
                            //                 ? Text(
                            //                     yearlyList[28].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[28].masjidId
                            //                 ? Text(
                            //                     yearlyList[28].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[28].masjidId
                            //                 ? Text(
                            //                     yearlyList[28].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[28].masjidId
                            //                 ? Text(
                            //                     yearlyList[28].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[29].masjidId
                            //                 ? Text(
                            //                     yearlyList[29].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[29].masjidId
                            //                 ? Text(
                            //                     yearlyList[29].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[29].masjidId
                            //                 ? Text(
                            //                     yearlyList[29].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[29].masjidId
                            //                 ? Text(
                            //                     yearlyList[29].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[29].masjidId
                            //                 ? Text(
                            //                     yearlyList[29].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[29].masjidId
                            //                 ? Text(
                            //                     yearlyList[29].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ), // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('21 to 28')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('01 to 13')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('14 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('01 to 12')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('13 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('Decembet')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),
                            // DataTable(
                            //   headingRowColor: MaterialStateColor.resolveWith(
                            //       (states) => Color(0xffddc2ae)),
                            //   // columnSpacing: widget.fajr == null ||
                            //   //         widget.fajr == '' ||
                            //   //         widget.duhr == '' ||
                            //   //         widget.duhr == null ||
                            //   //         widget.asr == '' ||
                            //   //         widget.asr == null ||
                            //   //         widget.maghrib == null ||
                            //   //         widget.maghrib == '' ||
                            //   //         widget.isha == '' ||
                            //   //         widget.isha == null
                            //   //     ? 25
                            //   //     : 18,
                            //   columnSpacing: 20,
                            //   columns: const <DataColumn>[
                            //     // DataColumn(
                            //     //   label: Text(
                            //     //     'Month',
                            //     //     style: TextStyle(fontStyle: FontStyle.italic),
                            //     //   ),
                            //     // ),
                            //     DataColumn(
                            //       label: SizedBox(
                            //         child: Text(
                            //           'Nov',
                            //           style: TextStyle(fontStyle: FontStyle.italic),
                            //         ),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Fajr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Duhr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Asr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Maghrib',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Isha',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //   ],
                            //   rows: <DataRow>[
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[30].masjidId
                            //                 ? Text(
                            //                     yearlyList[30].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[30].masjidId
                            //                 ? Text(
                            //                     yearlyList[30].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[30].masjidId
                            //                 ? Text(
                            //                     yearlyList[30].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[30].masjidId
                            //                 ? Text(
                            //                     yearlyList[30].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[30].masjidId
                            //                 ? Text(
                            //                     yearlyList[30].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[30].masjidId
                            //                 ? Text(
                            //                     yearlyList[30].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[31].masjidId
                            //                 ? Text(
                            //                     yearlyList[31].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[31].masjidId
                            //                 ? Text(
                            //                     yearlyList[31].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[31].masjidId
                            //                 ? Text(
                            //                     yearlyList[31].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[31].masjidId
                            //                 ? Text(
                            //                     yearlyList[31].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[31].masjidId
                            //                 ? Text(
                            //                     yearlyList[31].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[31].masjidId
                            //                 ? Text(
                            //                     yearlyList[31].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[32].masjidId
                            //                 ? Text(
                            //                     yearlyList[32].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[32].masjidId
                            //                 ? Text(
                            //                     yearlyList[32].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[32].masjidId
                            //                 ? Text(
                            //                     yearlyList[32].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[32].masjidId
                            //                 ? Text(
                            //                     yearlyList[32].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[32].masjidId
                            //                 ? Text(
                            //                     yearlyList[32].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[32].masjidId
                            //                 ? Text(
                            //                     yearlyList[32].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ), // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('21 to 28')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('01 to 13')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('14 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('01 to 12')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('13 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('Decembet')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),
                            // DataTable(
                            //   headingRowColor: MaterialStateColor.resolveWith(
                            //       (states) => Color(0xffddc2ae)),
                            //   // columnSpacing: widget.fajr == null ||
                            //   //         widget.fajr == '' ||
                            //   //         widget.duhr == '' ||
                            //   //         widget.duhr == null ||
                            //   //         widget.asr == '' ||
                            //   //         widget.asr == null ||
                            //   //         widget.maghrib == null ||
                            //   //         widget.maghrib == '' ||
                            //   //         widget.isha == '' ||
                            //   //         widget.isha == null
                            //   //     ? 25
                            //   //     : 18,
                            //   columnSpacing: 20,
                            //   columns: const <DataColumn>[
                            //     // DataColumn(
                            //     //   label: Text(
                            //     //     'Month',
                            //     //     style: TextStyle(fontStyle: FontStyle.italic),
                            //     //   ),
                            //     // ),
                            //     DataColumn(
                            //       label: SizedBox(
                            //         child: Text(
                            //           'Dec',
                            //           style: TextStyle(fontStyle: FontStyle.italic),
                            //         ),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Fajr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Duhr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Asr',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Maghrib',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //     DataColumn(
                            //       label: Text(
                            //         'Isha',
                            //         style: TextStyle(fontStyle: FontStyle.italic),
                            //       ),
                            //     ),
                            //   ],
                            //   rows: <DataRow>[
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[33].masjidId
                            //                 ? Text(
                            //                     yearlyList[33].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[33].masjidId
                            //                 ? Text(
                            //                     yearlyList[33].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[33].masjidId
                            //                 ? Text(
                            //                     yearlyList[33].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[33].masjidId
                            //                 ? Text(
                            //                     yearlyList[33].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[33].masjidId
                            //                 ? Text(
                            //                     yearlyList[33].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[33].masjidId
                            //                 ? Text(
                            //                     yearlyList[33].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[34].masjidId
                            //                 ? Text(
                            //                     yearlyList[34].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[34].masjidId
                            //                 ? Text(
                            //                     yearlyList[34].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[34].masjidId
                            //                 ? Text(
                            //                     yearlyList[34].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[34].masjidId
                            //                 ? Text(
                            //                     yearlyList[34].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[34].masjidId
                            //                 ? Text(
                            //                     yearlyList[34].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[34].masjidId
                            //                 ? Text(
                            //                     yearlyList[34].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ),
                            //     DataRow(
                            //       cells: <DataCell>[
                            //         // DataCell(Text('January')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[35].masjidId
                            //                 ? Text(
                            //                     yearlyList[35].dateRange.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[35].masjidId
                            //                 ? Text(
                            //                     yearlyList[35].fajar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[35].masjidId
                            //                 ? Text(
                            //                     yearlyList[35].zuhar.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[35].masjidId
                            //                 ? Text(
                            //                     yearlyList[35].asr.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[35].masjidId
                            //                 ? Text(
                            //                     yearlyList[35].maghrib.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //         DataCell(
                            //             widget.masjidId == yearlyList[35].masjidId
                            //                 ? Text(
                            //                     yearlyList[35].isha.toString(),
                            //                     style: TextStyle(
                            //                       fontSize: 10.0,
                            //                     ),
                            //                   )
                            //                 : Text('')),
                            //       ],
                            //     ), // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('February')),
                            //     //     DataCell(Text('21 to 28')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('01 to 13')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('14 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('March')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('01 to 12')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('13 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('April')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('May')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('June')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('July')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('August')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('September')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('October')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('November')),
                            //     //     DataCell(Text('21 to 30')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('01 to 10')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('December')),
                            //     //     DataCell(Text('11 to 20')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //     // DataRow(
                            //     //   cells: <DataCell>[
                            //     //     DataCell(Text('Decembet')),
                            //     //     DataCell(Text('21 to 31')),
                            //     //     DataCell(Text(widget.fajr.toString())),
                            //     //     DataCell(Text(widget.duhr.toString())),
                            //     //     DataCell(Text(widget.asr.toString())),
                            //     //     DataCell(Text(widget.maghrib.toString())),
                            //     //     DataCell(Text(widget.isha.toString())),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),

                            SizedBox(
                              height: 70.0,
                            ),

                            //       //     // Divider(
                            //       //     //   color: Colors.grey,
                            //       //     // ),
                            //       //     // detailRow(
                            //       //     //   title1: 'City : ',
                            //       //     //   value1: widget.city,
                            //       //     //   title2: 'Country : ',
                            //       //     //   value2: widget.country,
                            //       //     // ),
                            //       //     // detailRow(
                            //       //     //   title1: 'Description : ',
                            //       //     //   value1: widget.desc,
                            //       //     //   title2: 'Capacity : ',
                            //       //     //   value2: widget.capacity == null
                            //       //     //       ? ''
                            //       //     //       : widget.capacity.toString(),
                            //       //     // ),
                            //       //     // detailRow(
                            //       //     //   title1: 'Address : ',
                            //       //     //   value1: widget.address,
                            //       //     // ),
                            //       //   ],
                            //       // ),

                            //       ),
                            // ),

                            // new TabScreen("Detail"),
                            // new TabScreen("Address"),
                            // new TabScreen("Earning"),
                          ],
                        );
                      })),
              Container(
                child: SingleChildScrollView(
                  // scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ramadan 1447',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '16th Mar, 2023',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'to',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '15th Apr, 2023',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Color(0xffddc2ae)),
                        columnSpacing: widget.Sno == null ||
                                widget.Sno == '' ||
                                widget.format == '' ||
                                widget.format == null ||
                                widget.startDate == '' ||
                                widget.startDate == null ||
                                widget.endDate == null ||
                                widget.endDate == ''
                            // widget.isha == '' ||
                            // widget.isha == null
                            ? 18
                            : 10,
                        // columnSpacing: 35,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'S.No',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Format',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Start Date',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'End Date',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          // DataColumn(
                          //   label: Text(
                          //     'Maghrib',
                          //     style: TextStyle(fontStyle: FontStyle.italic),
                          //   ),
                          // ),
                          // DataColumn(
                          //   label: Text(
                          //     'Isha',
                          //     style: TextStyle(fontStyle: FontStyle.italic),
                          //   ),
                          // ),
                        ],
                        rows: <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('1st')),
                              DataCell(Text('3 juz')),
                              DataCell(Text('19th Oct, 2022')),
                              DataCell(Text('19th Nov, 2022')),
                              // DataCell(Text(widget.maghrib.toString())),
                              // DataCell(Text(widget.isha.toString())),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('2nd')),
                              DataCell(Text('4 juz')),
                              DataCell(Text('10th Sep, 2022')),
                              DataCell(Text('10th OCt, 2022')),
                              // DataCell(Text(widget.maghrib.toString())),
                              // DataCell(Text(widget.isha.toString())),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('3rd')),
                              DataCell(Text('10 juz')),
                              DataCell(Text('16th Mar, 2023')),
                              DataCell(Text('05th Apr, 2023')),
                              // DataCell(Text(widget.maghrib.toString())),
                              // DataCell(Text(widget.isha.toString())),
                            ],
                          ),
                          // DataRow(
                          //   cells: <DataCell>[
                          //     DataCell(Text('Thursday')),
                          //     DataCell(Text(widget.fajr.toString())),
                          //     DataCell(Text(widget.duhr.toString())),
                          //     DataCell(Text(widget.asr.toString())),
                          //     DataCell(Text(widget.maghrib.toString())),
                          //     DataCell(Text(widget.isha.toString())),
                          //   ],
                          // ),
                          // DataRow(
                          //   cells: <DataCell>[
                          //     DataCell(Text('Friday')),
                          //     DataCell(Text(widget.fajr.toString())),
                          //     DataCell(Text(widget.duhr.toString())),
                          //     DataCell(Text(widget.asr.toString())),
                          //     DataCell(Text(widget.maghrib.toString())),
                          //     DataCell(Text(widget.isha.toString())),
                          //   ],
                          // ),
                          // DataRow(
                          //   cells: <DataCell>[
                          //     DataCell(Text('Saturday')),
                          //     DataCell(Text(widget.fajr.toString())),
                          //     DataCell(Text(widget.duhr.toString())),
                          //     DataCell(Text(widget.asr.toString())),
                          //     DataCell(Text(widget.maghrib.toString())),
                          //     DataCell(Text(widget.isha.toString())),
                          //   ],
                          // ),
                          // DataRow(
                          //   cells: <DataCell>[
                          //     DataCell(Text('Sunday')),
                          //     DataCell(Text(widget.fajr.toString())),
                          //     DataCell(Text(widget.duhr.toString())),
                          //     DataCell(Text(widget.asr.toString())),
                          //     DataCell(Text(widget.maghrib.toString())),
                          //     DataCell(Text(widget.isha.toString())),
                          //   ],
                          // ),
                        ],
                      ),
                      // Divider(
                      //   color: Colors.grey,
                      // ),
                      // detailRow(
                      //   title1: 'City : ',
                      //   value1: widget.city,
                      //   title2: 'Country : ',
                      //   value2: widget.country,
                      // ),
                      // detailRow(
                      //   title1: 'Description : ',
                      //   value1: widget.desc,
                      //   title2: 'Capacity : ',
                      //   value2: widget.capacity == null
                      //       ? ''
                      //       : widget.capacity.toString(),
                      // ),
                      // detailRow(
                      //   title1: 'Address : ',
                      //   value1: widget.address,
                      // ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Eid Ul Fitr',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          '15th Apr, 2023',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Color(0xffddc2ae)),
                      columnSpacing: widget.Sno == null ||
                              widget.Sno == '' ||
                              widget.takberat_time == '' ||
                              widget.takberat_time == null ||
                              widget.lec_time == '' ||
                              widget.lec_time == null ||
                              widget.salah_time == null ||
                              widget.salah_time == ''
                          ? 35
                          : 13,
                      // columnSpacing: 35,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'S.No',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Takberat',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Lecture',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Salah Time',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        // DataColumn(
                        //   label: Text(
                        //     'Salah Type',
                        //     style: TextStyle(fontStyle: FontStyle.italic),
                        //   ),
                        // ),
                        // DataColumn(
                        //   label: Text(
                        //     'Year',
                        //     style: TextStyle(fontStyle: FontStyle.italic),
                        //   ),
                        // ),
                      ],
                      rows: <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('2022')),
                            DataCell(Text('7:00 AM')),
                            DataCell(Text('7:30 AM')),
                            DataCell(Text('8:00 AM')),
                            // DataCell(Text(widget.salahType.toString())),
                            // DataCell(Text(widget.year.toString())),
                          ],
                        ),
                        // DataRow(
                        //   cells: <DataCell>[
                        //     DataCell(Text('Tuesday')),
                        //     DataCell(Text(widget.fajr.toString())),
                        //     DataCell(Text(widget.duhr.toString())),
                        //     DataCell(Text(widget.asr.toString())),
                        //     DataCell(Text(widget.maghrib.toString())),
                        //     DataCell(Text(widget.isha.toString())),
                        //   ],
                        // ),
                        // DataRow(
                        //   cells: <DataCell>[
                        //     DataCell(Text('Wednesday')),
                        //     DataCell(Text(widget.fajr.toString())),
                        //     DataCell(Text(widget.duhr.toString())),
                        //     DataCell(Text(widget.asr.toString())),
                        //     DataCell(Text(widget.maghrib.toString())),
                        //     DataCell(Text(widget.isha.toString())),
                        //   ],
                        // ),
                        // DataRow(
                        //   cells: <DataCell>[
                        //     DataCell(Text('Thursday')),
                        //     DataCell(Text(widget.fajr.toString())),
                        //     DataCell(Text(widget.duhr.toString())),
                        //     DataCell(Text(widget.asr.toString())),
                        //     DataCell(Text(widget.maghrib.toString())),
                        //     DataCell(Text(widget.isha.toString())),
                        //   ],
                        // ),
                        // DataRow(
                        //   cells: <DataCell>[
                        //     DataCell(Text('Friday')),
                        //     DataCell(Text(widget.fajr.toString())),
                        //     DataCell(Text(widget.duhr.toString())),
                        //     DataCell(Text(widget.asr.toString())),
                        //     DataCell(Text(widget.maghrib.toString())),
                        //     DataCell(Text(widget.isha.toString())),
                        //   ],
                        // ),
                        // DataRow(
                        //   cells: <DataCell>[
                        //     DataCell(Text('Saturday')),
                        //     DataCell(Text(widget.fajr.toString())),
                        //     DataCell(Text(widget.duhr.toString())),
                        //     DataCell(Text(widget.asr.toString())),
                        //     DataCell(Text(widget.maghrib.toString())),
                        //     DataCell(Text(widget.isha.toString())),
                        //   ],
                        // ),
                        // DataRow(
                        //   cells: <DataCell>[
                        //     DataCell(Text('Sunday')),
                        //     DataCell(Text(widget.fajr.toString())),
                        //     DataCell(Text(widget.duhr.toString())),
                        //     DataCell(Text(widget.asr.toString())),
                        //     DataCell(Text(widget.maghrib.toString())),
                        //     DataCell(Text(widget.isha.toString())),
                        //   ],
                        // ),
                      ],
                    ),
                    // Divider(
                    //   color: Colors.grey,
                    // ),
                    // detailRow(
                    //   title1: 'City : ',
                    //   value1: widget.city,
                    //   title2: 'Country : ',
                    //   value2: widget.country,
                    // ),
                    // detailRow(
                    //   title1: 'Description : ',
                    //   value1: widget.desc,
                    //   title2: 'Capacity : ',
                    //   value2: widget.capacity == null
                    //       ? ''
                    //       : widget.capacity.toString(),
                    // ),
                    // detailRow(
                    //   title1: 'Address : ',
                    //   value1: widget.address,
                    // ),
                  ],
                ),
              ),
            ])));

    // DefaultTabController(
    //   length: 5,
    //   child: Scaffold(
    //     body: Builder(
    //       builder: (context) {
    //         final double height = MediaQuery.of(context).size.height;
    //         return CarouselSlider(
    //             options: CarouselOptions(
    //               height: height,
    //               enableInfiniteScroll: false,
    //               viewportFraction: 1.0,
    //               enlargeCenterPage: false,
    //               // autoPlay: false,
    //             ),
    //             items: [
    //               CustomScrollView(
    //                 slivers: <Widget>[
    //                   SliverAppBar(
    //                     toolbarHeight: widget.isprayerTime == true ? 0 : 60,
    //                     actions: [
    //                       widget.isprayerTime == true
    //                           ? Container()
    //                           : Padding(
    //                               padding: const EdgeInsets.all(15.0),
    //                               child: Text(
    //                                 "Today's Calendar",
    //                                 style: TextStyle(
    //                                     fontSize: 16,
    //                                     fontWeight: FontWeight.bold),
    //                               ))
    //                     ],
    //                     expandedHeight: widget.isprayerTime == true ? 2 : 300.0,
    //                     flexibleSpace: FlexibleSpaceBar(
    //                       title:
    //                           Text(widget.name.toString(), textScaleFactor: 1),
    //                       background: widget.isprayerTime == true
    //                           ? Container(
    //                               color: Colors.grey.shade200,
    //                             )
    //                           : Image.asset(
    //                               'assets/bilalmasjid.png',
    //                               fit: BoxFit.fill,
    //                             ),
    //                     ),
    //                     leading: widget.isprayerTime == true
    //                         ? Container()
    //                         : IconButton(
    //                             onPressed: () {
    //                               Navigator.of(context).pop();
    //                             },
    //                             icon: Icon(CupertinoIcons.chevron_back)),
    //                   ),
    //                   SliverList(
    //                     delegate: SliverChildBuilderDelegate(
    //                       (_, int index) {
    //                         return Column(
    //                           children: [
    //                             DataTable(
    //                               columnSpacing:
    //                                   MediaQuery.of(context).size.width / 1.7,
    //                               headingRowColor:
    //                                   MaterialStateColor.resolveWith(
    //                                       (states) => Colors.grey.shade300),
    //                               columns: const <DataColumn>[
    //                                 DataColumn(
    //                                   label: Text(
    //                                     'Prayers',
    //                                     style: TextStyle(
    //                                         fontStyle: FontStyle.italic),
    //                                   ),
    //                                 ),
    //                                 DataColumn(
    //                                   label: Text(
    //                                     'Time',
    //                                     style: TextStyle(
    //                                         fontStyle: FontStyle.italic),
    //                                   ),
    //                                 ),
    //                               ],
    //                               rows: <DataRow>[
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Fajr')),
    //                                     DataCell(Text(widget.fajr.toString())),
    //                                   ],
    //                                 ),
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Duhr')),
    //                                     DataCell(Text(widget.duhr.toString())),
    //                                   ],
    //                                 ),
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Asr')),
    //                                     DataCell(Text(widget.asr.toString())),
    //                                   ],
    //                                 ),
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Maghrib')),
    //                                     DataCell(
    //                                         Text(widget.maghrib.toString())),
    //                                   ],
    //                                 ),
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Isha')),
    //                                     DataCell(Text(widget.isha.toString())),
    //                                   ],
    //                                 ),
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('First Juma')),
    //                                     DataCell(Text(widget.juma.toString())),
    //                                   ],
    //                                 ),
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Second Juma')),
    //                                     DataCell(Text(widget.juma.toString())),
    //                                   ],
    //                                 ),
    //                               ],
    //                             ),
    //                             Divider(
    //                               color: Colors.grey,
    //                             ),
    //                             widget.isprayerTime == true
    //                                 ? Container()
    //                                 : detailRow(
    //                                     title1: 'City : ',
    //                                     value1: widget.city,
    //                                     title2: 'Country : ',
    //                                     value2: widget.country,
    //                                   ),
    //                             widget.isprayerTime == true
    //                                 ? Container()
    //                                 : detailRow(
    //                                     title1: 'Description :\n',
    //                                     value1: widget.desc,
    //                                     title2: '   Capacity : ',
    //                                     value2: widget.capacity == null
    //                                         ? ''
    //                                         : widget.capacity.toString(),
    //                                   ),
    //                             widget.isprayerTime == true
    //                                 ? Container()
    //                                 : detailRow(
    //                                     title1: 'Address : ',
    //                                     value1: widget.address,
    //                                   ),
    //                           ],
    //                         );
    //                       },
    //                       childCount: 1,
    //                     ),
    //                   )
    //                 ],
    //               ),
    //               CustomScrollView(
    //                 slivers: <Widget>[
    //                   SliverAppBar(
    //                     toolbarHeight: widget.isprayerTime == true ? 0 : 60,
    //                     actions: [
    //                       widget.isprayerTime == true
    //                           ? Container()
    //                           : widget.isprayerTime == true
    //                               ? Container()
    //                               : Padding(
    //                                   padding: const EdgeInsets.all(15.0),
    //                                   child: Text(
    //                                     "Weekly Calendar",
    //                                     style: TextStyle(
    //                                         fontSize: 16,
    //                                         fontWeight: FontWeight.bold),
    //                                   ))
    //                     ],
    //                     expandedHeight: widget.isprayerTime == true ? 2 : 300.0,
    //                     flexibleSpace: FlexibleSpaceBar(
    //                       title:
    //                           Text(widget.name.toString(), textScaleFactor: 1),
    //                       background: widget.isprayerTime == true
    //                           ? Container(
    //                               color: Colors.grey.shade200,
    //                             )
    //                           : Image.asset(
    //                               'assets/bilalmasjid.png',
    //                               fit: BoxFit.fill,
    //                             ),
    //                     ),
    //                     leading: widget.isprayerTime == true
    //                         ? Container()
    //                         : IconButton(
    //                             onPressed: () {
    //                               Navigator.of(context).pop();
    //                             },
    //                             icon: Icon(CupertinoIcons.chevron_back)),
    //                   ),
    //                   SliverList(
    //                     delegate: SliverChildBuilderDelegate(
    //                       (_, int index) {
    //                         return Column(
    //                           children: [
    //                             DataTable(
    //                               headingRowColor:
    //                                   MaterialStateColor.resolveWith(
    //                                       (states) => Colors.grey.shade300),
    //                               columnSpacing: widget.fajr == null ||
    //                                       widget.fajr == '' ||
    //                                       widget.duhr == '' ||
    //                                       widget.duhr == null ||
    //                                       widget.asr == '' ||
    //                                       widget.asr == null ||
    //                                       widget.maghrib == null ||
    //                                       widget.maghrib == '' ||
    //                                       widget.isha == '' ||
    //                                       widget.isha == null
    //                                   ? 25
    //                                   : 18,
    //                               columns: const <DataColumn>[
    //                                 DataColumn(
    //                                   label: Text(
    //                                     'Prayers',
    //                                     style: TextStyle(
    //                                         fontStyle: FontStyle.italic),
    //                                   ),
    //                                 ),
    //                                 DataColumn(
    //                                   label: Text(
    //                                     'Fajr',
    //                                     style: TextStyle(
    //                                         fontStyle: FontStyle.italic),
    //                                   ),
    //                                 ),
    //                                 DataColumn(
    //                                   label: Text(
    //                                     'Duhr',
    //                                     style: TextStyle(
    //                                         fontStyle: FontStyle.italic),
    //                                   ),
    //                                 ),
    //                                 DataColumn(
    //                                   label: Text(
    //                                     'Asr',
    //                                     style: TextStyle(
    //                                         fontStyle: FontStyle.italic),
    //                                   ),
    //                                 ),
    //                                 DataColumn(
    //                                   label: Text(
    //                                     'Maghrib',
    //                                     style: TextStyle(
    //                                         fontStyle: FontStyle.italic),
    //                                   ),
    //                                 ),
    //                                 DataColumn(
    //                                   label: Text(
    //                                     'Isha',
    //                                     style: TextStyle(
    //                                         fontStyle: FontStyle.italic),
    //                                   ),
    //                                 ),
    //                               ],
    //                               rows: <DataRow>[
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Monday')),
    //                                     DataCell(Text(widget.fajr.toString())),
    //                                     DataCell(Text(widget.duhr.toString())),
    //                                     DataCell(Text(widget.asr.toString())),
    //                                     DataCell(
    //                                         Text(widget.maghrib.toString())),
    //                                     DataCell(Text(widget.isha.toString())),
    //                                   ],
    //                                 ),
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Tuesday')),
    //                                     DataCell(Text(widget.fajr.toString())),
    //                                     DataCell(Text(widget.duhr.toString())),
    //                                     DataCell(Text(widget.asr.toString())),
    //                                     DataCell(
    //                                         Text(widget.maghrib.toString())),
    //                                     DataCell(Text(widget.isha.toString())),
    //                                   ],
    //                                 ),
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Wednesday')),
    //                                     DataCell(Text(widget.fajr.toString())),
    //                                     DataCell(Text(widget.duhr.toString())),
    //                                     DataCell(Text(widget.asr.toString())),
    //                                     DataCell(
    //                                         Text(widget.maghrib.toString())),
    //                                     DataCell(Text(widget.isha.toString())),
    //                                   ],
    //                                 ),
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Thursday')),
    //                                     DataCell(Text(widget.fajr.toString())),
    //                                     DataCell(Text(widget.duhr.toString())),
    //                                     DataCell(Text(widget.asr.toString())),
    //                                     DataCell(
    //                                         Text(widget.maghrib.toString())),
    //                                     DataCell(Text(widget.isha.toString())),
    //                                   ],
    //                                 ),
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Friday')),
    //                                     DataCell(Text(widget.fajr.toString())),
    //                                     DataCell(Text(widget.duhr.toString())),
    //                                     DataCell(Text(widget.asr.toString())),
    //                                     DataCell(
    //                                         Text(widget.maghrib.toString())),
    //                                     DataCell(Text(widget.isha.toString())),
    //                                   ],
    //                                 ),
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Saturday')),
    //                                     DataCell(Text(widget.fajr.toString())),
    //                                     DataCell(Text(widget.duhr.toString())),
    //                                     DataCell(Text(widget.asr.toString())),
    //                                     DataCell(
    //                                         Text(widget.maghrib.toString())),
    //                                     DataCell(Text(widget.isha.toString())),
    //                                   ],
    //                                 ),
    //                                 DataRow(
    //                                   cells: <DataCell>[
    //                                     DataCell(Text('Sunday')),
    //                                     DataCell(Text(widget.fajr.toString())),
    //                                     DataCell(Text(widget.duhr.toString())),
    //                                     DataCell(Text(widget.asr.toString())),
    //                                     DataCell(
    //                                         Text(widget.maghrib.toString())),
    //                                     DataCell(Text(widget.isha.toString())),
    //                                   ],
    //                                 ),
    //                               ],
    //                             ),
    //                             Divider(
    //                               color: Colors.grey,
    //                             ),
    //                             detailRow(
    //                               title1: 'City : ',
    //                               value1: widget.city,
    //                               title2: 'Country : ',
    //                               value2: widget.country,
    //                             ),
    //                             detailRow(
    //                               title1: 'Description : ',
    //                               value1: widget.desc,
    //                               title2: 'Capacity : ',
    //                               value2: widget.capacity == null
    //                                   ? ''
    //                                   : widget.capacity.toString(),
    //                             ),
    //                             detailRow(
    //                               title1: 'Address : ',
    //                               value1: widget.address,
    //                             ),
    //                           ],
    //                         );
    //                       },
    //                       childCount: 1,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ]);
    //       },
    //     ),
    //   ),
    // );
  }
}

class detailRow extends StatelessWidget {
  final String? title1, title2, value1, value2;
  const detailRow(
      {Key? key, this.title1, this.value1, this.title2, this.value2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: RichText(
              maxLines: 4,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  text: title1,
                  style: TextStyle(
                      color: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: value1,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: blackColor))
                  ]),
            ),
          ),
          RichText(
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            text: TextSpan(
                text: title2,
                style: TextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: value2,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: blackColor))
                ]),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
