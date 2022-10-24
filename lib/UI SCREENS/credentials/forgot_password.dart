import 'dart:convert';

import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../api_services/api_services.dart';
import '../../models/user.dart';
import 'log_in.dart';

class ForgotPassword extends StatefulWidget {
  final int currentuserid;
  const ForgotPassword({Key? key,required this.currentuserid}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var passwordController = TextEditingController ( );
  var cnfrmpasswordController = TextEditingController ( );
  var idcontroller = TextEditingController();
  final _form = GlobalKey<FormState> ( );
  var user =  User();
  Future<void> _saveForm(User user) async{
    final isValid = _form.currentState!.validate();
    if (isValid) {
      await ApiServices.postUserbyid ( widget.currentuserid.toString(), user );
        ScaffoldMessenger.of ( context )
            .showSnackBar ( const SnackBar (
          behavior: SnackBarBehavior.floating,
          content: Text ( "Password Updated Successfully" ), ) );

    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar( const SnackBar(
        behavior: SnackBarBehavior.floating,
        content:Text("Please fill form correctly"),));
    }
  }

  _getUser() async{
   // int currentUserId = await prefs.get ( 'userId' );

      await ApiServices.fetchForEdit (widget.currentuserid , 'user' )
          .then ( (response) {
        setState ( () {
          var userBody = json.decode ( response.body );
          user = User.fromJson ( userBody );

          if (user != null) {
            idcontroller.text = user.Id.toString ( );
            passwordController.text = user.Password.toString ( );
            cnfrmpasswordController.text = user.Password.toString ( );

          }
        } );
      } );


  }
  @override
  void initState() {
    super.initState();
    _getUser();}



  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: IconButton(
            onPressed: (){
          Navigator.pop(context);
        },
            icon: Icon(Icons.chevron_left,color: blackColor,)),
        centerTitle: true,
        title: Text('Forgot Password',style: TextStyle(color: blackColor),),
      ),
      body: Form (
          key: _form,
          child: ListView(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: Image.asset('assets/greenph.png')// this is green
                //Image.asset('assets/placeholder.png') //this isblue
              ),
              Padding(padding: EdgeInsets.only(left: 15,right: 15),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0,top: 4),
                          child: Text('Enter New Password'),
                        ),
                        TextFieldWidget (
                          p_obsText: false,
                          p_prefixicon:
                          Icon ( MdiIcons.lockOutline ,color: appColor,),
                          controller: passwordController,
                          textName: "Password",
                          inputType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter password';
                            }
                            if(passwordController.text!=cnfrmpasswordController.text){
                              return "Password does not match";
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0,top: 8),
                          child: Text('Confirm Password'),
                        ),
                        TextFieldWidget (
                          p_obsText:false,
                          p_prefixicon:
                          Icon ( MdiIcons.lockOutline ,color: appColor,),
                          controller: cnfrmpasswordController,
                          textName: "Confirm Password",
                          inputType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please re-enter password';
                            }
                            if(passwordController.text!=cnfrmpasswordController.text){
                              return "Password does not match";
                            }
                            return null;
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15,right: 15),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/15,
                          child: elevatedbutton (
                              buttonText: "\t\t Update \t\t",
                              routing: () async {
                              User userobj;
                                   userobj= User.WithId (
                                        Id: int.parse ( idcontroller.text ),
                                        Password: passwordController.text,
                                        ConfirmPassword: cnfrmpasswordController
                                            .text,);

                                    Navigator.push (
                                        context, MaterialPageRoute (
                                        builder: (context) =>
                                          LogIn ( ),) );

                                await _saveForm(userobj);
                              }
                          ),
                        ),
                        SizedBox(height: 8,)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ) ),
    );
  }
}

