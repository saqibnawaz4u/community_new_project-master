import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/filterDetails.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/filterList.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/widgets/custom_app_bar.dart';
import 'package:community_new/models/accommodationPosting.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:search_choices/search_choices.dart';
import '../../../../constants/styles.dart';
import '../../../../widgets/genericAppBar.dart';
import '../../../notifications/notification_screen.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../widgets/customTextField.dart';
import '../../widgets/search_input.dart';
import '../../widgets/welcome_text.dart';
import 'chat.dart';

class SearchFilter extends StatefulWidget {
  const SearchFilter({Key? key}) : super(key: key);

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  var lctnController = TextEditingController();
  String dropdownValue = 'Select';
  List<int> selectedItemsMultiDialogForAmeneties = [];
  List<int> selectedItemsMultiDialogForFeatures = [];
  List<DropdownMenuItem> itemsForAmenities = [
    DropdownMenuItem(child: Text('Parking')),
    DropdownMenuItem(child: Text('Washer & Dryer')),
    DropdownMenuItem(child: Text('Gym')),
    DropdownMenuItem(child: Text('Swimming Pool')),
    DropdownMenuItem(child: Text('Internet')),
  ];
  List<DropdownMenuItem> itemsForFeatures = [
    DropdownMenuItem(child: Text('Drawing Room')),
    DropdownMenuItem(child: Text('Dining Rooms')),
    DropdownMenuItem(child: Text('Kitchen')),
    DropdownMenuItem(child: Text('Study Room')),
    DropdownMenuItem(child: Text('Lounge or Sitting Room')),
    DropdownMenuItem(child: Text('Laundry Room')),
  ];

  String noofbedrroms = '';
  String NoOFBathrooms = '';
  String untilityIncluded = '';
  String parkingIncluded = '';
  String furnished = '';
  String appliances = '';
  String petFriendly = '';
  String aggrementType = '';
  String barrierFreeEntrance = '';
  String visualAids = '';
  String accessibleWahshroms = '';
  String personalOutdoorSpaces = '';
  String smookingPermitted = '';
  String forRentBy = '';
  List<String> selectedList = [];
  List<String> typesOfaccommodations = [
    'Houses',
    'Apartments & Flats',
    'Portion & Floors',
    'Roommates & Paying Guests',
    'Rooms',
    'Vacation Rentals - Guest Houses'
  ];
  RangeValues _currentRangeValues = const RangeValues(20, 60);
  RangeValues _currentRangeValuesforsqrt = const RangeValues(20, 60);
  bool status1 = false;
  bool status2 = false;
  bool status3 = false;

  var accPosting = AccommodationPosting();

