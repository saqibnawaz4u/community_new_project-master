import 'dart:convert';

import 'package:community_new/api_services/api_services.dart';
import 'package:flutter/material.dart';
import '../../constants/styles.dart';
import '../../models/user.dart';
import '../../widgets/add_screen_text_field.dart';
import '../credentials/log_in.dart';

class updateProfile extends StatefulWidget {
  final int? userId;
  final bool isNew;
  const updateProfile({Key? key, required this.isNew, this.userId})
      : super(key: key);

  @override
  State<updateProfile> createState() => _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  var fullNameController = TextEditingController();
  var idcontroller = TextEditingController();
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _saveForm(User user) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      await ApiServices.postUserbyid(idcontroller.text, user);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("User Updated Successfully"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Please fill form correctly"),
      ));
    }
  }

  var user = User();

  _getUserForProfile() async {
    if (widget.isNew == false) {
      await ApiServices.fetchForEdit(widget.userId, 'user').then((response) {
        setState(() {
          var userBody = json.decode(response.body);
          user = User.fromJson(userBody);

          if (user != null) {
            idcontroller.text = user.Id.toString();
            emailController.text = user.Email.toString();
            fullNameController.text = user.FullName.toString();
            userNameController.text = user.UserName.toString();
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserForProfile();
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: whiteColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.chevron_left,
                color: blackColor,
              )),
          centerTitle: true,
          title: Text(
            'Update Profile',
            style: TextStyle(color: blackColor),
          ),
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          AddScreenTextFieldWidget(
                            labelText: "Full Name",
                            obsecureText: false,
                            controller: fullNameController,
                            textName: user.FullName.toString(),
                            inputType: TextInputType.name,
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
                            textName: user.UserName.toString(),
                            inputType: TextInputType.name,
                            validator: (text) {
                              if (!(text!.length > 3) && text.isEmpty) {
                                return "Enter valid username of more then 3 characters!";
                              }
                              return null;
                            },
                          ),
                          AddScreenTextFieldWidget(
                            labelText: "Email",
                            obsecureText: false,
                            controller: emailController,
                            textName: user.Email.toString(),
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
                          midPadding2,
                          midPadding2,
                          Container(
                            //padding: EdgeInsets.only(left: 15, right: 15),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 15,
                            child: elevatedbutton(
                                buttonText: "\t\t Update \t\t",
                                routing: () async {
                                  User userobj;
                                  userobj = User.WithId(
                                      Id: int.parse(idcontroller.text),
                                      FullName: fullNameController.text,
                                      UserName: userNameController.text,
                                      Email: emailController.text);

                                  //Navigator.of(context).pop();

                                  await _saveForm(userobj);
                                }),
                          ),
                          SizedBox(
                            height: 8,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            )));
  }
}
