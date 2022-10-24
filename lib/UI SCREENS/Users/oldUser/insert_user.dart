import 'dart:convert';

import 'package:community_new/widgets/roles_dropdown.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:community_new/api_services/api_services.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);
  @override
  _AddUserState createState() => _AddUserState();
}
class _AddUserState extends State<AddUser> {
  String? _mySelection;
  String? email,fullName,userName,cnfrmemail,passwrd,cnfrmpass,publicemail;
  var fullNameController = TextEditingController();
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var publicEmailController = TextEditingController();
 // var invitationCodeController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  //var defaultcontroller = TextEditingController();
  final String url = 'http://localhost:8040/api/user';

  final _form = GlobalKey<FormState>(); //for storing form state.

//saving form after validation
  Future<void> _saveForm(User user) async{
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
  }
  Future<String> getSWData() async {
    var res = await http
        .get(Uri.parse ( url ), headers: {"Accept": "application/json"});
          var resBody = json.decode(res.body);

    // setState(() {
    //   data = resBody;
    // });

    print(resBody);

    return "Sucess";
  }
  @override
  void initState() {
    super.initState();
    this.getSWData();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blue.shade50,
          body: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height/10,),
                      const Center(child: Text("Add User",style: TextStyle(fontSize: 24),),),
                      midPadding2,
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: (){},
                            child: const Text("What's New",style: TextStyle(decoration: TextDecoration.underline),),),
                        ),
                      ),
                      AddUserTextFieldWidget(

                        controller: fullNameController,
                        textName: "Full Name",  inputType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          } else if (value.length < 6) {
                            return "Full name should be atleast 6 characters";
                          } else
                            return null;
                        },
                      ),
                      AddUserTextFieldWidget(

                        controller: userNameController,
                        textName: "User Name",  inputType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          } else if (value.length < 6) {
                            return "user name should be atleast 6 characters";
                          } else
                            return null;
                        },
                      ),
                      AddUserTextFieldWidget(

                        controller: publicEmailController,
                        textName: "Public Email",  inputType: TextInputType.emailAddress,
                        validator: (value){
                          if(value!.isEmpty)
                          {
                            return 'Please Enter your email';
                          }
                          if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                            return 'Please enter a valid Public Email';
                          }
                          return null;
                        },
                      ),
                      AddUserTextFieldWidget(

                        controller: emailController,
                        textName: "Email",  inputType: TextInputType.emailAddress,
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
                      AddUserTextFieldWidget(
                        controller: passwordController,
                        textName: "Password",  inputType: TextInputType.text,
                        validator: (value){
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
                      AddUserTextFieldWidget(

                        controller: confirmPasswordController,
                        textName: "Retype Password",  inputType: TextInputType.text,
                        validator: (value){
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
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width/4,
                        height: MediaQuery.of(context).size.height/16,
                        child: ElevatedButton(
                          onPressed: () async{
                          User user =  User(
                              UserName:userNameController.text,Email: emailController.text,
                              FullName:fullNameController.text, PublicEmail:publicEmailController.text,
                              Password:passwordController.text, ConfirmPassword:confirmPasswordController.text);

                          await _saveForm(user);

                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // background
                              onPrimary: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(24))
                              )// foreground
                          ),
                          child: const Text("Add User"),
                        ),
                      )
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


class AddUserTextFieldWidget extends StatelessWidget {
  const AddUserTextFieldWidget({Key? key, required this.textName,this.validator,
    required this.inputType, required this.controller,
  }) : super(key: key);

  final String textName;
  final TextInputType inputType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 15,right: 15),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration:  InputDecoration(
          hintText: textName,
          fillColor: Colors.white,
          filled: true,
          border:  OutlineInputBorder(
              borderRadius:  BorderRadius.circular(8.0),
              borderSide: BorderSide.none
          ),
        ),
        keyboardType: inputType,

      ),
    );
  }
}