  String location = 'Null, Press Button';
  String Address = 'search';
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: genericAppBarForUser(
          isSubScreen: true,
          notificationPress: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationScreen()));
          },
          chatPress: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ChatPage()));
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
                // onChanged: ((value) => _runFilter(value),
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding: EdgeInsets.all(0),
                  // fillColor: whiteColor,
                  // filled: true,
                  hintText: 'Search...',
                  prefixIconColor: Colors.grey,
                  suffixIconColor: appColor,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: whiteColor,
      body: ListView(
        children: [
          ListView(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.all(15),
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  // border: Border(
                  //   bottom: BorderSide(
                  //     color: Colors.grey,
                  //     width: 1,
                  //   ),
                  // ),
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color(0xffddc2ae),
                ),
                padding: EdgeInsets.only(
                  top: 15.0,
                  bottom: 10,
                  left: 20,
                ),
                child: Text(
                  'SORT OPTIONS',
                  style: TextStyle(color: textColor),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                    // border: Border(
                    //   bottom: BorderSide(
                    //     color: Colors.grey,
                    //     width: 1,
                    //   ),
                    // ),
                    // color: Colors.grey.shade300,
                    ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Sort Type ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Most Recent',
                      style: TextStyle(
                          color: blackColor, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  // border: Border(
                  //   bottom: BorderSide(
                  //     color: Colors.grey,
                  //     width: 1,
                  //   ),
                  //   top: BorderSide(
                  //     color: Colors.grey,
                  //     width: 1,
                  //   ),
                  // ),
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ),
                  color: Color(0xffddc2ae),
                ),
                padding: EdgeInsets.only(
                  top: 15.0,
                  bottom: 10,
                  left: 20,
                ),
                child: Text(
                  'REFINE OPTIONS',
                  style: TextStyle(color: textColor),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Category ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      'for rent',
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade300,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      'long term rentals',
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade300,
                      size: 20.0,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  // top: 10.0,
                  // bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Location ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: accPosting.location.toString(),
                          hintStyle: TextStyle(
                            fontSize: 10.0,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              Position position =
                                  await _getGeoLocationPosition();
                              GetAddressFromLatLong(position);
                            },
                            icon: Icon(
                              Icons.location_on,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                        controller: TextEditingController(
                            text: Address == 'Search'
                                ? lctnController.text
                                : Address),
                      ),
                    ),
                    // customTextField(
                    //   text: accPosting.location.toString(),
                    //   suffixIcon: IconButton(
                    //       onPressed: () async {
                    //         Position position = await _getGeoLocationPosition();
                    //         GetAddressFromLatLong(position);
                    //       },
                    //       icon: Icon(
                    //         Icons.location_on,
                    //       )),
                    //   controller: TextEditingController(
                    //       text: Address == 'Search'
                    //           ? lctnController.text
                    //           : Address),
                    // ),
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Price Type ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Any',
                      style: TextStyle(
                          color: blackColor, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Text(
                          'Min \$',
                          style: BlackTextStyleNormal16,
                        ),
                        Text(
                          'Any Price',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        SizedBox(
                          width: 50.0,
                        ),
                        Text(
                          'Max \$',
                          style: BlackTextStyleNormal16,
                        ),
                        Text(
                          'Any Price',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Offer Type ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Ads with images ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    FlutterSwitch(
                      width: 40,
                      value: status1,
                      activeColor: appColor,
                      toggleSize: 10,
                      inactiveColor: Colors.grey.shade300,
                      onToggle: (val) {
                        setState(() {
                          status1 = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Ads with video ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    FlutterSwitch(
                      width: 40,
                      value: status2,
                      activeColor: appColor,
                      toggleSize: 10,
                      inactiveColor: Colors.grey.shade300,
                      onToggle: (val) {
                        setState(() {
                          status2 = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                      // bottom: BorderSide(
                      //   color: Colors.grey,
                      //   width: 1,
                      // ),
                      ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Ads with virtual tour ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    FlutterSwitch(
                      width: 40,
                      value: status3,
                      activeColor: appColor,
                      toggleSize: 10,
                      inactiveColor: Colors.grey.shade300,
                      onToggle: (val) {
                        setState(() {
                          status3 = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  // border: Border(
                  //   bottom: BorderSide(
                  //     color: Colors.grey,
                  //     width: 1,
                  //   ),
                  //   top: BorderSide(
                  //     color: Colors.grey,
                  //     width: 1,
                  //   ),
                  // ),
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ),
                  color: Color(0xffddc2ae),
                ),
                padding: EdgeInsets.only(
                  top: 15.0,
                  bottom: 10,
                  left: 20,
                ),
                child: Text(
                  'LONG TERM RENTALS',
                  style: TextStyle(color: textColor),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Fot Rent By ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Unit type ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Bedrooms ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Bathrooms ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Agreement Type ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Pet Friendly ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price (sqft) ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Text(
                          'Min',
                          style: BlackTextStyleNormal16,
                        ),
                        Text(
                          'Any',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        SizedBox(
                          width: 50.0,
                        ),
                        Text(
                          'Max',
                          style: BlackTextStyleNormal16,
                        ),
                        Text(
                          'Any',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Furnished',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Laundry (In Unit)',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Laundry (In Building)',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Dishwasher',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Fridge/Freezer',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Air Conditioning',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Yard',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Balcony',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Smoking Permitted ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Gym',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Pool',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Concierge',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: '24 Hour Security',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Bicycle Parking',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Storage Space',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Elevator in Building',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Wheelchair accessible',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Braille Labels',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Audio Prompts',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Barrier-free Entrances and Ramps',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Visual Aids',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Accessible Washrooms in Suite',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Hydro',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Heat',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Water',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Cable/TV',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Internet',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Parking Included',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'Additional Options',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    // Text(
                    //   'Any',
                    //   style: TextStyle(
                    //       color: blackColor, fontWeight: FontWeight.bold),
                    // ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  // color: Colors.grey.shade300,
                ),
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10,
                  left: 10,
                ),
                child: customRadio1(
                  fn: (v) {
                    setState(() {
                      furnished = v;
                    });
                  },
                  //width: 55,
                  title: 'Term Agreement',
                  buttonLables: ['Any', 'Yes', 'No'],
                  buttonValues: ['Any', 'Yes', 'No'],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FilterDetails()));
                  },
                  child: Text(
                    'Reset',
                    style: BlackTextStyleNormal16,
                  )),
              // const Padding(
              //   padding: EdgeInsets.only(top: 10.0, bottom: 10),
              //   child: Align(
              //       alignment: Alignment.centerLeft,
              //       child: Text(
              //         "Type of Accommodation",
              //         style: BlackTextStyleNormal16,
              //       )),
              // ),
              // MultiSelectChip(
              //   typesOfaccommodations,
              //   onSelectionChanged: (selectList) {
              //     setState(() {
              //       selectedList = selectList;
              //     });
              //   },
              //   maxSelection: 4,
              // ),
              // Padding(
              //   padding: EdgeInsets.only(top: 10.0, bottom: 10),
              //   child: Align(
              //       alignment: Alignment.centerLeft,
              //       child: Text(
              //         "Price Range" + _currentRangeValues.toString(),
              //         style: BlackTextStyleNormal16,
              //       )),
              // ),
              // rangeSlider(
              //     startTitle: '\$0',
              //     endTitle: '\$5000',
              //     maxVal: 3000,
              //     currentRange: _currentRangeValues),
              // customRadio(
              //   fn: (v) {
              //     setState(() {
              //       noofbedrroms = v;
              //     });
              //   },
              //   //width: 55,
              //   title: 'No. of Bedrooms',
              //   buttonLables: ['Any', '1', '2', '3', '4', '5', '6+'],
              //   buttonValues: ['Any', '1', '2', '3', '4', '5+', '6+'],
              // ),
              // customRadio(
              //   fn: (v) {
              //     setState(() {
              //       NoOFBathrooms = v;
              //     });
              //   },
              //   //width: 55,
              //   title: 'No. of Bathrooms',
              //   buttonLables: [
              //     'Any',
              //     '1',
              //     '1.5',
              //     '2',
              //     '2.5',
              //     '3',
              //     '3.5',
              //     '4',
              //     '4.5'
              //   ],
              //   buttonValues: [
              //     'Any',
              //     '1',
              //     '1.5',
              //     '2',
              //     '2.5',
              //     '3',
              //     '3.5',
              //     '4',
              //     '4.5'
              //   ],
              // ),
              // customRadio(
              //   fn: (v) {
              //     setState(() {
              //       untilityIncluded = v;
              //     });
              //   },
              //   //width: 65,
              //   title: 'Utilities included',
              //   buttonLables: ['Any', 'None', 'Hydro', 'Heat', 'Water'],
              //   buttonValues: ['Any', 'None', 'Hydro', 'Heat', 'Water'],
              // ),
              // customRadio(
              //   fn: (v) {
              //     setState(() {
              //       parkingIncluded = v;
              //     });
              //   },
              //   // width: 55,
              //   title: 'Parking included',
              //   buttonLables: [
              //     'Any',
              //     '1',
              //     '2',
              //     '3+',
              //   ],
              //   buttonValues: [
              //     'Any',
              //     '1',
              //     '2',
              //     '3+',
              //   ],
              // ),
              // customRadio(
              //   fn: (v) {
              //     setState(() {
              //       furnished = v;
              //     });
              //   },
              //   //width: 55,
              //   title: 'Furnished',
              //   buttonLables: ['Any', 'Yes', 'No'],
              //   buttonValues: ['Any', 'Yes', 'No'],
              // ),
              // customRadio(
              //   fn: (v) {
              //     setState(() {
              //       appliances = v;
              //     });
              //   },
              //   //width: 0,
              //   title: 'Appliances',
              //   buttonLables: [
              //     'Any',
              //     'Laundry(In Unit)',
              //     'Laundry(In Building)'
              //   ],
              //   buttonValues: [
              //     'Any',
              //     'Laundry(In Unit)',
              //     'Laundry(In Building)'
              //   ],
              // ),
              // customRadio(
              //   fn: (v) {
              //     setState(() {
              //       petFriendly = v;
              //     });
              //   },
              //   //width: 55,
              //   title: 'Pet Friendly',
              //   buttonLables: ['Any', 'Yes', 'No', 'Limited'],
              //   buttonValues: ['Any', 'Yes', 'No', 'Limited'],
              // ),
              // midPadding2, midPadding2,
              // Divider(
              //   color: blackColor,
              // ),
              // Theme(
              //   data: Theme.of(context).copyWith(
              //       expansionTileTheme: ExpansionTileThemeData(
              //           textColor: appColor, iconColor: appColor),
              //       dividerColor: Colors.transparent),
              //   child: ExpansionTile(
              //     title: Text('Accessibility'),
              //     children: [
              //       customRadio(
              //         fn: (v) {
              //           barrierFreeEntrance = v;
              //         },
              //         //width: 55,
              //         title: 'Barrier-free Entrances and Ramps',
              //         buttonLables: ['Any', 'Yes', 'No'],
              //         buttonValues: ['Any', 'Yes', 'No'],
              //       ),
              //       customRadio(
              //         fn: (v) {
              //           setState(() {
              //             visualAids = v;
              //           });
              //         },
              //         //width: 55,
              //         title: 'Visual Aids',
              //         buttonLables: ['Any', 'Yes', 'No'],
              //         buttonValues: ['Any', 'Yes', 'No'],
              //       ),
              //       customRadio(
              //         fn: (v) {
              //           setState(() {
              //             accessibleWahshroms = v;
              //           });
              //         },
              //         //width: 55,
              //         title: 'Accessible Washrooms in Suite',
              //         buttonLables: ['Any', 'Yes', 'No'],
              //         buttonValues: ['Any', 'Yes', 'No'],
              //       ),
              //     ],
              //   ),
              // ),
              // midPadding2, midPadding2,
              // Divider(
              //   color: blackColor,
              // ),
              // Theme(
              //   data: Theme.of(context).copyWith(
              //       expansionTileTheme: ExpansionTileThemeData(
              //           textColor: appColor, iconColor: appColor),
              //       dividerColor: Colors.transparent),
              //   child: ExpansionTile(
              //     title: Text('More Filters'),
              //     children: [
              //       customRadio(
              //         fn: (v) {
              //           setState(() {
              //             aggrementType = v;
              //           });
              //         },
              //         title: 'Agreement Type',
              //         buttonLables: ['Any', 'Month-to-month', '1 Year'],
              //         buttonValues: ['Any', 'Month-to-month', '1 Year'],
              //       ),
              //       const Padding(
              //         padding: EdgeInsets.only(top: 10.0, bottom: 10),
              //         child: Align(
              //             alignment: Alignment.centerLeft,
              //             child: Text(
              //               "Size (Sqft)",
              //               style: BlackTextStyleNormal16,
              //             )),
              //       ),
              //       rangeSlider(
              //           startTitle: '0',
              //           endTitle: '3000',
              //           maxVal: 3000,
              //           currentRange: _currentRangeValuesforsqrt),
              //       customRadio(
              //         fn: (v) {
              //           setState(() {
              //             personalOutdoorSpaces = v;
              //           });
              //         },
              //         title: 'Personal Outdoor Space',
              //         buttonLables: ['Any', 'None', 'Balcony', 'Yard'],
              //         buttonValues: ['Any', 'None', 'Balcony', 'Yard'],
              //       ),
              //       customRadio(
              //         fn: (v) {
              //           setState(() {
              //             smookingPermitted = v;
              //           });
              //         },
              //         title: 'Smoking Permitted',
              //         buttonLables: ['Any', 'Yes', 'No', 'Outdoors only'],
              //         buttonValues: ['Any', 'Yes', 'No', 'Outdoors only'],
              //       ),
              //       customRadio(
              //         fn: (v) {
              //           setState(() {
              //             forRentBy = v;
              //           });
              //         },
              //         title: 'For Rent By',
              //         buttonLables: ['Any', 'Owner', 'Professional'],
              //         buttonValues: ['Any', 'Owner', 'Professional'],
              //       ),
              //     ],
              //   ),
              // ),
              // // const Padding(
              // //   padding:  EdgeInsets.only(top: 10.0,bottom: 10),
              // //   child: Align(
              // //       alignment: Alignment.centerLeft,
              // //       child: Text("Features",
              // //         style: BlackTextStyleNormal16,)),
              // // ),
              // // Card(
              // //   elevation: 0,
              // //   shape: RoundedRectangleBorder(
              // //     side: BorderSide(
              // //       width: 1,
              // //       color: Colors.grey,
              // //     ),
              // //     borderRadius: BorderRadius.circular(20),
              // //   ),
              // //   child: SearchChoices.multiple(
              // //
              // //     iconEnabledColor: appColor,
              // //     iconDisabledColor: Colors.grey,
              // //
              // //     items: itemsForFeatures,
              // //     selectedItems: selectedItemsMultiDialogForFeatures,
              // //     hint: const Padding(
              // //       padding: EdgeInsets.all(12.0),
              // //       child: Text("Select"),
              // //     ),underline: Container(),
              // //     searchHint: "Select",
              // //     searchInputDecoration:InputDecoration(
              // //
              // //     ),
              // //     onChanged: (value) {
              // //       setState(() {
              // //         selectedItemsMultiDialogForFeatures = value;
              // //       });
              // //     },
              // //     closeButton: (selectedItems) {
              // //       return (selectedItems.isNotEmpty
              // //           ? "Save ${selectedItems.length ==0 ? '"${itemsForFeatures[selectedItems.first].value}"'
              // //           : '(${selectedItems.length})'}"
              // //           : "Save without selection");
              // //     },
              // //     isExpanded: true,
              // //   ),
              // // ),
              // //
              // // const Padding(
              // //   padding:  EdgeInsets.only(top: 10.0,bottom: 10),
              // //   child: Align(
              // //       alignment: Alignment.centerLeft,
              // //       child: Text("Amenities",
              // //         style: BlackTextStyleNormal16,)),
              // // ),
              // // Card(
              // //   elevation: 0,
              // //   shape: RoundedRectangleBorder(
              // //     side: BorderSide(
              // //       width: 1,
              // //       color: Colors.grey,
              // //     ),
              // //     borderRadius: BorderRadius.circular(20),
              // //   ),
              // //   child: SearchChoices.multiple(
              // //
              // //     iconEnabledColor: appColor,
              // //     iconDisabledColor: Colors.grey,
              // //
              // //     items: itemsForAmenities,
              // //     selectedItems: selectedItemsMultiDialogForAmeneties,
              // //     hint: const Padding(
              // //       padding: EdgeInsets.all(12.0),
              // //       child: Text("Select"),
              // //     ),underline: Container(),
              // //     searchHint: "Select",
              // //     searchInputDecoration:InputDecoration(
              // //
              // //     ),
              // //     onChanged: (value) {
              // //       setState(() {
              // //         selectedItemsMultiDialogForAmeneties = value;
              // //       });
              // //     },
              // //     closeButton: (selectedItems) {
              // //       return (selectedItems.isNotEmpty
              // //           ? "Save ${selectedItems.length ==0 ? '"${itemsForAmenities[selectedItems.first].value}"'
              // //           : '(${selectedItems.length})'}"
              // //           : "Save without selection");
              // //     },
              // //     isExpanded: true,
              // //   ),
              // // ),
              // midPadding2, midPadding2,
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height / 16,
              //   child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //           primary: appColor, // background
              //           onPrimary: Colors.white,
              //           shape: const RoundedRectangleBorder(
              //               borderRadius: BorderRadius.all(
              //                   Radius.circular(20))) // foreground
              //           ),
              //       onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => FilterList(
              //               noofBathrooms: NoOFBathrooms,
              //               noofBedrooms: noofbedrroms,
              //               untilityIncluded: untilityIncluded,
              //               accessibleWahshroms: accessibleWahshroms,
              //               aggrementType: aggrementType,
              //               appliances: appliances,
              //               barrierFreeEntrance: barrierFreeEntrance,
              //               forRentBy: forRentBy,
              //               furnished: furnished,
              //               parkingIncluded: parkingIncluded,
              //               personalOutdoorSpaces: personalOutdoorSpaces,
              //               petFriendly: petFriendly,
              //               smookingPermitted: smookingPermitted,
              //               visualAids: visualAids,
              //             ),
              //           ),
              //         );
              //       },
              //       child: const Text('Apply')),
              // ),
            ],
          )
        ],
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>)? onSelectionChanged;
  final Function(List<String>)? onMaxSelected;
  final int? maxSelection;

  MultiSelectChip(this.reportList,
      {this.onSelectionChanged, this.onMaxSelected, this.maxSelection});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          selectedColor:
              selectedChoices.contains(item) ? appColor : Colors.grey.shade300,
          label: Text(item,
              style: TextStyle(
                color: selectedChoices.contains(item) ? whiteColor : blackColor,
              )),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            if (selectedChoices.length == (widget.maxSelection ?? -1) &&
                !selectedChoices.contains(item)) {
              widget.onMaxSelected?.call(selectedChoices);
            } else {
              setState(() {
                selectedChoices.contains(item)
                    ? selectedChoices.remove(item)
                    : selectedChoices.add(item);
                widget.onSelectionChanged?.call(selectedChoices);
              });
            }
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

class customRadio1 extends StatefulWidget {
  //final double width;
  final String title;
  final void Function(String a) fn;
  final List<String> buttonLables, buttonValues;
  const customRadio1(
      {Key? key,
      required this.title,
      required this.fn,
      required this.buttonLables,
      required this.buttonValues})
      : super(key: key);

  @override
  State<customRadio1> createState() => _customRadio1State();
}

class _customRadio1State extends State<customRadio1> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )),
          ),
        ),
        SizedBox(
          width: 50.0,
        ),
        Expanded(
          flex: 2,
          child: CustomRadioButton<String>(
            autoWidth: true,
            //width: widget.width,
            // height: 30.0,
            //customShape: CircleBorder(),
            enableShape: true,
            elevation: 0,
            absoluteZeroSpacing: false,
            unSelectedColor: Theme.of(context).canvasColor,
            buttonLables: widget.buttonLables,
            buttonValues: widget.buttonValues,
            defaultSelected: widget.buttonLables[0],
            buttonTextStyle: ButtonTextStyle(
                selectedColor: textColor,
                unSelectedColor: Colors.black,
                textStyle: TextStyle(fontSize: 12)),
            radioButtonValue: widget.fn,
            selectedBorderColor: Color(0xffddc2ae),
            selectedColor: Color(0xffddc2ae),
          ),
        ),
      ],
    );
  }
}

class customRadio extends StatefulWidget {
  //final double width;
  final String title;
  final void Function(String a) fn;
  final List<String> buttonLables, buttonValues;
  const customRadio(
      {Key? key,
      required this.title,
      required this.fn,
      required this.buttonLables,
      required this.buttonValues})
      : super(key: key);

  @override
  State<customRadio> createState() => _customRadioState();
}

class _customRadioState extends State<customRadio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: BlackTextStyleNormal16,
                )),
          ),
          CustomRadioButton<String>(
            wrapAlignment: WrapAlignment.start,
            spacing: 2.0,
            // wrapAlignment: WrapAlignment.start,
            // margin: EdgeInsets.symmetric(
            //   horizontal: 10.0,
            // ),
            autoWidth: true,
            //width: widget.width,
            //customShape: CircleBorder(),
            enableShape: true,
            elevation: 1,
            absoluteZeroSpacing: false,
            unSelectedColor: Theme.of(context).canvasColor,
            buttonLables: widget.buttonLables,
            buttonValues: widget.buttonValues,
            defaultSelected: widget.buttonLables[0],
            buttonTextStyle: ButtonTextStyle(
                selectedColor: textColor,
                unSelectedColor: Colors.black,
                textStyle: TextStyle(fontSize: 12)),
            radioButtonValue: widget.fn,
            selectedBorderColor: Color(0xffddc2ae),
            selectedColor: Color(0xffddc2ae),
          ),
        ],
      ),
    );
  }
}

