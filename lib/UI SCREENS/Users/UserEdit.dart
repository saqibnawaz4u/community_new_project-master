import 'dart:convert';
import 'package:community_new/UI%20SCREENS/Users/UserList.dart';
import 'package:community_new/models/keyvalue.dart';
import 'package:community_new/models/role.dart';
import 'package:community_new/widgets/roles_dropdown.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/user.dart';
import 'package:flutter/material.dart';
import 'package:community_new/api_services/api_services.dart';
import 'package:http/http.dart' as http;

import '../../models/organization.dart';
import '../../widgets/add_screen_text_field.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/roles_dropdown1.dart';
import '../credentials/log_in.dart';

class UserEdit extends StatefulWidget {
  final int? userId;
  final bool isNew;
  final bool? signup;
  const UserEdit({Key? key,required this.userId,
    required this.isNew,this.signup}) : super(key: key);
  @override
  _UserEditState createState() => _UserEditState();
}
class _UserEditState extends State<UserEdit> {
  var fullNameController = TextEditingController();
  var idcontroller = TextEditingController();
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var publicEmailController = TextEditingController();
  // var invitationCodeController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
var default_Role_IdController = TextEditingController();
  //var dropdown = new DropDown(mylist: [],);
  var dropdown = new DropDown(mylist: [],);
 // var selectedDrpUser = new DropDown(mylist: [],);

  // var myUser = user.toJson();
  // var userBody = json.encode(myUser);
  // var res = await http.post(Uri.parse ( UserUrl ),
  // headers: header, body: userBody);
  // print(res.statusCode);
  // return res.statusCode;
  final _form = GlobalKey<FormState>(); //for storing form state.
  /*Future<void> _saveForm(User user) async{
    final isValid = _form.currentState!.validate();
    if (isValid) {
      await ApiServices.postUser(user);
      ScaffoldMessenger.of(context)
          .showSnackBar(  SnackBar(
        content:Text("User Added Successfully"),));
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar(  SnackBar(
        content:Text("Please fill form correctly"),));
    }
  }*/
//saving form after validation
  Future<void> _saveForm(User user) async{
    final isValid = _form.currentState!.validate();
    if (isValid) {
   if(widget.isNew)
     {
       await ApiServices.postUser(user);
       ScaffoldMessenger.of(context)
           .showSnackBar( const SnackBar(
         content:Text("User Added Successfully"),));
     }
   else {
     await ApiServices.postUserbyid ( idcontroller.text, user );
     ScaffoldMessenger.of ( context )
         .showSnackBar ( const SnackBar (
       content: Text ( "User Updated Successfully" ), ) );
   }
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar( const SnackBar(
        content:Text("Please fill form correctly"),));
    }
  }


