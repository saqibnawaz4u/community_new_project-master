import 'dart:convert';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/role.dart';
import 'package:community_new/models/user.dart';
import 'package:flutter/material.dart';
import 'package:community_new/api_services/api_services.dart';
import 'package:http/http.dart' as http;

import '../../UI SCREENS/Users/UserEdit.dart';
import '../../widgets/add_screen_text_field.dart';
import '../../widgets/roles_dropdown.dart';
class EditRole extends StatefulWidget {
  final String mydata;
  const EditRole({Key? key,required this.mydata}) : super(key: key);
  @override
  _EditRoleState createState() => _EditRoleState();
}
class _EditRoleState extends State<EditRole> {
  var valueController = TextEditingController();
  var keyController = TextEditingController();


  final _form = GlobalKey<FormState>(); //for storing form state.

//saving form after validation
  Future<void> _saveForm(Role role) async{
    final isValid = _form.currentState!.validate();
    if (isValid) {
      await ApiServices.postRolebyid(keyController.text,role);
      ScaffoldMessenger.of(context)
          .showSnackBar(  SnackBar(
        content:Text("role Updated Successfully"),));
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar(  SnackBar(
        content:Text("Please fill form correctly"),));
    }
  }


  var role = new Role();
  _getRole() {
    ApiServices.fetchForEdit(int.parse(widget.mydata) ,'role' ).then((response) {
      setState(() {
        var roleBody=json.decode(response.body);
        role=Role.fromJson(roleBody);
        keyController.text=role.key.toString();
        valueController.text = role.value.toString();

      });
    });
  }
  @override
  void initState() {
    super.initState();
    _getRole();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: whiteColor,
          body: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(onPressed: (){
                          Navigator.pop(context);
                        },
                            icon: Icon(Icons.arrow_back,color: blackColor,)),
                      ),
                      //SizedBox(height: MediaQuery.of(context).size.height/10,),
                      const Center(child: Text("Edit Role",style: TextStyle(fontSize: 24),),),
                      midPadding2,
                      //const DropDownForRoles(),
                      AddScreenTextFieldWidget(
                        labelText: "key",
                        obsecureText: false,
                        controller: keyController,
                        textName: role.key.toString(),
                        inputType: TextInputType.number,

                      ),
                      AddScreenTextFieldWidget(
                        labelText: "value",
                        obsecureText: false,
                        controller: valueController,
                        textName:  role.value.toString(),  inputType: TextInputType.name,
                        validator: (text) {
                          if (!(text!.length > 5) && text.isNotEmpty) {
                            return "Enter role name of more then 5 characters!";
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
                            Role role =  Role.withId(
                                key: int.parse(keyController.text),
                                value:valueController.text, );

                            await _saveForm(role);

                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // background
                              onPrimary: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(24))
                              )// foreground
                          ),
                          child: const Text("Update role"),
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

