import 'dart:convert';

import 'package:community_new/UI%20SCREENS/masjid_screens/masjidStepper.dart';
import 'package:community_new/constants/styles.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../api_services/api_services.dart';
import '../../models/CodeBook.dart';
import '../../models/OrgAdmin.dart';
import '../../models/keyvalue.dart';
import '../../models/organization.dart';
import '../../models/user.dart';
import '../../provider/FavouriteItemProvider.dart';
import '../../widgets/add_screen_text_field.dart';
import '../../widgets/dropdown.dart';
import '../credentials/log_in.dart';
import 'org_tree.dart';

class stepper extends StatefulWidget {
  final int? organizationId;
  List<OrgAdmin>? selectedOrgUser = [];
  int? parentId;
  final bool isNew;
  stepper({
    Key? key,
    required this.isNew,
    this.selectedOrgUser,
    //this.objOrgusers1,
    required this.organizationId,
    this.parentId,
  }) : super(key: key);
  @override
  _stepperState createState() => _stepperState();
}

class _stepperState extends State<stepper>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<stepper> {
  int _activeStepIndex = 0;
  var idcontroller = TextEditingController();
  var OrganizationNameController = TextEditingController();
  var countryController = TextEditingController();
  var emailController = TextEditingController();
  var addressLine1Controller = TextEditingController();
  var phoneNoController = TextEditingController();
  var zipCodeController = TextEditingController();
  var descriptionController = TextEditingController();
  var parentIdController = TextEditingController();
  var stateController = TextEditingController();
  var cityController = TextEditingController();
  var orgTypeController = TextEditingController();
  var addressLine2Controller = TextEditingController();
  var drpParentId = new DropDown(mylist: []);
  var drpType = new DropDown(mylist: []);
  GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //for storing form state.
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  var organization = Organization();
  var codebook = CodeBook();
  List<CodeBook> codebooks = [];
  List<Organization> organizations = [];
  List<KeyValue> KeyvaleusParentId = [];
  List<KeyValue> KeyvaleusOrgType = [];
  List<OrgAdmin> objOrgAdmin2 = [];
  // List<KeyValueCodeBook> Keyvaleuscodebook= [];
  KeyValue? selectedKeyValueParentId;
  KeyValue? selectedKeyValueOrgType;
  // KeyValueCodeBook? selectedKeyValuecodebook;
  FocusNode myFocusNode = FocusNode();
  //List<bool> isChecked=[];
  Future<void> _saveForm(Organization organization) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (widget.isNew) {
        await ApiServices.postOrganization(organization);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrgTree()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Organization Added Successfully"),
        ));
      } else {
        await ApiServices.postOrganizationbyid(idcontroller.text, organization);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Organization Updated Successfully"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill form correctly"),
      ));
    }
  }

  List<User> users = [];
  bool isSelected(int? p_Id) {
    if (widget.selectedOrgUser == null) return false;
    for (int i = 0; i < widget.selectedOrgUser!.length; i++)
      if (widget.selectedOrgUser?[i].user_Id == p_Id) {
        // selectedIndexes[i]=selectedIndexes.length;
        return true;
      }
    return false;
  }

  _getUser() async {
    int currentUserId = await prefs.get('userId');
    await ApiServices.fetch('user',
            actionName: 'GetForOrgid',
            param1: organization.Id.toString() //currentUserId.toString()
            )
        .whenComplete(() => setState(() {}))
        .then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) => User.fromJson(model)).toList();
        print('orgid');
        print(organization.Id.toString());
      });
    });
  }

  _getOrganization() async {
    int currentUserId = await prefs.get('userId');
    await ApiServices.fetch("organization",
            actionName: 'Getfororgadmin', param1: currentUserId.toString())
        .then((response) {
      setState(() {
        Iterable listorganizations = json.decode(response.body);
        organizations = listorganizations
            .map((model) => Organization.fromJson(model))
            .toList();
        //org parent id dropdown
        if (organizations.length > 0) {
          KeyvaleusParentId.add(
              KeyValue(key: '0', value: "Please select Organzation"));
          for (int i = 0; i < organizations.length; i++) {
            KeyvaleusParentId.add(KeyValue(
                key: organizations[i].Id.toString(),
                value: organizations[i].description.toString()));
          }
        }
      });
    });

    await ApiServices.fetchCodeBook("codebook",
            tableName: "organization", codeName: "orgtype")
        .then((response) {
      setState(() {
        Iterable listcodebook = json.decode(response.body);
        // print(list);
        codebooks =
            listcodebook.map((model) => CodeBook.fromJson(model)).toList();
        //org parent id dropdown
        if (codebooks.length > 0) {
          KeyvaleusOrgType.add(
              KeyValue(key: '', value: "Please select Organization Type"));
          for (int i = 0; i < codebooks.length; i++) {
            KeyvaleusOrgType.add(KeyValue(
                key: codebooks[i].code_Value.toString(),
                value: codebooks[i].display_Value.toString()));
          }
        }
      });
    });
    if (widget.isNew == false) {
      await ApiServices.fetchForEdit(widget.organizationId, 'organization')
          .then((response) {
        setState(() {
          var userBody = json.decode(response.body);
          organization = Organization.fromJsonWithUsers(userBody);
          if (organization != null) {
            idcontroller.text = organization.Id.toString();
            // idcontroller.text = widget.jsondata.toString ();
            emailController.text = organization.Email.toString();
            countryController.text = organization.country.toString();
            addressLine1Controller.text = organization.address1.toString();
            addressLine2Controller.text = organization.address2.toString();
            OrganizationNameController.text = organization.name.toString();
            descriptionController.text = organization.description.toString();
            cityController.text = organization.city.toString();
            parentIdController.text = organization.parentId.toString();
            phoneNoController.text = organization.phoneNo.toString();
            zipCodeController.text = organization.zipCode.toString();
            stateController.text = organization.state.toString();
            orgTypeController.text = organization.orgType.toString();
            // if(widget.objOrgusers1==null)

            {
              objOrgAdmin2 = organization.Org_admin!;
              //widget.objOrgusers1=organization.Org_admin;
            }
            {
              var testforParentId;
              if (organization.parentId != "null" &&
                  organization.parentId != null) {
                try {
                  testforParentId = KeyvaleusParentId.firstWhere((element) =>
                      element.key == organization.parentId.toString());
                } catch (e) {
                  testforParentId = KeyvaleusParentId[0];
                }

                //dropdown.seletected_value=selectedKeyValue;
              } else {
                testforParentId = KeyvaleusParentId[0];
              }
              selectedKeyValueParentId = testforParentId;
            }
            //    if(KeyvaleusOrgType!=null&& KeyvaleusOrgType.length>0)
            {
              var testforOrgType;
              if (organization.orgType != "null" &&
                  organization.orgType != null) {
                try {
                  testforOrgType = KeyvaleusOrgType.firstWhere((element) =>
                      element.key == organization.orgType.toString());
                } catch (e) {
                  testforOrgType = KeyvaleusOrgType[0];
                }
                //print("find org type");
                //print(test);

              } else {
                testforOrgType = KeyvaleusOrgType[0];
              }
              selectedKeyValueOrgType = testforOrgType;
            }
          }
        });
      });
    } else {
      if (widget.parentId != "null" && widget.parentId != null) {
        var testForParentid2;
        try {
          testForParentid2 = KeyvaleusParentId.firstWhere(
              (element) => element.key == widget.parentId.toString());
        } catch (e) {
          testForParentid2 = KeyvaleusParentId[0];
        }
        selectedKeyValueParentId = testForParentid2;
        //dropdown.seletected_value=selectedKeyValue;
      }
      if (KeyvaleusOrgType != null && KeyvaleusOrgType.length > 0) {
        KeyvaleusOrgType[0];
      }
      parentIdController.text = widget.parentId.toString();
      orgTypeController.text = organization.orgType.toString();

      var currentid = prefs.getInt('userId');
      var currentuserName = prefs.getString('userName');
      objOrgAdmin2.add(
          OrgAdmin(org_Id: 0, user_Id: currentid, userName: currentuserName));
    }
    drpParentId = DropDown(
        mylist: KeyvaleusParentId, seletected_value: selectedKeyValueParentId);

    drpType = DropDown(
        mylist: KeyvaleusOrgType, seletected_value: selectedKeyValueOrgType);
  }

  late TabController _tabController;
  String countryValue = "";
  String? stateValue;
  String? cityValue;
  String address = "";
  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
      print('Has focus: $myFocusNode.hasFocus');
    });

    _getOrganization();
    _getUser();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    //_focusNode.dispose();
    _tabController.removeListener(_handleTabIndex);
    //_tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  // List<Step> stepList() => [
  //   Step(
  //     state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
  //     isActive: _activeStepIndex >= 0,
  //     title: const Text('Organization Detail'),
  //     content: Form(
  //       key: formKeys[0],
  //       child: Container(
  //         child: Column(
  //           children: [
  //             AddScreenTextFieldWidget(
  //               labelText: "Organization Name",
  //               obsecureText: false,
  //               controller:OrganizationNameController ,
  //               textName:  organization.name.toString(),
  //               inputType: TextInputType.name,
  //               validator: (text) {
  //                 if (!(text!.length > 2) && text.isEmpty) {
  //                   return "Enter Organization name of more then 2 characters!";
  //                 }
  //                 return null;
  //               },
  //             ),
  //             widget.parentId!=0?const Padding(
  //               padding:  EdgeInsets.only(top: 10.0,bottom: 10),
  //               child: Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text("Organization Parent Id",
  //                     style: BlackTextStyleNormal16,)),
  //             ):Container(),
  //             widget.parentId!=0?drpParentId :Container(),
  //             const Padding(
  //               padding:  EdgeInsets.only(top: 10.0,bottom: 10),
  //               child: Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text("Organization Type",
  //                     style: BlackTextStyleNormal16,)),
  //             ),
  //             drpType,
  //             AddScreenTextFieldWidget(
  //               labelText: "Email",
  //               obsecureText: false,
  //               controller: emailController,
  //               textName:organization.Email.toString(),
  //               inputType: TextInputType.emailAddress,
  //               validator: (value){
  //                 if(value!.isEmpty)
  //                 {
  //                   return 'Please Enter your email';
  //                 }
  //                 if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").
  //                 hasMatch(value)){
  //                   return 'Please enter a valid Email';
  //                 }
  //                 return null;
  //               },
  //
  //             ),
  //             AddScreenTextFieldWidget(
  //               labelText: "Description",
  //               obsecureText: false,
  //               controller: descriptionController,
  //               textName: organization.description.toString(),
  //               inputType: TextInputType.name,
  //               validator: (text) {
  //                 if (!(text!.length > 5) && text.isNotEmpty) {
  //                   return "Description should not be "
  //                       "less than 5 characters";
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
  //       state:
  //       _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
  //       isActive: _activeStepIndex >= 1,
  //       title: const Text('Address'),
  //       content: Form(
  //         key: formKeys[1],
  //         child: Container(
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: AddScreenTextFieldWidget(
  //                       labelText: "Country",
  //                       obsecureText: false,
  //                       controller: countryController,
  //                       textName: organization.country.toString(),
  //                       inputType: TextInputType.name,
  //                       validator: (text) {
  //                         if (!(text!.length > 2) && text.isEmpty) {
  //                           return "*Required";
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                   ),widthSizedBox12,
  //                   Expanded(
  //                     child: AddScreenTextFieldWidget(
  //                       labelText: "City",
  //                       obsecureText: false,
  //                       controller: cityController,
  //                       textName: organization.city.toString(),
  //                       inputType: TextInputType.name,
  //                       validator: (text) {
  //                         if (!(text!.length > 3) && text.isEmpty) {
  //                           return "*Required";
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                   ),
  //                 ],),
  //               Row(children: [
  //                 Expanded(
  //                   child: AddScreenTextFieldWidget(
  //                     labelText: "State",
  //                     obsecureText: false,
  //                     controller: stateController,
  //                     textName: organization.state.toString(),
  //                     inputType: TextInputType.name,
  //                     validator: (text) {
  //                       if (!(text!.length > 1) && text.isNotEmpty) {
  //                         return "*Required";
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
  //                     controller: zipCodeController,
  //                     textName: organization.zipCode.toString(),
  //                     inputType: TextInputType.name,
  //                     validator: (text) {
  //                       if ( text!.isEmpty) {
  //                         return "*Required";
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                 ),
  //               ],),
  //               Row(children: [
  //                 Expanded(
  //                   child: AddScreenTextFieldWidget(
  //                     labelText: "Address Line 1",
  //                     obsecureText: false,
  //                     controller: addressLine1Controller,
  //                     textName: organization.address1.toString(),
  //                     inputType: TextInputType.name,
  //                     validator: (text) {
  //                       if (!(text!.length > 5) && text.isNotEmpty) {
  //                         return "*Required";
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                 ),widthSizedBox12,
  //                 Expanded(
  //                   child: AddScreenTextFieldWidget(
  //                     labelText: "Address Line 2",
  //                     obsecureText: false,
  //                     controller: addressLine2Controller,
  //                     textName: organization.address2.toString(),
  //                     inputType: TextInputType.name,
  //                   ),
  //                 ),
  //               ],),
  //
  //               AddScreenTextFieldWidget(
  //                 labelText: "Phone Number",
  //                 obsecureText: false,
  //                 controller: phoneNoController,
  //                 textName: organization.phoneNo.toString(),
  //                 inputType: TextInputType.number,
  //                 validator: (text) {
  //                   if (!(text!.length > 4) && text.isNotEmpty) {
  //                     return "*Required";
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OrgTree()));
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: whiteColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Theme(
              data: ThemeData(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent),
              child: AppBar(
                leading: IconButton(
                  color: appColor,
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  icon: Icon(CupertinoIcons.chevron_back),
                ),
                backgroundColor: whiteColor,
                elevation: 0,
                bottom: TabBar(
                  labelStyle: TextStyle(fontSize: 15),
                  unselectedLabelStyle: TextStyle(fontSize: 15),
                  automaticIndicatorColorAdjustment: true,
                  labelColor: appColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: appColor,
                  unselectedLabelColor: Colors.grey,
                  //padding: EdgeInsets.only(bottom: 20),
                  controller: _tabController,
                  tabs: [
                    // _tabController.index==0?
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         color:offWhite,
                    //         borderRadius: BorderRadius.circular(5)
                    //     ),
                    //     padding: EdgeInsets.all(12),
                    //     child: widget.isNew==false?Text("Edit Organization",
                    //         style: TextStyle(
                    //         color: appColor
                    //     ),
                    //     ):
                    //     Text("Add Organization",style: TextStyle(
                    //         color: appColor
                    //     ),
                    //     ),
                    //   ),
                    // ):
                    widget.isNew == false
                        ? Text('Edit Organization')
                        : Text('Add Organization'),
                    // _tabController.index==1?
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //       decoration: BoxDecoration(
                    //           color:offWhite,//:appColor,
                    //           borderRadius: BorderRadius.circular(5)
                    //       ),
                    //       padding:const EdgeInsets.all(12),
                    //       child:const Text('Admins',style: TextStyle(
                    //         color: appColor
                    //       ),
                    //         //style: appcolorTextStylebold,
                    //       )),
                    // ):
                    Text('Admins'),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              NestedTabBarOrg(nestedTabbarView: [
                Form(
                  key: formKeys[0],
                  child: Column(
                    children: [
                      midPadding2,
                      AddScreenTextFieldWidget(
                        labelText: "Organization Name",
                        obsecureText: false,
                        controller: OrganizationNameController,
                        textName: organization.name.toString(),
                        inputType: TextInputType.name,
                        validator: (text) {
                          if (!(text!.length > 2) && text.isEmpty) {
                            return "Enter Organization name of more then 2 characters!";
                          }
                          return null;
                        },
                      ),
                      widget.parentId != 0
                          ? const Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Organization Parent Id",
                                    style: BlackTextStyleNormal16,
                                  )),
                            )
                          : Container(),
                      widget.parentId != 0 ? drpParentId : Container(),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Organization Type",
                              style: BlackTextStyleNormal16,
                            )),
                      ),
                      drpType,
                      AddScreenTextFieldWidget(
                        labelText: "Email",
                        obsecureText: false,
                        controller: emailController,
                        textName: organization.Email.toString(),
                        inputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your email';
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return 'Please enter a valid Email';
                          }
                          return null;
                        },
                      ),
                      AddScreenTextFieldWidget(
                        labelText: "Description",
                        obsecureText: false,
                        controller: descriptionController,
                        textName: organization.description.toString(),
                        inputType: TextInputType.name,
                        validator: (text) {
                          if (!(text!.length > 5) && text.isNotEmpty) {
                            return "Description should not be "
                                "less than 5 characters";
                          }
                          return null;
                        },
                      ),
                      midPadding,
                    ],
                  ),
                ),
                Form(
                  key: formKeys[1],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      children: [
                        midPadding2,
                        Row(
                          children: [
                            Expanded(
                              child: AddScreenTextFieldWidget(
                                textFieldLength: 1,
                                labelText: "Address Line 1",
                                obsecureText: false,
                                controller: addressLine1Controller,
                                textName: organization.address1.toString(),
                                inputType: TextInputType.name,
                                validator: (text) {
                                  if (!(text!.length > 5) && text.isNotEmpty) {
                                    return "*Required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            widthSizedBox12,
                            Expanded(
                              child: AddScreenTextFieldWidget(
                                textFieldLength: 1,
                                labelText: "Address Line 2",
                                obsecureText: false,
                                controller: addressLine2Controller,
                                textName: organization.address2.toString(),
                                inputType: TextInputType.name,
                              ),
                            ),
                          ],
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1)),
                          disabledDropdownDecoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey.shade300,
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1)),
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
                        //         textName: organization.country.toString(),
                        //         inputType: TextInputType.name,
                        //         validator: (text) {
                        //           if (!(text!.length > 2) && text.isEmpty) {
                        //             return "*Required";
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
                        //         controller: zipCodeController,
                        //         textName: organization.zipCode.toString(),
                        //         inputType: TextInputType.name,
                        //         validator: (text) {
                        //           if (text!.isEmpty) {
                        //             return "*Required";
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
                        //         textName: organization.city.toString(),
                        //         inputType: TextInputType.name,
                        //         validator: (text) {
                        //           if (!(text!.length > 3) && text.isEmpty) {
                        //             return "*Required";
                        //           }
                        //           return null;
                        //         },
                        //       ),
                        //     ),
                        //     widthSizedBox12,
                        //     Expanded(
                        //       child: AddScreenTextFieldWidget(
                        //         textFieldLength: 1,
                        //         labelText: "State",
                        //         obsecureText: false,
                        //         controller: stateController,
                        //         textName: organization.state.toString(),
                        //         inputType: TextInputType.name,
                        //         validator: (text) {
                        //           if (!(text!.length > 1) && text.isNotEmpty) {
                        //             return "*Required";
                        //           }
                        //           return null;
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        AddScreenTextFieldWidget(
                          textFieldLength: 1,
                          labelText: "Postal Code",
                          obsecureText: false,
                          controller: zipCodeController,
                          textName: organization.zipCode.toString(),
                          inputType: TextInputType.name,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "*Required";
                            }
                            return null;
                          },
                        ),
                        AddScreenTextFieldWidget(
                          labelText: "Phone Number",
                          obsecureText: false,
                          controller: phoneNoController,
                          textName: organization.phoneNo.toString(),
                          inputType: TextInputType.number,
                          validator: (text) {
                            if (!(text!.length > 4) && text.isNotEmpty) {
                              return "*Required";
                            }
                            return null;
                          },
                        ),
                        // Container(
                        //     padding: EdgeInsets.symmetric(horizontal: 20),
                        //     height: 600,
                        //     child: Column(
                        //       children: [
                        //         ///Adding CSC Picker Widget in app
                        //         CSCPicker(
                        //           ///Enable disable state dropdown [OPTIONAL PARAMETER]
                        //           showStates: true,
                        //
                        //           /// Enable disable city drop down [OPTIONAL PARAMETER]
                        //           showCities: true,
                        //
                        //           ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                        //           flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                        //
                        //
                        //           ///selected item style [OPTIONAL PARAMETER]
                        //           selectedItemStyle: TextStyle(color: Colors.black, fontSize: 14,),
                        //
                        //           ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                        //           dropdownHeadingStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                        //
                        //           ///DropdownDialog Item style [OPTIONAL PARAMETER]
                        //           dropdownItemStyle: TextStyle(color: Colors.black,fontSize: 14, ),
                        //
                        //           ///Dialog box radius [OPTIONAL PARAMETER]
                        //           dropdownDialogRadius: 10.0,
                        //
                        //           ///Search bar radius [OPTIONAL PARAMETER]
                        //           searchBarRadius: 10.0,
                        //
                        //           ///triggers once country selected in dropdown
                        //           onCountryChanged: (value) {
                        //             setState(() {
                        //               ///store value in country variable
                        //               countryValue = value;
                        //             });
                        //           },
                        //
                        //           ///triggers once state selected in dropdown
                        //           onStateChanged: (value) {
                        //             setState(() {
                        //               ///store value in state variable
                        //               stateValue = value!;
                        //             });
                        //           },
                        //
                        //           ///triggers once city selected in dropdown
                        //           onCityChanged: (value) {
                        //             setState(() {
                        //               ///store value in city variable
                        //               cityValue = value!;
                        //             });
                        //           },
                        //         ),
                        //
                        //         ///print newly selected country state and city in Text Widget
                        //         TextButton(
                        //             onPressed: () {
                        //               setState(() {
                        //                 address = "$cityValue, $stateValue, $countryValue";
                        //               });
                        //             },
                        //             child: Text("Print Data")),
                        //         Text(address)
                        //       ],
                        //     )),

                        midPadding2, midPadding2,
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 16,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: appColor, // background
                                  onPrimary: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))) // foreground
                                  ),
                              onPressed: () async {
                                Organization organization;
                                if (!widget.isNew) {
                                  organization = Organization.WithId(
                                      Id: int.parse(idcontroller.text),
                                      //parentId: 0,
                                      parentId: int.parse(drpParentId
                                          .seletected_value!.key
                                          .toString()),
                                      name: OrganizationNameController.text,
                                      Email: emailController.text,
                                      country: countryValue,
                                      zipCode: zipCodeController.text,
                                      city: cityValue,
                                      address1: addressLine1Controller.text,
                                      address2: addressLine2Controller.text,
                                      description: descriptionController.text,
                                      phoneNo: phoneNoController.text,
                                      state: stateValue,
                                      orgType: drpType.seletected_value!.key
                                          .toString(),
                                      //  orgType: '',
                                      Org_admin: objOrgAdmin2
                                      //Orgusers:[]
                                      );
                                } else {
                                  organization = Organization.WithId(
                                      Id: 0,
                                      parentId: widget.parentId != null
                                          ? int.parse(drpParentId
                                              .seletected_value!.key
                                              .toString())
                                          : 0,
                                      name: OrganizationNameController.text,
                                      Email: emailController.text,
                                      country: countryValue,
                                      zipCode: zipCodeController.text,
                                      city: cityValue,
                                      address1: addressLine1Controller.text,
                                      address2: addressLine2Controller.text,
                                      description: descriptionController.text,
                                      phoneNo: phoneNoController.text,
                                      state: stateValue,
                                      orgType: drpType.seletected_value!.key
                                          .toString(),
                                      Org_admin: objOrgAdmin2);
                                }
                                await _saveForm(organization);
                              },
                              child: const Text('Submit')),
                        ),
                      ],
                    ),
                  ),
                )
              ], frmNested: _formKey, tabbarbarLength: 2),
              // Form(
              //   key: _formKey,
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
              //                   Expanded(
              //                     child: ElevatedButton(
              //                       style: ElevatedButton.styleFrom(
              //                         primary: appColor,
              //                       ),
              //                       onPressed: isLastStep?
              //                           ()async{
              //                         Organization organization ;
              //                         if(!widget.isNew) {
              //                           organization= Organization.WithId (
              //                               Id: int.parse ( idcontroller.text ),
              //                               //parentId: 0,
              //                               parentId:
              //                               int.parse(drpParentId.seletected_value!.key.toString()),
              //                               name: OrganizationNameController.text,
              //                               Email: emailController.text,
              //                               country: countryController.text,
              //                               zipCode: zipCodeController.text,
              //                               city: cityController.text,
              //                               address1: addressLine1Controller.text,
              //                               address2: addressLine2Controller.text,
              //                               description: descriptionController.text,
              //                               phoneNo: phoneNoController.text,
              //                               state: stateController.text,
              //                               orgType: drpType.seletected_value!.key.toString(),
              //                               //  orgType: '',
              //                               Org_admin: objOrgAdmin2//objOrgusers2,
              //                             //Orgusers:[]
              //                           );
              //                         }
              //                         else
              //                         {
              //                           organization= Organization.WithId(
              //                               Id:0,
              //                               //parentId: 0,
              //                               parentId:widget.parentId!=null? int.parse(
              //                                   drpParentId.seletected_value!.key.toString()):0,
              //                               //parentId: 0,
              //                               name: OrganizationNameController.text,
              //                               Email: emailController.text,
              //                               country: countryController.text,
              //                               zipCode: zipCodeController.text,
              //                               city: cityController.text,
              //                               address1: addressLine1Controller.text,
              //                               address2: addressLine2Controller.text,
              //                               description: descriptionController.text,
              //                               phoneNo: phoneNoController.text,
              //                               state: stateController.text,
              //                               orgType: drpType.seletected_value!.key.toString(),
              //                               // Org_admin:objOrgAdmin2
              //                               Org_admin: objOrgAdmin2
              //                             //Org_admin: objOrgAdmin2
              //                           );
              //                         }
              //                         await _saveForm(organization);
              //                       }
              //                           :details.onStepContinue,
              //                       child: (isLastStep)
              //                           ? const Text('Submit')
              //                           : const Text('Next'),
              //                     ),
              //                   ),
              //                   const SizedBox(
              //                     width: 10,
              //                   ),
              //                   if (_activeStepIndex > 0)
              //                     Expanded(
              //                       child: ElevatedButton(
              //                         style: ElevatedButton.styleFrom(
              //                           primary: appColor,
              //                         ),
              //                         onPressed: details.onStepCancel,
              //                         child: const Text('Back'),
              //                       ),
              //                     )
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
              ListView.builder(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          color: whiteColor,
                          elevation: 5,
                          child: ListTile(
                              leading: const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/user.png'),
                              ),
                              title: Text(users[index].FullName.toString()),
                              trailing: ElevatedButton(
                                onPressed: () async {
                                  //bool? chkedValue;
                                  // isChecked[index]=chkedValue!;
                                  int currentUserId = await prefs.get('userId');
                                  if (value.selectedItem.contains(index)) {
                                    value.removeItem(index);
                                    // await apiService.deleteendUserMaterial
                                    //   ('endusermasjids',currentUserId,masjids[index].Id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(users[index]
                                                    .FullName
                                                    .toString() +
                                                " Deleted Successfully")));
                                  } else {
                                    //isChecked[index]=true;
                                    value.addItem(index);
                                    Organization organization;
                                    if (!widget.isNew) {
                                      organization = Organization.WithId(
                                          Id: int.parse(idcontroller.text),
                                          //parentId: 0,
                                          parentId: int.parse(drpParentId
                                              .seletected_value!.key
                                              .toString()),
                                          name: OrganizationNameController.text,
                                          Email: emailController.text,
                                          country: countryController.text,
                                          zipCode: zipCodeController.text,
                                          city: cityController.text,
                                          address1: addressLine1Controller.text,
                                          address2: addressLine2Controller.text,
                                          description:
                                              descriptionController.text,
                                          phoneNo: phoneNoController.text,
                                          state: stateController.text,
                                          orgType: drpType.seletected_value!.key
                                              .toString(),
                                          //  orgType: '',
                                          Org_admin:
                                              objOrgAdmin2 //objOrgusers2,
                                          //Orgusers:[]
                                          );
                                    } else {
                                      organization = Organization.WithId(
                                          Id: 0,
                                          //parentId: 0,
                                          parentId: widget.parentId != null
                                              ? int.parse(drpParentId
                                                  .seletected_value!.key
                                                  .toString())
                                              : 0,
                                          //parentId: 0,
                                          name: OrganizationNameController.text,
                                          Email: emailController.text,
                                          country: countryController.text,
                                          zipCode: zipCodeController.text,
                                          city: cityController.text,
                                          address1: addressLine1Controller.text,
                                          address2: addressLine2Controller.text,
                                          description:
                                              descriptionController.text,
                                          phoneNo: phoneNoController.text,
                                          state: stateController.text,
                                          orgType: drpType.seletected_value!.key
                                              .toString(),
                                          // Org_admin:objOrgAdmin2
                                          Org_admin: objOrgAdmin2
                                          //Org_admin: objOrgAdmin2
                                          );
                                    }
                                    await _saveForm(organization);

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Stack(
                                      children: [
                                        Text(users[index].FullName.toString() +
                                            " assigned as an admin"),
                                      ],
                                    )));
                                  }
                                },
                                child: value.selectedItem.contains(index)
                                    ? Text('Assigned')
                                    : Text(
                                        'Assign',
                                      ),
                                // style: ElevatedButton.styleFrom(
                                //   primary:value.selectedItem.contains(index)?LightBlueColor:assignButton,
                                //   onPrimary: value.selectedItem.contains(index)?blueColor:assignText,
                                // ),
                                style: ElevatedButton.styleFrom(
                                  primary: favouriteItemProvider.selectedItem
                                          .contains(index)
                                      ? Color(0xffF0FAF2)
                                      : assignButton,
                                  //?LightBlueColor:assignButton,
                                  onPrimary: favouriteItemProvider.selectedItem
                                          .contains(index)
                                      ? Color(0xff6BCD7B)
                                      : assignText,
                                ),
                              )),
                        ),
                      );
                    });
                  }),
            ],
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class NestedTabBarOrg extends StatefulWidget {
  final List<Widget> nestedTabbarView;
  final int tabbarbarLength;
  final GlobalKey<FormState> frmNested;
  NestedTabBarOrg(
      {Key? key,
      required this.nestedTabbarView,
      required this.frmNested,
      required this.tabbarbarLength})
      : super(key: key);
  @override
  _NestedTabBarOrgState createState() => _NestedTabBarOrgState();
}

class _NestedTabBarOrgState extends State<NestedTabBarOrg>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<NestedTabBarOrg> {
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
                            'Organization Details',
                            style: TextStyle(color: whiteColor),
                            //style: appcolorTextStylebold,
                          ),
                        ))
                    : Tab(
                        text: "Organization Details",
                      ),
                _tabController.index == 1
                    ? Container(
                        height: 42,
                        decoration: BoxDecoration(
                            color: appColor, //:appColor,
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: const Text(
                            'Address', style: TextStyle(color: whiteColor),
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
              height: screenHeight * 0.70,
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


// class BackgroundWaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//
//     final p0 = size.height * 0.75;
//     path.lineTo(0.0, p0);
//
//     final controlPoint = Offset(size.width * 0.4, size.height);
//     final endPoint = Offset(size.width, size.height / 2);
//     path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
//
//     path.lineTo(size.width, 0.0);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(BackgroundWaveClipper oldClipper) =>
//       oldClipper != this;
// }
// Padding(
// padding: const EdgeInsets.only(left:15.0,right: 15),
// child: Card(
//
// child: Column(
// children: [
// ListTile(
//
//
// trailing:
// ElevatedButton(
// style: ElevatedButton.styleFrom(
// primary:assign[index]==true?LightBlueColor:assignButton,
// onPrimary: assign[index]==true?blueColor:assignText,
// ),
// onPressed: ()async{
// if(assign[index]==true){
// setState(() {
// assign[index]=false;
// });
// }
// else if(assign[index]==false){
// setState(() {
// assign[index]=true;
// });
// }
//
// },
//
// ),
//
// ),
// ],
// )),
// );