  var user =  User();
  var role =  Role();
  List<Role> roles = [];
  List<KeyValue> Keyvaleusorg= [];
  List<KeyValue> Keyvaleus= [];
  KeyValue? selectedKeyValue;
  KeyValue? selectedKeyValueOrgId;
  List<Organization> organizations=[];
  var drpOrg =  new DropDown(mylist: [] );
  // List<KeyValue> Keyvaleus1= [];
  // KeyValue? selectedKeyValue1;
//  int? _selected_default_Role_Id;
   _getUser() async{
     int currentUserId = await prefs.get ( 'userId' );
  await ApiServices.fetch("role").then((response) {
   setState ( () {
     Iterable listroles = json.decode ( response.body);
     // print(list);
     roles = listroles.map ( (model) => Role.fromJson
       ( model ) ).toList ( );
//print(response.body);
     // copy roles into list<KeyVale> ListValues
     // for(int i=0;i<roles.length)
     //   {
     //
     //   }
    // Keyvaleus=[];

     // roles.insert(0, new Role(key:0,value:"please select Role"));
     if (roles.length > 0) {
       Keyvaleus.add ( new KeyValue( key: '0', value: "Please Select Role" ) );
       for (int i = 0; i < roles.length; i++) {
         Keyvaleus.add (
             new KeyValue( key: roles[i].key.toString(),
                 value: roles[i].value ));
       }
       //dropdown=new DropDown(mylist: Keyvaleus);
     }
   }
   );
 });
  await ApiServices.fetch("organization",
  //actionName: 'GetOrgForUserId',
   // param1: currentUserId.toString()
  ).then((response) {
    setState ( () {
      Iterable listorganizations = json.decode ( response.body);
      organizations = listorganizations.map (
              (model) => Organization.fromJson ( model ) ).toList ( );
      //org parent id dropdown
      if (organizations.length > 0){
        Keyvaleusorg.add (
            KeyValue( key: '0',
                value: "Please select Organzation") );
        for (int i = 0; i < organizations.length; i++){
          Keyvaleusorg.add (
              KeyValue( key: organizations[i].Id.toString(),
                  value: organizations[i].description.toString()));
        }
      }
    }
    );
  });

 print(Keyvaleus.length);
  if(widget.isNew==false) {
    await ApiServices.fetchForEdit (  widget.userId , 'user' )
        .then ( (response) {
      setState ( () {
        var userBody = json.decode ( response.body );
        user = User.fromJson ( userBody );
        // user=UserModel.fromJson(json.decode(response.body));
        // print(json.decode(response.body));
        //   Iterable list = json.decode(response.body);
        // user = list.map((model) => UserModel.fromJson(model)).toList()[0];
        //  print(user.Email.toString());
        //  print(role.key.toString());
        //  print( int.parse(user.default_Role_Id.toString()));
        // print(userBody);
        if (user != null) {
          idcontroller.text = user.Id.toString ( );
          emailController.text = user.Email.toString ( );
          publicEmailController.text = user.PublicEmail.toString ( );
          fullNameController.text = user.FullName.toString ( );
          userNameController.text = user.UserName.toString ( );
          passwordController.text = user.Password.toString ( );
          confirmPasswordController.text = user.Password.toString ( );


          KeyValue testforOrgId;
          if (user.org_id != "null" && user.org_id != null) {
            try {
              // print('try assign  masjid ' +selectedKeyValueOrgId!.key.toString());
              testforOrgId = Keyvaleusorg.firstWhere(
                      (element) => element.key == user.org_id.toString());
            } catch (e) {

              testforOrgId = Keyvaleusorg[0];
            }
          } else {
            //print('after assign  masjid ' +
            //    selectedKeyValueOrgId!.value.toString());
            //print('inside if from masjid ' + masjid.Org_Id.toString());
            testforOrgId = Keyvaleusorg[0];
          }

          selectedKeyValueOrgId = testforOrgId;
          // _selected_default_Role_Id=null;
          if (user.default_Role_Id != "null" &&
              user.default_Role_Id != null) {
            //  print(user.default_Role_Id.toString()+" user edit");
            //_selected_default_Role_Id=user.default_Role_Id;
            //print(_selected_default_Role_Id.toString()+" user edit");
            //_selected_default_Role_Id=user.default_Role_Id;
            //dropdown.seletected_default_Role_Id=user.default_Role_Id;
            selectedKeyValue = Keyvaleus.firstWhere ( (element) =>
            element.key == user.default_Role_Id.toString());
            //dropdown.seletected_value=selectedKeyValue;
            }
          // print(userBody);
          }

        if (widget.signup==true && user.default_Role_Id != "null" &&
            user.default_Role_Id != null) {
          selectedKeyValue = Keyvaleus[4];
          drpOrg= DropDown(mylist: Keyvaleusorg,
              seletected_value: selectedKeyValueOrgId);
        }
        //defaultroleIdController.text = user.defaultRoleid.toString();
      } );
    } );
  }
  drpOrg= DropDown(mylist: Keyvaleusorg,
      seletected_value: selectedKeyValueOrgId);
   dropdown= DropDown(mylist: Keyvaleus,
       seletected_value: selectedKeyValue,);
  // selectedDrpUser= DropDown(mylist: Keyvaleus,
  //   seletected_value: selectedKeyValue,isSelected: true,);

   }

