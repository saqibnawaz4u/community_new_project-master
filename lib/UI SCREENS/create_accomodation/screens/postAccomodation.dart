import 'dart:convert';
import 'dart:io';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/categories.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/home2.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/postDetails.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/widgets/categories.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/widgets/customTextField.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/accommodationAggrement.dart';
import 'package:community_new/models/accommodationAmenities.dart';
import 'package:community_new/models/accommodationType.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../api_services/api_services.dart';
import 'package:http/http.dart' as http;
import '../../../models/accommodationPosting.dart';
import '../../../models/keyvalue.dart';
import '../../../widgets/add_screen_text_field.dart';
import 'package:search_choices/search_choices.dart';
import '../../../widgets/dropdown.dart';
import '../../../widgets/extra_widgets.dart';
import '../widgets/buttons.dart';
import 'home/searchFilter.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class PostAccommodation extends StatefulWidget {
  final int? noofbedrroms;
  final double? NoOFBathrooms;
  final String? untilityIncluded;
  final String? parkingIncluded;
  final String? furnished;
  final String? appliances;
  final String? petFriendly;
  final String? barrierFreeEntrance;
  final String? visualAids;
  final String? accessibleWahshroms;
  final String? personalOutdoorSpaces;
  final String? smookingPermitted;
  final String? forRentBy;
  final String? agreementTypeString;
  final String? laundryInUnit;
  final String? laundryInBuilding;
  final String? dishwasher;
  final String? airConditioning;
  final String? fridge;
  final String? balcony;
  final String? hydro;
  final String? heat;
  final String? water;
  final String? yard;
  final String? cable;
  final String? internet;
  final int? size;
  final String? adType;
  final bool isNew;
  final int? accId;
  const PostAccommodation({
    Key? key,
    required this.isNew,
    this.size,
    this.accId,
    this.NoOFBathrooms,
    this.accessibleWahshroms,
    this.adType,
    this.agreementTypeString,
    this.airConditioning,
    this.appliances,
    this.balcony,
    this.barrierFreeEntrance,
    this.cable,
    this.dishwasher,
    this.forRentBy,
    this.fridge,
    this.furnished,
    this.heat,
    this.hydro,
    this.internet,
    this.laundryInBuilding,
    this.laundryInUnit,
    this.noofbedrroms,
    this.parkingIncluded,
    this.personalOutdoorSpaces,
    this.petFriendly,
    this.smookingPermitted,
    this.untilityIncluded,
    this.visualAids,
    this.water,
    this.yard,
  }) : super(key: key);
  @override
  _PostAccommodationState createState() => _PostAccommodationState();
}

class _PostAccommodationState extends State<PostAccommodation>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<PostAccommodation> {
  var priceController = TextEditingController();
  var cityController = TextEditingController();
  var streetAddresscntrl = TextEditingController();
  var statecntrl = TextEditingController();
  var countryCntrl = TextEditingController();
  var titleCntrl = TextEditingController();
  var zipCodeCntrl = TextEditingController();
  var phoneNoCntrl = TextEditingController();
  var areaController = TextEditingController();
  var lctnController = TextEditingController();
  var idController = TextEditingController();
  var descriptionController = TextEditingController();
  KeyValue? selectedKeyValueaccType;
  KeyValue? selectedKeyValueagreementType;
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  var dropdownAccType = new DropDown(
    mylist: [],
  );
  var dropdownagreementType = new DropDown(
    mylist: [],
  );
  List<accommodationType> acctype = [];
  List<accommodationAgreement> agreementType = [];
  List<accommodationAmenities> amenitiesType = [];
  List<KeyValue> KeyvaleusaccType = [];
  List<KeyValue> KeyvaleusagreementType = [];

  _getaccType() async {
    await ApiServices.fetch("accommodationtype").then((response) {
      setState(() {
        Iterable listroles = json.decode(response.body);
        // print(list);
        acctype = listroles
            .map((model) => accommodationType.fromJson(model))
            .toList();
        if (acctype.length > 0) {
          KeyvaleusaccType.add(new KeyValue(
              key: '0', value: "Please Select Accommodation Type"));
          for (int i = 0; i < acctype.length; i++) {
            KeyvaleusaccType.add(new KeyValue(
                key: acctype[i].id.toString(), value: acctype[i].name));
          }
        }
      });
    });
    dropdownAccType = DropDown(
      mylist: KeyvaleusaccType,
      seletected_value: selectedKeyValueaccType,
    );
  }

  // List<AccommodationPosting> accomodationPosting = [];
  // getAladhanData() async {
  //   var response =
  //       http.post(Uri.parse('http://ijtimaee.com/api/accommodationposting'));
  //       accomodationPosting=AccommodationPosting.toJson

  //   if (response.statusCode == 200) {
  //     data = AladhanModel.fromJson(jsonDecode(response.body));

  //     print(data.status);
  //     setState(() {
  //       _isloading = false;
  //     });
  //   }
  // }

