import 'dart:convert';
import 'package:community_new/UI%20SCREENS/masjid_screens/oldMasjid/AssignMasjidAdmin.dart';
import 'package:community_new/models/MasjidAdmin.dart';
import 'package:community_new/models/masjid.dart';
import 'package:community_new/widgets/roles_dropdown.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/user.dart';
import 'package:flutter/material.dart';
import 'package:community_new/api_services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../../models/keyvalue.dart';
import '../../../models/organization.dart';
import '../../../widgets/add_screen_text_field.dart';
import '../../../widgets/dropdown.dart';



class EditMasjid extends StatefulWidget {
  final String masjidId;
  final bool isNew;
  List<MasjidAdminModel>? objMasjidAdmin1 = [];
   EditMasjid({Key? key,required this.masjidId,
    required this.isNew,this.objMasjidAdmin1}) : super(key: key);
  @override
  _EditMasjidState createState() => _EditMasjidState();
}
class _EditMasjidState extends State<EditMasjid> with SingleTickerProviderStateMixin{
  var idController = TextEditingController();
  var OrgIdController = TextEditingController();
  var masjidNameController = TextEditingController();
  var descriptiomController = TextEditingController();
  var locationController = TextEditingController();
  var emailController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var countryController = TextEditingController();
  var postalCodeController = TextEditingController();
  var phoneController = TextEditingController();
  var drpOrg =  new DropDown(mylist: [] );
  final _form = GlobalKey<FormState>(); //for storing form state.
  List<Organization> organizations=[];
  List<KeyValue> Keyvaleus= [];
  //List<MasjidAdminModel> objMasjidusers = [] ;
  var organization =  Organization();
  KeyValue? selectedKeyValueOrgId;
  List<MasjidAdminModel> objMasjidAdmin2 = [] ;
  Future<void> _saveForm(Masjid masjid) async{
    final isValid = _form.currentState!.validate();
    if (isValid) {
      if(widget.isNew)
      {
        await ApiServices.postMasjid(masjid);
        ScaffoldMessenger.of(context)
            .showSnackBar( SnackBar(
          content:Text("Masjid Added Successfully"),));
      }
      else {
        await ApiServices.postmasjidbyid (idController.text, masjid );
        ScaffoldMessenger.of ( context )
            .showSnackBar ( SnackBar (
          content: Text ( "Masjid Updated Successfully" ), ) );
      }
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar(  SnackBar(
        content:Text("Please fill form correctly"),));
    }
  }