  // list<KeyVale> ListValues
//   _getRoles() async {
//
//     await ApiServices.fetch("role").then((response) {
//       setState(() {
//         Iterable list = json.decode(response.body);
//         // print(list);
//         roles = list.map((model) => Role.fromJson(model)).toList();
//
//         // copy roles into list<KeyVale> ListValues
//         // for(int i=0;i<roles.length)
//         //   {
//         //
//         //   }
//
//
//         // roles.insert(0, new Role(key:0,value:"please select Role"));
//         if(roles.length>0){
//           Keyvaleus.add(new KeyValue( key:0,value:"Please Select Role"));
// for(int i=0;i<roles.length;i++){
//   Keyvaleus.add(new KeyValue(key: roles[i].key,value: roles[i].value));
// }
//           //print(roles[0].key);
//           //print(roles[1].key);
//           //print(roles[2].key);
//           // print(response.body);
//          // selectedRole=null;
//           // widget.seletected_default_Role_Id=null;
//          // print(widget.seletected_default_Role_Id.toString() + " from dropdown out side if");
//         //  if(widget.seletected_default_Role_Id!="null" &&
//        //       widget.seletected_default_Role_Id!=null  ) {
//
//          //   print (
//           //      widget.seletected_default_Role_Id.toString ( ) +
//            //         " from dropdown inside if" );
//       //      selectedRole = roles.firstWhere ( (element) => element.key ==
//            //     widget.seletected_default_Role_Id );
//         //  }
//         }
//         //print("bye");
//       });
//     });
//   }
  @override
  void initState() {
    super.initState();
    //if(widget.isNew==false){
    _getUser();
    //
    //  dropdown= DropDown(mylist: Keyvaleus);
    // dropdown.seletected_value=selectedKeyValue;
   // }
   }

