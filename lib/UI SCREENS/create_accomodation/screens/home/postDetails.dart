import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/bathrooms.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/bedrooms.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/searchFilter.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/unitType.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/postAccomodation.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/widgets/buttons.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/widgets/customTextField.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/accommodationPosting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostingDetails extends StatefulWidget {
  String? unitType, bedrooms, bathrooms;
  int? num;
  final bool? isNew;
  PostingDetails({
    super.key,
    this.isNew,
    this.unitType,
    this.bedrooms,
    this.bathrooms,
    this.num,
  });

  @override
  State<PostingDetails> createState() => _PostingDetailsState();
}

class _PostingDetailsState extends State<PostingDetails> {
  TextEditingController _sizeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String noofbedrroms = '';
  String NoOFBathrooms = '';
  String untilityIncluded = '';
  String parkingIncluded = '';
  String furnished = '';
  String appliances = '';
  String petFriendly = '';
  String barrierFreeEntrance = '';
  String visualAids = '';
  String accessibleWahshroms = '';
  String personalOutdoorSpaces = '';
  String smookingPermitted = '';
  String forRentBy = '';
  String agreementTypeString = '';
  String laundryInUnit = '';
  String laundryInBuilding = '';
  String dishwasher = '';
  String airConditioning = '';
  String fridge = '';
  String balcony = '';
  String hydro = '';
  String heat = '';
  String water = '';
  String yard = '';
  String cable = '';
  String internet = '';
  String adType = '';

  Future onTappedFunctionOfStartDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        dateController.text =
            formattedDate; //set output date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
                "Details",
                style: TextStyle(fontSize: 20, color: appColor),
              ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
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
                      'REQUIRED',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        forRentBy = v;
                      });
                    },
                    title: 'For Rent By',
                    buttonLables: ['Owner', 'Professional'],
                    buttonValues: ['Owner', 'Professional'],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UnitTypeScreen()));
                    },
                    child: Container(
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
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BedroomsScreen()));
                    },
                    child: Container(
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
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BathroomScreen()));
                    },
                    child: Container(
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
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        agreementTypeString = v;
                      });
                    },
                    title: 'Agreement Type',
                    buttonLables: ['Month to Month', '1 Year'],
                    buttonValues: ['Month to Month', '1 Year'],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // InkWell(
                  //   onTap: onTappedFunctionOfStartDate,
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     height: 40,
                  //     decoration: BoxDecoration(
                  //       border: Border(
                  //         bottom: BorderSide(
                  //           color: Colors.grey,
                  //           width: 1,
                  //         ),
                  //       ),
                  //       // color: Colors.grey.shade300,
                  //     ),
                  //     padding: EdgeInsets.only(
                  //       top: 10.0,
                  //       bottom: 10,
                  //       left: 10,
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         Text(
                  //           'Select Move-in Date ',
                  //           style: TextStyle(
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //         Spacer(),
                  //         // Text(
                  //         //   'Any',
                  //         //   style: TextStyle(
                  //         //       color: blackColor, fontWeight: FontWeight.bold),
                  //         // ),
                  //         Icon(
                  //           Icons.arrow_forward_ios,
                  //           size: 20.0,
                  //           color: Colors.grey.shade300,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  //  customTextField(
                  //   text: 'Move-in Date',
                  //   controller: dateController,
                  // ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        petFriendly = v;
                      });
                    },
                    //width: 55,
                    title: 'Pet Friendly',
                    buttonLables: ['Yes', 'No', 'Limited'],
                    buttonValues: ['Yes', 'No', 'Limited'],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  customTextField(
                    text: 'Enter Size(sqft)',
                    controller: _sizeController,
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        furnished = v;
                      });
                    },
                    //width: 55,
                    title: 'Furnished',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        laundryInUnit = v;
                      });
                    },
                    //width: 55,
                    title: 'Laundry (In Unit)',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        laundryInBuilding = v;
                      });
                    },
                    //width: 55,
                    title: 'Laundry (In Building)',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        dishwasher = v;
                      });
                    },
                    //width: 55,
                    title: 'Dishwasher',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        fridge = v;
                      });
                    },
                    //width: 55,
                    title: 'Fridge/Freezer',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        airConditioning = v;
                      });
                    },
                    //width: 55,
                    title: 'Air Conditioning',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        yard = v;
                      });
                    },
                    //width: 55,
                    title: 'Yard',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        balcony = v;
                      });
                    },
                    //width: 55,
                    title: 'Balcony',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        smookingPermitted = v;
                      });
                    },
                    title: 'Smoking Permitted',
                    buttonLables: ['Yes', 'No', 'Outdoors only'],
                    buttonValues: ['Yes', 'No', 'Outdoors only'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        barrierFreeEntrance = v;
                      });
                    },
                    //width: 55,
                    title: 'Barrier-free Entrances and Ramps',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        visualAids = v;
                      });
                    },
                    //width: 55,
                    title: 'Visual Aids',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        accessibleWahshroms = v;
                      });
                    },
                    //width: 55,
                    title: 'Accessible Washrooms in Suite',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        hydro = v;
                      });
                    },
                    //width: 55,
                    title: 'Hydro',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        heat = v;
                      });
                    },
                    //width: 55,
                    title: 'Heat',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        water = v;
                      });
                    },
                    //width: 55,
                    title: 'Water',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        cable = v;
                      });
                    },
                    //width: 55,
                    title: 'Cable/TV',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        internet = v;
                      });
                    },
                    //width: 55,
                    title: 'Internet',
                    buttonLables: ['Yes', 'No'],
                    buttonValues: ['Yes', 'No'],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        parkingIncluded = v;
                      });
                    },
                    // width: 55,
                    title: 'Parking included',
                    buttonLables: [
                      '1',
                      '2',
                      '3+',
                    ],
                    buttonValues: [
                      '1',
                      '2',
                      '3+',
                    ],
                  ),
                  customRadio(
                    fn: (v) {
                      setState(() {
                        adType = v;
                      });
                    },
                    //width: 55,
                    title: 'Ad Type',
                    buttonLables: ['I am offering', 'I want'],
                    buttonValues: ['I am offering', 'I want'],
                  ),
                  SizedBox(
                    height: 70.0,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // decoration: BoxDecoration(
              //   boxShadow: [
              //     new BoxShadow(
              //       color: Colors.black,
              //       // blurRadius: 0.1,
              //     ),
              //   ],
              // ),
              height: 80,
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: customEmailBtn(
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostAccommodation(
                            isNew: true,
                            // NoOFBathrooms: double.parse(widget.bathrooms!),
                            // NoOFBathrooms: double.parse(NoOFBathrooms),
                            accessibleWahshroms: accessibleWahshroms,
                            adType: adType,
                            agreementTypeString: agreementTypeString,
                            airConditioning: airConditioning,
                            // appliances: appliances,
                            balcony: balcony,
                            barrierFreeEntrance: barrierFreeEntrance,
                            cable: cable,
                            dishwasher: dishwasher,
                            forRentBy: forRentBy,
                            fridge: fridge,
                            furnished: furnished,
                            heat: heat,
                            hydro: hydro,
                            internet: internet,
                            laundryInBuilding: laundryInBuilding,
                            laundryInUnit: laundryInUnit,
                            // noofbedrroms: int.parse(widget.bedrooms!),
                            parkingIncluded: parkingIncluded,
                            personalOutdoorSpaces: personalOutdoorSpaces,
                            petFriendly: petFriendly,
                            size: int.parse(_sizeController.text),
                            smookingPermitted: smookingPermitted,
                            untilityIncluded: untilityIncluded,
                            visualAids: visualAids,
                            water: water,
                            yard: yard,
                          ),
                        ),
                      );
                    },
                    'Done',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