  var masjid = new Masjid();
  List<Masjid> masjids = [] ;
  _getMasjid() async{
    await ApiServices.fetch("organization").then((response) {
      setState ( () {
        Iterable listorganizations = json.decode ( response.body);
        organizations = listorganizations.map (
                (model) => Organization.fromJson ( model ) ).toList ( );
        //org parent id dropdown
        if (organizations.length > 0){
          Keyvaleus.add (
              KeyValue( key: '0',
                  value: "Please select Organzation") );
          for (int i = 0; i < organizations.length; i++){
            Keyvaleus.add (
                KeyValue( key: organizations[i].Id.toString(),
                    value: organizations[i].description.toString()));
          }
        }
      }
      );
    });
    if(widget.isNew==false){
      ApiServices.fetchForEdit(int.parse(widget.masjidId),'masjid').
      then((response) {
        setState(() {
          var masjidBody = json.decode ( response.body );
          masjid = Masjid.fromJsonWithUsers ( masjidBody );
          // user=UserModel.fromJson(json.decode(response.body));
          // print(json.decode(response.body));
          //   Iterable list = json.decode(response.body);
          // user = list.map((model) => UserModel.fromJson(model)).toList()[0];
          // print(masjid.Email.toString());
          //  print(masjidBody);
          if(masjid!=null){
            idController.text = masjid.Id.toString ( );
             OrgIdController.text=masjid.Org_Id.toString();
            emailController.text = masjid.Email.toString ( );
            masjidNameController.text = masjid.Name.toString ( );
            locationController.text = masjid.Location.toString ( );
            descriptiomController.text = masjid.Description.toString ( );
            cityController.text = masjid.City.toString ( );
            countryController.text = masjid.Country.toString ( );
            phoneController.text = masjid.Phone1.toString ( );
            postalCodeController.text = masjid.PostalCode.toString ( );
            stateController.text = masjid.State.toString ( );


            if (widget.objMasjidAdmin1 == null) {
              objMasjidAdmin2 = masjid.Masjid_admin;
              widget.objMasjidAdmin1 = masjid.Masjid_admin;
            }
            else {
              objMasjidAdmin2 = widget.objMasjidAdmin1!;
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
          drpOrg= DropDown(mylist: Keyvaleus,
              seletected_value: selectedKeyValueOrgId);
        });
      } );
    }
    else{
      if(Keyvaleus!=null&& Keyvaleus.length>0){
        selectedKeyValueOrgId= Keyvaleus[0];
      }
      //print('ok masjid ' +selectedKeyValueOrgId!.key.toString());
       OrgIdController.text=masjid.Org_Id.toString();
      drpOrg= DropDown(mylist: Keyvaleus,
          seletected_value: selectedKeyValueOrgId);

      var currentid=prefs.getInt('userId');
      var currentuserName=prefs.getString('userName');
      objMasjidAdmin2.add(MasjidAdminModel(
          masjid_Id: 0,
          user_Id: currentid,
          userName:currentuserName
      ));
    }

    // drpOrg=new DropDown(mylist: Keyvaleus,
    //     seletected_value: selectedKeyValueOrgId);
    //print('try assign  masjid ' +selectedKeyValueOrgId!.key.toString());

  }

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    //if(widget.isNew==false){
      _getMasjid();
   // }
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
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
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
            floatingActionButton: _tabController.index==1?
            SizedBox(
              width: MediaQuery.of(context).size.width/3.5,
              child: FloatingActionButton(
                child:const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text("Assign Admin",style: whiteTextStyleNormal,),
                ),
                backgroundColor: appColor,
                shape:const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))
                ),
                onPressed: ()async{
                        await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AssigningMasjidAdmins(
                                selectedMasjidUser: objMasjidAdmin2
                            ),
                      ));
                  if(mounted){
                    setState((){});
                  }
                  setState(() {});
                },
              ),
            ) :null,
            backgroundColor: backgroundColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70.0),
              child: AppBar(
                shape:const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                backgroundColor: appColor,
                bottom:  TabBar(
                  controller: _tabController,
                  indicatorColor: whiteColor,
                  labelColor: whiteColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    widget.isNew==false? Text("Edit Masjid",
                      style: whiteTextStyleNormalTabbar,):
                    Text("Add Masjid",style: whiteTextStyleNormalTabbar,),
                    Text('Admins',style: whiteTextStyleNormalTabbar,),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _form,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            AddScreenTextFieldWidget(
                              labelText: "Masjid Name",
                              obsecureText: false,
                              controller: masjidNameController,
                              textName:  masjid.Name.toString(),  inputType: TextInputType.name,
                              validator: (text) {
                                if (!(text!.length > 5) && text.isEmpty) {
                                  return "Enter Masjid name of more then 5 characters!";
                                }
                                return null;
                              },
                            ),
                            const Padding(
                              padding: const EdgeInsets.only(top: 10.0,bottom: 10,left: 15),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Organization ",
                                    style: BlackTextStyleNormal16,)),
                            ),
                            drpOrg,
                            AddScreenTextFieldWidget(
                              labelText: "location",
                              obsecureText: false,
                              controller: locationController,
                              textName: masjid.Location.toString(),  inputType: TextInputType.text,
                              validator: (text) {
                                if ( text!.isEmpty) {
                                  return "* Required";
                                }
                                return null;
                              },
                            ),
                            AddScreenTextFieldWidget(
                              labelText: "Description",
                              obsecureText: false,
                              controller: descriptiomController,
                              textName: masjid.Description.toString(),
                              inputType: TextInputType.multiline,
                              validator: (value){
                                if (!(value!.length > 5) && value.isEmpty) {
                                  return "Description should not be less than 5 characters";
                                }
                                return null;
                              },
                            ),
                            Row(children: [
                              Expanded(
                                child: AddScreenTextFieldWidget(
                                  labelText: "Country",
                                  obsecureText: false,
                                  controller: countryController,
                                  textName: masjid.Country.toString(),  inputType: TextInputType.text,
                                  validator: ( value){
                                    if(value!.isEmpty)
                                    {
                                      return 'Please enter you Country';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                child: AddScreenTextFieldWidget(
                                  labelText: "State name",
                                  obsecureText: false,
                                  controller: stateController,
                                  textName: masjid.State.toString(),  inputType: TextInputType.text,
                                  validator: ( value){
                                    if(value!.isEmpty)
                                    {
                                      return 'Please enter you state';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                            ],),
                            Row(children: [
                              Expanded(
                                child: AddScreenTextFieldWidget(
                                  labelText: "City",
                                  obsecureText: false,
                                  controller: cityController,
                                  textName: masjid.City.toString(),
                                  inputType: TextInputType.text,
                                  validator: ( value){
                                    if(value!.isEmpty)
                                    {
                                      return 'Please enter you city';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              Expanded(
                                child: AddScreenTextFieldWidget(
                                  labelText: "Postal Code",
                                  obsecureText: false,
                                  controller: postalCodeController,
                                  textName: masjid.PostalCode.toString(),  inputType: TextInputType.number,
                                  validator: ( value){
                                    if(value!.isEmpty)
                                    {
                                      return '* Required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],),
                            AddScreenTextFieldWidget(
                              labelText: "Email",
                              obsecureText: false,
                              controller: emailController,
                              textName:masjid.Email.toString(),  inputType: TextInputType.emailAddress,
                              validator: (value){
                                if(value!.isEmpty)
                                {
                                  return 'Please Enter your email';
                                }
                                if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                                  return 'Please enter a valid Email';
                                }
                                return null;
                              },
                            ),
                            AddScreenTextFieldWidget(
                              labelText: "Phone Number",
                              obsecureText: false,
                              controller: phoneController,
                              textName: masjid.Phone1.toString(),  inputType: TextInputType.number,
                              validator: ( value){
                                if(value!.isEmpty)
                                {
                                  return '* Required';
                                }
                                return null;
                              },
                            ),
                            midPadding,
                        Container(
                              width: MediaQuery.of(context).size.width/2,
                              child: ElevatedButton(
                                onPressed: () async{
                                  Masjid masjid ;
                                  if(!widget.isNew) {
                                    masjid= Masjid.WithId (
                                      Id: int.parse (idController.text ),
                                      Org_Id:int.parse(drpOrg.seletected_value!.key.toString()),
                                      Name: masjidNameController.text,
                                      Email: emailController.text,
                                      Location : locationController.text,
                                      Country: countryController.text,
                                      City: cityController.text,
                                      Phone1: phoneController.text,
                                      PostalCode: postalCodeController.text,
                                      State: stateController.text,
                                      Description: descriptiomController.text,
                                        Masjid_admin: widget.objMasjidAdmin1!,
                                    );
                                  }
                                  else
                                  {
                                    masjid=Masjid.WithId(
                                      Org_Id:int.parse(drpOrg.seletected_value!.key.toString()),
                                      Name: masjidNameController.text,
                                      Email: emailController.text,
                                      Location : locationController.text,
                                      Country: countryController.text,
                                      City: cityController.text,
                                      Phone1: phoneController.text,
                                      PostalCode: postalCodeController.text,
                                      State: stateController.text,
                                      Description: descriptiomController.text,
                                        Masjid_admin: widget.objMasjidAdmin1!
                                    );
                                  }

                                  await _saveForm(masjid);

                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    primary: appColor, // background
                                    onPrimary: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(24))
                                    )// foreground
                                ),
                                child: const Text("Save"),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Padding(
                //   padding:  EdgeInsets.only(left:15.0,top: 8),
                //   child: Align(
                //       alignment: Alignment.topLeft,
                //       child: Text("Admins",style: BlackTextStyleBold18,)),
                // ),
                objMasjidAdmin2.isEmpty?
                // Padding(
                //     padding: const EdgeInsets.all(12.0),
                //     child: Marquee(
                //       blankSpace: 50,
                //       style: BlackTextStyleNormal16,
                //       fadingEdgeStartFraction: 0.3,
                //       fadingEdgeEndFraction: 0.9,
                //       pauseAfterRound: Duration(seconds: 1),
                //       text: 'No Admins is Assigned Please Assign Admins ',
                //     )
                // ):
                // Center(
                //   child: DefaultTextStyle(
                //     style: const TextStyle(
                //       fontSize: 20.0,
                //     ),
                //     child: AnimatedTextKit(
                //       animatedTexts: [
                //         WavyAnimatedText('No Admins is Assigned!',
                //             speed: Duration(milliseconds: 60),
                //             textStyle: BlackTextStyleNormal),
                //         WavyAnimatedText('Please Assign Admins',
                //             speed: Duration(milliseconds: 60),
                //             textStyle: BlackTextStyleNormal),
                //       ],
                //       isRepeatingAnimation: true,
                //     ),
                //   )
                // ):
               // RiveAnimation.asset('assets/avatar.riv')
                    //:
               Column(
                 children: [
                 Lottie.asset('assets/noresult.json'),
                 // DefaultTextStyle(
                 //   style: const TextStyle(
                 //     fontSize: 20.0,
                 //   ),
                 //   child: AnimatedTextKit(
                 //     animatedTexts: [
                 //       WavyAnimatedText('No Admins is Assigned!',
                 //           speed: Duration(milliseconds: 60),
                 //           textStyle: BlackTextStyleNormal),
                 //       WavyAnimatedText('Please Assign Admins',
                 //           speed: Duration(milliseconds: 60),
                 //           textStyle: BlackTextStyleNormal),
                 //     ],
                 //     isRepeatingAnimation: true,
                 //   ),
                 // ),
               ],):
                ListView.builder(
                  //primary: false,
                    shrinkWrap: true,
                    itemCount:objMasjidAdmin2.length,
                    //itemCount: widget.selectedindex!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left:15.0,right: 15,top: 10),
                        child: Card(
                            elevation: 10,
                            color: whiteColor,
                            child: Column(
                              children: [
                                ListTile(
                                  title:
                                  Text(
                                      objMasjidAdmin2[index].userName.toString()
                                  ),
                                ),
                              ],
                            )),
                      );
                    }
                ),
              ],
            )
        ),
      ),
    );
  }
}