  @override
  Widget build(BuildContext context) {
    // if(widget.isNew==false){
    //   _getUser();}
    // dropdown.mylist=Keyvaleus;
    // dropdown.seletected_value=selectedKeyValue;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading:  IconButton(onPressed: (){
            //showAlertDialog(context);
          }, icon: Icon(Icons.arrow_back,color: blackColor,)),
          backgroundColor: backgroundColor,
          title:
        widget.signup==true?
        Text("Sign up",style: TextStyle(fontSize: 24,color: blackColor),)
          :(widget.isNew==false?
          Text("Edit User",style: TextStyle(fontSize: 24,color: blackColor),):
          Text("Add User",style: TextStyle(fontSize: 24,color: blackColor),))
        ),
          backgroundColor: backgroundColor,
          body: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Stack(
                children: [
                  // IconButton(onPressed: (){
                  //   Navigator.pop(context);
                  // }, icon: Icon(Icons.arrow_back)),
                  Column(
                    children: [
                //    selectedKeyValue=="null" || selectedKeyValue==null?Text("empty")
                    //DropDownForRoles1(seletected_default_Role_Id: 0,)
               //          :
               //  DropDown(seletected_value: selectedKeyValue,mylist: Keyvaleus),

                      // AddScreenTextFieldWidget(
                      //   p_readOnly: true,
                      //   labelText: "Id",
                      //   obsecureText: false,
                      //   controller: idcontroller,
                      //   textName: user.Id.toString(),
                      //   inputType: TextInputType.number,
                        // validator: (val) {
                        //   if (val.isEmpty) {
                        //     return "Full Name cannot be empty";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      // ),
                      widget.signup!=true?const Padding(
                        padding:  EdgeInsets.only(top: 8.0,bottom: 8),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Role Id",style: BlackTextStyleNormal16,)),
                      ):Container(),
                     // widget.signup==true
                     //     ?IgnorePointer(
                     //   child: selectedDrpUser,
                     //   ignoring: true,
                     // )
                     // :
                     widget.signup!=true?dropdown:
                     Container(),
                      const Padding(
                        padding:  EdgeInsets.only(top: 10.0,bottom: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Organization ",
                              style: BlackTextStyleNormal16,)),
                      ),
                      drpOrg,
                     //selectedDrpUser,
                      AddScreenTextFieldWidget(
                        labelText: "Full Name",
                        obsecureText: false,
                        controller: fullNameController,
                        textName:  user.FullName.toString(),  inputType: TextInputType.name,
                        validator: (text) {
                          if (!(text!.length > 5) && text.isEmpty) {
                            return "Enter full name of more then 5 characters!";
                          }
                          return null;
                        },
                      ),
                      AddScreenTextFieldWidget(
                        labelText: "User Name",
                        obsecureText: false,
                        controller: userNameController,
                        textName: user.UserName.toString(),  inputType: TextInputType.name,
                        validator: (text) {
                          if (!(text!.length > 3) && text.isEmpty) {
                            return "Enter valid username of more then 3 characters!";
                          }
                          return null;
                        },
                      ),

                      AddScreenTextFieldWidget(
                        labelText: "Public Email",
                        obsecureText: false,
                        controller: publicEmailController,
                        textName: user.PublicEmail.toString(),  inputType: TextInputType.emailAddress,
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
                        labelText: "Email",
                        obsecureText: false,
                        controller: emailController,
                        textName:user.Email.toString(),  inputType: TextInputType.emailAddress,
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
                        labelText: "Password",
                        obsecureText: true,
                        textFieldLength: 1,
                        controller: passwordController,
                        textName: user.Password.toString(),  inputType: TextInputType.text,
                        validator: ( value){
                          if(value!.isEmpty)
                          {
                            return 'Please re-enter password';
                          }
                          if(passwordController.text!=confirmPasswordController.text){
                            return "Password does not match";
                          }
                          return null;
                        },
                      ),
                      AddScreenTextFieldWidget(
                        textFieldLength: 1,
                        labelText: "Confirm Password",
                        obsecureText: true,
                        controller: confirmPasswordController,
                        textName: user.ConfirmPassword.toString(),  inputType: TextInputType.text,
                        validator: ( value){
                          if(value!.isEmpty)
                          {
                            return 'Please re-enter password';
                          }
                          if(passwordController.text!=confirmPasswordController.text){
                            return "Password does not match";
                          }
                          return null;
                        },
                      ),
                      midPadding,
                      Container(
                        width: MediaQuery.of(context).size.width/4,
                        child: ElevatedButton(
                          onPressed: () async{
                            User user ;
                            if(!widget.isNew) {
                             user= User.WithId (
                                  Id: int.parse ( idcontroller.text ),
                                 org_id:int.parse(drpOrg.seletected_value!.key.toString()),
                                  UserName: userNameController.text,
                                  Email: emailController.text,
                                  FullName: fullNameController.text,
                                  PublicEmail: publicEmailController.text,
                                  Password: passwordController.text,
                                  ConfirmPassword: confirmPasswordController.text,
                               // default_Role_Id: DropDown.SelectKeyValue?.key
                                 default_Role_Id: int.parse(dropdown.seletected_value!.key)
                              // default_Role_Id:int.parse(dropdown.seletected_value!.key)
                             );
                            }
                            else
                              {
                                user=User(
                                  default_Role_Id:widget.signup!=true?
                                  int.parse(dropdown.seletected_value!.key):7,
                                  org_id:int.parse(drpOrg.seletected_value!.key.toString()),
                                 // default_Role_Id:int.parse(dropdown.seletected_value!.key),
                                    UserName:userNameController.text,
                                  Email: emailController.text,
                                    FullName:fullNameController.text,
                                  PublicEmail:publicEmailController.text,
                                    Password:passwordController.text,
                                  ConfirmPassword:confirmPasswordController.text,

                                );
                              }
                            await _saveForm(user);

                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 3,
                              primary: appColor, // background
                              onPrimary: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(24))
                              )// foreground
                          ),
                          child: widget.signup!=true?Text("Save"):Text('Sign up'),
                        ),
                      ),midPadding2,
                    ],
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}