class customRadioForList extends StatefulWidget {
  //final double width;
  final String title;
  final List<String> buttonLables;
  final ListView buttonValues;
  const customRadioForList(
      {Key? key,
      required this.title,
      required this.buttonLables,
      required this.buttonValues})
      : super(key: key);

  @override
  State<customRadioForList> createState() => _customRadioForListState();
}

class _customRadioForListState extends State<customRadioForList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style: BlackTextStyleNormal16,
              )),
        ),
        CustomRadioButton(
          autoWidth: true,
          //width: widget.width,
          //customShape: CircleBorder(),
          enableShape: true,
          elevation: 1,
          absoluteZeroSpacing: false,
          unSelectedColor: Theme.of(context).canvasColor,
          buttonLables: widget.buttonLables,
          buttonValues: [widget.buttonValues],
          buttonTextStyle: ButtonTextStyle(
              selectedColor: Colors.white,
              unSelectedColor: Colors.black,
              textStyle: TextStyle(fontSize: 12)),
          radioButtonValue: (value) {
            print(value);
          },
          selectedColor: appColor,
        ),
      ],
    );
  }
}

class rangeSlider extends StatefulWidget {
  final String startTitle, endTitle;
  final double maxVal;
  RangeValues currentRange = const RangeValues(20, 60);
  rangeSlider(
      {Key? key,
      required this.currentRange,
      required this.maxVal,
      required this.startTitle,
      required this.endTitle})
      : super(key: key);

  @override
  State<rangeSlider> createState() => _rangeSliderState();
}

class _rangeSliderState extends State<rangeSlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 0, child: Text(widget.startTitle)),
        Expanded(
          flex: 10,
          child: RangeSlider(
            values: widget.currentRange,
            activeColor: appColor,
            inactiveColor: Colors.grey.shade300,
            min: 0,
            max: widget.maxVal,
            divisions: 100,
            labels: RangeLabels(
              '${widget.currentRange.start.round().toString()}',
              '${widget.currentRange.end.round().toString()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                widget.currentRange = values;
              });
            },
          ),
        ),
        Expanded(flex: 0, child: Text(widget.endTitle)),
      ],
    );
  }
}
