
import 'dart:convert';

import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/role.dart';
import 'package:flutter/material.dart';

import '../api_services/api_services.dart';

class DropDownForRoles1 extends StatefulWidget {
   final int? seletected_default_Role_Id;
   DropDownForRoles1({Key? key,this.seletected_default_Role_Id}) : super(key: key)
   {
    // DropDownForRoles1.seletected_default_Role_Id=null;
   }

  @override
  _DropDownForRolesState createState() => _DropDownForRolesState();
}

class _DropDownForRolesState extends State<DropDownForRoles1> {
  Role? selectedRole;
  /*List<RoleModel> roles =<RoleModel>[ RoleModel( key: 4,value: 'Administrator1'),
    RoleModel(key:5,value: 'ProjectManager'),
    RoleModel(key: 6, value: "User")
  ];*/
   final ApiServices apiService = ApiServices();
   //RoleModel1? selectedrole;
   List<Role> roles = [] ;
   _getRoles() async {

    await ApiServices.fetch("role").then((response) {
        setState(() {
          Iterable list = json.decode(response.body);
         // print(list);
          roles = list.map((model) => Role.fromJson(model)).toList();
         // roles.insert(0, new Role(key:0,value:"please select Role"));
          if(roles.length>0){

          //print(roles[0].key);
          //print(roles[1].key);
          //print(roles[2].key);
         // print(response.body);
            selectedRole=null;
           // widget.seletected_default_Role_Id=null;
            print(widget.seletected_default_Role_Id.toString() + " from dropdown out side if");
           if(widget.seletected_default_Role_Id!="null" &&
               widget.seletected_default_Role_Id!=null  ) {

               print (
                   widget.seletected_default_Role_Id.toString ( ) +
                       " from dropdown inside if" );
               selectedRole = roles.firstWhere ( (element) => element.key ==
                   widget.seletected_default_Role_Id );
               }
             }
             //print("bye");
           });
     });
   }
  //String dropdownValue="";
@override
void initState() {
 //    print("hhhh");
    _getRoles();
    super.initState();
  //selectedRole=roles[1];

}
  @override
  Widget build(BuildContext context) {
    // _getRoles();
    return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Center(
                child:roles.length==0?
                DropdownButton(
                  onChanged: (int? value) {
                    setState(() {
                      //_value = value;
                    });
                  },
                  items:const [
                    DropdownMenuItem(
                      child: Text("List is empty"),
                      value: 0,
                    ),

                  ],
                )
                    :Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 15),
                      child: DropdownButton<Role>(
                          dropdownColor: appColor,
                       focusColor: Colors.white,
                        underline:const Text(""),
                  value: selectedRole!=null?selectedRole:roles[0],

                          onChanged: (Role? newValue) {
                      setState(() {
                        selectedRole = newValue;
                       // _getRoles();

                      });
                  },
                  items: roles.map((Role role) {
                      return  DropdownMenuItem<Role>(
                        value: role,
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            role.value.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                  }).toList()
                ),
                    ),
              ),
             // new Text("selected user name is ${selectedRole!.value} : and key is : ${selectedRole!.key}"),
            ],

    );
  }
}
// class RoleModel1{
//   final int? key;
//   final String? value;
//   RoleModel1({this.key,this.value});
// }

// class DropDownForRoles1 extends StatelessWidget {
//   const DropDownForRoles1({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }



