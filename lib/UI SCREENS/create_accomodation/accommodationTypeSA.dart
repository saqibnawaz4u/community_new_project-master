import 'dart:convert';

import 'package:community_new/UI%20SCREENS/Menues/constantMenu.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/accommodationAggrement.dart';
import 'package:community_new/models/accommodationAmenities.dart';
import 'package:community_new/models/accommodationType.dart';
import 'package:community_new/widgets/add_screen_text_field.dart';
import 'package:community_new/widgets/genericAppBar.dart';
import 'package:community_new/widgets/genericDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../api_services/api_services.dart';

class accommodationTypeSuperAdmin extends StatefulWidget {
  final int index;
  const accommodationTypeSuperAdmin({Key? key, required this.index})
      : super(key: key);

  @override
  State<accommodationTypeSuperAdmin> createState() =>
      _accommodationTypeSuperAdminState();
}

class _accommodationTypeSuperAdminState
    extends State<accommodationTypeSuperAdmin>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  GlobalKey<FormState> _formkey =
      GlobalKey<FormState>(); //for storing form state.
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
      print('Has focus: $myFocusNode.hasFocus');
    });
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController!.addListener(_handleTabIndex);
    _tabController!.notifyListeners();
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: widget.index,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            drawer: genericDrawerForSA(),
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(95),
                child: genericAppBarForSA(
                  appbarTitle: 'Accomudation',
                  bottom: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    controller: _tabController,
                    padding: EdgeInsets.only(top: 1),
                    labelColor: appColor,
                    labelStyle: TextStyle(fontSize: 10),
                    isScrollable: true,
                    //labelPadding: EdgeInsets.only(left:2,right: 2),
                    unselectedLabelColor: Colors.black54,
                    indicatorColor: whiteColor,
                    tabs: <Widget>[
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
                                'Accomodation\nType',
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
                                'Acccomodation\nType',
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
                                'Accomodation\nAgreement',
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
                                'Accomodation\nAgreement',
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
                                'Accomodation\nAmenities',
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
                                'Accomodation\nAmenities',
                                style: TextStyle(
                                  color: Color(0xff93573c),
                                ),
                              ),
                            ),
                    ],
                  ),
                )),
            backgroundColor: whiteColor,
            body: Form(
              key: _formkey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  accommodationtypeWidget(),
                  accommodationagreementWidget(),
                  accommodationAmenitiesWidget(),
                ],
              ),
            )),
      ),
    );
  }
}

class accommodationtypeWidget extends StatefulWidget {
  const accommodationtypeWidget({Key? key}) : super(key: key);

  @override
  State<accommodationtypeWidget> createState() =>
      _accommodationtypeWidgetState();
}

class _accommodationtypeWidgetState extends State<accommodationtypeWidget> {
  var accnameController = TextEditingController();
  var accdesController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> _saveForm(accommodationType acctype) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      //if(widget.isNew)
      //{
      await ApiServices.postaccType(acctype);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Accommodation Type Added Successfully"),
      ));
      //}
      // else {
      //   await ApiServices.postUserbyid ( idcontroller.text, user );
      //   ScaffoldMessenger.of ( context )
      //       .showSnackBar ( const SnackBar (
      //     content: Text ( "User Updated Successfully" ), ) );
      // }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Please fill form correctly"),
      ));
    }
  }

  List<accommodationType> accType = [];
  _getAccType() async {
    ApiServices.fetch(
      'accommodationtype',
    ) //current user id will pass here
        .then((response) {
      setState(() {
        try {
          Iterable list = json.decode(response.body);
          accType =
              list.map((model) => accommodationType.fromJson(model)).toList();
        } on Exception catch (e) {}
      });
    });
  }

  @override
  initState() {
    // at the beginning, all users are shown
    _getAccType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Text('Existing Accommodation Type'),
            // Divider(
            //   color: blackColor,
            // ),
            ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: accType.length,
                itemBuilder: ((context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  accType[index].name.toString(),
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
                                Text(
                                  accType[index].description.toString() + '\n',
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
                  );
                })),
            Divider(
              color: blackColor,
            ),
            AddScreenTextFieldWidget(
                labelText: 'Accommodation Type',
                textName: 'Accommodation Type',
                obsecureText: false,
                inputType: TextInputType.name,
                controller: accnameController),
            AddScreenTextFieldWidget(
                labelText: 'Description',
                textName: 'Description',
                obsecureText: false,
                inputType: TextInputType.name,
                controller: accdesController),
            midPadding2,
            midPadding2,
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
                    accommodationType accType;
                    accType = accommodationType(
                        name: accnameController.text,
                        description: accdesController.text);
                    await _saveForm(accType);
                  },
                  child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}

class accommodationagreementWidget extends StatefulWidget {
  const accommodationagreementWidget({Key? key}) : super(key: key);

  @override
  State<accommodationagreementWidget> createState() =>
      _accommodationagreementWidgetState();
}

class _accommodationagreementWidgetState
    extends State<accommodationagreementWidget> {
  var agreementdesController = TextEditingController();
  var agreementTitle = TextEditingController();
  var agreementReoccuring = TextEditingController();
  var agreementMonthDuration = TextEditingController();
  GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //for storing form state.
  Future<void> _saveForm(accommodationAgreement agreementType) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      //if(widget.isNew)
      //{
      await ApiServices.postAgreementType(agreementType);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Agreement Type Added Successfully"),
      ));
      //}
      // else {
      //   await ApiServices.postUserbyid ( idcontroller.text, user );
      //   ScaffoldMessenger.of ( context )
      //       .showSnackBar ( const SnackBar (
      //     content: Text ( "User Updated Successfully" ), ) );
      // }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Please fill form correctly"),
      ));
    }
  }

  List<accommodationAgreement> accAggreement = [];
  _getAccAgreement() async {
    ApiServices.fetch(
      'accommodationagreement',
    ) //current user id will pass here
        .then((response) {
      setState(() {
        try {
          Iterable list = json.decode(response.body);
          accAggreement = list
              .map((model) => accommodationAgreement.fromJson(model))
              .toList();
        } on Exception catch (e) {}
      });
    });
  }

  @override
  initState() {
    // at the beginning, all users are shown
    _getAccAgreement();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Text('Existing Accommodation Agreements'),
            // Divider(
            //   color: blackColor,
            // ),
            ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: accAggreement.length,
                itemBuilder: ((context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  accAggreement[index].title.toString(),
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
                                Text(
                                  accAggreement[index].description.toString() +
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
                  );
                })),
            Divider(
              color: blackColor,
            ),
            AddScreenTextFieldWidget(
                labelText: 'Agreement Title',
                textName: 'Agreement Title',
                obsecureText: false,
                inputType: TextInputType.name,
                controller: agreementTitle),
            AddScreenTextFieldWidget(
                labelText: 'Reoccurring',
                textName: 'Reoccurring',
                obsecureText: false,
                inputType: TextInputType.number,
                controller: agreementReoccuring),
            AddScreenTextFieldWidget(
                labelText: 'Month Duration',
                textName: 'Month Duration',
                obsecureText: false,
                inputType: TextInputType.number,
                controller: agreementMonthDuration),
            AddScreenTextFieldWidget(
                labelText: 'Description',
                textName: 'Description',
                obsecureText: false,
                inputType: TextInputType.name,
                controller: agreementdesController),
            midPadding2,
            midPadding2,
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
                    accommodationAgreement agType;
                    agType = accommodationAgreement(
                        id: 0,
                        title: agreementTitle.text,
                        description: agreementdesController.text,
                        monthDuration:
                            int.parse(agreementMonthDuration.toString()),
                        reocurring: int.parse(agreementReoccuring.toString()));
                    await _saveForm(agType);
                  },
                  child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}

class accommodationAmenitiesWidget extends StatefulWidget {
  const accommodationAmenitiesWidget({Key? key}) : super(key: key);

  @override
  State<accommodationAmenitiesWidget> createState() =>
      _accommodationAmenitiesWidgetState();
}

class _accommodationAmenitiesWidgetState
    extends State<accommodationAmenitiesWidget> {
  var amnameController = TextEditingController();
  var amdesController = TextEditingController();
  GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //for storing form state.
  Future<void> _saveForm(accommodationAmenities amenitiesType) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      //if(widget.isNew)
      //{
      await ApiServices.postAmenitiesType(amenitiesType);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Amenity Added Successfully"),
      ));
      //}
      // else {
      //   await ApiServices.postUserbyid ( idcontroller.text, user );
      //   ScaffoldMessenger.of ( context )
      //       .showSnackBar ( const SnackBar (
      //     content: Text ( "User Updated Successfully" ), ) );
      // }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Please fill form correctly"),
      ));
    }
  }

  List<accommodationAmenities> accAmenities = [];
  _getAccAmenitites() async {
    ApiServices.fetch(
      'accommodationamenities',
    ) //current user id will pass here
        .then((response) {
      setState(() {
        try {
          Iterable list = json.decode(response.body);
          accAmenities = list
              .map((model) => accommodationAmenities.fromJson(model))
              .toList();
        } on Exception catch (e) {}
      });
    });
  }

  @override
  initState() {
    // at the beginning, all users are shown
    _getAccAmenitites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Text('Existing Accommodation Amenities'),
            // Divider(
            //   color: blackColor,
            // ),
            ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: accAmenities.length,
                itemBuilder: ((context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  accAmenities[index].name.toString(),
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
                                Text(
                                  accAmenities[index].description.toString() +
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
                  );
                })),
            Divider(
              color: blackColor,
            ),
            AddScreenTextFieldWidget(
                labelText: 'Amenity Type',
                textName: 'Amenity Type',
                obsecureText: false,
                inputType: TextInputType.name,
                controller: amnameController),
            AddScreenTextFieldWidget(
                labelText: 'Description',
                textName: 'Description',
                obsecureText: false,
                inputType: TextInputType.name,
                controller: amdesController),
            midPadding2,
            midPadding2,
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
                    accommodationAmenities amType;
                    amType = accommodationAmenities(
                        id: 0,
                        name: amnameController.text,
                        description: amdesController.text);
                    await _saveForm(amType);
                  },
                  child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
