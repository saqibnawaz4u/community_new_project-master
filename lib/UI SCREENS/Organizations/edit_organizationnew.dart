import 'dart:convert';
import 'package:community_new/models/CodeBook.dart';
import 'package:community_new/models/keyvalue.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/organization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../api_services/api_services.dart';
import '../../models/OrgAdmin.dart';
import '../../models/user.dart';
import '../../widgets/add_screen_text_field.dart';
import '../../widgets/dropdown.dart';
import 'org_tree.dart';

class OrganizationEditnew extends StatefulWidget {
  final int? organizationId;
  List<OrgAdmin>? selectedOrgUser = [];
  int? parentId;
 // var selectedindex;
 // List<OrgAdmin>? objOrgusers1 = [];
  final bool isNew;
   OrganizationEditnew({Key? key,required this.isNew,this.selectedOrgUser,
     //this.objOrgusers1,
     required this.organizationId,
   this.parentId,
     //this.jsondata
   }) : super(key: key);
  @override
  _OrganizationEditnewState createState() => _OrganizationEditnewState();
}
class _OrganizationEditnewState extends State<OrganizationEditnew>
    with SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<OrganizationEditnew>{

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
  var orgTypeController= TextEditingController();
  var addressLine2Controller = TextEditingController();
  var drpParentId = new DropDown(mylist: [] );
  var drpType = new DropDown(mylist: [] );
  final _form = GlobalKey<FormState>(); //for storing form state.
 // var dropdownCodeBook = new DropDownCodebook(mylist: [] );
  var organization = new Organization();
  var codebook = CodeBook();
  List<CodeBook> codebooks = [];
  List<Organization> organizations = [] ;
  List<KeyValue> KeyvaleusParentId= [];
  List<KeyValue> KeyvaleusOrgType= [];
  List<OrgAdmin> objOrgAdmin2 = [] ;
 // List<KeyValueCodeBook> Keyvaleuscodebook= [];
  KeyValue? selectedKeyValueParentId;
  KeyValue? selectedKeyValueOrgType;
 // KeyValueCodeBook? selectedKeyValuecodebook;

  Future<void> _saveForm(Organization organization) async{
    final isValid = _form.currentState!.validate();
    if (isValid) {
      if(widget.isNew)
      {
        await ApiServices.postOrganization(organization);
        Navigator.push(context, MaterialPageRoute
          (builder: (context) =>OrgTree()));
        ScaffoldMessenger.of(context)
            .showSnackBar( const SnackBar(
          content:Text("Organization Added Successfully"),));
      }
      else {
        await ApiServices.postOrganizationbyid(idcontroller.text, organization );
        ScaffoldMessenger.of ( context )
            .showSnackBar ( const SnackBar (
          content: Text ( "Organization Updated Successfully" ), ) );
      }
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar( const SnackBar(
        content:Text("Please fill form correctly"),));
    }
  }
  List<User> users = [];
  bool isSelected(int? p_Id)
  {
    if(widget.selectedOrgUser==null) return false;
    for(int i=0;i<widget.selectedOrgUser!.length;i++)
      if(widget.selectedOrgUser?[i].user_Id==p_Id) {
        // selectedIndexes[i]=selectedIndexes.length;
        return true;
      }
    return false;

  }
  _getUser() async{
    int currentUserId = await prefs.get ( 'userId' );
    await ApiServices.fetch ( 'user',
        actionName: 'GetUsersForOrg',
        param1: currentUserId.toString()
    ).then ( (response) {
      setState ( () {
        Iterable list = json.decode ( response.body );
        users = list.map ( (model) => User.fromJson ( model ) ).toList ( );
        //  print(response.body);
      } );
    } );
    // isChecked=await List<bool>.filled(users.length, false);
    // for(int i=0;i<users.length;i++){
    //   //if(isSelected(users[i].Id)){
    //   isChecked[i]=isSelected(users[i].Id);
      //}
    //}
  }
  //List<bool> isChecked=[];
  List<bool> assign=[];
  _getOrganization() async{
    int currentUserId = await prefs.get ( 'userId' );
    await ApiServices.fetch("organization",
    actionName: 'GetOrgForUserId',
      param1: currentUserId.toString()
    ).then((response) {
      setState ( () {
        Iterable listorganizations = json.decode ( response.body);
        organizations = listorganizations.map (
                (model) => Organization.fromJson ( model ) ).toList ( );
        //org parent id dropdown
        if (organizations.length > 0){
         KeyvaleusParentId.add (
            KeyValue( key: '0',
              value: "Please select Organzation") );
          for (int i = 0; i < organizations.length; i++){
            KeyvaleusParentId.add (
                   KeyValue( key: organizations[i].Id.toString(),
                value: organizations[i].description.toString()));
          }
        }
      }
      );
    });

    await ApiServices.fetchCodeBook("codebook",
    tableName: "organization", codeName: "orgtype"
    ).then((response) {
      setState ( () {
        Iterable listcodebook = json.decode ( response.body);
        // print(list);
        codebooks = listcodebook.map (
                (model) => CodeBook.fromJson ( model ) ).toList ( );
        //org parent id dropdown
        if (codebooks.length > 0){
          KeyvaleusOrgType.add ( KeyValue( key: '',
              value: "Please select Organization Type") );
          for (int i = 0; i < codebooks.length; i++){
            KeyvaleusOrgType.add (
                   KeyValue( key: codebooks[i].code_Value.toString(),
                    value: codebooks[i].display_Value.toString()));
          }
        }
      }
      );
    });
    // await ApiServices.fetch('user').then((response) {
    //   setState(() {
    //     Iterable list = json.decode(response.body);
    //     users = list.map((model) => User.fromJson(model)).toList();
    //     //  print(response.body);
    //   });
    // });
    if(widget.isNew==false) {
      await ApiServices.fetchForEdit(widget.organizationId , 'organization' )
          .then ( (response) {
        setState ((){
          var userBody = json.decode ( response.body );
          organization = Organization.fromJsonWithUsers ( userBody );
          if (organization != null) {
            idcontroller.text = organization.Id.toString ( );
           // idcontroller.text = widget.jsondata.toString ();
            emailController.text = organization.Email.toString ( );
            countryController.text = organization.country.toString ( );
            addressLine1Controller.text = organization.address1.toString ( );
            addressLine2Controller.text = organization.address2.toString ( );
            OrganizationNameController.text=organization.name.toString();
           descriptionController.text = organization.description.toString();
           cityController.text=organization.city.toString();
           parentIdController.text =organization.parentId.toString();
           phoneNoController.text = organization.phoneNo.toString();
           zipCodeController.text = organization.zipCode.toString();
           stateController.text = organization.state.toString();
           orgTypeController.text=organization.orgType.toString();
          // if(widget.objOrgusers1==null)

           {
             objOrgAdmin2=organization.Org_admin!;
           //widget.objOrgusers1=organization.Org_admin;
           }
           // else
           // {
           //   objOrgAdmin2=widget.objOrgusers1!;
           // }

           /* if (organization.users != [] ) {

            }*/
          //if(  KeyvaleusParentId!=null&& KeyvaleusParentId.length>0)
            {
              var testforParentId;
            if (organization.parentId != "null" &&
                organization.parentId != null)
            {
              //  print(user.default_Role_Id.toString()+" user edit");
              //_selected_default_Role_Id=user.default_Role_Id;
              //print(_selected_default_Role_Id.toString()+" user edit");
              //_selected_default_Role_Id=user.default_Role_Id;
              //dropdown.seletected_default_Role_Id=user.default_Role_Id;

              try {
                testforParentId =
                    KeyvaleusParentId.firstWhere ( (element) =>
                    element.key == organization.parentId.toString () );
              }
              catch (e) {
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
                testforOrgType = KeyvaleusOrgType.firstWhere
                  ( (element) =>
                element.key == organization.orgType.toString ( ) );
              }
              catch (e) {
                      testforOrgType = KeyvaleusOrgType[0];

              }
              //print("find org type");
              //print(test);

            }
            else {
              testforOrgType = KeyvaleusOrgType[0];

            }
              selectedKeyValueOrgType = testforOrgType;
          }
          }

        } );
      } );
    }else{
      if (widget.parentId != "null" &&
          widget.parentId != null) {
        //  print(user.default_Role_Id.toString()+" user edit");
        //_selected_default_Role_Id=user.default_Role_Id;
        //print(_selected_default_Role_Id.toString()+" user edit");
        //_selected_default_Role_Id=user.default_Role_Id;
        //dropdown.seletected_default_Role_Id=user.default_Role_Id;
        var testForParentid2;
        try{
        testForParentid2 = KeyvaleusParentId.firstWhere
          ( (element) =>
        element.key == widget.parentId.toString() );}
            catch(e){
              testForParentid2=KeyvaleusParentId[0];
            }
        selectedKeyValueParentId = testForParentid2;
        //dropdown.seletected_value=selectedKeyValue;
      }
      if(KeyvaleusOrgType!=null&& KeyvaleusOrgType.length>0){
         KeyvaleusOrgType[0];}
      parentIdController.text =widget.parentId.toString();
      orgTypeController.text =organization.orgType.toString();

      var currentid=prefs.getInt('userId');
      var currentuserName=prefs.getString('userName');
      objOrgAdmin2.add(OrgAdmin(
          org_Id: 0,
          user_Id: currentid,
        userName:currentuserName
       ));

    }
    drpParentId= DropDown(mylist: KeyvaleusParentId,
        seletected_value: selectedKeyValueParentId);

    drpType= DropDown(mylist: KeyvaleusOrgType,
        seletected_value: selectedKeyValueOrgType);
  }
 late TabController _tabController;
  @override
  void initState() {
    super.initState();
    assign=[false,false];
    _getOrganization();
    _getUser();
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
          //floatingActionButton: _tabController.index==0?SaveButton():null,
          // floatingActionButton:
          // _tabController.index==1?
          // SizedBox(
          //   width: MediaQuery.of(context).size.width/3.5,
          //   child: FloatingActionButton(
          //     child: Padding(
          //       padding:  EdgeInsets.all(8.0),
          //       child:
          //       Text("Assign Admin",style: whiteTextStyleNormal,),
          //     ),
          //     backgroundColor: appbarColor,
          //     shape:const RoundedRectangleBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(15.0))
          //     ),
          //     onPressed: ()async{
          //       await Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) =>
          //                 AssigningOrgAdmins(
          //                     selectedOrgUser: objOrgAdmin2
          //                 ),
          //           ));
          //       if(mounted){
          //         setState((){});
          //       }
          //       setState(() {});
          //     },
          //   ),
          // ) :null,
            backgroundColor: backgroundColor,
            appBar: AppBar(
              leading: IconButton(
                color: offWhite,
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(CupertinoIcons.chevron_back),
              ),
              // actions: [
              //   _tabController.index==1?
              //   TextButton(
              //         onPressed: ()async{
              //           await Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) =>
              //                     AssigningOrgAdmins(
              //                         selectedOrgUser: objOrgAdmin2
              //                     ),
              //               ));
              //           if(mounted){
              //             setState((){});
              //           }
              //           setState(() {});
              //         },
              //       child: DefaultTextStyle(
              //         style: const TextStyle(
              //           fontSize: 15,
              //         ),
              //         child: AnimatedTextKit(
              //           animatedTexts: [
              //             WavyAnimatedText('Assign Admins',
              //                 speed: Duration(milliseconds: 60),
              //                 textStyle: whiteTextStyleNormal),
              //           ],
              //           isRepeatingAnimation: true,
              //         ),
              //       ),
              //   )
              //       :Container()
                // SizedBox(
                //   width: MediaQuery.of(context).size.width/3.5,
                //   child: FloatingActionButton(
                //     child: Padding(
                //       padding:  EdgeInsets.all(8.0),
                //       child:
                //       Text("Assign Admin",style: whiteTextStyleNormal,),
                //     ),
                //     backgroundColor: appbarColor,
                //     shape:const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(15.0))
                //     ),
                //     onPressed: ()async{
                //       await Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) =>
                //                 AssigningOrgAdmins(
                //                     selectedOrgUser: objOrgAdmin2
                //                 ),
                //           ));
                //       if(mounted){
                //         setState((){});
                //       }
                //       setState(() {});
                //     },
                //   ),
                // )
             // ],
              // shape:const RoundedRectangleBorder(
              //   borderRadius: BorderRadius.vertical(
              //     bottom: Radius.circular(12),
              //   ),
              // ),
              backgroundColor: appColor,
              bottom:  TabBar(
                labelColor: appColor,
                unselectedLabelColor: offWhite,
                padding: EdgeInsets.only(bottom: 20),
                indicatorWeight: 0.01,
                controller: _tabController,
                tabs: [
              widget.isNew==false?
              Container(
                decoration: BoxDecoration(
                  color:_tabController.index==0?offWhite:appColor,
                  borderRadius: BorderRadius.circular(5)
                ),
                padding: EdgeInsets.all(12),
                child: Text("Edit Organization",
                 // style: appcolorTextStylebold,
                ),
              ):
              Container(
                  decoration: BoxDecoration(
                      color:_tabController.index==0?offWhite:appColor,
                      borderRadius: BorderRadius.circular(5)
                  ),
                padding: EdgeInsets.all(12),
                  child: Text("Add Organization",
                   // style: appcolorTextStylebold,
                  )),
                  Container(
                      decoration: BoxDecoration(
                          color:_tabController.index==1?offWhite:appColor,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      padding: EdgeInsets.all(12),
                      child: Text('Admins',
                        //style: appcolorTextStylebold,
                      )),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            // AddScreenTextFieldWidget(
                            //   p_readOnly: true,
                            //   labelText: "Id",
                            //   obsecureText: false,
                            //   controller: idcontroller,
                            //   textName: organization.Id.toString(),
                            //   inputType: TextInputType.none,
                            // ),
                            AddScreenTextFieldWidget(
                              labelText: "Organization Name",
                              obsecureText: false,
                              controller:OrganizationNameController ,
                              textName:  organization.name.toString(),  inputType: TextInputType.name,
                              validator: (text) {
                                if (!(text!.length > 2) && text.isEmpty) {
                                  return "Enter Organization name of more then 2 characters!";
                                }
                                return null;
                              },
                            ),
                            widget.parentId!=0?const Padding(
                              padding:  EdgeInsets.only(top: 10.0,bottom: 10,left: 15),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Organization Parent Id",
                                    style: BlackTextStyleNormal16,)),
                            ):Container(),
                            widget.parentId!=0?drpParentId :Container(),
                            //drpParentId,
                           const Padding(
                              padding: const EdgeInsets.only(top: 10.0,bottom: 10,left: 15),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Organization Type",
                                    style: BlackTextStyleNormal16,)),
                            ),
                            drpType,
                            Row(
                              children: [
                              Expanded(
                                child: AddScreenTextFieldWidget(
                                  labelText: "Country",
                                  obsecureText: false,
                                  controller: countryController,
                                  textName: organization.country.toString(),
                                  inputType: TextInputType.name,
                                  validator: (text) {
                                    if (!(text!.length > 2) && text.isEmpty) {
                                      return "*Required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                child: AddScreenTextFieldWidget(
                                  labelText: "City",
                                  obsecureText: false,
                                  controller: cityController,
                                  textName: organization.city.toString(),
                                  inputType: TextInputType.name,
                                  validator: (text) {
                                    if (!(text!.length > 3) && text.isEmpty) {
                                      return "*Required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],),
                            Row(children: [
                              Expanded(
                                child: AddScreenTextFieldWidget(
                                  labelText: "State",
                                  obsecureText: false,
                                  controller: stateController,
                                  textName: organization.state.toString(),
                                  inputType: TextInputType.name,
                                  validator: (text) {
                                    if (!(text!.length > 1) && text.isNotEmpty) {
                                      return "*Required";
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              Expanded(
                                child: AddScreenTextFieldWidget(
                                  labelText: "Postal Code",
                                  obsecureText: false,
                                  controller: zipCodeController,
                                  textName: organization.zipCode.toString(),
                                  inputType: TextInputType.name,
                                  validator: (text) {
                                    if ( text!.isEmpty) {
                                      return "*Required";
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
                              textName:organization.Email.toString(),
                              inputType: TextInputType.emailAddress,
                              validator: (value){
                                if(value!.isEmpty)
                                {
                                  return 'Please Enter your email';
                                }
                                if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").
                                hasMatch(value)){
                                  return 'Please enter a valid Email';
                                }
                                return null;
                              },

                            ),
                            Row(children: [
                              Expanded(
                                child: AddScreenTextFieldWidget(
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
                              Expanded(
                                child: AddScreenTextFieldWidget(
                                  labelText: "Address Line 2",
                                  obsecureText: false,
                                  controller: addressLine2Controller,
                                  textName: organization.address2.toString(),
                                  inputType: TextInputType.name,
                                ),
                              ),
                            ],),

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
                            midPadding,SaveButton()
                           // ElevatedButton(
                           //     style: ElevatedButton.styleFrom(
                           //         primary: Colors.blue, // background
                           //         onPrimary: Colors.white,
                           //         shape: const RoundedRectangleBorder(
                           //             borderRadius: BorderRadius.all(
                           //                 Radius.circular(24))
                           //         )),
                           //     onPressed: ()async{
                           //       await Navigator.push(
                           //           context,
                           //           MaterialPageRoute(
                           //             builder: (context) =>
                           //                 AssigningAdmins(
                           //                     selectedOrgUser: objOrgusers2
                           //                 ),
                           //           ));
                           //       if(mounted){
                           //         setState((){});
                           //       }
                           //       setState(() {});
                           //     },
                           //     child: Text("Assign Admin")),
                          // SaveButton(),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                    itemCount: users.length,
                    itemBuilder:  (_, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left:15.0,right: 15),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                            ),
                            color: Colors.white,
                            elevation: 10.0,
                            child: Column(
                              children: [
                                ListTile(
                                    leading:const CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage('assets/user.png'),
                                    ),
                                   // subtitle:Text(users[index].Id.toString()) ,
                                    title:Text(users[index].FullName.toString()),
                                  trailing:
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary:assign[index]==true?LightBlueColor:assignButton,
                                      onPrimary: assign[index]==true?blueColor:assignText,
                                    ),
                                    onPressed: ()async{
                                     if(assign[index]==true){
                                       setState(() {
                                         assign[index]=false;
                                       });
                                     }
                                     else if(assign[index]==false){
                                       setState(() {
                                         assign[index]=true;
                                       });
                                     }

                                    },
                                    child:assign[index]==true?Text('Assigned')
                                        :Text('Assign',),
                                  ),

                                ),

//                       ListTile(
//                         subtitle: Text(users[index].FullName.toString()),
//                         leading:Text(users[index].Id.toString()),
//                         onTap: null,
//                         title: Row(
//                           children: [
//                             Text(users[index].UserName.toString()),
//                             const Spacer(),
// Padding(
//   padding: const EdgeInsets.only(top:16.0),
//   child: ButtonTheme(
//     minWidth: MediaQuery.of(context).size.width / 7,
//     height: MediaQuery.of(context).size.height / 18,
//     child: ElevatedButton(
//       onPressed: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => UserEdit(
//                   isNew: false,
//                   userId: users[index]
//                       .Id
//                       .toString(),
//                 )));
//       },
//       style: ElevatedButton.styleFrom(
//           shadowColor: Colors.black,
//           primary: Colors.white,
//           onPrimary: Colors.white,
//           shape: CircleBorder()// foreground
//       ),
//       child:FaIcon(FontAwesomeIcons.edit,color: blackColor,)
//     ),
//   ),
// ),
//                             ElevatedButton(
//                                 style: crudButtonStyle,
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => UserEdit(
//                                               isNew: false,
//                                               userId: users[index]
//                                                   .Id
//                                           )));
//                                 },
//                                 child: editIcon),
//                             widthSizedBox,
//                             ElevatedButton(
//                                 style: crudButtonStyle,
//                                 onPressed: () async {
//                                   await apiService.deleteFn(int.parse(
//                                       users[index].Id.toString()),'user');
//                                   ScaffoldMessenger.of(context)
//                                       .showSnackBar(const SnackBar(
//                                       content:  Text("User Deleted Successfully")));
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             UserList(),
//                                       ));
//                                 },
//                                 child: deleteIcon),
// Padding(
//   padding: const EdgeInsets.only(top: 16.0),
//   child: ButtonTheme(
//     minWidth: MediaQuery.of(context).size.width / 7,
//     height:
//     MediaQuery.of(context).size.height / 18,
//     child: ElevatedButton(
//       onPressed: () async {
//         await apiService.deleteFn(int.parse(
//             users[index].Id.toString()),'user');
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(
//             content:  Text("User Deleted Successfully")));
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   UserList(),
//             ));
//       },
//       style: ElevatedButton.styleFrom(
//           shadowColor: Colors.white,
//           primary: Colors.black,
//           onPrimary: Colors.white,
//           shape:  CircleBorder() // foreground
//       ),
//       child: Icon(Icons.delete_outline)
//     ),
//   ),
// )
//                           ],
//                         )

                              ],
                            )),
                      );
                    }),
                //objOrgAdmin2.isEmpty?
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
                // Column(
                //   children: [
                //     Lottie.asset('assets/noresult.json'),
                //     DefaultTextStyle(
                //       style: const TextStyle(
                //         fontSize: 20.0,
                //       ),
                //       child: AnimatedTextKit(
                //         animatedTexts: [
                //           WavyAnimatedText('No Admins is Assigned!',
                //               speed: Duration(milliseconds: 60),
                //               textStyle: BlackTextStyleNormal),
                //           WavyAnimatedText('Please Assign Admins',
                //               speed: Duration(milliseconds: 60),
                //               textStyle: BlackTextStyleNormal),
                //         ],
                //         isRepeatingAnimation: true,
                //       ),
                //     ),
                //   ],):
                // Column(children: [
                //   Expanded(
                //     child: ListView.builder(
                //       //primary: false,
                //         shrinkWrap: true,
                //         itemCount:objOrgAdmin2.length,
                //         //itemCount: widget.selectedindex!.length,
                //         itemBuilder: (context, index) {
                //           return Padding(
                //             padding: const EdgeInsets.only(left:15.0,right: 15,top: 10),
                //             child: Card(
                //                 elevation: 10,
                //                 color: whiteColor,
                //                 child: Column(
                //                   children: [
                //                     ListTile(
                //                       //title: Text('hello'),
                //                       title: Text(objOrgAdmin2[index].userName.toString()),
                //                     ),
                //                   ],
                //                 )),
                //           );
                //         }
                //     ),
                //   ),
                //
                // ],)
              ],
            )
        ),
      ),
    );
  }
Widget SaveButton(){
    return  Container(
      width: MediaQuery.of(context).size.width/4,
      child: ElevatedButton(
        onPressed: () async{
          Organization organization ;
          if(!widget.isNew) {
            organization= Organization.WithId (
                Id: int.parse ( idcontroller.text ),
                //parentId: 0,
                parentId:
                int.parse(drpParentId.seletected_value!.key.toString()),
                name: OrganizationNameController.text,
                Email: emailController.text,
                country: countryController.text,
                zipCode: zipCodeController.text,
                city: cityController.text,
                address1: addressLine1Controller.text,
                address2: addressLine2Controller.text,
                description: descriptionController.text,
                phoneNo: phoneNoController.text,
                state: stateController.text,
                orgType: drpType.seletected_value!.key.toString(),
                //  orgType: '',
                Org_admin: objOrgAdmin2//objOrgusers2,
              //Orgusers:[]
            );
          }
          else
          {
            organization= Organization.WithId(
                Id:0,
                //parentId: 0,
                parentId:widget.parentId!=null? int.parse(
                    drpParentId.seletected_value!.key.toString()):0,
                //parentId: 0,
                name: OrganizationNameController.text,
                Email: emailController.text,
                country: countryController.text,
                zipCode: zipCodeController.text,
                city: cityController.text,
                address1: addressLine1Controller.text,
                address2: addressLine2Controller.text,
                description: descriptionController.text,
                phoneNo: phoneNoController.text,
                state: stateController.text,
                orgType: drpType.seletected_value!.key.toString(),
                // Org_admin:objOrgAdmin2
                Org_admin: objOrgAdmin2
              //Org_admin: objOrgAdmin2
            );
          }
          await _saveForm(organization);

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
    );
}

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

