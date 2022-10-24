import 'dart:convert';
import 'package:community_new/UI%20SCREENS/Events_new/usereventDetail.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/chat.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/UserEvent.dart';
import 'package:community_new/models/event.dart';
import 'package:community_new/widgets/genericAppBar.dart';
import 'package:community_new/widgets/genericDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../api_services/api_services.dart';
import '../../provider/FavouriteItemProvider.dart';
import '../masjid_screens/Masjids.dart';
import '../notifications/notification_screen.dart';
import 'EventEditNew.dart';

class Events extends StatefulWidget {
  Events({
    Key? key,
  }) : super(key: key);

  @override
  EventsState createState() => EventsState();
}

class EventsState extends State<Events> with SingleTickerProviderStateMixin {
  final ApiServices apiService = ApiServices();
  Event? event;
  List<Event> events = [];
  List<Event> copiedListEvents = [];
  List<UserEvents>? selectedendUserEvents = [];

  List<Event> allEventsForUser = [];

  _allEventsForUser() {
    ApiServices.fetch('communityevent', actionName: null, param1: null)
        .then((response) {
      setState(() {
        try {
          errorController.text = "";
          Iterable list = json.decode(response.body);
          //print ( response.body );
          allEventsForUser =
              list.map((model) => Event.fromJson(model)).toList();
          // print(masjids[0].Id);
          //  errorController.text="test";
        } on Exception catch (e) {
          errorController.text = "wow : " + e.toString();
        }
      });
    });
  }