  final _form = GlobalKey<FormState>();
  Future<void> _saveForm(AccommodationPosting accommodationpostingObj) async {
    // final isValid = _form.currentState!.validate();
    // if (isValid) {
    if (widget.isNew) {
      await ApiServices.postAccommodationfn(accommodationpostingObj);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Accommodation Added Successfully"),
      ));
    } else {
      await ApiServices.postaccommodationbyid(
          idController.text, accommodationpostingObj);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Accommodation Updated Successfully"),
      ));
    }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text("Please fill form correctly"),
    //   ));
    // }
  }

  _getagreementType() async {
    await ApiServices.fetch("accommodationagreement").then((response) {
      setState(() {
        Iterable listroles = json.decode(response.body);
        // print(list);
        agreementType = listroles
            .map((model) => accommodationAgreement.fromJson(model))
            .toList();
        if (agreementType.length > 0) {
          KeyvaleusagreementType.add(
              new KeyValue(key: '0', value: "Please Select Agreement Type"));
          for (int i = 0; i < agreementType.length; i++) {
            KeyvaleusagreementType.add(new KeyValue(
                key: agreementType[i].id.toString(),
                value: agreementType[i].title));
          }
        }
      });
    });
    dropdownagreementType = DropDown(
      mylist: KeyvaleusagreementType,
      seletected_value: selectedKeyValueagreementType,
    );
  }

  _getamenities() async {
    await ApiServices.fetch("accommodationamenities").then((response) {
      setState(() {
        Iterable listroles = json.decode(response.body);
        // print(list);
        amenitiesType = listroles
            .map((model) => accommodationAmenities.fromJson(model))
            .toList();
      });
    });
  }

  var accPosting = AccommodationPosting();
  getacc() async {
    if (widget.isNew == false) {
      await ApiServices.fetchForEdit(widget.accId, 'accommodationposting')
          .then((response) {
        setState(() {
          var userBody = json.decode(response.body);
          accPosting = AccommodationPosting.fromJson(userBody);

          if (accPosting != null) {
            idController.text = accPosting.id.toString();
            priceController.text = accPosting.rent.toString();
            noofbedrroms = accPosting.noofBedrooms.toString();
            NoOFBathrooms = accPosting.noofBathrooms.toString();
            untilityIncluded = accPosting.utilitiesIncluded.toString();
            // parkingIncluded=accPosting.parkingIncluded.toString()
            // furnished
            appliances = accPosting.appliances.toString();
            petFriendly = accPosting.petFriendly.toString();
            barrierFreeEntrance =
                accPosting.barrier_free_entrancesAndRamps.toString();
            visualAids = accPosting.visualAids.toString();
            accessibleWahshroms =
                accPosting.accessibleWashroomsInSuite.toString();
            personalOutdoorSpaces = accPosting.personalOutdoorSpace.toString();
            smookingPermitted = accPosting.smokingPermitted.toString();
            forRentBy = accPosting.forRentBy.toString();
            areaController.text = accPosting.sizeInSqft.toString();
            descriptionController.text = accPosting.description.toString();
            cityController.text = accPosting.city.toString();
            titleCntrl.text = accPosting.title.toString();
            zipCodeCntrl.text = accPosting.zipCode.toString();
            streetAddresscntrl.text = accPosting.streetAddress.toString();
            statecntrl.text = accPosting.state.toString();
            phoneNoCntrl.text = accPosting.phoneNumber.toString();
            countryCntrl.text = accPosting.country.toString();

            KeyValue testforOrgId;
            if (accPosting.accommodationType_Id != "null" &&
                accPosting.accommodationType_Id != null) {
              try {
                // print('try assign  masjid ' +selectedKeyValueOrgId!.key.toString());
                testforOrgId = KeyvaleusaccType.firstWhere((element) =>
                    element.key == accPosting.accommodationType_Id.toString());
              } catch (e) {
                testforOrgId = KeyvaleusaccType[0];
              }
            } else {
              testforOrgId = KeyvaleusaccType[0];
            }

            selectedKeyValueaccType = testforOrgId;
            // _selected_default_Role_Id=null;
            if (accPosting.aggreementType_id != "null" &&
                accPosting.aggreementType_id != null) {
              selectedKeyValueagreementType = KeyvaleusagreementType.firstWhere(
                  (element) =>
                      element.key == accPosting.aggreementType_id.toString());
            }
            // print(userBody);
          }
        });
      });
    }
    dropdownAccType = DropDown(
      mylist: KeyvaleusaccType,
      seletected_value: selectedKeyValueaccType,
    );
    dropdownagreementType = DropDown(
      mylist: KeyvaleusagreementType,
      seletected_value: selectedKeyValueagreementType,
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget yesButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop(false);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => home2()));
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

  List<int> selectedItemsMultiDialog = [];
  List<DropdownMenuItem> items = [
    DropdownMenuItem(child: Text('Parking')),
    DropdownMenuItem(child: Text('Washer & Dryer')),
    DropdownMenuItem(child: Text('Gym')),
    DropdownMenuItem(child: Text('Swimming Pool')),
    DropdownMenuItem(child: Text('Internet')),
  ];

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
  List<XFile>? imageFileList = [];
  final ImagePicker imagePicker = ImagePicker();
  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

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

  XFile imageFile = XFile('');

  Future<void> uploadImage(AccommodationPosting accomodationPosting) async {
    String uploadurl = "http://ijtimaee.com/api/accomodationposting/UploadPost";

    try {
      List<int> imageBytes = imageFile.readAsBytes() as List<int>;
      String baseimage = base64Encode(imageBytes);
      //convert file image to Base64 encoding
      var response = await http.post(Uri.parse(uploadurl), body: {
        'image': baseimage,
      });
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["error"]) {
          print(jsondata["msg"]);
        } else {
          print("Upload successful");
        }
      } else {
        print("Error during connection to server");
      }
    } catch (e) {
      print("Error during converting to Base64");
    }
  }

  @override
  void initState() {
    super.initState();
    _getaccType();
    _getagreementType();
    _getamenities();
    getacc();
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
                "Post",
                style: TextStyle(fontSize: 20, color: appColor),
              ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Form(
              key: formKeys[0],
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (imageFileList!.isEmpty)
                        ? DottedBorder(
                            color: Colors.grey,
                            strokeWidth: 2,
                            dashPattern: [10, 3],
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: double.infinity,
                              color: Color(0xffddc2ae),
                              child: TextButton.icon(
                                  label: Text(
                                    'Upload',
                                    style: BlackTextStyleNormal,
                                  ),
                                  onPressed: () {
                                    selectImages();
                                  }, //icon: const
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: blackColor,
                                  )),
                              // SingleChildScrollView(
                              //   scrollDirection: Axis.horizontal,
                              //   child: Row(
                              //     children: [
                              //       Container(
                              //         width: MediaQuery.of(context).size.width * 0.3,
                              //         child: Column(
                              //           mainAxisAlignment: MainAxisAlignment.center,
                              //           children: [
                              //             Icon(
                              //               Icons.add_a_photo_outlined,
                              //               size: 50.0,
                              //               color: appColor,
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              //       Container(
                              //         height: MediaQuery.of(context).size.height,
                              //         width: MediaQuery.of(context).size.width * 0.4,
                              //         decoration: BoxDecoration(
                              //           border: Border.all(
                              //             color: Colors.grey,
                              //           ),
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         width: 10.0,
                              //       ),
                              //       Container(
                              //         height: MediaQuery.of(context).size.height,
                              //         width: MediaQuery.of(context).size.width * 0.4,
                              //         decoration: BoxDecoration(
                              //           border: Border.all(
                              //             color: Colors.grey,
                              //           ),
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         width: 10.0,
                              //       ),
                              //       Container(
                              //         height: MediaQuery.of(context).size.height,
                              //         width: MediaQuery.of(context).size.width * 0.4,
                              //         decoration: BoxDecoration(
                              //           border: Border.all(
                              //             color: Colors.grey,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: imageFileList!.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4),
                            itemBuilder: (BuildContext context, int index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(imageFileList![index].path),
                                  fit: BoxFit.cover,
                                ),
                              );
                            }),
                    SizedBox(
                      height: 20.0,
                    ),
                    customTextField(
                      text: 'title',
                      controller: titleCntrl,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    customTextField(
                      text: 'Description',
                      controller: descriptionController,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccCategories(),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          // border: Border(
                          //   bottom: BorderSide(
                          //     color: Colors.grey,
                          //     width: 1,
                          //   ),
                          color: whiteColor,
                          // ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 1.0,
                                offset: Offset(0.0, 0.75))
                          ],
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
                              'Select Category ',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey.shade300,
                              size: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostingDetails()),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          // border: Border(
                          //   bottom: BorderSide(
                          //     color: Colors.grey,
                          //     width: 1,
                          //   ),
                          color: whiteColor,
                          // ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 1.0,
                                offset: Offset(0.0, 0.75))
                          ],
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
                              'Details ',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey.shade300,
                              size: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //     // border: Border(
                    //     //   bottom: BorderSide(
                    //     //     color: Colors.grey,
                    //     //     width: 1,
                    //     //   ),
                    //     color: whiteColor,
                    //     // ),
                    //     boxShadow: <BoxShadow>[
                    //       BoxShadow(
                    //           color: Colors.black54,
                    //           blurRadius: 1.0,
                    //           offset: Offset(0.0, 0.75))
                    //     ],
                    //     // color: Colors.grey.shade300,
                    //   ),
                    //   padding: EdgeInsets.only(
                    //     top: 10.0,
                    //     bottom: 10,
                    //     left: 10,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         'Location ',
                    //         style: TextStyle(
                    //           color: Colors.grey,
                    //         ),
                    //       ),
                    //       Spacer(),
                    //       Icon(
                    //         Icons.arrow_forward_ios,
                    //         color: Colors.grey.shade300,
                    //         size: 20.0,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    customTextField(
                      text: accPosting.location.toString(),
                      suffixIcon: IconButton(
                          onPressed: () async {
                            Position position = await _getGeoLocationPosition();
                            GetAddressFromLatLong(position);
                          },
                          icon: Icon(
                            Icons.location_on,
                          )),
                      controller: TextEditingController(
                          text: Address == 'Search'
                              ? lctnController.text
                              : Address),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //     // border: Border(
                    //     //   bottom: BorderSide(
                    //     //     color: Colors.grey,
                    //     //     width: 1,
                    //     //   ),
                    //     color: whiteColor,
                    //     // ),
                    //     boxShadow: <BoxShadow>[
                    //       BoxShadow(
                    //           color: Colors.black54,
                    //           blurRadius: 1.0,
                    //           offset: Offset(0.0, 0.75))
                    //     ],
                    //     // color: Colors.grey.shade300,
                    //   ),
                    //   padding: EdgeInsets.only(
                    //     top: 10.0,
                    //     bottom: 10,
                    //     left: 10,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         'Additional Options ',
                    //         style: TextStyle(
                    //           color: Colors.grey,
                    //         ),
                    //       ),
                    //       Spacer(),
                    //       Icon(
                    //         Icons.arrow_forward_ios,
                    //         color: Colors.grey.shade300,
                    //         size: 20.0,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
                    customTextField(
                        controller: phoneNoCntrl,
                        text: 'Phone Number (Optional)'),
                    SizedBox(
                      height: 80.0,
                    )
                    // AddScreenTextFieldWidget(
                    //   labelText: "Title",
                    //   obsecureText: false,
                    //   controller: priceController,
                    //   textName: accPosting.rent.toString(),
                    //   inputType: TextInputType.number,
                    //   validator: (text) {
                    //     if (!(text!.length > 2) && text.isEmpty) {
                    //       return "Enter Title";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // AddScreenTextFieldWidget(
                    //   labelText: "Description",
                    //   obsecureText: false,
                    //   controller: priceController,
                    //   textName: accPosting.rent.toString(),
                    //   inputType: TextInputType.number,
                    //   validator: (text) {
                    //     if (!(text!.length > 2) && text.isEmpty) {
                    //       return "Enter Description";
                    //     }
                    //     return null;
                    //   },
                    // ),
                  ],
                ),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: customCallBtn(() {}, 'Preview Ad'),
                      ),
                      Expanded(
                        child: customEmailBtn(
                          () async {
                            AccommodationPosting accPosting;
                            if (!widget.isNew) {
                              accPosting = AccommodationPosting.WithId(
                                advancePayment: 0,
                                id: int.parse(idController.text),
                                furnished: widget.furnished,
                                // rent: 10,
                                country: countryCntrl.text,
                                title: titleCntrl.text,
                                phoneNumber: int.parse(phoneNoCntrl.text),
                                state: statecntrl.text,
                                streetAddress: streetAddresscntrl.text,
                                zipCode: zipCodeCntrl.text,
                                aggreementType_id: 8,
                                description: descriptionController.text,
                                accommodationType_Id: 8,
                                city: cityController.text,
                                sizeInSqft: widget.size,
                                rent: int.parse(priceController.text),
                                smokingPermitted: widget.smookingPermitted,
                                visualAids: widget.visualAids,
                                utilitiesIncluded: widget.untilityIncluded,
                                petFriendly: widget.petFriendly,
                                personalOutdoorSpace:
                                    widget.personalOutdoorSpaces,
                                noofBathrooms: double.parse(NoOFBathrooms),
                                forRentBy: widget.forRentBy,
                                barrier_free_entrancesAndRamps:
                                    widget.barrierFreeEntrance,
                                appliances: widget.appliances,
                                accessibleWashroomsInSuite:
                                    widget.accessibleWahshroms,
                                photo: imageFile.path,
                                noofBedrooms: int.parse(noofbedrroms),
                              );
                            } else {
                              //
                              accPosting = AccommodationPosting(
                                ///
                                advancePayment: 0,

                                rent: 10,
                                id: 0,
                                furnished: widget.furnished,
                                country: 'Pakistan',

                                title: titleCntrl.text,
                                phoneNumber: int.parse(phoneNoCntrl.text),

                                state: 'Kohat',
                                streetAddress: 'Jungle Khel',
                                zipCode: '2600',
                                aggreementType_id: 8,
                                description: descriptionController.text,
                                accommodationType_Id: 8,
                                city: 'Kohat',
                                sizeInSqft: widget.size,
                                // rent: int.parse(priceController.text),
                                smokingPermitted: widget.smookingPermitted,
                                visualAids: widget.visualAids,
                                utilitiesIncluded: widget.untilityIncluded,
                                petFriendly: widget.petFriendly,
                                personalOutdoorSpace:
                                    widget.personalOutdoorSpaces,
                                noofBathrooms: 10,
                                location: lctnController.text,
                                forRentBy: widget.forRentBy,
                                barrier_free_entrancesAndRamps:
                                    widget.barrierFreeEntrance,
                                appliances: widget.appliances,
                                accessibleWashroomsInSuite:
                                    widget.accessibleWahshroms,
                                photo: imageFile.path,
                                noofBedrooms: 5,
                              );
                            }
                            AccommodationPosting
                                accommodationPostingforPicUpload;
                            if (!widget.isNew) {
                              accommodationPostingforPicUpload =
                                  AccommodationPosting.WithId(
                                      id: int.parse(idController.text),

                                      // masjiId:
                                      //     int.parse(masjidI.seletected_value!.key),
                                      photo: imageFile.path
                                      //masjidId:int.parse(dropdown.seletected_value!.key),
                                      );
                            } else {
                              accommodationPostingforPicUpload =
                                  AccommodationPosting(
                                photo: imageFile.path,
                                //masjidId:int.parse(dropdown.seletected_value!.key),
                              );
                            }
                            await uploadImage(accommodationPostingforPicUpload);
                            await _saveForm(accPosting);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => home2())));
                          },
                          'Post Ad',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    //     SafeArea(
    //   child: NestedTabBarUser(
    //     tabbarbarLength: 2,
    //     frmNested: _form,
    //     nestedTabbarView: [
    //       Form(
    //         key: formKeys[0],
    //         child: SingleChildScrollView(
    //           child: Column(
    //             children: [
    //               midPadding2,
    //               // Container(
    //               //     child: CarouselSlider(
    //               //       carouselController: CarouselController(),
    //               //       options: CarouselOptions(
    //               //         aspectRatio: 2.0,
    //               //         enlargeCenterPage: true,
    //               //         scrollDirection: Axis.horizontal,
    //               //         autoPlay: true,
    //               //       ),
    //               //       items: imageSliders,
    //               //     )),

    //               Padding(
    //                 padding: const EdgeInsets.only(top: 15.0, left: 15),
    //                 child: const RichTextWidget(
    //                   text1: "Add Photos",
    //                   text2: "*",
    //                 ),
    //               ),
    //               (imageFileList!.isEmpty)
    //                   ? Padding(
    //                       padding: const EdgeInsets.all(15.0),
    //                       child: DottedBorder(
    //                         color: Colors.grey, //color of dotted/dash line
    //                         strokeWidth: 2, //thickness of dash/dots
    //                         dashPattern: const [10, 3],
    //                         child: Container(
    //                             color: Colors.white,
    //                             width: MediaQuery.of(context).size.width,
    //                             height: MediaQuery.of(context).size.height / 7,
    //                             child: Center(
    //                                 child: Column(
    //                               mainAxisAlignment: MainAxisAlignment.center,
    //                               children: [
    //                                 TextButton.icon(
    //                                     label: Text(
    //                                       'Upload',
    //                                       style: BlackTextStyleNormal,
    //                                     ),
    //                                     onPressed: () {
    //                                       selectImages();
    //                                     }, //icon: const
    //                                     icon: const Icon(
    //                                       Icons.camera_alt,
    //                                       color: blackColor,
    //                                     )),
    //                               ],
    //                             ))),
    //                       ),
    //                     )
    //                   : Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: GridView.builder(
    //                           shrinkWrap: true,
    //                           primary: false,
    //                           itemCount: imageFileList!.length,
    //                           gridDelegate:
    //                               SliverGridDelegateWithFixedCrossAxisCount(
    //                                   crossAxisCount: 3,
    //                                   mainAxisSpacing: 4,
    //                                   crossAxisSpacing: 4),
    //                           itemBuilder: (BuildContext context, int index) {
    //                             return ClipRRect(
    //                               borderRadius: BorderRadius.circular(8),
    //                               child: Image.file(
    //                                 File(imageFileList![index].path),
    //                                 fit: BoxFit.cover,
    //                               ),
    //                             );
    //                           }),
    //                     ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 10.0, bottom: 10),
    //                 child: Align(
    //                     alignment: Alignment.centerLeft,
    //                     child: Text(
    //                       "Type of Accommodation",
    //                       style: BlackTextStyleNormal16,
    //                     )),
    //               ),
    //               dropdownAccType,
    //               Padding(
    //                 padding: EdgeInsets.only(top: 10.0, bottom: 10),
    //                 child: Align(
    //                     alignment: Alignment.centerLeft,
    //                     child: Text(
    //                       "Type of Agreement",
    //                       style: BlackTextStyleNormal16,
    //                     )),
    //               ),
    //               dropdownagreementType,
    //               //     Container(
    //               //   height: MediaQuery.of(context).size.height/14,
    //               //   decoration: BoxDecoration(
    //               //       color: whiteColor,
    //               //       borderRadius: BorderRadius.circular(20),
    //               //       border: Border.all(color: Colors.grey)
    //               //     // shape: RoundedRectangleBorder(
    //               //     //   borderRadius: BorderRadius.circular(8),)
    //               //   ),
    //               //   child: Padding(
    //               //     padding: const EdgeInsets.only(left:10.0,right: 10,top: 5),
    //               //     child: DropdownButton<String>(
    //               //       value: dropdownValue,
    //               //       isExpanded: true,
    //               //       hint: Text('Select',style: TextStyle(color: blackColor),),
    //               //       dropdownColor: whiteColor,
    //               //       focusColor: whiteColor,
    //               //       underline: Text(""),
    //               //       elevation: 16,
    //               //       style: const TextStyle(color: blackColor),
    //               //       onChanged: (String? newValue) {
    //               //         setState(() {
    //               //           dropdownValue = newValue!;
    //               //         });
    //               //       },
    //               //       items:
    //               //           acctyp.map((String value) {
    //               //         return DropdownMenuItem(
    //               //           value: value,
    //               //           child: Text(value),
    //               //         );
    //               //       }).toList(),
    //               //     ),
    //               //   ),
    //               // ),
    //               AddScreenTextFieldWidget(
    //                 labelText: "Price*",
    //                 obsecureText: false,
    //                 controller: priceController,
    //                 textName: accPosting.rent.toString(),
    //                 inputType: TextInputType.number,
    //                 validator: (text) {
    //                   if (!(text!.length > 2) && text.isEmpty) {
    //                     return "Enter Price";
    //                   }
    //                   return null;
    //                 },
    //               ),
    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     noofbedrroms = v;
    //                   });
    //                 },
    //                 //width: 55,
    //                 title: 'No. of Bedrooms',
    //                 buttonLables: ['1', '2', '3', '4', '5', '6+'],
    //                 buttonValues: ['1', '2', '3', '4', '5+', '6+'],
    //               ),
    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     NoOFBathrooms = v;
    //                   });
    //                 },
    //                 //width: 55,
    //                 title: 'No. of Bathrooms',
    //                 buttonLables: [
    //                   '1',
    //                   '1.5',
    //                   '2',
    //                   '2.5',
    //                   '3',
    //                   '3.5',
    //                   '4',
    //                   '4.5'
    //                 ],
    //                 buttonValues: [
    //                   '1',
    //                   '1.5',
    //                   '2',
    //                   '2.5',
    //                   '3',
    //                   '3.5',
    //                   '4',
    //                   '4.5'
    //                 ],
    //               ),
    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     untilityIncluded = v;
    //                   });
    //                 },
    //                 //width: 65,
    //                 title: 'Utilities included',
    //                 buttonLables: ['None', 'Hydro', 'Heat', 'Water'],
    //                 buttonValues: ['None', 'Hydro', 'Heat', 'Water'],
    //               ),
    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     parkingIncluded = v;
    //                   });
    //                 },
    //                 // width: 55,
    //                 title: 'Parking included',
    //                 buttonLables: [
    //                   '1',
    //                   '2',
    //                   '3+',
    //                 ],
    //                 buttonValues: [
    //                   '1',
    //                   '2',
    //                   '3+',
    //                 ],
    //               ),
    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     furnished = v;
    //                   });
    //                 },
    //                 //width: 55,
    //                 title: 'Furnished',
    //                 buttonLables: ['Yes', 'No'],
    //                 buttonValues: ['Yes', 'No'],
    //               ),
    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     appliances = v;
    //                   });
    //                 },
    //                 //width: 0,
    //                 title: 'Appliances',
    //                 buttonLables: ['Laundry(In Unit)', 'Laundry(In Building)'],
    //                 buttonValues: ['Laundry(In Unit)', 'Laundry(In Building)'],
    //               ),
    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     petFriendly = v;
    //                   });
    //                 },
    //                 //width: 55,
    //                 title: 'Pet Friendly',
    //                 buttonLables: ['Yes', 'No', 'Limited'],
    //                 buttonValues: ['Yes', 'No', 'Limited'],
    //               ),

    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     barrierFreeEntrance = v;
    //                   });
    //                 },
    //                 //width: 55,
    //                 title: 'Barrier-free Entrances and Ramps',
    //                 buttonLables: ['Yes', 'No'],
    //                 buttonValues: ['Yes', 'No'],
    //               ),
    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     visualAids = v;
    //                   });
    //                 },
    //                 //width: 55,
    //                 title: 'Visual Aids',
    //                 buttonLables: ['Yes', 'No'],
    //                 buttonValues: ['Yes', 'No'],
    //               ),
    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     accessibleWahshroms = v;
    //                   });
    //                 },
    //                 //width: 55,
    //                 title: 'Accessible Washrooms in Suite',
    //                 buttonLables: ['Yes', 'No'],
    //                 buttonValues: ['Yes', 'No'],
    //               ),
    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     personalOutdoorSpaces = v;
    //                   });
    //                 },
    //                 title: 'Personal Outdoor Space',
    //                 buttonLables: ['None', 'Balcony', 'Yard'],
    //                 buttonValues: ['None', 'Balcony', 'Yard'],
    //               ),
    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     smookingPermitted = v;
    //                   });
    //                 },
    //                 title: 'Smoking Permitted',
    //                 buttonLables: ['Yes', 'No', 'Outdoors only'],
    //                 buttonValues: ['Yes', 'No', 'Outdoors only'],
    //               ),
    //               customRadio(
    //                 fn: (v) {
    //                   setState(() {
    //                     forRentBy = v;
    //                   });
    //                 },
    //                 title: 'For Rent By',
    //                 buttonLables: ['Owner', 'Professional'],
    //                 buttonValues: ['Owner', 'Professional'],
    //               ),
    //               // customRadio(   fn: (v){
    //               //   setState(() {
    //               //     agreementTypeString=v;
    //               //   });
    //               // },
    //               //   title: 'Agreement Type',
    //               //   buttonLables:  agreementType
    //               //       .map(
    //               //         (e) =>e.title.toString(),
    //               //   )
    //               //       .toList(),
    //               //   buttonValues: agreementType
    //               //       .map(
    //               //         (e) =>e.title.toString(),
    //               //   )
    //               //       .toList(),
    //               // ),

    //               // const Padding(
    //               //   padding:  EdgeInsets.only(top: 10.0,bottom: 10),
    //               //   child: Align(
    //               //       alignment: Alignment.centerLeft,
    //               //       child: Text("Features",
    //               //         style: BlackTextStyleNormal16,)),
    //               // ),
    //               // Container(
    //               //   height: MediaQuery.of(context).size.height/14,
    //               //   decoration: BoxDecoration(
    //               //       color: whiteColor,
    //               //       borderRadius: BorderRadius.circular(20),
    //               //       border: Border.all(color: Colors.grey)
    //               //     // shape: RoundedRectangleBorder(
    //               //     //   borderRadius: BorderRadius.circular(8),)
    //               //   ),
    //               //   child: Padding(
    //               //     padding: const EdgeInsets.only(left:10.0,right: 10,top: 5),
    //               //     child: DropdownButton<String>(
    //               //       isExpanded: true,
    //               //       hint: Text('Select',style: TextStyle(color: blackColor),),
    //               //       dropdownColor: whiteColor,
    //               //       focusColor: whiteColor,
    //               //       underline: Text(""),
    //               //       elevation: 16,
    //               //       style: const TextStyle(color: blackColor),
    //               //       onChanged: (String? newValue) {
    //               //         setState(() {
    //               //           dropdownValue = newValue!;
    //               //         });
    //               //       },
    //               //       items: <String>['Drawing Room', 'Dining Rooms', 'Kitchen',
    //               //         'Study Room','Lounge or Sitting Room','Laundry Room']
    //               //           .map((String value) {
    //               //         return DropdownMenuItem<String>(
    //               //           value: value,
    //               //           child: Text(value),
    //               //         );
    //               //       }).toList(),
    //               //     ),
    //               //   ),
    //               // ),
    //               const Padding(
    //                 padding: EdgeInsets.only(top: 10.0, bottom: 10),
    //                 child: Align(
    //                     alignment: Alignment.centerLeft,
    //                     child: Text(
    //                       "Amenities",
    //                       style: BlackTextStyleNormal16,
    //                     )),
    //               ),

    //               Card(
    //                 elevation: 0,
    //                 shape: RoundedRectangleBorder(
    //                   side: BorderSide(
    //                     width: 1,
    //                     color: Colors.grey,
    //                   ),
    //                   borderRadius: BorderRadius.circular(20),
    //                 ),
    //                 child: SearchChoices.multiple(
    //                   iconEnabledColor: appColor,
    //                   iconDisabledColor: Colors.grey,
    //                   items: amenitiesType
    //                       .map(
    //                         (e) => DropdownMenuItem(
    //                           child: Text(e.name.toString()),
    //                           value: e,
    //                         ),
    //                       )
    //                       .toList(),
    //                   selectedItems: selectedItemsMultiDialog,
    //                   hint: const Padding(
    //                     padding: EdgeInsets.all(12.0),
    //                     child: Text("Select"),
    //                   ),
    //                   underline: Container(),
    //                   searchHint: "Select",
    //                   searchInputDecoration: InputDecoration(),
    //                   onChanged: (value) {
    //                     setState(() {
    //                       selectedItemsMultiDialog = value;
    //                     });
    //                   },
    //                   closeButton: (selectedItems) {
    //                     return (selectedItems.isNotEmpty
    //                         ? "Save ${selectedItems.length == 0 ? '"${items[selectedItems.length].value}"' : '(${selectedItems.length})'}"
    //                         : "Save without selection");
    //                   },
    //                   isExpanded: true,
    //                 ),
    //               ),
    //               AddScreenTextFieldWidget(
    //                 labelText: "Area in Sqft",
    //                 obsecureText: false,
    //                 controller: areaController,
    //                 textName: accPosting.sizeInSqft.toString(),
    //                 inputType: TextInputType.number,
    //                 validator: (text) {
    //                   if (!(text!.length > 3) && text.isEmpty) {
    //                     return "Enter Area";
    //                   }
    //                   return null;
    //                 },
    //               ),
    //               // AddScreenTextFieldWidget(
    //               //   labelText: "Title",
    //               //   obsecureText: false,
    //               //   controller: titleController,
    //               //   textName: user.UserName.toString(),  inputType: TextInputType.name,
    //               //   validator: (text) {
    //               //     if (!(text!.length > 3) && text.isEmpty) {
    //               //       return "Enter valid title of more then 3 characters!";
    //               //     }
    //               //     return null;
    //               //   },
    //               // ),
    //               AddScreenTextFieldWidget(
    //                 labelText: "Title",
    //                 obsecureText: false,
    //                 controller: titleCntrl,
    //                 textName: '',
    //                 inputType: TextInputType.name,
    //                 validator: (text) {
    //                   if (!(text!.length > 3) && text.isEmpty) {
    //                     return "Please enter title";
    //                   }
    //                   return null;
    //                 },
    //               ),
    //               AddScreenTextFieldWidget(
    //                 labelText: "Description",
    //                 obsecureText: false,
    //                 controller: descriptionController,
    //                 textName: '',
    //                 inputType: TextInputType.name,
    //                 validator: (text) {
    //                   if (!(text!.length > 3) && text.isEmpty) {
    //                     return "Please enter descrtiption";
    //                   }
    //                   return null;
    //                 },
    //               ),
    //               SizedBox(
    //                 height: 280,
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //       Form(
    //         key: formKeys[1],
    //         child: Padding(
    //           padding: EdgeInsets.only(left: 10),
    //           child: Column(
    //             children: [
    //               SizedBox(
    //                 height: 12,
    //               ),
    //               AddScreenTextFieldWidget(
    //                 labelText: "Street address",
    //                 obsecureText: false,
    //                 controller: TextEditingController(),
    //                 textName: '',
    //                 inputType: TextInputType.text,
    //                 validator: (text) {
    //                   if (text!.isEmpty) {
    //                     return "* Required";
    //                   }
    //                   return null;
    //                 },
    //               ),
    //               Row(
    //                 children: [
    //                   Expanded(
    //                     child: AddScreenTextFieldWidget(
    //                       textFieldLength: 1,
    //                       labelText: "City",
    //                       obsecureText: false,
    //                       controller: cityController,
    //                       textName: '',
    //                       inputType: TextInputType.text,
    //                       validator: (value) {
    //                         if (value!.isEmpty) {
    //                           return 'Please enter you Country';
    //                         }
    //                         return null;
    //                       },
    //                     ),
    //                   ),
    //                   widthSizedBox12,
    //                   Expanded(
    //                     child: AddScreenTextFieldWidget(
    //                       textFieldLength: 1,
    //                       labelText: "state",
    //                       obsecureText: false,
    //                       controller: TextEditingController(),
    //                       textName: '',
    //                       inputType: TextInputType.number,
    //                       validator: (value) {
    //                         if (value!.isEmpty) {
    //                           return '* Required';
    //                         }
    //                         return null;
    //                       },
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               Row(
    //                 children: [
    //                   Expanded(
    //                     child: AddScreenTextFieldWidget(
    //                       textFieldLength: 1,
    //                       labelText: "Country",
    //                       obsecureText: false,
    //                       controller: TextEditingController(),
    //                       textName: '',
    //                       inputType: TextInputType.text,
    //                       validator: (value) {
    //                         if (value!.isEmpty) {
    //                           return 'Please enter you city';
    //                         }
    //                         return null;
    //                       },
    //                     ),
    //                   ),
    //                   widthSizedBox12,
    //                   Expanded(
    //                     child: AddScreenTextFieldWidget(
    //                       textFieldLength: 1,
    //                       labelText: "Zip/postal code",
    //                       obsecureText: false,
    //                       controller: TextEditingController(),
    //                       textName: '',
    //                       inputType: TextInputType.text,
    //                       validator: (value) {
    //                         if (value!.isEmpty) {
    //                           return 'Please enter you state';
    //                         }
    //                         return null;
    //                       },
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               AddScreenTextFieldWidget(
    //                 labelText: "Phone number",
    //                 obsecureText: false,
    //                 controller: TextEditingController(),
    //                 textName: '',
    //                 inputType: TextInputType.number,
    //                 validator: (value) {
    //                   if (value!.isEmpty) {
    //                     return '* Required';
    //                   }
    //                   return null;
    //                 },
    //               ),
    //               midPadding2,
    //               midPadding2,
    //               Container(
    //                 width: MediaQuery.of(context).size.width,
    //                 height: MediaQuery.of(context).size.height / 16,
    //                 child: ElevatedButton(
    //                     style: ElevatedButton.styleFrom(
    //                         primary: appColor, // background
    //                         onPrimary: Colors.white,
    //                         shape: const RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.all(
    //                                 Radius.circular(20))) // foreground
    //                         ),
    //                     onPressed: () async {
    //                       AccommodationPosting accPosting;
    //                       if (!widget.isNew) {
    //                         accPosting = AccommodationPosting.WithId(
    //                           advancePayment: 0,
    //                           id: int.parse(idController.text),
    //                           furnished: furnished,
    //                           country: countryCntrl.text,
    //                           title: titleCntrl.text,
    //                           phoneNumber: int.parse(phoneNoCntrl.text),
    //                           // state: statecntrl.text,
    //                           // streetAddress: streetAddresscntrl.text,
    //                           // zipCode: zipCodeCntrl.text,
    //                           // aggreementType_id: int.parse(
    //                           //     dropdownagreementType
    //                           //         .seletected_value!.key),
    //                           description: descriptionController.text,
    //                           // accommodationType_Id: int.parse(
    //                           //     dropdownAccType.seletected_value!.key),
    //                           // city: cityController.text,
    //                           // sizeInSqft: int.parse(areaController.text),
    //                           // rent: int.parse(priceController.text),
    //                           smokingPermitted: smookingPermitted,
    //                           visualAids: visualAids,
    //                           utilitiesIncluded: untilityIncluded,
    //                           petFriendly: petFriendly,
    //                           personalOutdoorSpace: personalOutdoorSpaces,
    //                           // noofBathrooms: double.parse(NoOFBathrooms),
    //                           forRentBy: forRentBy,
    //                           barrier_free_entrancesAndRamps:
    //                               barrierFreeEntrance,
    //                           appliances: appliances,
    //                           accessibleWashroomsInSuite: accessibleWahshroms,
    //                           // noofBedrooms: int.parse(noofbedrroms)
    //                         );
    //                       } else {
    //                         //
    //                         accPosting = AccommodationPosting(
    //                           ///
    //                           advancePayment: 0,
    //                           id: 0,
    //                           furnished: furnished,
    //                           // country: countryCntrl.text,
    //                           title: titleCntrl.text,
    //                           // phoneNumber: int.parse(phoneNoCntrl.text),
    //                           // state: statecntrl.text,
    //                           // streetAddress: streetAddresscntrl.text,
    //                           // zipCode: zipCodeCntrl.text,
    //                           // aggreementType_id: int.parse(
    //                           //     dropdownagreementType
    //                           //         .seletected_value!.key),
    //                           description: descriptionController.text,
    //                           // accommodationType_Id: int.parse(
    //                           //     dropdownAccType.seletected_value!.key),
    //                           // city: cityController.text,
    //                           // sizeInSqft: int.parse(areaController.text),
    //                           // rent: int.parse(priceController.text),
    //                           smokingPermitted: smookingPermitted,
    //                           visualAids: visualAids,
    //                           utilitiesIncluded: untilityIncluded,
    //                           petFriendly: petFriendly,
    //                           personalOutdoorSpace: personalOutdoorSpaces,
    //                           // noofBathrooms: double.parse(NoOFBathrooms),
    //                           forRentBy: forRentBy,
    //                           barrier_free_entrancesAndRamps:
    //                               barrierFreeEntrance,
    //                           appliances: appliances,
    //                           accessibleWashroomsInSuite: accessibleWahshroms,
    //                           // noofBedrooms: int.parse(noofbedrroms)
    //                         );
    //                       }
    //                       await _saveForm(accPosting);
    //                     },
    //                     // onPressed: ()async{
    //                     //   User user ;
    //                     //   if(!widget.isNew) {
    //                     //     user= User.WithId (
    //                     //         Id: int.parse ( idcontroller.text ),
    //                     //         org_id:int.parse(drpOrg.seletected_value!.key.toString()),
    //                     //         UserName: userNameController.text,
    //                     //         Email: emailController.text,
    //                     //         FullName: fullNameController.text,
    //                     //         PublicEmail: publicEmailController.text,
    //                     //         Password: passwordController.text,
    //                     //         ConfirmPassword: confirmPasswordController
    //                     //             .text,
    //                     //         // default_Role_Id: DropDown.SelectKeyValue?.key
    //                     //         default_Role_Id: int.parse(dropdown.seletected_value!.key)
    //                     //       // default_Role_Id:int.parse(dropdown.seletected_value!.key)
    //                     //     );
    //                     //   }
    //                     //   else
    //                     //   {
    //                     //     user=User(
    //                     //       default_Role_Id:widget.signup!=true?
    //                     //       int.parse(dropdown.seletected_value!.key):7,
    //                     //       org_id:int.parse(drpOrg.seletected_value!.key.toString()),
    //                     //       // default_Role_Id:int.parse(dropdown.seletected_value!.key),
    //                     //       UserName:userNameController.text,
    //                     //       Email: emailController.text,
    //                     //       FullName:fullNameController.text,
    //                     //       PublicEmail:publicEmailController.text,
    //                     //       Password:passwordController.text,
    //                     //       ConfirmPassword:confirmPasswordController.text,
    //                     //
    //                     //     );
    //                     //   }
    //                     //   await _saveForm(user);
    //                     // },
    //                     child: const Text('Post Now')),
    //               ),
    //             ],
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
                            'Accommodation Details',
                            style: TextStyle(color: whiteColor, fontSize: 12),
                            //style: appcolorTextStylebold,
                          ),
                        ))
                    : Tab(
                        text: "Accommodation Details",
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
