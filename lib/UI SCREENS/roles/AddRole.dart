import 'dart:convert';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/role.dart';
import 'package:community_new/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:community_new/api_services/api_services.dart';

import '../../UI SCREENS/Users/UserEdit.dart';
import '../../widgets/add_screen_text_field.dart';
import '../../widgets/roles_dropdown.dart';
class AddRole extends StatefulWidget {
  const AddRole({Key? key}) : super(key: key);
  @override
  _AddRoleState createState() => _AddRoleState();
}
class _AddRoleState extends State<AddRole> {

  var keyController = TextEditingController();
  var valueController = TextEditingController();

  final String url = 'http://localhost:8040/api/role';

  final _form = GlobalKey<FormState>(); //for storing form state.

//saving form after validation
  Future<void> _saveForm(Role role) async{
    final isValid = _form.currentState!.validate();
    if (isValid) {
      await ApiServices.postRole(role);
      ScaffoldMessenger.of(context)
          .showSnackBar(  SnackBar(
        content:Text("role Added Successfully"),));
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar(  SnackBar(
        content:Text("Please fill form correctly"),));
    }
  }
  Future<String> getRoleData() async {
    var res = await http
        .get(Uri.parse ( url ), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    print(resBody);

    return "Sucess";
  }
  @override
  void initState() {
    super.initState();
    this.getRoleData();
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
                      const Center(child: Text("Add Roles",style: TextStyle(fontSize: 24),),),
                      midPadding2,
                      //const DropDownForRoles(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: (){},
                            child: const Text("What's New",style: TextStyle(decoration: TextDecoration.underline),),),
                        ),
                      ),
                      AddScreenTextFieldWidget(
                        obsecureText: false,
                        controller: valueController,
                        textName: "Role name",  inputType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          } else if (value.length < 6) {
                            return "role name should be atleast 6 characters";
                          } else
                            return null;
                        },labelText: "Role name",
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width/4,
                        height: MediaQuery.of(context).size.height/16,
                        child: ElevatedButton(
                          onPressed: () async{
                            Role role =  Role(
                               // key: int.parse(keyController.text),
                            value: valueController.text
                            );
                            await _saveForm(role);

                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // background
                              onPrimary: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(24))
                              )// foreground
                          ),
                          child: const Text("Add role"),
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

