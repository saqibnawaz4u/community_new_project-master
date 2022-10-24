import 'dart:convert';
import 'dart:developer';

import 'package:community_new/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:csc_picker/csc_picker.dart';
import '../../api_services/api_services.dart';
import '../../models/CodeBook.dart';
import '../../models/MasjidAdmin.dart';
import '../../models/OrgAdmin.dart';
import '../../models/keyvalue.dart';
import '../../models/masjid.dart';
import '../../models/organization.dart';
import '../../models/user.dart';
import '../../provider/FavouriteItemProvider.dart';
import '../../widgets/add_screen_text_field.dart';
import '../../widgets/dropdown.dart';
import 'Masjids.dart';

class EditMasjidStepper extends StatefulWidget {
  final String masjidId;
  final bool isNew;
  List<MasjidAdminModel> objMasjidAdmin1 = [];
  EditMasjidStepper(
      {Key? key,
      required this.masjidId,
      required this.isNew,
      required this.objMasjidAdmin1})
      : super(key: key);
  @override
  _EditMasjidStepperState createState() => _EditMasjidStepperState();
}

class _EditMasjidStepperState extends State<EditMasjidStepper>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<EditMasjidStepper> {
  int _activeStepIndex = 0;
  // GlobalKey<FormState> _formKey =  GlobalKey<FormState>();//for storing form state.
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  String countryValue = "";
  String? stateValue;
  String? cityValue;
  var idController = TextEditingController();
  var OrgIdController = TextEditingController();
  var masjidNameController = TextEditingController();
  var fajrController = TextEditingController();
  var duhrController = TextEditingController();
  var asrController = TextEditingController();
  var maghribController = TextEditingController();
  var ishaController = TextEditingController();
  var descriptiomController = TextEditingController();
  var locationController = TextEditingController();
  var emailController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var countryController = TextEditingController();
  var postalCodeController = TextEditingController();
  var phoneController = TextEditingController();
  var drpOrg = new DropDown(mylist: []);
  final _form = GlobalKey<FormState>(); //for storing form state.
  List<Organization> organizations = [];