  _getEvent() async {
    String currentRole = //'admin';
        await prefs.getString('role_name');
    int currentUserId = await prefs.get('userId');
    // ApiServices.fetch('communityevent',
    //     actionName:currentRole == 'admin'? null:'getcommunityeventforuserid',
    //     param1:currentRole == 'admin'? null: currentUserId.toString()
    // ).
    // then((response) {
    //   setState(() {
    //     Iterable list = json.decode(response.body);
    //    // print(response.body);
    //     events = list.map((model) => Event.fromJson(model)).toList();
    //   });
    // });

    if (currentRole == 'SuperAdmin') {
      ApiServices.fetch('communityevent', actionName: null, param1: null)
          .then((response) {
        setState(() {
          try {
            errorController.text = "";
            Iterable list = json.decode(response.body);
            //print ( response.body );
            events = list.map((model) => Event.fromJson(model)).toList();
            // print(masjids[0].Id);
            //  errorController.text="test";
          } on Exception catch (e) {
            errorController.text = "wow : " + e.toString();
          }
        });
      });
    } else if (currentRole == 'OrgAdmin') {
      ApiServices.fetch('communityevent',
              actionName: 'getfororgadmin', param1: currentUserId.toString())
          .then((response) {
        setState(() {
          try {
            errorController.text = "";
            Iterable list = json.decode(response.body);
            //print ( response.body );
            events = list.map((model) => Event.fromJson(model)).toList();
            // print(masjids[0].Id);
            //  errorController.text="test";
          } on Exception catch (e) {
            errorController.text = "wow : " + e.toString();
          }
        });
      });
    } else if (currentRole == 'MasjidAdmin') {
      ApiServices.fetch('communityevent',
              actionName: 'getformasjidadmin',
              //'GetEventsForEndUserMasjidsEvents',
              //'GetEventsForUserMasjids',
              param1: currentUserId.toString())
          .then((response) {
        setState(() {
          try {
            errorController.text = "";
            Iterable list = json.decode(response.body);
            //print ( response.body );
            events = list.map((model) => Event.fromJson(model)).toList();
            // print(masjids[0].Id);
            //  .text="test";
          } on Exception catch (e) {
            errorController.text = "wow : " + e.toString();
          }
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
            errorController.text = "";
            Iterable list = json.decode(response.body);
            //print ( response.body );
            events = list.map((model) => Event.fromJson(model)).toList();
            // print(masjids[0].Id);
            //  .text="test";
          } on Exception catch (e) {
            errorController.text = "wow : " + e.toString();
          }
        });
      });
    }
  }

  bool isSelected(int? p_Id) {
    if (selectedendUserEvents == null) return false;
    for (int i = 0; i < selectedendUserEvents!.length; i++)
      if (selectedendUserEvents?[i].event_Id == p_Id) return true;
    return false;
  }

  final _controller = TextEditingController();
  String? _searchText;
  bool isGrid = true;
  TabController? _tabController;
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

    _allEventsForUser();
    copiedListEvents = events;
    super.initState();
    _tabController =
        TabController(length: currentRole == 'User' ? 3 : 2, vsync: this);
    _tabController!.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  String currentRole = //'admin';
      prefs.getString('role_name');
  void _runFilter(String enteredKeyword) async {
    List<Event> results = [];
    if (enteredKeyword.isEmpty) {
      results = await events;
    } else {
      results = await events
          .where((event) =>
              event.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      copiedListEvents = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favouriteItemProvider = Provider.of<FavouriteItemProvider>(context);
    _getEvent();
    return DefaultTabController(
      length: currentRole == 'User' ? 3 : 2,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          drawer: currentRole == 'SuperAdmin'
              ? genericDrawerForSA()
              : currentRole == 'MasjidAdmin'
                  ? genericDrawerForMA()
                  : currentRole == 'User'
                      ? genericDrawerForUser()
                      : genericDrawerForOA(),
          floatingActionButton: currentRole == 'User' &&
                  _tabController!.index == 0
              ? FloatingActionButton(
                  backgroundColor: appColor,
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const EventEditnew(isNew: true, eventId: 0)));
                  },
                )
              : null,
          appBar: currentRole == 'User'
              ? PreferredSize(
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.all(0),

                            // fillColor: whiteColor,
                            // filled: true,
                            hintText: 'Search event by name',
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
                      isScrollable: true,
                      controller: _tabController,
                      tabs: [
                        // _tabController!.index==0? Container(
                        //    decoration: BoxDecoration(
                        //        color:offWhite,//:appColor,
                        //        borderRadius: BorderRadius.circular(5)
                        //    ),
                        //    padding: EdgeInsets.all(12),
                        //    child:const Text("Attending",style: TextStyle(color: appColor),
                        //    ),
                        //  ):
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
                                  'All',
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
                                  'All',
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
                                  'Attending',
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
                                  'Attending',
                                  style: TextStyle(
                                    color: Color(0xff93573c),
                                  ),
                                ),
                              ),

                        _tabController!.index == 2
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
                                  'Hosting',
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
                                  'Hosting',
                                  style: TextStyle(
                                    color: Color(0xff93573c),
                                  ),
                                ),
                              ),
                        // Text(
                        //   "All",
                        //   style: TextStyle(fontSize: 16),
                        // ),

                        // Text(
                        //   "Attending",
                        //   style: TextStyle(fontSize: 16),
                        // ),

                        // // _tabController!.index==1? Container(
                        // //           decoration: BoxDecoration(
                        // //               color:offWhite,
                        // //               borderRadius: BorderRadius.circular(5)
                        // //           ),
                        // //           padding: EdgeInsets.all(12),
                        // //           child: Text('Hosting',style: TextStyle(color: appColor),
                        // //           )):
                        // Text(
                        //   'Hosting',
                        //   style: TextStyle(fontSize: 16),
                        // ),
                      ],
                    ),
                  ),
                )
              : PreferredSize(
                  preferredSize: Size.fromHeight(95),
                  child: genericAppBarForSA(
                    appbarTitle: 'Events',
                    bottom: TabBar(
                      labelColor: appColor,
                      unselectedLabelColor: Colors.grey, //offWhite,
                      padding: EdgeInsets.only(top: 15),
                      indicatorSize: TabBarIndicatorSize.label,

                      indicatorColor: whiteColor,
                      controller: _tabController,
                      tabs: [
                        // _tabController!.index==0? Container(
                        //    decoration: BoxDecoration(
                        //        color:offWhite,//:appColor,
                        //        borderRadius: BorderRadius.circular(5)
                        //    ),
                        //    padding: EdgeInsets.all(12),
                        //    child:const Text("Attending",style: TextStyle(color: appColor),
                        //    ),
                        //  ):
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
                                  'Attending',
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
                                  'Attending',
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
                                  'Hosting',
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
                                  'Hosting',
                                  style: TextStyle(
                                    color: Color(0xff93573c),
                                  ),
                                ),
                              ),

                        // Text(
                        //   "Attending",
                        //   style: TextStyle(fontSize: 16),
                        // ),

                        // // _tabController!.index==1? Container(
                        // //           decoration: BoxDecoration(
                        // //               color:offWhite,
                        // //               borderRadius: BorderRadius.circular(5)
                        // //           ),
                        // //           padding: EdgeInsets.all(12),
                        // //           child: Text('Hosting',style: TextStyle(color: appColor),
                        // //           )):
                        // Text(
                        //   'Hosting',
                        //   style: TextStyle(fontSize: 16),
                        // ),
                      ],
                    ),
                  )),
          backgroundColor: whiteColor, //appColor,
          body: Container(
            color: whiteColor, //backgroundColor,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: currentRole == 'User'
                        ? [
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
                                //             hintText: 'Search event by name',
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
                                        : Icon(Icons.grid_on_outlined),
                                  ),
                                ),
                                allEventsForUser.isEmpty
                                    ? const Center(child: Text('Empty'))
                                    : isGrid
                                        ?
                                        // Expanded(
                                        //   child: ListView.builder(
                                        //       itemCount: copiedListEvents.isEmpty?events.length:copiedListEvents.length,
                                        //       itemBuilder: (context, i) {
                                        //         return Padding(
                                        //           padding: const EdgeInsets.only(
                                        //               left: 8.0, right: 8, top: 5),
                                        //           child: Card(
                                        //               shape: RoundedRectangleBorder(
                                        //                   borderRadius: BorderRadius.circular(8)
                                        //               ),
                                        //               color: Colors.white,
                                        //               elevation: 10.0,
                                        //               child: Column(
                                        //                 children: [
                                        //                   ListTile(
                                        //                     leading:const CircleAvatar(
                                        //                       radius: 25,
                                        //                       backgroundImage: AssetImage('assets/darussalam.jpg'),
                                        //                     ),
                                        //                     subtitle: Text(
                                        //                       events[i]
                                        //                           .description
                                        //                           .toString() +
                                        //                           '\n',
                                        //                       textAlign:
                                        //                       TextAlign.justify,
                                        //                     ),
                                        //                     onTap: null,
                                        //                     title: Row(
                                        //                       children: [
                                        //                         copiedListEvents.isEmpty?Text(events[i].name.toString(),
                                        //                           overflow: TextOverflow.ellipsis,)
                                        //                             :Text(copiedListEvents[i].name.toString(),
                                        //                             overflow: TextOverflow.ellipsis
                                        //                         ),
                                        //                         const Spacer(),
                                        //                         currentRole=='User'?
                                        //                         IconButton(
                                        //                           onPressed: () async{
                                        //                             if(favouriteItemProvider.selectedItem.contains(i))
                                        //                             {
                                        //                               favouriteItemProvider.removeItem(i);
                                        //                               ScaffoldMessenger.of(context)
                                        //                                   .showSnackBar( SnackBar(
                                        //                                   content:  Text(events[i].name.toString()
                                        //                                       +" Deleted Successfully")));
                                        //                             }else{
                                        //                               favouriteItemProvider.addItem(i);
                                        //                               ScaffoldMessenger.of(context)
                                        //                                   .showSnackBar(  SnackBar(
                                        //                                 content:Text(events[i].name.toString()
                                        //                                     +" added "),));
                                        //                             }
                                        //
                                        //                           },
                                        //                           icon: Icon(
                                        //                             favouriteItemProvider.selectedItem.contains(i)
                                        //                                 ||isSelected(events[i].Id)
                                        //                                 ? Icons.favorite
                                        //                                 : Icons.favorite_border,
                                        //                             color: Colors.red,
                                        //                           ),
                                        //                         )
                                        //                             :ElevatedButton(
                                        //                             style:
                                        //                             crudButtonStyle,
                                        //                             onPressed: () {
                                        //                               Navigator.push(
                                        //                                   context,
                                        //                                   MaterialPageRoute(
                                        //                                       builder: (context) => EventEditnew(
                                        //                                           isNew:
                                        //                                           false,
                                        //                                           eventId:
                                        //                                           events[i].Id)));
                                        //                             },
                                        //                             child: const FaIcon(FontAwesomeIcons.edit,
                                        //                               color: Color(0xFF8BBAF0),size: size,)),
                                        //                         currentRole=='User'?
                                        //                         Container()
                                        //                             :
                                        //                         ElevatedButton(
                                        //                             style:
                                        //                             crudButtonStyle,
                                        //                             onPressed:
                                        //                                 () async {
                                        //                               await apiService.deleteFn(
                                        //                                   int.parse(events[
                                        //                                   i]
                                        //                                       .Id
                                        //                                       .toString()),
                                        //                                   'communityevent');
                                        //                               ScaffoldMessenger
                                        //                                   .of(
                                        //                                   context)
                                        //                                   .showSnackBar(
                                        //                                   const SnackBar(
                                        //                                       content:
                                        //                                       Text("Event Deleted Successfully")));
                                        //                               Navigator.push(
                                        //                                   context,
                                        //                                   MaterialPageRoute(
                                        //                                     builder:
                                        //                                         (context) =>
                                        //                                         Events(),
                                        //                                   ));
                                        //                             },
                                        //                             child: deleteIcon),
                                        //                       ],
                                        //                     ),
                                        //                   ),
                                        //                 ],
                                        //               )),
                                        //         );
                                        //       }),
                                        // )

                                        Expanded(
                                            child: ListView.builder(
                                                itemCount: copiedListEvents
                                                        .isEmpty
                                                    ? allEventsForUser.length
                                                    : copiedListEvents.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              UsereventDetails(
                                                            eventName:
                                                                allEventsForUser[
                                                                        index]
                                                                    .name
                                                                    .toString(),
                                                            discription:
                                                                allEventsForUser[
                                                                        index]
                                                                    .description
                                                                    .toString(),
                                                            imageUrlEvent:
                                                                'assets/darussalam.jpg',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        color: whiteColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 150,
                                                                height: 80,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/darussalam.jpg'),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  copiedListEvents
                                                                          .isEmpty
                                                                      ? Text(
                                                                          allEventsForUser[index]
                                                                              .name
                                                                              .toString(),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline1!
                                                                              .copyWith(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                        )
                                                                      : Text(
                                                                          copiedListEvents[index]
                                                                              .name
                                                                              .toString(),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline1!
                                                                              .copyWith(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                        ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  copiedListEvents
                                                                          .isEmpty
                                                                      ? Text(
                                                                          allEventsForUser[index].fullName.toString() +
                                                                              '\n',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText1!
                                                                              .copyWith(
                                                                                fontSize: 12,
                                                                              ),
                                                                        )
                                                                      : Text(
                                                                          copiedListEvents[index].fullName.toString() +
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
                                                          Positioned(
                                                              right: 0,
                                                              child: Row(
                                                                children: [
                                                                  currentRole ==
                                                                          'User'
                                                                      ? IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (favouriteItemProvider.selectedItem.contains(index)) {
                                                                              favouriteItemProvider.removeItem(index);
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(allEventsForUser[index].name.toString() + " Deleted Successfully")));
                                                                            } else {
                                                                              favouriteItemProvider.addItem(index);
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                content: Text(allEventsForUser[index].name.toString() + " added "),
                                                                              ));
                                                                            }
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            favouriteItemProvider.selectedItem.contains(index) || isSelected(allEventsForUser[index].Id)
                                                                                ? Icons.favorite
                                                                                : Icons.favorite_border,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        )
                                                                      : PopupMenuButton(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          itemBuilder:
                                                                              (context) {
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
                                                                          onSelected:
                                                                              (value) {
                                                                            if (value ==
                                                                                'edit') {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => EventEditnew(
                                                                                            isNew: false,
                                                                                            eventId: allEventsForUser[index].Id,
                                                                                          )));
                                                                            } else if (value ==
                                                                                'delete') {
                                                                              // await
                                                                              apiService.deleteFn(int.parse(events[index].Id.toString()), 'communityevent');
                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Deleted Successfully")));
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => Events(),
                                                                                  ));
                                                                            }
                                                                          },
                                                                        ),
                                                                  // ElevatedButton(
                                                                  //     style:
                                                                  //     crudButtonStyle,
                                                                  //     onPressed: () {
                                                                  //       Navigator.push(
                                                                  //           context,
                                                                  //           MaterialPageRoute(
                                                                  //               builder: (context) => EventEditnew(
                                                                  //                   isNew:
                                                                  //                   false,
                                                                  //                   eventId:
                                                                  //                   events[index].Id)));
                                                                  //     },
                                                                  //     child: const FaIcon(FontAwesomeIcons.edit,
                                                                  //       color: Color(0xFF8BBAF0),size: size,)),
                                                                  // currentRole=='User'?
                                                                  // Container()
                                                                  //     :
                                                                  // ElevatedButton(
                                                                  //     style:
                                                                  //     crudButtonStyle,
                                                                  //     onPressed:
                                                                  //         () async {
                                                                  //       await apiService.deleteFn(
                                                                  //           int.parse(events[
                                                                  //           index]
                                                                  //               .Id
                                                                  //               .toString()),
                                                                  //           'communityevent');
                                                                  //       ScaffoldMessenger
                                                                  //           .of(
                                                                  //           context)
                                                                  //           .showSnackBar(
                                                                  //           const SnackBar(
                                                                  //               content:
                                                                  //               Text("Event Deleted Successfully")));
                                                                  //       Navigator.push(
                                                                  //           context,
                                                                  //           MaterialPageRoute(
                                                                  //             builder:
                                                                  //                 (context) =>
                                                                  //                 Events(),
                                                                  //           ));
                                                                  //     },
                                                                  //     child: deleteIcon),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  );
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
                                        : Expanded(
                                            child: GridView.builder(
                                                padding: EdgeInsets.all(4),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3),
                                                itemCount: copiedListEvents
                                                        .isEmpty
                                                    ? allEventsForUser.length
                                                    : copiedListEvents.length,
                                                itemBuilder: (_, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3.0,
                                                            right: 3),
                                                    child: Card(
                                                        key: ValueKey(
                                                            allEventsForUser[
                                                                    index]
                                                                .Id),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        color: Colors.white,
                                                        elevation: 2.0,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4.0,
                                                                      right: 4),
                                                              child: Row(
                                                                children: [
                                                                  const Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                        ''),
                                                                  ),
                                                                  const Expanded(
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius:
                                                                          25,
                                                                      backgroundImage:
                                                                          AssetImage(
                                                                              'assets/darussalam.jpg'),
                                                                    ),
                                                                  ),
                                                                  // widthSizedBox8,
                                                                  // currentRole ==
                                                                  //         'User'
                                                                  //     ? Expanded(
                                                                  //         child:
                                                                  //             Padding(
                                                                  //           padding: const EdgeInsets
                                                                  //                   .only(
                                                                  //               bottom:
                                                                  //                   10),
                                                                  //           child:
                                                                  //               IconButton(
                                                                  //             onPressed:
                                                                  //                 () async {
                                                                  //               int currentUserId =
                                                                  //                   await prefs.get('userId');
                                                                  //               if (favouriteItemProvider
                                                                  //                   .selectedItem
                                                                  //                   .contains(index)) {
                                                                  //                 favouriteItemProvider.removeItem(index);
                                                                  //                 await apiService.deleteendUserMaterial(
                                                                  //                     'enduserevents',
                                                                  //                     currentUserId,
                                                                  //                     events[index].Id);
                                                                  //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  //                     duration: Duration(seconds: 1),
                                                                  //                     content: Text(events[index].name.toString() + " Deleted Successfully")));
                                                                  //               } else {
                                                                  //                 favouriteItemProvider.addItem(index);
                                                                  //                 var postEndUserEvent =
                                                                  //                     UserEvents(user_Id: currentUserId, event_Id: events[index].Id);
                                                                  //                 await ApiServices.postendUserEvents(postEndUserEvent);
                                                                  //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  //                   duration: Duration(seconds: 1),
                                                                  //                   content: Text(events[index].name.toString() + " added "),
                                                                  //                 ));
                                                                  //               }
                                                                  //             },
                                                                  //             icon:
                                                                  //                 Icon(
                                                                  //               favouriteItemProvider.selectedItem.contains(index) || isSelected(events[index].Id)
                                                                  //                   ? Icons.favorite
                                                                  //                   : Icons.favorite_border,
                                                                  //               color:
                                                                  //                   Colors.red,
                                                                  //             ),
                                                                  //           ),
                                                                  //         ),
                                                                  //       )
                                                                  //     : Expanded(
                                                                  //         child:
                                                                  //             PopupMenuButton(
                                                                  //           position:
                                                                  //               PopupMenuPosition
                                                                  //                   .under,
                                                                  //           shape:
                                                                  //               RoundedRectangleBorder(
                                                                  //             borderRadius:
                                                                  //                 BorderRadius.circular(10),
                                                                  //           ),
                                                                  //           itemBuilder:
                                                                  //               (context) {
                                                                  //             return [
                                                                  //               _buildPopupMenuItem(
                                                                  //                   //'Edit',
                                                                  //                   'assets/edit.png',
                                                                  //                   //Icons.edit,
                                                                  //                   'edit'),
                                                                  //               _buildPopupMenuItem(
                                                                  //                   //'Delete',
                                                                  //                   'assets/delete.png',
                                                                  //                   //Icons.delete_outline,
                                                                  //                   'delete'),
                                                                  //             ];
                                                                  //           },
                                                                  //           onSelected:
                                                                  //               (value) {
                                                                  //             if (value ==
                                                                  //                 'edit') {
                                                                  //               Navigator.push(
                                                                  //                   context,
                                                                  //                   MaterialPageRoute(
                                                                  //                       builder: (context) => EventEditnew(
                                                                  //                             isNew: false,
                                                                  //                             eventId: events[index].Id,
                                                                  //                           )));
                                                                  //             } else if (value ==
                                                                  //                 'delete') {
                                                                  //               // await
                                                                  //               apiService.deleteFn(
                                                                  //                   int.parse(events[index].Id.toString()),
                                                                  //                   'communityevent');
                                                                  //               ScaffoldMessenger.of(context)
                                                                  //                   .showSnackBar(const SnackBar(content: Text("Event Deleted Successfully")));
                                                                  //               Navigator.push(
                                                                  //                   context,
                                                                  //                   MaterialPageRoute(
                                                                  //                     builder: (context) => Events(),
                                                                  //                   ));
                                                                  //             }
                                                                  //           },
                                                                  //         ),
                                                                  //       ),
                                                                ],
                                                              ),
                                                            ),
                                                            midPadding2,
                                                            copiedListEvents
                                                                    .isEmpty
                                                                ? Text(
                                                                    allEventsForUser[
                                                                            index]
                                                                        .name
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  )
                                                                : Text(
                                                                    copiedListEvents[
                                                                            index]
                                                                        .name
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                            midPadding2,
                                                            Text(
                                                                maxLines: 1,
                                                                allEventsForUser[
                                                                        index]
                                                                    .description
                                                                    .toString(),
                                                                softWrap: false,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ],
                                                        )),
                                                  );
                                                }),
                                          )
                              ],
                            ),
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
                                //             hintText: 'Search event by name',
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
                                        : Icon(Icons.grid_on_outlined),
                                  ),
                                ),
                                events.isEmpty
                                    ? const Center(child: Text('Empty'))
                                    : isGrid
                                        ?
                                        // Expanded(
                                        //   child: ListView.builder(
                                        //       itemCount: copiedListEvents.isEmpty?events.length:copiedListEvents.length,
                                        //       itemBuilder: (context, i) {
                                        //         return Padding(
                                        //           padding: const EdgeInsets.only(
                                        //               left: 8.0, right: 8, top: 5),
                                        //           child: Card(
                                        //               shape: RoundedRectangleBorder(
                                        //                   borderRadius: BorderRadius.circular(8)
                                        //               ),
                                        //               color: Colors.white,
                                        //               elevation: 10.0,
                                        //               child: Column(
                                        //                 children: [
                                        //                   ListTile(
                                        //                     leading:const CircleAvatar(
                                        //                       radius: 25,
                                        //                       backgroundImage: AssetImage('assets/darussalam.jpg'),
                                        //                     ),
                                        //                     subtitle: Text(
                                        //                       events[i]
                                        //                           .description
                                        //                           .toString() +
                                        //                           '\n',
                                        //                       textAlign:
                                        //                       TextAlign.justify,
                                        //                     ),
                                        //                     onTap: null,
                                        //                     title: Row(
                                        //                       children: [
                                        //                         copiedListEvents.isEmpty?Text(events[i].name.toString(),
                                        //                           overflow: TextOverflow.ellipsis,)
                                        //                             :Text(copiedListEvents[i].name.toString(),
                                        //                             overflow: TextOverflow.ellipsis
                                        //                         ),
                                        //                         const Spacer(),
                                        //                         currentRole=='User'?
                                        //                         IconButton(
                                        //                           onPressed: () async{
                                        //                             if(favouriteItemProvider.selectedItem.contains(i))
                                        //                             {
                                        //                               favouriteItemProvider.removeItem(i);
                                        //                               ScaffoldMessenger.of(context)
                                        //                                   .showSnackBar( SnackBar(
                                        //                                   content:  Text(events[i].name.toString()
                                        //                                       +" Deleted Successfully")));
                                        //                             }else{
                                        //                               favouriteItemProvider.addItem(i);
                                        //                               ScaffoldMessenger.of(context)
                                        //                                   .showSnackBar(  SnackBar(
                                        //                                 content:Text(events[i].name.toString()
                                        //                                     +" added "),));
                                        //                             }
                                        //
                                        //                           },
                                        //                           icon: Icon(
                                        //                             favouriteItemProvider.selectedItem.contains(i)
                                        //                                 ||isSelected(events[i].Id)
                                        //                                 ? Icons.favorite
                                        //                                 : Icons.favorite_border,
                                        //                             color: Colors.red,
                                        //                           ),
                                        //                         )
                                        //                             :ElevatedButton(
                                        //                             style:
                                        //                             crudButtonStyle,
                                        //                             onPressed: () {
                                        //                               Navigator.push(
                                        //                                   context,
                                        //                                   MaterialPageRoute(
                                        //                                       builder: (context) => EventEditnew(
                                        //                                           isNew:
                                        //                                           false,
                                        //                                           eventId:
                                        //                                           events[i].Id)));
                                        //                             },
                                        //                             child: const FaIcon(FontAwesomeIcons.edit,
                                        //                               color: Color(0xFF8BBAF0),size: size,)),
                                        //                         currentRole=='User'?
                                        //                         Container()
                                        //                             :
                                        //                         ElevatedButton(
                                        //                             style:
                                        //                             crudButtonStyle,
                                        //                             onPressed:
                                        //                                 () async {
                                        //                               await apiService.deleteFn(
                                        //                                   int.parse(events[
                                        //                                   i]
                                        //                                       .Id
                                        //                                       .toString()),
                                        //                                   'communityevent');
                                        //                               ScaffoldMessenger
                                        //                                   .of(
                                        //                                   context)
                                        //                                   .showSnackBar(
                                        //                                   const SnackBar(
                                        //                                       content:
                                        //                                       Text("Event Deleted Successfully")));
                                        //                               Navigator.push(
                                        //                                   context,
                                        //                                   MaterialPageRoute(
                                        //                                     builder:
                                        //                                         (context) =>
                                        //                                         Events(),
                                        //                                   ));
                                        //                             },
                                        //                             child: deleteIcon),
                                        //                       ],
                                        //                     ),
                                        //                   ),
                                        //                 ],
                                        //               )),
                                        //         );
                                        //       }),
                                        // )

                                        Expanded(
                                            child: ListView.builder(
                                                itemCount: copiedListEvents
                                                        .isEmpty
                                                    ? events.length
                                                    : copiedListEvents.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              UsereventDetails(
                                                            eventName: copiedListEvents
                                                                    .isEmpty
                                                                ? events[index]
                                                                    .name
                                                                    .toString()
                                                                : copiedListEvents[
                                                                        index]
                                                                    .name
                                                                    .toString(),
                                                            discription: copiedListEvents
                                                                    .isEmpty
                                                                ? events[index]
                                                                    .description
                                                                    .toString()
                                                                : copiedListEvents[
                                                                        index]
                                                                    .description
                                                                    .toString(),
                                                            imageUrlEvent:
                                                                'assets/darussalam.jpg',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        color: whiteColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 150,
                                                                height: 80,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/darussalam.jpg'),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  copiedListEvents
                                                                          .isEmpty
                                                                      ? Text(
                                                                          events[index]
                                                                              .name
                                                                              .toString(),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline1!
                                                                              .copyWith(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                        )
                                                                      : Text(
                                                                          copiedListEvents[index]
                                                                              .name
                                                                              .toString(),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline1!
                                                                              .copyWith(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                        ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  copiedListEvents
                                                                          .isEmpty
                                                                      ? Text(
                                                                          events[index].fullName.toString() +
                                                                              '\n',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText1!
                                                                              .copyWith(
                                                                                fontSize: 12,
                                                                              ),
                                                                        )
                                                                      : Text(
                                                                          copiedListEvents[index].fullName.toString() +
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
                                                          Positioned(
                                                              right: 0,
                                                              child: Row(
                                                                children: [
                                                                  currentRole ==
                                                                          'User'
                                                                      ? IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (favouriteItemProvider.selectedItem.contains(index)) {
                                                                              favouriteItemProvider.removeItem(index);
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(events[index].name.toString() + " Deleted Successfully")));
                                                                            } else {
                                                                              favouriteItemProvider.addItem(index);
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                content: Text(events[index].name.toString() + " added "),
                                                                              ));
                                                                            }
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            favouriteItemProvider.selectedItem.contains(index) || isSelected(events[index].Id)
                                                                                ? Icons.favorite
                                                                                : Icons.favorite_border,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        )
                                                                      : PopupMenuButton(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          itemBuilder:
                                                                              (context) {
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
                                                                          onSelected:
                                                                              (value) {
                                                                            if (value ==
                                                                                'edit') {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => EventEditnew(
                                                                                            isNew: false,
                                                                                            eventId: events[index].Id,
                                                                                          )));
                                                                            } else if (value ==
                                                                                'delete') {
                                                                              // await
                                                                              apiService.deleteFn(int.parse(events[index].Id.toString()), 'communityevent');
                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Deleted Successfully")));
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => Events(),
                                                                                  ));
                                                                            }
                                                                          },
                                                                        ),
                                                                  // ElevatedButton(
                                                                  //     style:
                                                                  //     crudButtonStyle,
                                                                  //     onPressed: () {
                                                                  //       Navigator.push(
                                                                  //           context,
                                                                  //           MaterialPageRoute(
                                                                  //               builder: (context) => EventEditnew(
                                                                  //                   isNew:
                                                                  //                   false,
                                                                  //                   eventId:
                                                                  //                   events[index].Id)));
                                                                  //     },
                                                                  //     child: const FaIcon(FontAwesomeIcons.edit,
                                                                  //       color: Color(0xFF8BBAF0),size: size,)),
                                                                  // currentRole=='User'?
                                                                  // Container()
                                                                  //     :
                                                                  // ElevatedButton(
                                                                  //     style:
                                                                  //     crudButtonStyle,
                                                                  //     onPressed:
                                                                  //         () async {
                                                                  //       await apiService.deleteFn(
                                                                  //           int.parse(events[
                                                                  //           index]
                                                                  //               .Id
                                                                  //               .toString()),
                                                                  //           'communityevent');
                                                                  //       ScaffoldMessenger
                                                                  //           .of(
                                                                  //           context)
                                                                  //           .showSnackBar(
                                                                  //           const SnackBar(
                                                                  //               content:
                                                                  //               Text("Event Deleted Successfully")));
                                                                  //       Navigator.push(
                                                                  //           context,
                                                                  //           MaterialPageRoute(
                                                                  //             builder:
                                                                  //                 (context) =>
                                                                  //                 Events(),
                                                                  //           ));
                                                                  //     },
                                                                  //     child: deleteIcon),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  );
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
                                        : Expanded(
                                            child: GridView.builder(
                                                padding: EdgeInsets.all(4),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3),
                                                itemCount: copiedListEvents
                                                        .isEmpty
                                                    ? events.length
                                                    : copiedListEvents.length,
                                                itemBuilder: (_, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3.0,
                                                            right: 3),
                                                    child: Card(
                                                        key: ValueKey(
                                                            events[index].Id),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        color: Colors.white,
                                                        elevation: 2.0,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4.0,
                                                                      right: 4),
                                                              child: Row(
                                                                children: [
                                                                  const Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                        ''),
                                                                  ),
                                                                  const Expanded(
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius:
                                                                          25,
                                                                      backgroundImage:
                                                                          AssetImage(
                                                                              'assets/darussalam.jpg'),
                                                                    ),
                                                                  ),
                                                                  widthSizedBox8,
                                                                  currentRole ==
                                                                          'User'
                                                                      ? Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 10),
                                                                            child:
                                                                                IconButton(
                                                                              onPressed: () async {
                                                                                int currentUserId = await prefs.get('userId');
                                                                                if (favouriteItemProvider.selectedItem.contains(index)) {
                                                                                  favouriteItemProvider.removeItem(index);
                                                                                  await apiService.deleteendUserMaterial('enduserevents', currentUserId, events[index].Id);
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 1), content: Text(events[index].name.toString() + " Deleted Successfully")));
                                                                                } else {
                                                                                  favouriteItemProvider.addItem(index);
                                                                                  var postEndUserEvent = UserEvents(user_Id: currentUserId, event_Id: events[index].Id);
                                                                                  await ApiServices.postendUserEvents(postEndUserEvent);
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                    duration: Duration(seconds: 1),
                                                                                    content: Text(events[index].name.toString() + " added "),
                                                                                  ));
                                                                                }
                                                                              },
                                                                              icon: Icon(
                                                                                favouriteItemProvider.selectedItem.contains(index) || isSelected(events[index].Id) ? Icons.favorite : Icons.favorite_border,
                                                                                color: Colors.red,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          child:
                                                                              PopupMenuButton(
                                                                            position:
                                                                                PopupMenuPosition.under,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            itemBuilder:
                                                                                (context) {
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
                                                                            onSelected:
                                                                                (value) {
                                                                              if (value == 'edit') {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => EventEditnew(
                                                                                              isNew: false,
                                                                                              eventId: events[index].Id,
                                                                                            )));
                                                                              } else if (value == 'delete') {
                                                                                // await
                                                                                apiService.deleteFn(int.parse(events[index].Id.toString()), 'communityevent');
                                                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Deleted Successfully")));
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => Events(),
                                                                                    ));
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                            midPadding2,
                                                            copiedListEvents
                                                                    .isEmpty
                                                                ? Text(
                                                                    events[index]
                                                                        .name
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  )
                                                                : Text(
                                                                    copiedListEvents[
                                                                            index]
                                                                        .name
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                            midPadding2,
                                                            Text(
                                                                maxLines: 1,
                                                                events[index]
                                                                    .description
                                                                    .toString(),
                                                                softWrap: false,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ],
                                                        )),
                                                  );
                                                }),
                                          )
                              ],
                            ),
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
                                //           onChanged: (value) {
                                //             Provider.of<SearchEvents>(context, listen: false)
                                //                 .changeSearchString(value);
                                //           },
                                //           controller: _controller,
                                //           decoration: InputDecoration(
                                //
                                //             // fillColor: whiteColor,
                                //             // filled: true,
                                //             hintText: 'Search event by name',
                                //             prefixIconColor: appColor,
                                //             suffixIconColor: appColor,
                                //             prefixIcon: Icon(Icons.search),
                                //             suffixIcon: IconButton(
                                //               onPressed: () {},
                                //               icon: Icon(Icons.filter_alt_outlined),
                                //             ),
                                //             border: new OutlineInputBorder(
                                //               borderSide: BorderSide(color: appColor)
                                //             ),
                                //           ),
                                //           keyboardType: TextInputType.text,
                                //         ),
                                //       ),
                                //     ),
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
                                        : Icon(Icons.grid_on_outlined),
                                  ),
                                ),
                                // _tabController!.index==1?
                                // Align(
                                //   alignment: Alignment.topRight,
                                //   child: IconButton(
                                //     onPressed: (){
                                //       if(isGrid==true){
                                //         setState(() {
                                //           isGrid=false;
                                //         });}
                                //       else if(isGrid==false){
                                //         setState(() {
                                //           isGrid=true;
                                //         });
                                //       }
                                //     }, icon: isGrid==false?
                                //   Icon(Icons.grid_on_outlined)
                                //       : Icon(Icons.list),),
                                // ):Container(),
                                events.isEmpty
                                    ? const Center(child: Text('Empty'))
                                    :
                                    // isGrid?
                                    // Expanded(
                                    //   child: GridView.builder(
                                    //       gridDelegate:const
                                    //       SliverGridDelegateWithFixedCrossAxisCount
                                    //         (crossAxisCount: 3),
                                    //       itemCount: events.length,
                                    //       itemBuilder:  (_, index) {
                                    //         return Card(
                                    //             shape: RoundedRectangleBorder(
                                    //                 borderRadius: BorderRadius.circular(10)
                                    //             ),
                                    //             color: Colors.white,
                                    //             elevation: 10.0,
                                    //             child: Column(
                                    //               children: [
                                    //                 Row(
                                    //                   children: [
                                    //                     const Expanded(
                                    //                       flex:1,
                                    //                       child: Text(''),),
                                    //                     const Padding(
                                    //                       padding:  EdgeInsets.only(top: 8),
                                    //                       child:  CircleAvatar(
                                    //                         radius: 25,
                                    //                         backgroundImage: AssetImage('assets/darussalam.jpg'),
                                    //                       ),
                                    //                     ),
                                    //                     widthSizedBox8,
                                    //                     currentRole=='User'?Expanded(
                                    //                       child: Padding(
                                    //                         padding: const EdgeInsets.only(bottom:20.0),
                                    //                         child: IconButton(
                                    //                           onPressed: () async{
                                    //                             if(favouriteItemProvider.selectedItem.contains(index))
                                    //                             {
                                    //                               favouriteItemProvider.removeItem(index);
                                    //                               ScaffoldMessenger.of(context)
                                    //                                   .showSnackBar( SnackBar(
                                    //                                   content:  Text(events[index].name.toString()
                                    //                                       +" Deleted Successfully")));
                                    //                             }else{
                                    //                               favouriteItemProvider.addItem(index);
                                    //                               ScaffoldMessenger.of(context)
                                    //                                   .showSnackBar(  SnackBar(
                                    //                                 content:Text(events[index].name.toString()
                                    //                                     +" added "),));
                                    //                             }
                                    //
                                    //                           },
                                    //                           icon: Icon(
                                    //                             favouriteItemProvider.selectedItem.contains(index)
                                    //                             ||isSelected(events[index].Id)
                                    //                                 ? Icons.favorite
                                    //                                 : Icons.favorite_border,
                                    //                             color: Colors.red,
                                    //                           ),
                                    //                         ),
                                    //                       ),
                                    //                     ):Expanded(
                                    //                       child: Padding(
                                    //                         padding: const EdgeInsets.only(bottom:20.0),
                                    //                         child: PopupMenuButton(
                                    //                           shape: RoundedRectangleBorder(
                                    //                             borderRadius: BorderRadius.circular(10),
                                    //                           ),
                                    //                           itemBuilder: (context) {
                                    //                             return [
                                    //                               _buildPopupMenuItem(
                                    //                                 //'Edit',
                                    //                                   'assets/edit.png',
                                    //                                   //Icons.edit,
                                    //                                   'edit'),
                                    //                               _buildPopupMenuItem(
                                    //                                 //'Delete',
                                    //                                   'assets/delete.png',
                                    //                                   //Icons.delete_outline,
                                    //                                   'delete'),
                                    //                             ];
                                    //                           },
                                    //                           onSelected: (value) {
                                    //                             if(value=='edit'){
                                    //                               Navigator.push(
                                    //                                   context,
                                    //                                   MaterialPageRoute(
                                    //                                       builder: (context) => EventEditnew(
                                    //                                         isNew: false,
                                    //                                         eventId: events[index].Id,
                                    //                                       )));
                                    //                             }
                                    //                             else if(value=='delete'){
                                    //                               // await
                                    //                               apiService.deleteFn(int.parse(
                                    //                                   events[index].Id.toString()),'user');
                                    //                               ScaffoldMessenger.of(context)
                                    //                                   .showSnackBar(const SnackBar(
                                    //                                   content:  Text("User Deleted Successfully")));
                                    //                               Navigator.push(
                                    //                                   context,
                                    //                                   MaterialPageRoute(
                                    //                                     builder: (context) =>
                                    //                                         Events(),
                                    //                                   ));
                                    //                             }
                                    //                           },
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                   ],),
                                    //                 midPadding2,
                                    //                 Text(events[index].name.toString()),
                                    //                 midPadding2,
                                    //                 Text(events[index].description.toString(),softWrap: true,
                                    //                     overflow: TextOverflow.ellipsis),
                                    //
                                    //               ],
                                    //             ));
                                    //       }),
                                    // ):
                                    isGrid
                                        ? Expanded(
                                            child: ListView.builder(
                                                itemCount: copiedListEvents
                                                        .isEmpty
                                                    ? events.length
                                                    : copiedListEvents.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              UsereventDetails(
                                                            eventName:
                                                                events[index]
                                                                    .name
                                                                    .toString(),
                                                            discription:
                                                                events[index]
                                                                    .description
                                                                    .toString(),
                                                            imageUrlEvent:
                                                                'assets/darussalam.jpg',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        color: whiteColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 150,
                                                                height: 80,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/darussalam.jpg'),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  copiedListEvents
                                                                          .isEmpty
                                                                      ? Text(
                                                                          events[index]
                                                                              .name
                                                                              .toString(),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline1!
                                                                              .copyWith(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                        )
                                                                      : Text(
                                                                          copiedListEvents[index]
                                                                              .name
                                                                              .toString(),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline1!
                                                                              .copyWith(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                        ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  copiedListEvents
                                                                          .isEmpty
                                                                      ? Text(
                                                                          events[index].fullName.toString() +
                                                                              '\n',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText1!
                                                                              .copyWith(
                                                                                fontSize: 12,
                                                                              ),
                                                                        )
                                                                      : Text(
                                                                          copiedListEvents[index].fullName.toString() +
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
                                                          Positioned(
                                                              right: 0,
                                                              child: Row(
                                                                children: [
                                                                  currentRole ==
                                                                          'User'
                                                                      ? IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (favouriteItemProvider.selectedItem.contains(index)) {
                                                                              favouriteItemProvider.removeItem(index);
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(events[index].name.toString() + " Deleted Successfully")));
                                                                            } else {
                                                                              favouriteItemProvider.addItem(index);
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                content: Text(events[index].name.toString() + " added "),
                                                                              ));
                                                                            }
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            favouriteItemProvider.selectedItem.contains(index) || isSelected(events[index].Id)
                                                                                ? Icons.favorite
                                                                                : Icons.favorite_border,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        )
                                                                      : PopupMenuButton(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          itemBuilder:
                                                                              (context) {
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
                                                                          onSelected:
                                                                              (value) {
                                                                            if (value ==
                                                                                'edit') {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => EventEditnew(
                                                                                            isNew: false,
                                                                                            eventId: events[index].Id,
                                                                                          )));
                                                                            } else if (value ==
                                                                                'delete') {
                                                                              // await
                                                                              apiService.deleteFn(int.parse(events[index].Id.toString()), 'communityevent');
                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Deleted Successfully")));
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => Events(),
                                                                                  ));
                                                                            }
                                                                          },
                                                                        ),
                                                                  // ElevatedButton(
                                                                  //     style:
                                                                  //     crudButtonStyle,
                                                                  //     onPressed: () {
                                                                  //       Navigator.push(
                                                                  //           context,
                                                                  //           MaterialPageRoute(
                                                                  //               builder: (context) => EventEditnew(
                                                                  //                   isNew:
                                                                  //                   false,
                                                                  //                   eventId:
                                                                  //                   events[index].Id)));
                                                                  //     },
                                                                  //     child: const FaIcon(FontAwesomeIcons.edit,
                                                                  //       color: Color(0xFF8BBAF0),size: size,)),
                                                                  // currentRole=='User'?
                                                                  // Container()
                                                                  //     :
                                                                  // ElevatedButton(
                                                                  //     style:
                                                                  //     crudButtonStyle,
                                                                  //     onPressed:
                                                                  //         () async {
                                                                  //       await apiService.deleteFn(
                                                                  //           int.parse(events[
                                                                  //           index]
                                                                  //               .Id
                                                                  //               .toString()),
                                                                  //           'communityevent');
                                                                  //       ScaffoldMessenger
                                                                  //           .of(
                                                                  //           context)
                                                                  //           .showSnackBar(
                                                                  //           const SnackBar(
                                                                  //               content:
                                                                  //               Text("Event Deleted Successfully")));
                                                                  //       Navigator.push(
                                                                  //           context,
                                                                  //           MaterialPageRoute(
                                                                  //             builder:
                                                                  //                 (context) =>
                                                                  //                 Events(),
                                                                  //           ));
                                                                  //     },
                                                                  //     child: deleteIcon),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  );
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
                                        : Expanded(
                                            child: GridView.builder(
                                                padding: EdgeInsets.all(4),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3),
                                                itemCount: copiedListEvents
                                                        .isEmpty
                                                    ? events.length
                                                    : copiedListEvents.length,
                                                itemBuilder: (_, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 2.0,
                                                            right: 2,
                                                            bottom: 2),
                                                    child: Card(
                                                        key: ValueKey(
                                                            events[index].Id),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        color: Colors.white,
                                                        elevation: 2.0,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4.0,
                                                                      right: 4),
                                                              child: Row(
                                                                children: [
                                                                  const Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                        ''),
                                                                  ),
                                                                  const Expanded(
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius:
                                                                          25,
                                                                      backgroundImage:
                                                                          AssetImage(
                                                                              'assets/darussalam.jpg'),
                                                                    ),
                                                                  ),
                                                                  widthSizedBox8,
                                                                  currentRole ==
                                                                          'User'
                                                                      ? Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 10),
                                                                            child:
                                                                                IconButton(
                                                                              onPressed: () async {
                                                                                int currentUserId = await prefs.get('userId');
                                                                                if (favouriteItemProvider.selectedItem.contains(index)) {
                                                                                  favouriteItemProvider.removeItem(index);
                                                                                  await apiService.deleteendUserMaterial('enduserevents', currentUserId, events[index].Id);
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 1), content: Text(events[index].name.toString() + " Deleted Successfully")));
                                                                                } else {
                                                                                  favouriteItemProvider.addItem(index);
                                                                                  var postEndUserEvent = UserEvents(user_Id: currentUserId, event_Id: events[index].Id);
                                                                                  await ApiServices.postendUserEvents(postEndUserEvent);
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                    duration: Duration(seconds: 1),
                                                                                    content: Text(events[index].name.toString() + " added "),
                                                                                  ));
                                                                                }
                                                                              },
                                                                              icon: Icon(
                                                                                favouriteItemProvider.selectedItem.contains(index) || isSelected(events[index].Id) ? Icons.favorite : Icons.favorite_border,
                                                                                color: Colors.red,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          child:
                                                                              PopupMenuButton(
                                                                            position:
                                                                                PopupMenuPosition.under,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            itemBuilder:
                                                                                (context) {
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
                                                                            onSelected:
                                                                                (value) {
                                                                              if (value == 'edit') {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => EventEditnew(
                                                                                              isNew: false,
                                                                                              eventId: events[index].Id,
                                                                                            )));
                                                                              } else if (value == 'delete') {
                                                                                // await
                                                                                apiService.deleteFn(int.parse(events[index].Id.toString()), 'communityevent');
                                                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Deleted Successfully")));
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => Events(),
                                                                                    ));
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                            midPadding2,
                                                            copiedListEvents
                                                                    .isEmpty
                                                                ? Text(
                                                                    events[index]
                                                                        .name
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  )
                                                                : Text(
                                                                    copiedListEvents[
                                                                            index]
                                                                        .name
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                            midPadding2,
                                                            Text(
                                                                events[index]
                                                                    .description
                                                                    .toString(),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ],
                                                        )),
                                                  );
                                                }),
                                          )
                              ],
                            ),
                          ]
                        : [
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
                                //             hintText: 'Search event by name',
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
                                        : Icon(Icons.grid_on_outlined),
                                  ),
                                ),
                                events.isEmpty
                                    ? const Center(child: Text('Empty'))
                                    : isGrid
                                        ?
                                        // Expanded(
                                        //   child: ListView.builder(
                                        //       itemCount: copiedListEvents.isEmpty?events.length:copiedListEvents.length,
                                        //       itemBuilder: (context, i) {
                                        //         return Padding(
                                        //           padding: const EdgeInsets.only(
                                        //               left: 8.0, right: 8, top: 5),
                                        //           child: Card(
                                        //               shape: RoundedRectangleBorder(
                                        //                   borderRadius: BorderRadius.circular(8)
                                        //               ),
                                        //               color: Colors.white,
                                        //               elevation: 10.0,
                                        //               child: Column(
                                        //                 children: [
                                        //                   ListTile(
                                        //                     leading:const CircleAvatar(
                                        //                       radius: 25,
                                        //                       backgroundImage: AssetImage('assets/darussalam.jpg'),
                                        //                     ),
                                        //                     subtitle: Text(
                                        //                       events[i]
                                        //                           .description
                                        //                           .toString() +
                                        //                           '\n',
                                        //                       textAlign:
                                        //                       TextAlign.justify,
                                        //                     ),
                                        //                     onTap: null,
                                        //                     title: Row(
                                        //                       children: [
                                        //                         copiedListEvents.isEmpty?Text(events[i].name.toString(),
                                        //                           overflow: TextOverflow.ellipsis,)
                                        //                             :Text(copiedListEvents[i].name.toString(),
                                        //                             overflow: TextOverflow.ellipsis
                                        //                         ),
                                        //                         const Spacer(),
                                        //                         currentRole=='User'?
                                        //                         IconButton(
                                        //                           onPressed: () async{
                                        //                             if(favouriteItemProvider.selectedItem.contains(i))
                                        //                             {
                                        //                               favouriteItemProvider.removeItem(i);
                                        //                               ScaffoldMessenger.of(context)
                                        //                                   .showSnackBar( SnackBar(
                                        //                                   content:  Text(events[i].name.toString()
                                        //                                       +" Deleted Successfully")));
                                        //                             }else{
                                        //                               favouriteItemProvider.addItem(i);
                                        //                               ScaffoldMessenger.of(context)
                                        //                                   .showSnackBar(  SnackBar(
                                        //                                 content:Text(events[i].name.toString()
                                        //                                     +" added "),));
                                        //                             }
                                        //
                                        //                           },
                                        //                           icon: Icon(
                                        //                             favouriteItemProvider.selectedItem.contains(i)
                                        //                                 ||isSelected(events[i].Id)
                                        //                                 ? Icons.favorite
                                        //                                 : Icons.favorite_border,
                                        //                             color: Colors.red,
                                        //                           ),
                                        //                         )
                                        //                             :ElevatedButton(
                                        //                             style:
                                        //                             crudButtonStyle,
                                        //                             onPressed: () {
                                        //                               Navigator.push(
                                        //                                   context,
                                        //                                   MaterialPageRoute(
                                        //                                       builder: (context) => EventEditnew(
                                        //                                           isNew:
                                        //                                           false,
                                        //                                           eventId:
                                        //                                           events[i].Id)));
                                        //                             },
                                        //                             child: const FaIcon(FontAwesomeIcons.edit,
                                        //                               color: Color(0xFF8BBAF0),size: size,)),
                                        //                         currentRole=='User'?
                                        //                         Container()
                                        //                             :
                                        //                         ElevatedButton(
                                        //                             style:
                                        //                             crudButtonStyle,
                                        //                             onPressed:
                                        //                                 () async {
                                        //                               await apiService.deleteFn(
                                        //                                   int.parse(events[
                                        //                                   i]
                                        //                                       .Id
                                        //                                       .toString()),
                                        //                                   'communityevent');
                                        //                               ScaffoldMessenger
                                        //                                   .of(
                                        //                                   context)
                                        //                                   .showSnackBar(
                                        //                                   const SnackBar(
                                        //                                       content:
                                        //                                       Text("Event Deleted Successfully")));
                                        //                               Navigator.push(
                                        //                                   context,
                                        //                                   MaterialPageRoute(
                                        //                                     builder:
                                        //                                         (context) =>
                                        //                                         Events(),
                                        //                                   ));
                                        //                             },
                                        //                             child: deleteIcon),
                                        //                       ],
                                        //                     ),
                                        //                   ),
                                        //                 ],
                                        //               )),
                                        //         );
                                        //       }),
                                        // )

                                        Expanded(
                                            child: ListView.builder(
                                                itemCount: copiedListEvents
                                                        .isEmpty
                                                    ? events.length
                                                    : copiedListEvents.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              UsereventDetails(
                                                            eventName:
                                                                events[index]
                                                                    .name
                                                                    .toString(),
                                                            discription:
                                                                events[index]
                                                                    .description
                                                                    .toString(),
                                                            imageUrlEvent:
                                                                'assets/darussalam.jpg',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        color: whiteColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 150,
                                                                height: 80,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/darussalam.jpg'),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  copiedListEvents
                                                                          .isEmpty
                                                                      ? Text(
                                                                          events[index]
                                                                              .name
                                                                              .toString(),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline1!
                                                                              .copyWith(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                        )
                                                                      : Text(
                                                                          copiedListEvents[index]
                                                                              .name
                                                                              .toString(),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline1!
                                                                              .copyWith(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                        ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  copiedListEvents
                                                                          .isEmpty
                                                                      ? Text(
                                                                          events[index].fullName.toString() +
                                                                              '\n',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText1!
                                                                              .copyWith(
                                                                                fontSize: 12,
                                                                              ),
                                                                        )
                                                                      : Text(
                                                                          copiedListEvents[index].fullName.toString() +
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
                                                          Positioned(
                                                              right: 0,
                                                              child: Row(
                                                                children: [
                                                                  currentRole ==
                                                                          'User'
                                                                      ? IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (favouriteItemProvider.selectedItem.contains(index)) {
                                                                              favouriteItemProvider.removeItem(index);
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(events[index].name.toString() + " Deleted Successfully")));
                                                                            } else {
                                                                              favouriteItemProvider.addItem(index);
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                content: Text(events[index].name.toString() + " added "),
                                                                              ));
                                                                            }
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            favouriteItemProvider.selectedItem.contains(index) || isSelected(events[index].Id)
                                                                                ? Icons.favorite
                                                                                : Icons.favorite_border,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        )
                                                                      : PopupMenuButton(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          itemBuilder:
                                                                              (context) {
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
                                                                          onSelected:
                                                                              (value) {
                                                                            if (value ==
                                                                                'edit') {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => EventEditnew(
                                                                                            isNew: false,
                                                                                            eventId: events[index].Id,
                                                                                          )));
                                                                            } else if (value ==
                                                                                'delete') {
                                                                              // await
                                                                              apiService.deleteFn(int.parse(events[index].Id.toString()), 'communityevent');
                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Deleted Successfully")));
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => Events(),
                                                                                  ));
                                                                            }
                                                                          },
                                                                        ),
                                                                  // ElevatedButton(
                                                                  //     style:
                                                                  //     crudButtonStyle,
                                                                  //     onPressed: () {
                                                                  //       Navigator.push(
                                                                  //           context,
                                                                  //           MaterialPageRoute(
                                                                  //               builder: (context) => EventEditnew(
                                                                  //                   isNew:
                                                                  //                   false,
                                                                  //                   eventId:
                                                                  //                   events[index].Id)));
                                                                  //     },
                                                                  //     child: const FaIcon(FontAwesomeIcons.edit,
                                                                  //       color: Color(0xFF8BBAF0),size: size,)),
                                                                  // currentRole=='User'?
                                                                  // Container()
                                                                  //     :
                                                                  // ElevatedButton(
                                                                  //     style:
                                                                  //     crudButtonStyle,
                                                                  //     onPressed:
                                                                  //         () async {
                                                                  //       await apiService.deleteFn(
                                                                  //           int.parse(events[
                                                                  //           index]
                                                                  //               .Id
                                                                  //               .toString()),
                                                                  //           'communityevent');
                                                                  //       ScaffoldMessenger
                                                                  //           .of(
                                                                  //           context)
                                                                  //           .showSnackBar(
                                                                  //           const SnackBar(
                                                                  //               content:
                                                                  //               Text("Event Deleted Successfully")));
                                                                  //       Navigator.push(
                                                                  //           context,
                                                                  //           MaterialPageRoute(
                                                                  //             builder:
                                                                  //                 (context) =>
                                                                  //                 Events(),
                                                                  //           ));
                                                                  //     },
                                                                  //     child: deleteIcon),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  );
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
                                        : Expanded(
                                            child: GridView.builder(
                                                padding: EdgeInsets.all(4),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3),
                                                itemCount: copiedListEvents
                                                        .isEmpty
                                                    ? events.length
                                                    : copiedListEvents.length,
                                                itemBuilder: (_, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3.0,
                                                            right: 3),
                                                    child: Card(
                                                        key: ValueKey(
                                                            events[index].Id),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        color: Colors.white,
                                                        elevation: 2.0,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4.0,
                                                                      right: 4),
                                                              child: Row(
                                                                children: [
                                                                  const Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                        ''),
                                                                  ),
                                                                  const Expanded(
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius:
                                                                          25,
                                                                      backgroundImage:
                                                                          AssetImage(
                                                                              'assets/darussalam.jpg'),
                                                                    ),
                                                                  ),
                                                                  widthSizedBox8,
                                                                  currentRole ==
                                                                          'User'
                                                                      ? Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 10),
                                                                            child:
                                                                                IconButton(
                                                                              onPressed: () async {
                                                                                int currentUserId = await prefs.get('userId');
                                                                                if (favouriteItemProvider.selectedItem.contains(index)) {
                                                                                  favouriteItemProvider.removeItem(index);
                                                                                  await apiService.deleteendUserMaterial('enduserevents', currentUserId, events[index].Id);
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 1), content: Text(events[index].name.toString() + " Deleted Successfully")));
                                                                                } else {
                                                                                  favouriteItemProvider.addItem(index);
                                                                                  var postEndUserEvent = UserEvents(user_Id: currentUserId, event_Id: events[index].Id);
                                                                                  await ApiServices.postendUserEvents(postEndUserEvent);
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                    duration: Duration(seconds: 1),
                                                                                    content: Text(events[index].name.toString() + " added "),
                                                                                  ));
                                                                                }
                                                                              },
                                                                              icon: Icon(
                                                                                favouriteItemProvider.selectedItem.contains(index) || isSelected(events[index].Id) ? Icons.favorite : Icons.favorite_border,
                                                                                color: Colors.red,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          child:
                                                                              PopupMenuButton(
                                                                            position:
                                                                                PopupMenuPosition.under,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            itemBuilder:
                                                                                (context) {
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
                                                                            onSelected:
                                                                                (value) {
                                                                              if (value == 'edit') {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => EventEditnew(
                                                                                              isNew: false,
                                                                                              eventId: events[index].Id,
                                                                                            )));
                                                                              } else if (value == 'delete') {
                                                                                // await
                                                                                apiService.deleteFn(int.parse(events[index].Id.toString()), 'communityevent');
                                                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Deleted Successfully")));
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => Events(),
                                                                                    ));
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                            midPadding2,
                                                            copiedListEvents
                                                                    .isEmpty
                                                                ? Text(
                                                                    events[index]
                                                                        .name
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  )
                                                                : Text(
                                                                    copiedListEvents[
                                                                            index]
                                                                        .name
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                            midPadding2,
                                                            Text(
                                                                maxLines: 1,
                                                                events[index]
                                                                    .description
                                                                    .toString(),
                                                                softWrap: false,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ],
                                                        )),
                                                  );
                                                }),
                                          )
                              ],
                            ),
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
                                //           onChanged: (value) {
                                //             Provider.of<SearchEvents>(context, listen: false)
                                //                 .changeSearchString(value);
                                //           },
                                //           controller: _controller,
                                //           decoration: InputDecoration(
                                //
                                //             // fillColor: whiteColor,
                                //             // filled: true,
                                //             hintText: 'Search event by name',
                                //             prefixIconColor: appColor,
                                //             suffixIconColor: appColor,
                                //             prefixIcon: Icon(Icons.search),
                                //             suffixIcon: IconButton(
                                //               onPressed: () {},
                                //               icon: Icon(Icons.filter_alt_outlined),
                                //             ),
                                //             border: new OutlineInputBorder(
                                //               borderSide: BorderSide(color: appColor)
                                //             ),
                                //           ),
                                //           keyboardType: TextInputType.text,
                                //         ),
                                //       ),
                                //     ),
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
                                        : Icon(Icons.grid_on_outlined),
                                  ),
                                ),
                                // _tabController!.index==1?
                                // Align(
                                //   alignment: Alignment.topRight,
                                //   child: IconButton(
                                //     onPressed: (){
                                //       if(isGrid==true){
                                //         setState(() {
                                //           isGrid=false;
                                //         });}
                                //       else if(isGrid==false){
                                //         setState(() {
                                //           isGrid=true;
                                //         });
                                //       }
                                //     }, icon: isGrid==false?
                                //   Icon(Icons.grid_on_outlined)
                                //       : Icon(Icons.list),),
                                // ):Container(),
                                events.isEmpty
                                    ? const Center(child: Text('Empty'))
                                    :
                                    // isGrid?
                                    // Expanded(
                                    //   child: GridView.builder(
                                    //       gridDelegate:const
                                    //       SliverGridDelegateWithFixedCrossAxisCount
                                    //         (crossAxisCount: 3),
                                    //       itemCount: events.length,
                                    //       itemBuilder:  (_, index) {
                                    //         return Card(
                                    //             shape: RoundedRectangleBorder(
                                    //                 borderRadius: BorderRadius.circular(10)
                                    //             ),
                                    //             color: Colors.white,
                                    //             elevation: 10.0,
                                    //             child: Column(
                                    //               children: [
                                    //                 Row(
                                    //                   children: [
                                    //                     const Expanded(
                                    //                       flex:1,
                                    //                       child: Text(''),),
                                    //                     const Padding(
                                    //                       padding:  EdgeInsets.only(top: 8),
                                    //                       child:  CircleAvatar(
                                    //                         radius: 25,
                                    //                         backgroundImage: AssetImage('assets/darussalam.jpg'),
                                    //                       ),
                                    //                     ),
                                    //                     widthSizedBox8,
                                    //                     currentRole=='User'?Expanded(
                                    //                       child: Padding(
                                    //                         padding: const EdgeInsets.only(bottom:20.0),
                                    //                         child: IconButton(
                                    //                           onPressed: () async{
                                    //                             if(favouriteItemProvider.selectedItem.contains(index))
                                    //                             {
                                    //                               favouriteItemProvider.removeItem(index);
                                    //                               ScaffoldMessenger.of(context)
                                    //                                   .showSnackBar( SnackBar(
                                    //                                   content:  Text(events[index].name.toString()
                                    //                                       +" Deleted Successfully")));
                                    //                             }else{
                                    //                               favouriteItemProvider.addItem(index);
                                    //                               ScaffoldMessenger.of(context)
                                    //                                   .showSnackBar(  SnackBar(
                                    //                                 content:Text(events[index].name.toString()
                                    //                                     +" added "),));
                                    //                             }
                                    //
                                    //                           },
                                    //                           icon: Icon(
                                    //                             favouriteItemProvider.selectedItem.contains(index)
                                    //                             ||isSelected(events[index].Id)
                                    //                                 ? Icons.favorite
                                    //                                 : Icons.favorite_border,
                                    //                             color: Colors.red,
                                    //                           ),
                                    //                         ),
                                    //                       ),
                                    //                     ):Expanded(
                                    //                       child: Padding(
                                    //                         padding: const EdgeInsets.only(bottom:20.0),
                                    //                         child: PopupMenuButton(
                                    //                           shape: RoundedRectangleBorder(
                                    //                             borderRadius: BorderRadius.circular(10),
                                    //                           ),
                                    //                           itemBuilder: (context) {
                                    //                             return [
                                    //                               _buildPopupMenuItem(
                                    //                                 //'Edit',
                                    //                                   'assets/edit.png',
                                    //                                   //Icons.edit,
                                    //                                   'edit'),
                                    //                               _buildPopupMenuItem(
                                    //                                 //'Delete',
                                    //                                   'assets/delete.png',
                                    //                                   //Icons.delete_outline,
                                    //                                   'delete'),
                                    //                             ];
                                    //                           },
                                    //                           onSelected: (value) {
                                    //                             if(value=='edit'){
                                    //                               Navigator.push(
                                    //                                   context,
                                    //                                   MaterialPageRoute(
                                    //                                       builder: (context) => EventEditnew(
                                    //                                         isNew: false,
                                    //                                         eventId: events[index].Id,
                                    //                                       )));
                                    //                             }
                                    //                             else if(value=='delete'){
                                    //                               // await
                                    //                               apiService.deleteFn(int.parse(
                                    //                                   events[index].Id.toString()),'user');
                                    //                               ScaffoldMessenger.of(context)
                                    //                                   .showSnackBar(const SnackBar(
                                    //                                   content:  Text("User Deleted Successfully")));
                                    //                               Navigator.push(
                                    //                                   context,
                                    //                                   MaterialPageRoute(
                                    //                                     builder: (context) =>
                                    //                                         Events(),
                                    //                                   ));
                                    //                             }
                                    //                           },
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                   ],),
                                    //                 midPadding2,
                                    //                 Text(events[index].name.toString()),
                                    //                 midPadding2,
                                    //                 Text(events[index].description.toString(),softWrap: true,
                                    //                     overflow: TextOverflow.ellipsis),
                                    //
                                    //               ],
                                    //             ));
                                    //       }),
                                    // ):
                                    isGrid
                                        ? Expanded(
                                            child: ListView.builder(
                                                itemCount: copiedListEvents
                                                        .isEmpty
                                                    ? events.length
                                                    : copiedListEvents.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              UsereventDetails(
                                                            eventName:
                                                                events[index]
                                                                    .name
                                                                    .toString(),
                                                            discription:
                                                                events[index]
                                                                    .description
                                                                    .toString(),
                                                            imageUrlEvent:
                                                                'assets/darussalam.jpg',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        color: whiteColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 150,
                                                                height: 80,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/darussalam.jpg'),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  copiedListEvents
                                                                          .isEmpty
                                                                      ? Text(
                                                                          events[index]
                                                                              .name
                                                                              .toString(),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline1!
                                                                              .copyWith(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                        )
                                                                      : Text(
                                                                          copiedListEvents[index]
                                                                              .name
                                                                              .toString(),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline1!
                                                                              .copyWith(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                        ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  copiedListEvents
                                                                          .isEmpty
                                                                      ? Text(
                                                                          events[index].fullName.toString() +
                                                                              '\n',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText1!
                                                                              .copyWith(
                                                                                fontSize: 12,
                                                                              ),
                                                                        )
                                                                      : Text(
                                                                          copiedListEvents[index].fullName.toString() +
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
                                                          Positioned(
                                                              right: 0,
                                                              child: Row(
                                                                children: [
                                                                  currentRole ==
                                                                          'User'
                                                                      ? IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (favouriteItemProvider.selectedItem.contains(index)) {
                                                                              favouriteItemProvider.removeItem(index);
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(events[index].name.toString() + " Deleted Successfully")));
                                                                            } else {
                                                                              favouriteItemProvider.addItem(index);
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                content: Text(events[index].name.toString() + " added "),
                                                                              ));
                                                                            }
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            favouriteItemProvider.selectedItem.contains(index) || isSelected(events[index].Id)
                                                                                ? Icons.favorite
                                                                                : Icons.favorite_border,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        )
                                                                      : PopupMenuButton(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          itemBuilder:
                                                                              (context) {
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
                                                                          onSelected:
                                                                              (value) {
                                                                            if (value ==
                                                                                'edit') {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => EventEditnew(
                                                                                            isNew: false,
                                                                                            eventId: events[index].Id,
                                                                                          )));
                                                                            } else if (value ==
                                                                                'delete') {
                                                                              // await
                                                                              apiService.deleteFn(int.parse(events[index].Id.toString()), 'communityevent');
                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Deleted Successfully")));
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => Events(),
                                                                                  ));
                                                                            }
                                                                          },
                                                                        ),
                                                                  // ElevatedButton(
                                                                  //     style:
                                                                  //     crudButtonStyle,
                                                                  //     onPressed: () {
                                                                  //       Navigator.push(
                                                                  //           context,
                                                                  //           MaterialPageRoute(
                                                                  //               builder: (context) => EventEditnew(
                                                                  //                   isNew:
                                                                  //                   false,
                                                                  //                   eventId:
                                                                  //                   events[index].Id)));
                                                                  //     },
                                                                  //     child: const FaIcon(FontAwesomeIcons.edit,
                                                                  //       color: Color(0xFF8BBAF0),size: size,)),
                                                                  // currentRole=='User'?
                                                                  // Container()
                                                                  //     :
                                                                  // ElevatedButton(
                                                                  //     style:
                                                                  //     crudButtonStyle,
                                                                  //     onPressed:
                                                                  //         () async {
                                                                  //       await apiService.deleteFn(
                                                                  //           int.parse(events[
                                                                  //           index]
                                                                  //               .Id
                                                                  //               .toString()),
                                                                  //           'communityevent');
                                                                  //       ScaffoldMessenger
                                                                  //           .of(
                                                                  //           context)
                                                                  //           .showSnackBar(
                                                                  //           const SnackBar(
                                                                  //               content:
                                                                  //               Text("Event Deleted Successfully")));
                                                                  //       Navigator.push(
                                                                  //           context,
                                                                  //           MaterialPageRoute(
                                                                  //             builder:
                                                                  //                 (context) =>
                                                                  //                 Events(),
                                                                  //           ));
                                                                  //     },
                                                                  //     child: deleteIcon),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  );
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
                                        : Expanded(
                                            child: GridView.builder(
                                                padding: EdgeInsets.all(4),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3),
                                                itemCount: copiedListEvents
                                                        .isEmpty
                                                    ? events.length
                                                    : copiedListEvents.length,
                                                itemBuilder: (_, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 2.0,
                                                            right: 2,
                                                            bottom: 2),
                                                    child: Card(
                                                        key: ValueKey(
                                                            events[index].Id),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        color: Colors.white,
                                                        elevation: 2.0,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4.0,
                                                                      right: 4),
                                                              child: Row(
                                                                children: [
                                                                  const Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                        ''),
                                                                  ),
                                                                  const Expanded(
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius:
                                                                          25,
                                                                      backgroundImage:
                                                                          AssetImage(
                                                                              'assets/darussalam.jpg'),
                                                                    ),
                                                                  ),
                                                                  widthSizedBox8,
                                                                  currentRole ==
                                                                          'User'
                                                                      ? Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 10),
                                                                            child:
                                                                                IconButton(
                                                                              onPressed: () async {
                                                                                int currentUserId = await prefs.get('userId');
                                                                                if (favouriteItemProvider.selectedItem.contains(index)) {
                                                                                  favouriteItemProvider.removeItem(index);
                                                                                  await apiService.deleteendUserMaterial('enduserevents', currentUserId, events[index].Id);
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 1), content: Text(events[index].name.toString() + " Deleted Successfully")));
                                                                                } else {
                                                                                  favouriteItemProvider.addItem(index);
                                                                                  var postEndUserEvent = UserEvents(user_Id: currentUserId, event_Id: events[index].Id);
                                                                                  await ApiServices.postendUserEvents(postEndUserEvent);
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                    duration: Duration(seconds: 1),
                                                                                    content: Text(events[index].name.toString() + " added "),
                                                                                  ));
                                                                                }
                                                                              },
                                                                              icon: Icon(
                                                                                favouriteItemProvider.selectedItem.contains(index) || isSelected(events[index].Id) ? Icons.favorite : Icons.favorite_border,
                                                                                color: Colors.red,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          child:
                                                                              PopupMenuButton(
                                                                            position:
                                                                                PopupMenuPosition.under,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            itemBuilder:
                                                                                (context) {
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
                                                                            onSelected:
                                                                                (value) {
                                                                              if (value == 'edit') {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => EventEditnew(
                                                                                              isNew: false,
                                                                                              eventId: events[index].Id,
                                                                                            )));
                                                                              } else if (value == 'delete') {
                                                                                // await
                                                                                apiService.deleteFn(int.parse(events[index].Id.toString()), 'communityevent');
                                                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Deleted Successfully")));
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => Events(),
                                                                                    ));
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                            midPadding2,
                                                            copiedListEvents
                                                                    .isEmpty
                                                                ? Text(
                                                                    events[index]
                                                                        .name
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  )
                                                                : Text(
                                                                    copiedListEvents[
                                                                            index]
                                                                        .name
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                            midPadding2,
                                                            Text(
                                                                events[index]
                                                                    .description
                                                                    .toString(),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ],
                                                        )),
                                                  );
                                                }),
                                          )
                              ],
                            ),
                          ],
                  ),
                ),
              ],
            ),
          ),
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
          width: 20,
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
