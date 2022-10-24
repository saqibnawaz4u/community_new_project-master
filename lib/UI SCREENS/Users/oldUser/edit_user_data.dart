import 'dart:convert';
import 'package:community_new/widgets/roles_dropdown.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/user.dart';
import 'package:flutter/material.dart';
import 'package:community_new/api_services/api_services.dart';
import 'package:http/http.dart' as http;
class EditUser extends StatefulWidget {
  final String mydata;
  const EditUser({Key? key,required this.mydata}) : super(key: key);
  @override
  _EditUserState createState() => _EditUserState();
}
class _EditUserState extends State<EditUser> {
  var fullNameController = TextEditingController();
  var idcontroller = TextEditingController();
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var publicEmailController = TextEditingController();
  // var invitationCodeController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  //var defaultcontroller = TextEditingController();

  // var myUser = user.toJson();
  // var userBody = json.encode(myUser);
  // var res = await http.post(Uri.parse ( UserUrl ),
  // headers: header, body: userBody);
  // print(res.statusCode);
  // return res.statusCode;
  final _form = GlobalKey<FormState>(); //for storing form state.

//saving form after validation
  Future<void> _saveForm(User user) async{
    final isValid = _form.currentState!.validate();
    if (isValid) {
       await ApiServices.postUserbyid(idcontroller.text,user);
      ScaffoldMessenger.of(context)
          .showSnackBar(  SnackBar(
        content:Text("User Updated Successfully"),));
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar(  SnackBar(
        content:Text("Please fill form correctly"),));
    }
  }


  var user = new User();
   _getUser() {
    ApiServices.fetchForEdit(int.parse(widget.mydata) ,'user' ).then((response) {
      setState(() {
        var userBody=json.decode(response.body);
        user=User.fromJson(userBody);
       // user=UserModel.fromJson(json.decode(response.body));
       // print(json.decode(response.body));
     //   Iterable list = json.decode(response.body);
       // user = list.map((model) => UserModel.fromJson(model)).toList()[0];
        print(user.Email.toString());
        print(userBody);
        idcontroller.text=user.Id.toString();
        emailController.text = user.Email.toString();
        publicEmailController.text = user.PublicEmail.toString();
        fullNameController.text = user.FullName.toString();
        userNameController.text=user.UserName.toString();
        passwordController.text = user.Password.toString();
        confirmPasswordController.text=user.ConfirmPassword.toString();
      });
    });
  }
  @override
  void initState() {
    super.initState();
    _getUser();
   }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blue.shade50,
          body: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height/10,),
                      const Center(child: Text("Edit User",style: TextStyle(fontSize: 24),),),
                     midPadding2,
                      AddUserTextFieldWidget(
                        labelText: "Id",
                        obsecureText: false,
                        controller: idcontroller,
                        textName: user.Id.toString(),
                        inputType: TextInputType.number,
                        // validator: (val) {
                        //   if (val.isEmpty) {
                        //     return "Full Name cannot be empty";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      ),

                      AddUserTextFieldWidget(
                        labelText: "Full Name",
                        obsecureText: false,
                        controller: fullNameController,
                        textName:  user.FullName.toString(),  inputType: TextInputType.name,
                        validator: (text) {
                          if (!(text!.length > 5) && text.isNotEmpty) {
                            return "Enter full name of more then 5 characters!";
                          }
                          return null;
                        },
                      ),
                      AddUserTextFieldWidget(
                        labelText: "User Name",
                        obsecureText: false,
                        controller: userNameController,
                        textName: user.UserName.toString(),  inputType: TextInputType.name,
                        validator: (text) {
                          if (!(text!.length > 5) && text.isNotEmpty) {
                            return "Enter valid username of more then 5 characters!";
                          }
                          return null;
                        },
                      ),
                      AddUserTextFieldWidget(
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
                      AddUserTextFieldWidget(
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
                      AddUserTextFieldWidget(
                        labelText: "Password",
                        obsecureText: true,
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
                      AddUserTextFieldWidget(
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
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width/4,
                        height: MediaQuery.of(context).size.height/16,
                        child: ElevatedButton(
                          onPressed: () async{
                            User user =  User.WithId(
                                 Id: int.parse(idcontroller.text),
                                UserName:userNameController.text,
                                Email: emailController.text,
                                FullName:fullNameController.text,
                                PublicEmail:publicEmailController.text,
                                Password:passwordController.text,
                                ConfirmPassword:confirmPasswordController.text);

                            await _saveForm(user);

                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // background
                              onPrimary: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(24))
                              )// foreground
                          ),
                          child: const Text("Update User"),
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
  const AddUserTextFieldWidget({Key? key, required this.textName,required this.obsecureText,
    required this.inputType, this.labelText,this.validator,this.textFieldLength,
    required this.controller
  }) : super(key: key);

  final String textName;
  final TextInputType inputType;
  final TextEditingController controller;
  final bool obsecureText;
  final int? textFieldLength;
  final String? labelText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 15,right: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(labelText.toString(),style: const TextStyle(
                    fontSize: 16, ),)),
            ),
            TextFormField(
              validator: validator,
              obscureText: obsecureText,
              //initialValue:  widget.textName,
              // initialValue: "i am initial",
              controller: controller,
              decoration:  InputDecoration(
                // hintText: widget.textName,
                fillColor: Colors.white,
                filled: true,
                border:  OutlineInputBorder(
                    borderRadius:  BorderRadius.circular(8.0),
                    borderSide: BorderSide.none
                ),
              ),
              keyboardType: inputType,

            ),
          ],
        )
    );
  }
}