  List<bool> isChecked = [];
  List<KeyValue> Keyvaleus = [];
  //List<MasjidAdminModel> objMasjidusers = [] ;
  var organization = Organization();
  KeyValue? selectedKeyValueOrgId;
  List<MasjidAdminModel> objMasjidAdmin2 = [];
  Future<void> _saveForm(Masjid masjid) async {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      if (widget.isNew) {
        await ApiServices.postMasjid(masjid);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Masjid Added Successfully")));
      } else {
        await ApiServices.postmasjidbyid(idController.text, masjid);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Masjid Updated Successfully"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please fill form correctly"),
      ));
    }
  }

  var masjid = new Masjid();
  // List<Masjid> masjids = [] ;
  FocusNode myFocusNode = FocusNode();
  bool isSelected(int? p_Id) {
    if (widget.objMasjidAdmin1 == null) return false;
    for (int i = 0; i < widget.objMasjidAdmin1.length; i++)
      if (widget.objMasjidAdmin1[i].user_Id == p_Id) return true;
    return false;
  }

  final ApiServices apiService = ApiServices();
  List<User> users = [];
  _getUser() async {
    // await ApiServices.fetch ( 'user' ).then ( (response) {
    //   setState ( () {
    //     Iterable list = json.decode ( response.body );
    //     users = list.map ( (model) => User.fromJson ( model ) ).toList ( );
    //     //print(response.body);
    //   } );
    // } );
    await ApiServices.fetch('user',
            actionName: 'getusersbyrolename', //getformasjidadmin
            param1: 'masjidadmin')
        .then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) => User.fromJson(model)).toList();
        //  print(response.body);
      });
    }).whenComplete(() => setState(() {}));
    isChecked = await List<bool>.filled(users.length, false);
    for (int i = 0; i < users.length; i++) {
      //if(isSelected(users[i].Id)){
      isChecked[i] = isSelected(users[i].Id);
    }
    // List<OrgUser> selectedOrgUser = [];
    // bool _value = false;
  }

  _getMasjid() async {
    await ApiServices.fetch("organization").then((response) {
      setState(() {
        Iterable listorganizations = json.decode(response.body);
        organizations = listorganizations
            .map((model) => Organization.fromJson(model))
            .toList();
        //org parent id dropdown
        if (organizations.length > 0) {
          Keyvaleus.add(KeyValue(key: '0', value: "Please select Organzation"));
          for (int i = 0; i < organizations.length; i++) {
            Keyvaleus.add(KeyValue(
                key: organizations[i].Id.toString(),
                value: organizations[i].description.toString()));
          }
        }
      });
    }).whenComplete(() => setState(() {}));
    if (widget.isNew == false) {
      ApiServices.fetchForEdit(int.parse(widget.masjidId), 'masjid')
          .then((response) {
        setState(() {
          var masjidBody = json.decode(response.body);
          masjid = Masjid.fromJsonWithUsers(masjidBody);
          // user=UserModel.fromJson(json.decode(response.body));
          // print(json.decode(response.body));
          //   Iterable list = json.decode(response.body);
          // user = list.map((model) => UserModel.fromJson(model)).toList()[0];
          // print(masjid.Email.toString());
          //  print(masjidBody);
          if (masjid != null) {
            idController.text = masjid.Id.toString();
            fajrController.text = masjid.Fajr.toString();
            duhrController.text = masjid.Duhr.toString();
            asrController.text = masjid.Asr.toString();
            maghribController.text = masjid.Maghrib.toString();
            ishaController.text = masjid.Isha.toString();
            OrgIdController.text = masjid.Org_Id.toString();
            emailController.text = masjid.Email.toString();
            masjidNameController.text = masjid.Name.toString();
            locationController.text = masjid.Location.toString();
            descriptiomController.text = masjid.Description.toString();
            cityController.text = masjid.City.toString();
            countryController.text = masjid.Country.toString();
            phoneController.text = masjid.Phone1.toString();
            postalCodeController.text = masjid.PostalCode.toString();
            stateController.text = masjid.State.toString();

            if (widget.objMasjidAdmin1 == null) {
              objMasjidAdmin2 = masjid.Masjid_admin;
              widget.objMasjidAdmin1 = masjid.Masjid_admin;
            } else {
              objMasjidAdmin2 = widget.objMasjidAdmin1;
            }

            KeyValue testforOrgId;

            if (masjid.Org_Id != "null" && masjid.Org_Id != null) {
              try {
                // print('try assign  masjid ' +selectedKeyValueOrgId!.key.toString());
                testforOrgId = Keyvaleus.firstWhere(
                    (element) => element.key == masjid.Org_Id.toString());
              } catch (e) {
                testforOrgId = Keyvaleus[0];
              }
            } else {
              //print('after assign  masjid ' +
              //    selectedKeyValueOrgId!.value.toString());
              //print('inside if from masjid ' + masjid.Org_Id.toString());
              testforOrgId = Keyvaleus[0];
            }

            selectedKeyValueOrgId = testforOrgId;
            // print('before assign  masjid ' +selectedKeyValueOrgId!.key.toString());
          }
          // print('outside assign  masjid ' +selectedKeyValueOrgId!.value.toString());
          drpOrg = DropDown(
              mylist: Keyvaleus, seletected_value: selectedKeyValueOrgId);
        });
      });
    } else {
      if (Keyvaleus != null && Keyvaleus.length > 0) {
        selectedKeyValueOrgId = Keyvaleus[0];
      }
      //print('ok masjid ' +selectedKeyValueOrgId!.key.toString());
      OrgIdController.text = masjid.Org_Id.toString();
      drpOrg =
          DropDown(mylist: Keyvaleus, seletected_value: selectedKeyValueOrgId);

      var currentid = prefs.getInt('userId');
      var currentuserName = prefs.getString('userName');
      objMasjidAdmin2.add(MasjidAdminModel(
          masjid_Id: 0, user_Id: currentid, userName: currentuserName));
    }

    // drpOrg=new DropDown(mylist: Keyvaleus,
    //     seletected_value: selectedKeyValueOrgId);
    //print('try assign  masjid ' +selectedKeyValueOrgId!.key.toString());
  }

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
      print('Has focus: $myFocusNode.hasFocus');
    });
    //if(widget.isNew==false){
    _getUser();
    _getMasjid();
    // }
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    _tabController.notifyListeners();
  }

  Future fajrTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      DateTime parsedTime = DateFormat.jm().parse(pickedTime
          .replacing(hour: pickedTime.hourOfPeriod)
          .format(context)
          .toString());
      var inputDate = DateTime.parse(parsedTime.toString());
      var outPutFormat = DateFormat.jm();
      var outputDate = outPutFormat.format(inputDate);

      setState(() {
        fajrController.text = outputDate; //set the value of text field.
      });
    } else {
      //print("Time is not selected");
    }
  }

  Future duhrTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      DateTime parsedTime = DateFormat.jm().parse(pickedTime
          .replacing(hour: pickedTime.hourOfPeriod)
          .format(context)
          .toString());
      var inputDate = DateTime.parse(parsedTime.toString());
      var outPutFormat = DateFormat.jm();
      var outputDate = outPutFormat.format(inputDate);

      setState(() {
        duhrController.text = outputDate; //set the value of text field.
      });
    } else {
      //print("Time is not selected");
    }
  }

  Future asrTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      DateTime parsedTime = DateFormat.jm().parse(pickedTime
          .replacing(hour: pickedTime.hourOfPeriod)
          .format(context)
          .toString());
      var inputDate = DateTime.parse(parsedTime.toString());
      var outPutFormat = DateFormat.jm();
      var outputDate = outPutFormat.format(inputDate);

      setState(() {
        asrController.text = outputDate; //set the value of text field.
      });
    } else {
      //print("Time is not selected");
    }
  }

  Future maghribTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      DateTime parsedTime = DateFormat.jm().parse(pickedTime
          .replacing(hour: pickedTime.hourOfPeriod)
          .format(context)
          .toString());
      var inputDate = DateTime.parse(parsedTime.toString());
      var outPutFormat = DateFormat.jm();
      var outputDate = outPutFormat.format(inputDate);

      setState(() {
        maghribController.text = outputDate; //set the value of text field.
      });
    } else {
      //print("Time is not selected");
    }
  }

  Future ishaTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      DateTime parsedTime = DateFormat.jm().parse(pickedTime
          .replacing(hour: pickedTime.hourOfPeriod)
          .format(context)
          .toString());
      //String formattedTime = DateFormat.jm().format(parsedTime);

      var inputDate = DateTime.parse(parsedTime.toString());
      var outPutFormat = DateFormat.jm();
      var outputDate = outPutFormat.format(inputDate);
      setState(() {
        ishaController.text = outputDate; //set the value of text field.
      });
    } else {
      //print("Time is not selected");
    }
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
  // List<Step> stepList() => [
  //   Step(
  //     state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
  //     isActive: _activeStepIndex >= 0,
  //     title: const Text('Masjid Detail'),
  //     content: Form(
  //       key: formKeys[0],
  //       child: Container(
  //         child: Column(
  //           children: [
  //             AddScreenTextFieldWidget(
  //               labelText: "Masjid Name",
  //               obsecureText: false,
  //               controller: masjidNameController,
  //               textName:  masjid.Name.toString(),  inputType: TextInputType.name,
  //               validator: (text) {
  //                 if (!(text!.length > 5) && text.isEmpty) {
  //                   return "Enter Masjid name of more then 5 characters!";
  //                 }
  //                 return null;
  //               },
  //             ),
  //             const Padding(
  //               padding: const EdgeInsets.only(top: 10.0,bottom: 10),
  //               child: Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text("Organization ",
  //                     style: BlackTextStyleNormal16,)),
  //             ),
  //             drpOrg,
  //             AddScreenTextFieldWidget(
  //               labelText: "Description",
  //               obsecureText: false,
  //               controller: descriptiomController,
  //               textName: masjid.Description.toString(),
  //               inputType: TextInputType.multiline,
  //               validator: (value){
  //                 if (!(value!.length > 5) && value.isEmpty) {
  //                   return "Description should not be less than 5 characters";
  //                 }
  //                 return null;
  //               },
  //             ),
  //             midPadding,
  //           ],
  //         ),
  //       ),
  //     ),
  //   ),
  //   Step(
  //     state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
  //     isActive: _activeStepIndex >= 1,
  //     title: const Text('Prayer Times'),
  //     content: Form(
  //       key: formKeys[1],
  //       child: Column(
  //         //shrinkWrap: true,
  //         children: [
  //           Row(children: [
  //             Flexible(child: Text('Fajr          ',style: const TextStyle(
  //               fontSize: 16, ),)),
  //             widthSizedBox8,
  //             Flexible(
  //               flex: 4,
  //               child: AddScreenTextFieldWidget(
  //                 ontap: fajrTime,
  //                 labelText: '',
  //                 obsecureText: false,
  //                 controller: fajrController,
  //                 textName:  masjid.Fajr.toString(),
  //                 inputType: TextInputType.none,
  //                 validator: (text) {
  //                   if (!(text!.length > 3) || text.isEmpty) {
  //                     return "Please enter valid time";
  //                   }
  //                   return null;
  //                 },
  //               ),
  //             ),
  //           ],),
  //           Row(
  //             children: [
  //               Flexible(child: Text('Duhr          ',style: const TextStyle(
  //                 fontSize: 16, ),)), widthSizedBox8,
  //               Flexible(
  //                 flex: 4,
  //                 child: AddScreenTextFieldWidget(
  //                   ontap: duhrTime,
  //                   labelText: "",
  //                   obsecureText: false,
  //                   controller: duhrController,
  //                   textName: masjid.Duhr.toString(),
  //                   inputType: TextInputType.none,
  //                   validator: (value){
  //                     if (!(value!.length > 3) || value.isEmpty) {
  //                       return "Please enter valid time";
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Row(children: [
  //             Flexible(child: Text('Asr           ',style: const TextStyle(
  //               fontSize: 16, ),)), widthSizedBox8,
  //             Flexible(
  //               flex: 4,
  //               child: AddScreenTextFieldWidget(
  //                 ontap: asrTime,
  //                 labelText: "",
  //                 obsecureText: false,
  //                 controller: asrController,
  //                 textName: masjid.Asr.toString(),
  //                 inputType: TextInputType.none,
  //                 validator: (value){
  //                   if (!(value!.length > 3) || value.isEmpty) {
  //                     return "Please enter valid time";
  //                   }
  //                   return null;
  //                 },
  //               ),
  //             ),
  //           ],),
  //           Row(children: [
  //             Expanded(child: Text('Maghrib',style: const TextStyle(
  //               fontSize: 16, ),)),
  //             widthSizedBox8,
  //             Flexible(
  //               flex: 4,
  //               child: AddScreenTextFieldWidget(
  //                 ontap: maghribTime,
  //                 labelText: "",
  //                 obsecureText: false,
  //                 controller: maghribController,
  //                 textName: masjid.Maghrib.toString(),
  //                 inputType: TextInputType.none,
  //                 validator: (value){
  //                   if (!(value!.length > 3) || value.isEmpty) {
  //                     return "Please enter valid time";
  //                   }
  //                   return null;
  //                 },
  //               ),
  //             ),
  //           ],),
  //           Row(children: [
  //             Flexible(child: Text('Isha          ',style: const TextStyle(
  //               fontSize: 16, ),)), widthSizedBox8,
  //             Flexible(
  //               flex: 4,
  //               child: AddScreenTextFieldWidget(
  //                 ontap: ishaTime,
  //                 labelText: "",
  //                 obsecureText: false,
  //                 controller: ishaController,
  //                 textName: masjid.Isha.toString(),
  //                 inputType: TextInputType.none,
  //                 validator: (value){
  //                   if (!(value!.length > 3) || value.isEmpty) {
  //                     return "Please enter valid time";
  //                   }
  //                   return null;
  //                 },
  //               ),
  //             ),
  //           ],),
  //           midPadding,
  //         ],
  //       ),
  //     ),
  //   ),
  //   Step(
  //       state:
  //       _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
  //       isActive: _activeStepIndex >= 2,
  //       title: const Text('Address'),
  //       content: Form(
  //         key: formKeys[2],
  //         child: Container(
  //           child: Column(
  //             children: [
  //               Row(children: [
  //                 Expanded(
  //                   child: AddScreenTextFieldWidget(
  //                     labelText: "Country",
  //                     obsecureText: false,
  //                     controller: countryController,
  //                     textName: masjid.Country.toString(),  inputType: TextInputType.text,
  //                     validator: ( value){
  //                       if(value!.isEmpty)
  //                       {
  //                         return 'Please enter you Country';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                 ),widthSizedBox12,
  //                 Expanded(
  //                   child: AddScreenTextFieldWidget(
  //                     labelText: "State name",
  //                     obsecureText: false,
  //                     controller: stateController,
  //                     textName: masjid.State.toString(),  inputType: TextInputType.text,
  //                     validator: ( value){
  //                       if(value!.isEmpty)
  //                       {
  //                         return 'Please enter you state';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                 ),
  //
  //               ],),
  //               Row(children: [
  //                 Expanded(
  //                   child: AddScreenTextFieldWidget(
  //                     labelText: "City",
  //                     obsecureText: false,
  //                     controller: cityController,
  //                     textName: masjid.City.toString(),
  //                     inputType: TextInputType.text,
  //                     validator: ( value){
  //                       if(value!.isEmpty)
  //                       {
  //                         return 'Please enter you city';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                 ),
  //                 widthSizedBox12,
  //                 Expanded(
  //                   child: AddScreenTextFieldWidget(
  //                     labelText: "Postal Code",
  //                     obsecureText: false,
  //                     controller: postalCodeController,
  //                     textName: masjid.PostalCode.toString(),  inputType: TextInputType.number,
  //                     validator: ( value){
  //                       if(value!.isEmpty)
  //                       {
  //                         return '* Required';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                 ),
  //               ],),
  //               AddScreenTextFieldWidget(
  //                 labelText: "location",
  //                 obsecureText: false,
  //                 controller: locationController,
  //                 textName: masjid.Location.toString(),  inputType: TextInputType.text,
  //                 validator: (text) {
  //                   if ( text!.isEmpty) {
  //                     return "* Required";
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               AddScreenTextFieldWidget(
  //                 labelText: "Email",
  //                 obsecureText: false,
  //                 controller: emailController,
  //                 textName:masjid.Email.toString(),  inputType: TextInputType.emailAddress,
  //                 validator: (value){
  //                   if(value!.isEmpty)
  //                   {
  //                     return 'Please Enter your email';
  //                   }
  //                   if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
  //                     return 'Please enter a valid Email';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               AddScreenTextFieldWidget(
  //                 labelText: "Phone Number",
  //                 obsecureText: false,
  //                 controller: phoneController,
  //                 textName: masjid.Phone1.toString(),  inputType: TextInputType.number,
  //                 validator: ( value){
  //                   if(value!.isEmpty)
  //                   {
  //                     return '* Required';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               midPadding,
  //             ],
  //           ),
  //         ),
  //       )),
  // ];

  showAlertDialog(BuildContext context) {
    // Create button
    Widget yesButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop(true);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Masjids()));
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
    final favouriteItemProvider = Provider.of<FavouriteItemProvider>(context);
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
    return DefaultTabController(
      //animationDuration: Duration(milliseconds: 1),
      length: 2,
      child: Scaffold(
          //key: _form,
          backgroundColor: whiteColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Theme(
              data: ThemeData(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: AppBar(
                elevation: 0,
                leading: IconButton(
                  color: appColor,
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  icon: Icon(CupertinoIcons.chevron_back),
                ),
                backgroundColor: whiteColor,
                bottom: TabBar(
                  labelStyle: TextStyle(fontSize: 15),
                  unselectedLabelStyle: TextStyle(fontSize: 15),
                  automaticIndicatorColorAdjustment: true,
                  labelColor: appColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: appColor,
                  unselectedLabelColor: Colors.grey,
                  controller: _tabController,
                  tabs: [
                    // _tabController.index==0?
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color:offWhite,
                    //       borderRadius: BorderRadius.circular(5)
                    //   ),
                    //   padding: EdgeInsets.all(12),
                    //   child: widget.isNew==false?Text("Edit Masjid",
                    //     style: TextStyle(
                    //         color: appColor
                    //     ),
                    //   ):Text("Add Masjid",style: TextStyle(
                    //       color: appColor
                    //   ),
                    //   ),
                    // ):
                    widget.isNew == false
                        ? Text('Edit Masjid')
                        : Text('Add Masjid'),
                    // _tabController.index==1?Container(
                    //     decoration: BoxDecoration(
                    //         color:offWhite,//:appColor,
                    //         borderRadius: BorderRadius.circular(5)
                    //     ),
                    //     padding:const EdgeInsets.all(12),
                    //     child:const Text('Admins',style: TextStyle(
                    //         color: appColor
                    //     ),
                    //       //style: appcolorTextStylebold,
                    //     )):
                    Text('Admins'),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            // dragStartBehavior: DragStartBehavior.down,
            controller: _tabController,viewportFraction: 1,
            children: [
              NestedTabBar(
                  tabbarbarLength: 3,
                  frmNested: _form,
                  nestedTabbarView: [
                    Form(
                      key: formKeys[0],
                      child: Container(
                        child: Column(
                          children: [
                            midPadding2,
                            AddScreenTextFieldWidget(
                              labelText: "Masjid Name",
                              obsecureText: false,
                              controller: masjidNameController,
                              textName: masjid.Name.toString(),
                              inputType: TextInputType.name,
                              validator: (text) {
                                if (!(text!.length > 5) && text.isEmpty) {
                                  return "Enter Masjid name of more then 5 characters!";
                                }
                                return null;
                              },
                            ),
                            const Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Organization ",
                                    style: BlackTextStyleNormal16,
                                  )),
                            ),
                            drpOrg,
                            AddScreenTextFieldWidget(
                              labelText: "Description",
                              obsecureText: false,
                              controller: descriptiomController,
                              textName: masjid.Description.toString(),
                              inputType: TextInputType.multiline,
                              validator: (value) {
                                if (!(value!.length > 5) && value.isEmpty) {
                                  return "Description should not be less than 5 characters";
                                }
                                return null;
                              },
                            ),
                            midPadding,
                          ],
                        ),
                      ),
                    ),
                    Form(
                      key: formKeys[1],
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          //shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: Text(
                                      '\t\tFajr          ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    )),
                                widthSizedBox8,
                                Flexible(
                                  flex: 4,
                                  child: AddScreenTextFieldWidget(
                                    ontap: fajrTime,
                                    labelText: '',
                                    obsecureText: false,
                                    controller: fajrController,
                                    textName: masjid.Fajr.toString(),
                                    inputType: TextInputType.none,
                                    validator: (text) {
                                      if (!(text!.length > 3) ||
                                          text.isEmpty) {
                                        return "Please enter valid time";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: Text(
                                      '\t\tDuhr          ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    )),
                                widthSizedBox8,
                                Flexible(
                                  flex: 4,
                                  child: AddScreenTextFieldWidget(
                                    ontap: duhrTime,
                                    labelText: "",
                                    obsecureText: false,
                                    controller: duhrController,
                                    textName: masjid.Duhr.toString(),
                                    inputType: TextInputType.none,
                                    validator: (value) {
                                      if (!(value!.length > 3) ||
                                          value.isEmpty) {
                                        return "Please enter valid time";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: Text(
                                      '\t\tAsr           ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    )),
                                widthSizedBox8,
                                Flexible(
                                  flex: 4,
                                  child: AddScreenTextFieldWidget(
                                    ontap: asrTime,
                                    labelText: "",
                                    obsecureText: false,
                                    controller: asrController,
                                    textName: masjid.Asr.toString(),
                                    inputType: TextInputType.none,
                                    validator: (value) {
                                      if (!(value!.length > 3) ||
                                          value.isEmpty) {
                                        return "Please enter valid time";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                      '\t\tMaghrib',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    )),
                                widthSizedBox8,
                                Flexible(
                                  flex: 4,
                                  child: AddScreenTextFieldWidget(
                                    ontap: maghribTime,
                                    labelText: "",
                                    obsecureText: false,
                                    controller: maghribController,
                                    textName: masjid.Maghrib.toString(),
                                    inputType: TextInputType.none,
                                    validator: (value) {
                                      if (!(value!.length > 3) ||
                                          value.isEmpty) {
                                        return "Please enter valid time";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: Text(
                                      '\t\tIsha          ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    )),
                                widthSizedBox8,
                                Flexible(
                                  flex: 4,
                                  child: AddScreenTextFieldWidget(
                                    ontap: ishaTime,
                                    labelText: "",
                                    obsecureText: false,
                                    controller: ishaController,
                                    textName: masjid.Isha.toString(),
                                    inputType: TextInputType.none,
                                    validator: (value) {
                                      if (!(value!.length > 3) ||
                                          value.isEmpty) {
                                        return "Please enter valid time";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            midPadding,
                          ],
                        ),
                      ),
                    ),
                    Form(
                      key: formKeys[2],
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            AddScreenTextFieldWidget(
                              labelText: "location",
                              obsecureText: false,
                              controller: locationController,
                              textName: masjid.Location.toString(),
                              inputType: TextInputType.text,
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "* Required";
                                }
                                return null;
                              },
                            ),
                            midPadding,
                            CSCPicker(
                                countryDropdownLabel: "* Country",
                                stateDropdownLabel: "* State",
                                cityDropdownLabel: "* City",
                                countrySearchPlaceholder: "Country",
                                stateSearchPlaceholder: "State",
                                citySearchPlaceholder: "City",
                                selectedItemStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                dropdownHeadingStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                                dropdownItemStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                dropdownDialogRadius: 10.0,
                                searchBarRadius: 10.0,
                                showStates: true,
                                showCities: true,
                                dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1)),
                                disabledDropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1)),
                                onCountryChanged: (country) {
                                  setState(() {
                                    countryValue = country;
                                  });
                                },
                                onStateChanged: (state) {
                                  setState(() {
                                    stateValue = state;
                                  });
                                },
                                onCityChanged: (city) {
                                  setState(() {
                                    cityValue = city;
                                  });
                                }),
                            midPadding,
                            AddScreenTextFieldWidget(
                              textFieldLength: 1,
                              labelText: "Postal Code",
                              obsecureText: false,
                              controller: postalCodeController,
                              textName: organization.zipCode.toString(),
                              inputType: TextInputType.name,
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "*Required";
                                }
                                return null;
                              },
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: AddScreenTextFieldWidget(
                            //         textFieldLength: 1,
                            //         labelText: "Country",
                            //         obsecureText: false,
                            //         controller: countryController,
                            //         textName: masjid.Country.toString(),
                            //         inputType: TextInputType.text,
                            //         validator: (value) {
                            //           if (value!.isEmpty) {
                            //             return 'Please enter you Country';
                            //           }
                            //           return null;
                            //         },
                            //       ),
                            //     ),
                            //     widthSizedBox12,
                            //     Expanded(
                            //       child: AddScreenTextFieldWidget(
                            //         textFieldLength: 1,
                            //         labelText: "Postal Code",
                            //         obsecureText: false,
                            //         controller: postalCodeController,
                            //         textName: masjid.PostalCode.toString(),
                            //         inputType: TextInputType.number,
                            //         validator: (value) {
                            //           if (value!.isEmpty) {
                            //             return '* Required';
                            //           }
                            //           return null;
                            //         },
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: AddScreenTextFieldWidget(
                            //         textFieldLength: 1,
                            //         labelText: "City",
                            //         obsecureText: false,
                            //         controller: cityController,
                            //         textName: masjid.City.toString(),
                            //         inputType: TextInputType.text,
                            //         validator: (value) {
                            //           if (value!.isEmpty) {
                            //             return 'Please enter you city';
                            //           }
                            //           return null;
                            //         },
                            //       ),
                            //     ),
                            //     widthSizedBox12,
                            //     Expanded(
                            //       child: AddScreenTextFieldWidget(
                            //         textFieldLength: 1,
                            //         labelText: "State name",
                            //         obsecureText: false,
                            //         controller: stateController,
                            //         textName: masjid.State.toString(),
                            //         inputType: TextInputType.text,
                            //         validator: (value) {
                            //           if (value!.isEmpty) {
                            //             return 'Please enter you state';
                            //           }
                            //           return null;
                            //         },
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            AddScreenTextFieldWidget(
                              labelText: "Email",
                              obsecureText: false,
                              controller: emailController,
                              textName: masjid.Email.toString(),
                              inputType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter your email';
                                }
                                if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return 'Please enter a valid Email';
                                }
                                return null;
                              },
                            ),
                            AddScreenTextFieldWidget(
                              labelText: "Phone Number",
                              obsecureText: false,
                              controller: phoneController,
                              textName: masjid.Phone1.toString(),
                              inputType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* Required';
                                }
                                return null;
                              },
                            ),
                            midPadding2,
                            // midPadding2,
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height:
                              MediaQuery.of(context).size.height / 16,
                              child: ElevatedButton(
                                onPressed: () async {
                                  Masjid masjidchk;
                                  if (!widget.isNew) {
                                    masjidchk = Masjid.WithId(
                                        Id: int.parse(idController.text),
                                        Org_Id: int.parse(drpOrg
                                            .seletected_value!.key
                                            .toString()),
                                        Name: masjidNameController.text,
                                        Email: emailController.text,
                                        Location: locationController.text,
                                        Country: countryValue,
                                        City: cityValue,
                                        Phone1: phoneController.text,
                                        PostalCode:
                                        postalCodeController.text,
                                        State: stateValue,
                                        Description:
                                        descriptiomController.text,
                                        Masjid_admin:
                                        widget.objMasjidAdmin1,
                                        Fajr: fajrController.text,
                                        Duhr: duhrController.text,
                                        Asr: asrController.text,
                                        Maghrib: maghribController.text,
                                        Isha: ishaController.text);
                                  } else {
                                    masjidchk = Masjid.WithId(
                                        Id: 0,
                                        Org_Id: int.parse(drpOrg
                                            .seletected_value!.key
                                            .toString()),
                                        Name: masjidNameController.text,
                                        Email: emailController.text,
                                        Location: locationController.text,
                                        Country: countryValue,
                                        City: cityValue,
                                        Phone1: phoneController.text,
                                        PostalCode:
                                        postalCodeController.text,
                                        State: stateValue,
                                        Description:
                                        descriptiomController.text,
                                        Masjid_admin:
                                        widget.objMasjidAdmin1,
                                        Fajr: fajrController.text,
                                        Duhr: duhrController.text,
                                        Asr: asrController.text,
                                        Maghrib: maghribController.text,
                                        Isha: ishaController.text);
                                  }

                                  await _saveForm(masjidchk);
                                },
                                child: const Text('Save'),
                                style: ElevatedButton.styleFrom(
                                    primary: appColor, // background
                                    onPrimary: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                20))) // foreground
                                ),
                              ),
                            ),
                            midPadding,
                          ],
                        ),
                      ),
                    )
                  ]),
              // Form(
              //   key: _form,
              //   child: Theme(
              //     data: ThemeData(
              //       canvasColor: backgroundColor,
              //       colorScheme:const ColorScheme.light(
              //           onPrimary: Colors.white,
              //           primary: Colors.green),
              //
              //     ),
              //     child: Stepper(
              //       elevation: 0,
              //       type: StepperType.horizontal,
              //       currentStep: _activeStepIndex,
              //       steps: stepList(),
              //       onStepContinue: () {
              //         if (_activeStepIndex < (stepList().length - 1)) {
              //           setState(() {
              //             _activeStepIndex += 1;
              //           });
              //         } else {
              //           print('Submited');
              //         }
              //       },
              //       onStepCancel: () {
              //         if (_activeStepIndex == 0) {
              //           return;
              //         }
              //         setState(() {
              //           _activeStepIndex -= 1;
              //         });
              //       },
              //       onStepTapped: (int index) {
              //         setState(() {
              //           _activeStepIndex = index;
              //         });
              //       },
              //       controlsBuilder: (
              //           BuildContext context, ControlsDetails details) {
              //         final isLastStep = _activeStepIndex == stepList().length - 1;
              //         return Column(
              //           children: [
              //             Container(
              //               child: Row(
              //                 children: [
              //                   if (_activeStepIndex > 0)
              //                     Expanded(
              //                       child: ElevatedButton(
              //                         style: ElevatedButton.styleFrom(
              //                           primary: appColor,
              //                         ),
              //                         onPressed: details.onStepCancel,
              //                         child: const Text('Back'),
              //                       ),
              //                     ), const SizedBox(
              //                     width: 10,
              //                   ),
              //                   Expanded(
              //                     child: ElevatedButton(
              //                       style: ElevatedButton.styleFrom(
              //                         primary: appColor,
              //                       ),
              //                       onPressed: isLastStep?
              //                           ()async{
              //                         Masjid masjidchk ;
              //                         if(!widget.isNew) {
              //                           masjidchk= Masjid.WithId (
              //                               Id: int.parse (idController.text ),
              //                               Org_Id:int.parse(drpOrg.seletected_value!.key.toString()),
              //                               Name: masjidNameController.text,
              //                               Email: emailController.text,
              //                               Location : locationController.text,
              //                               Country: countryController.text,
              //                               City: cityController.text,
              //                               Phone1: phoneController.text,
              //                               PostalCode: postalCodeController.text,
              //                               State: stateController.text,
              //                               Description: descriptiomController.text,
              //                               Masjid_admin: widget.objMasjidAdmin1,
              //                               Fajr: fajrController.text,
              //                             Duhr: duhrController.text,
              //                             Asr: asrController.text,
              //                             Maghrib: maghribController.text,
              //                             Isha: ishaController.text
              //                           );
              //                         }
              //                         else
              //                         {
              //                           masjidchk=Masjid.WithId(
              //                               Id: 0,
              //                               Org_Id:int.parse(drpOrg.seletected_value!.key.toString()),
              //                               Name: masjidNameController.text,
              //                               Email: emailController.text,
              //                               Location : locationController.text,
              //                               Country: countryController.text,
              //                               City: cityController.text,
              //                               Phone1: phoneController.text,
              //                               PostalCode: postalCodeController.text,
              //                               State: stateController.text,
              //                               Description: descriptiomController.text,
              //                               Masjid_admin: widget.objMasjidAdmin1,
              //                               Fajr: fajrController.text,
              //                               Duhr: duhrController.text,
              //                               Asr: asrController.text,
              //                               Maghrib: maghribController.text,
              //                               Isha: ishaController.text
              //                           );
              //                         }
              //
              //                         await _saveForm(masjidchk);
              //                       }
              //                           :details.onStepContinue,
              //                       child: (isLastStep)
              //                           ? const Text('Submit')
              //                           : const Text('Next'),
              //                     ),
              //                   ),
              //
              //                 ],
              //               ),
              //             ),
              //             SizedBox(
              //               height: 60,
              //             )
              //           ],
              //         );
              //       },
              //     ),
              //   ),
              // ),
              users.isEmpty
                  ? Text('no admin assigned')
                  : ListView.builder(
                  addAutomaticKeepAlives: true,
                  itemCount: users.length,
                  itemBuilder: (_, index) {
                    return Consumer<FavouriteItemProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 4),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12))),
                              color: whiteColor,
                              elevation: 0,
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                  AssetImage('assets/user.png'),
                                ),
                                title:
                                Text(users[index].FullName.toString()),
                                trailing: ElevatedButton(
                                  onPressed: () async {
                                    //bool? chkedValue;
                                    // isChecked[index]=chkedValue!;
                                    int currentUserId =
                                    await prefs.get('userId');
                                    if (favouriteItemProvider.selectedItem
                                        .contains(index)) {
                                      favouriteItemProvider
                                          .removeItem(index);
                                      // await apiService.deleteendUserMaterial
                                      //   ('endusermasjids',currentUserId,masjids[index].Id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          behavior:
                                          SnackBarBehavior.floating,
                                          duration:
                                          Duration(seconds: 2),
                                          content: Text(
                                              "Admin Unassigned Successfully")));
                                    } else {
                                      //isChecked[index]=true;
                                      favouriteItemProvider.addItem(index);
                                      Masjid masjidchk1;
                                      if (!widget.isNew) {
                                        masjidchk1 = Masjid.WithId(
                                          Id: int.parse(idController.text),
                                          Org_Id: int.parse(drpOrg
                                              .seletected_value!.key
                                              .toString()),
                                          Name: masjidNameController.text,
                                          Email: emailController.text,
                                          Location: locationController.text,
                                          Country: countryController.text,
                                          City: cityController.text,
                                          Phone1: phoneController.text,
                                          PostalCode:
                                          postalCodeController.text,
                                          State: stateController.text,
                                          Description:
                                          descriptiomController.text,
                                          Masjid_admin:
                                          widget.objMasjidAdmin1,
                                          Fajr: fajrController.text,
                                          Duhr: duhrController.text,
                                          Asr: asrController.text,
                                          Maghrib: maghribController.text,
                                          Isha: ishaController.text,
                                        );
                                      } else {
                                        masjidchk1 = Masjid.WithId(
                                            Id: 0,
                                            Org_Id: int.parse(drpOrg
                                                .seletected_value!.key
                                                .toString()),
                                            Name: masjidNameController.text,
                                            Email: emailController.text,
                                            Location:
                                            locationController.text,
                                            Country: countryController.text,
                                            City: cityController.text,
                                            Phone1: phoneController.text,
                                            PostalCode:
                                            postalCodeController.text,
                                            State: stateController.text,
                                            Description:
                                            descriptiomController.text,
                                            Masjid_admin:
                                            widget.objMasjidAdmin1,
                                            Fajr: fajrController.text,
                                            Duhr: duhrController.text,
                                            Asr: asrController.text,
                                            Maghrib: maghribController.text,
                                            Isha: ishaController.text);
                                      }

                                      await _saveForm(masjidchk1);
                                      // var postOrgAdmin = UserMasjids(
                                      //     userId: currentUserId,
                                      //     masjidid: users[index].Id
                                      // );
                                      // await ApiServices.postendUsermasjid(postOrgAdmin);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          behavior:
                                          SnackBarBehavior.floating,
                                          duration:
                                          Duration(seconds: 2),
                                          content: Text(
                                              "Admin assigned Successfully")));
                                    }
                                  },
                                  child: favouriteItemProvider.selectedItem
                                      .contains(index) ||
                                      isSelected(users[index].Id)
                                      ? Text('Unassign')
                                      : Text(
                                    'Assign',
                                  ),
                                  // style: ElevatedButton.styleFrom(
                                  //   primary:value.selectedItem.contains(index)?LightBlueColor:assignButton,
                                  //   onPrimary: value.selectedItem.contains(index)?blueColor:assignText,
                                  // ),
                                  style: ElevatedButton.styleFrom(
                                    primary: favouriteItemProvider
                                        .selectedItem
                                        .contains(index)
                                        ? Color(0xffF0FAF2)
                                        : assignButton,
                                    //?LightBlueColor:assignButton,
                                    onPrimary: favouriteItemProvider
                                        .selectedItem
                                        .contains(index)
                                        ? Color(0xff6BCD7B)
                                        : assignText,
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ],
          ),),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: whiteColor,
                border: Border.all(color: appColor)),
            child: TabBar(
              labelPadding: EdgeInsets.only(left: 2, right: 2),
              indicatorWeight: 0.01,
              controller: _tabController,
              labelColor: appColor,
              unselectedLabelColor: Colors.black54,
              isScrollable: false,
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
                            'Masjid Details',
                            style: TextStyle(color: whiteColor, fontSize: 12),
                            //style: appcolorTextStylebold,
                          ),
                        ))
                    : Tab(
                        text: "Masjid Details",
                      ),
                _tabController.index == 1
                    ? Container(
                        height: 42,
                        decoration: BoxDecoration(
                            color: appColor, //:appColor,
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: const Text(
                            'Prayer Times',
                            style: TextStyle(color: whiteColor, fontSize: 12),
                            //style: appcolorTextStylebold,
                          ),
                        ))
                    : Tab(
                        text: "Prayer Times",
                      ),
                _tabController.index == 2
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
        // TabBar(
        //   controller: _tabController,
        //   indicatorColor: appColor,
        //   labelColor: appColor,
        //   unselectedLabelColor: Colors.black54,
        //   isScrollable: true,
        //   tabs: <Widget>[
        //     Tab(
        //       text: "Masjid Details",
        //     ),
        //     Tab(
        //       text: "Prayer Times",
        //     ),
        //     Tab(
        //       text: "Address",
        //     ),
        //
        //   ],
        // ),
        Form(
          key: widget.frmNested,
          child: Container(
              height: screenHeight * 0.90,
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
