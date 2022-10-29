import 'dart:convert';
import 'dart:io';
import 'package:community_new/models/event.dart';
import 'package:community_new/widgets/roles_dropdown.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/user.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:community_new/api_services/api_services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../models/keyvalue.dart';
import '../../models/masjid.dart';
import '../../widgets/add_screen_text_field.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/extra_widgets.dart';
import 'Events.dart';

class EventEditnew extends StatefulWidget {
  final int? eventId;
  final bool isNew;
  const EventEditnew({Key? key, required this.eventId, required this.isNew})
      : super(key: key);
  @override
  _EventEditState createState() => _EventEditState();
}

class _EventEditState extends State<EventEditnew> {
  XFile imageFile = XFile('');
  var eventIdController = TextEditingController();
  var eventNameController = TextEditingController();
  var locationController = TextEditingController();
  var startDateController = TextEditingController();
  var startTimeController = TextEditingController();
  var endDateController = TextEditingController();
  var endTimeController = TextEditingController();
  var descriptionController = TextEditingController();
  var fullNameController = TextEditingController();
  var masjidIdController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var dropdown = new DropDown(mylist: []);
  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = pickedFile!;
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile!;
    });
    Navigator.pop(context);
  }

  //show dialog to give option of gallery and camera on camera icon
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: blackColor),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(height: 1, color: blackColor),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box,
                      color: appColor,
                    ),
                  ),
                  Divider(height: 1, color: blackColor),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text("Camera"),
                    leading: Icon(Icons.camera, color: appColor),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> uploadImage(Event event) async {
    String uploadurl = "http://ijtimaee.com/api/CommunityEvent/UploadPost";

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

//saving form after validation
  Future<void> _saveForm(Event event) async {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      if (widget.isNew) {
        await ApiServices.postEvent(event);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("event Added Successfully"),
        ));
      } else {
        await ApiServices.postEventbyid(eventIdController.text, event);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("event Updated Successfully"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please fill form correctly"),
      ));
    }
  }

  List<Masjid> masjids = [];
  List<KeyValue> Keyvaleus = [];
  KeyValue? selectedKeyValue;

  var event = new Event();

  _getEvent() async {
    int currentUserId = await prefs.get('userId');
    String currentRole = //'admin';
        await prefs.getString('role_name');

    if (currentRole == 'SuperAdmin') {
      await ApiServices.fetch(
        "masjid",
      ).then((response) {
        setState(() {
          Iterable listroles = json.decode(response.body);
          // print(list);
          masjids = listroles.map((model) => Masjid.fromJson(model)).toList();
//print(response.body);
          // copy roles into list<KeyVale> ListValues
          // for(int i=0;i<roles.length)
          //   {
          //
          //   }
          // Keyvaleus=[];

          // roles.insert(0, new Role(key:0,value:"please select Role"));
          if (masjids.length > 0) {
            Keyvaleus.add(
                new KeyValue(key: "0", value: "Please Select masjid"));
            for (int i = 0; i < masjids.length; i++) {
              Keyvaleus.add(new KeyValue(
                  key: masjids[i].Id.toString(), value: masjids[i].Name));
            }
            //dropdown=new DropDown(mylist: Keyvaleus);
          }
        });
      });
    } else if (currentRole == 'OrgAdmin') {
      await ApiServices.fetch("masjid",
              actionName: 'getfororgadmin', param1: currentUserId.toString())
          .then((response) {
        setState(() {
          Iterable listroles = json.decode(response.body);
          // print(list);
          masjids = listroles.map((model) => Masjid.fromJson(model)).toList();
//print(response.body);
          // copy roles into list<KeyVale> ListValues
          // for(int i=0;i<roles.length)
          //   {
          //
          //   }
          // Keyvaleus=[];

          // roles.insert(0, new Role(key:0,value:"please select Role"));
          if (masjids.length > 0) {
            Keyvaleus.add(
                new KeyValue(key: "0", value: "Please Select masjid"));
            for (int i = 0; i < masjids.length; i++) {
              Keyvaleus.add(new KeyValue(
                  key: masjids[i].Id.toString(), value: masjids[i].Name));
            }
            //dropdown=new DropDown(mylist: Keyvaleus);
          }
        });
      });
    } else if (currentRole == 'MasjidAdmin') {
      await ApiServices.fetch("masjid",
              actionName: 'getformasjidadmin', param1: currentUserId.toString())
          .then((response) {
        setState(() {
          Iterable listroles = json.decode(response.body);
          // print(list);
          masjids = listroles.map((model) => Masjid.fromJson(model)).toList();
//print(response.body);
          // copy roles into list<KeyVale> ListValues
          // for(int i=0;i<roles.length)
          //   {
          //
          //   }
          // Keyvaleus=[];

          // roles.insert(0, new Role(key:0,value:"please select Role"));
          if (masjids.length > 0) {
            Keyvaleus.add(
                new KeyValue(key: "0", value: "Please Select masjid"));
            for (int i = 0; i < masjids.length; i++) {
              Keyvaleus.add(new KeyValue(
                  key: masjids[i].Id.toString(), value: masjids[i].Name));
            }
            //dropdown=new DropDown(mylist: Keyvaleus);
          }
        });
      });
    } else if (currentRole == 'User') {
      await ApiServices.fetch("masjid", actionName: null, param1: null)
          .then((response) {
        setState(() {
          Iterable listroles = json.decode(response.body);
          // print(list);
          masjids = listroles.map((model) => Masjid.fromJson(model)).toList();
//print(response.body);
          // copy roles into list<KeyVale> ListValues
          // for(int i=0;i<roles.length)
          //   {
          //
          //   }
          // Keyvaleus=[];

          // roles.insert(0, new Role(key:0,value:"please select Role"));
          if (masjids.length > 0) {
            Keyvaleus.add(
                new KeyValue(key: "0", value: "Please Select masjid"));
            for (int i = 0; i < masjids.length; i++) {
              Keyvaleus.add(new KeyValue(
                  key: masjids[i].Id.toString(), value: masjids[i].Name));
            }
            //dropdown=new DropDown(mylist: Keyvaleus);
          }
        });
      });
    }

    print(Keyvaleus.length);
    if (widget.isNew == false) {
      await ApiServices.fetchForEdit(widget.eventId, 'communityevent')
          .then((response) {
        setState(() {
          var eventBody = json.decode(response.body);
          event = Event.fromJson(eventBody);
          // user=UserModel.fromJson(json.decode(response.body));
          // print(json.decode(response.body));
          //   Iterable list = json.decode(response.body);
          // user = list.map((model) => UserModel.fromJson(model)).toList()[0];
          print(eventBody);
          if (event != null) {
            eventIdController.text = event.Id.toString();

            //fullNameController.text = event.fullName.toString ( );
            eventNameController.text = event.name.toString();
            locationController.text = event.location.toString();

            startDateController.text =
                event.startDate == null ? "" : event.startDate.toString();
            endDateController.text =
                event.endDate == null ? "" : event.endDate.toString();

            startTimeController.text =
                event.startTime == null ? "" : event.startTime.toString();
            endTimeController.text =
                event.endTime == null ? "" : event.endTime.toString();

            descriptionController.text = event.description.toString();
            masjidIdController.text = event.masjiId.toString();
            //imageFile.path=event.eDocLink;
            // if (event.masjiId != "null" &&
            //     event.masjiId != null) {
            //  print(user.default_Role_Id.toString()+" user edit");
            //_selected_default_Role_Id=user.default_Role_Id;
            //print(_selected_default_Role_Id.toString()+" user edit");
            //_selected_default_Role_Id=user.default_Role_Id;
            //dropdown.seletected_default_Role_Id=user.default_Role_Id;
            //   selectedKeyValue = Keyvaleus.firstWhere ( (element) =>
            //   element.key == event.masjiId );
            //dropdown.seletected_value=selectedKeyValue;
            // }

            KeyValue testforMasjidId;
            if (event.masjiId != "null" && event.masjiId != null) {
              try {
                // print('try assign  masjid ' +selectedKeyValueOrgId!.key.toString());
                testforMasjidId = Keyvaleus.firstWhere(
                    (element) => element.key == event.masjiId.toString());
              } catch (e) {
                testforMasjidId = Keyvaleus[0];
              }
            } else {
              //print('after assign  masjid ' +
              //    selectedKeyValueOrgId!.value.toString());
              //print('inside if from masjid ' + masjid.Org_Id.toString());
              testforMasjidId = Keyvaleus[0];
            }

            selectedKeyValue = testforMasjidId;
          }
        });
      });
    }
    dropdown =
        new DropDown(mylist: Keyvaleus, seletected_value: selectedKeyValue);
  }

  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];

  void selectImages() async {
    //http:ijtimaee.com/api/images/edoclink[index]['images']
    //imagesfilelist[index].name
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //if(widget.isNew==false){
    _getEvent();

    //dropdown= DropDown(mylist: Keyvaleus);
    //}
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

  showAlertDialog(BuildContext context) {
    // Create button
    Widget yesButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop(true);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Events()));
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
    // dropdown.mylist=Keyvaleus;
    // dropdown.seletected_value=selectedKeyValue;
    return SafeArea(
      child: Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: whiteColor,
            leading: IconButton(
              onPressed: () {
                showAlertDialog(context);
              },
              icon: Icon(
                CupertinoIcons.chevron_left,
                color: appColor,
              ),
            ),
            centerTitle: true,
            title: widget.isNew == false
                ? Text(
                    "Edit Event",
                    style: TextStyle(
                        fontSize: 20,
                        color: appColor,
                        fontWeight: FontWeight.normal),
                  )
                : Text(
                    "Add Event",
                    style: TextStyle(
                        fontSize: 20,
                        color: appColor,
                        fontWeight: FontWeight.normal),
                  ),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: IconButton(onPressed: (){Navigator.pop(context);
                  //   },
                  //   icon: Icon(Icons.arrow_back),
                  //   ),
                  // ),
                  // Center(child:widget.isNew==false? Text("Edit Event",style: TextStyle(fontSize: 24),):
                  // Text("Add Event",style: TextStyle(fontSize: 24),),),

                  midPadding2,
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 15),
                    child: const RichTextWidget(
                      text1: "Event Photos",
                      text2: "*",
                    ),
                  ),
                  (imageFileList!.isEmpty)
                      ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: DottedBorder(
                            color: Colors.grey, //color of dotted/dash line
                            strokeWidth: 2, //thickness of dash/dots
                            dashPattern: const [10, 3],
                            child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 7,
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton.icon(
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
                                  ],
                                ))),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
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
                        ),

                  // midPadding2,
                  // Padding(
                  //   padding: const EdgeInsets.only(top:15.0,left: 15),
                  //   child: const  RichTextWidget(text1: "Event Photos",text2: "*",),
                  // ),
                  // ( imageFile==null)?Padding(
                  //   padding: const EdgeInsets.all(15.0),
                  //   child: DottedBorder(
                  //     color: Colors.grey,//color of dotted/dash line
                  //     strokeWidth: 2, //thickness of dash/dots
                  //     dashPattern: const [10,3],
                  //     child: Container(
                  //         color: Colors.white,
                  //         width: MediaQuery.of(context).size.width/3,
                  //         height: MediaQuery.of(context).size.height/5,
                  //         child: Center(
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               TextButton.icon(
                  //                 label: Text('Upload',style: BlackTextStyleNormal,),
                  //                   onPressed: (){
                  //                     _showChoiceDialog(context);
                  //                   }, //icon: const
                  //                   icon: const Icon(Icons.camera_alt,color: blackColor,)
                  //               ),
                  //
                  //             ],
                  //           )
                  //         )
                  //     ),
                  //   ),
                  // ):Padding(
                  //   padding: const EdgeInsets.all(15.0),
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width/3,
                  //     height: MediaQuery.of(context).size.height/5,
                  //     child:Image.file( File(  imageFile.path)),),
                  // ),

                  // SizedBox(height: MediaQuery.of(context).size.height/10,),
                  //DropDown(seletected_value: selectedKeyValue,mylist: Keyvaleus),
                  // Padding(
                  //   padding: const EdgeInsets.only(top:15.0,left: 15),
                  //   child: AddScreenTextFieldWidget(
                  //     p_readOnly: true,
                  //     labelText: "Id",
                  //     obsecureText: false,
                  //     controller: eventIdController,
                  //     textName: "id",
                  //     inputType: TextInputType.number,
                  //     // validator: (val) {
                  //     //   if (val.isEmpty) {
                  //     //     return "Full Name cannot be empty";
                  //     //   } else {
                  //     //     return null;
                  //     //   }
                  //     // },
                  //   ),
                  // ),
                  const Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8, left: 15, right: 15),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Masjid Name",
                          style: BlackTextStyleNormal16,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15),
                    child: dropdown,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15),
                    child: AddScreenTextFieldWidget(
                      labelText: "Event Name",
                      obsecureText: false,
                      controller: eventNameController,
                      textName: event.name.toString(),
                      inputType: TextInputType.name,
                      validator: (text) {
                        if (!(text!.length > 5) && text.isEmpty) {
                          return "Enter event name of more then 5 characters!";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15),
                    child: AddScreenTextFieldWidget(
                      icn: Icons.location_on,
                      locationIcon: () async {
                        Position position = await _getGeoLocationPosition();
                        GetAddressFromLatLong(position);
                      },
                      labelText: "Location",
                      obsecureText: false,
                      controller: TextEditingController(
                          text: Address == 'search'
                              ? locationController.text
                              : Address),
                      textName: event.location.toString(),
                      inputType: TextInputType.name,
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "*Required";
                        }
                        return null;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: AddScreenTextFieldWidget(
                            textFieldLength: 1,
                            labelText: "Start Date",
                            ontap: onTappedFunctionOfStartDate,
                            obsecureText: false,
                            controller: startDateController,
                            textName: event.startDate.toString(),
                            inputType: TextInputType.none,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "*Required";
                              }
                              return null;
                            },
                          ),
                        ),
                        widthSizedBox8,
                        Expanded(
                          child: AddScreenTextFieldWidget(
                            textFieldLength: 1,
                            labelText: "Start Time",
                            ontap: ontappedFunctionOfStartTime,
                            obsecureText: false,
                            controller: startTimeController,
                            textName: event.startTime.toString(),
                            inputType: TextInputType.none,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "*Required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: AddScreenTextFieldWidget(
                            textFieldLength: 1,
                            labelText: "End Date",
                            ontap: onTappedFunctionOfEndDate,
                            obsecureText: false,
                            controller: endDateController,
                            textName: event.endDate.toString(),
                            inputType: TextInputType.none,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "*Required";
                              }
                              return null;
                            },
                          ),
                        ),
                        widthSizedBox8,
                        Expanded(
                          child: AddScreenTextFieldWidget(
                            textFieldLength: 1,
                            labelText: "End Time",
                            ontap: ontappedFunctionOfEndTime,
                            obsecureText: false,
                            controller: endTimeController,
                            textName: event.endTime.toString(),
                            inputType: TextInputType.none,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "*Required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15),
                    child: AddScreenTextFieldWidget(
                      labelText: "Description",
                      obsecureText: false,
                      controller: descriptionController,
                      textName: event.description.toString(),
                      inputType: TextInputType.name,
                      validator: (text) {
                        if (!(text!.length > 5) && text.isEmpty) {
                          return "Description should be more then 5 characters!";
                        }
                        return null;
                      },
                    ),
                  ),

                  // SizedBox(height: 10,),
                  // Text('ADDRESS',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                  // SizedBox(height: 10,),
                  // Text('${Address}'),
                  // ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         primary: appColor, // background
                  //         onPrimary: Colors.white,
                  //         shape: const RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.all(Radius.circular(10))
                  //         )// foreground
                  //     ),
                  //     onPressed: () async{
                  //   Position position = await _getGeoLocationPosition();
                  //   GetAddressFromLatLong(position);
                  // }, child: Text('Get Location')),

                  // FadeInImage(
                  //   placeholderErrorBuilder:  (context, error, stackTrace) {
                  //     return Container(
                  //       child: CircularProgressIndicator(
                  //         color: appColor,
                  //         backgroundColor: Colors.grey.shade200,
                  //       ),
                  //     );
                  //   },
                  //   height: 30,
                  //   image: AssetImage('assets/community.png'),
                  //   placeholder: AssetImage('assets/community.png'),
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.only(right:15.0,left: 15),
                  //   child: AddScreenTextFieldWidget(
                  //     labelText: "full Name",
                  //     obsecureText: false,
                  //     controller: fullNameController,
                  //     textName: event.fullName.toString(),  inputType: TextInputType.name,
                  //     validator: (text) {
                  //       if (!(text!.length > 5) && text.isEmpty) {
                  //         return "Enter full name of more then 5 characters!";
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),

                  midPadding,
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 16,
                    child: ElevatedButton(
                      onPressed: () async {
                        Event event;
                        if (!widget.isNew) {
                          event = Event.withId(
                              fullName: '',
                              Id: int.parse(eventIdController.text),
                              name: eventNameController.text,
                              //fullName: fullNameController.text,
                              endTime: endTimeController.text,
                              endDate: endDateController.text,
                              startTime: startTimeController.text,
                              startDate: startDateController.text,
                              description: descriptionController.text,
                              location: locationController.text,
                              masjiId:
                                  int.parse(dropdown.seletected_value!.key),
                              eDocLink: imageFile.path
                              //masjidId:int.parse(dropdown.seletected_value!.key),
                              );
                        } else {
                          event = Event(
                              fullName: '',
                              Id: 0,
                              name: eventNameController.text,
                              // fullName: fullNameController.text,
                              endTime: endTimeController.text,
                              endDate: endDateController.text,
                              startTime: startTimeController.text,
                              startDate: startDateController.text,
                              description: descriptionController.text,
                              location: locationController.text,
                              masjiId:
                                  int.parse(dropdown.seletected_value!.key),
                              eDocLink: imageFile.path
                              //masjidId:int.parse(dropdown.seletected_value!.key),
                              );
                        }

                        Event eventforpicupload;
                        if (!widget.isNew) {
                          eventforpicupload = Event.withId(
                              Id: int.parse(eventIdController.text),
                              masjiId:
                                  int.parse(dropdown.seletected_value!.key),
                              eDocLink: imageFile.path
                              //masjidId:int.parse(dropdown.seletected_value!.key),
                              );
                        } else {
                          eventforpicupload = Event(
                              masjiId:
                                  int.parse(dropdown.seletected_value!.key),
                              eDocLink: imageFile.path
                              //masjidId:int.parse(dropdown.seletected_value!.key),
                              );
                        }
                        await uploadImage(eventforpicupload);
                        await _saveForm(event);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: appColor, // background
                          onPrimary: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20))) // foreground
                          ),
                      child: const Text("Save"),
                    ),
                  ),
                  midPadding2,
                  midPadding2,
                ],
              ),
            ),
          )),
    );
  }

  Future ontappedFunctionOfStartTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      DateTime parsedTime = DateFormat.jm().parse(pickedTime
          .replacing(hour: pickedTime.hourOfPeriod)
          .format(context)
          .toString());
      String formattedTime = DateFormat('HH:mm a').format(parsedTime);

      setState(() {
        startTimeController.text = formattedTime; //set the value of text field.
      });
    } else {
      //print("Time is not selected");
    }
  }

// start date function
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
        startDateController.text =
            formattedDate; //set output date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }

  //end time function
  Future ontappedFunctionOfEndTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      DateTime parsedTime = DateFormat.jm().parse(pickedTime
          .replacing(hour: pickedTime.hourOfPeriod)
          .format(context)
          .toString());
      String formattedTime = DateFormat('HH:mm a').format(parsedTime);

      setState(() {
        endTimeController.text = formattedTime; //set the value of text field.
      });
    } else {
      print("Time is not selected");
    }
  }

  //end date function
  Future onTappedFunctionOfEndDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        endDateController.text =
            formattedDate; //set output date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }
}
