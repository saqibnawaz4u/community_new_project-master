import 'dart:convert';
import 'package:community_new/UI%20SCREENS/roles/EditRole.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/role.dart';
import 'package:community_new/models/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../api_services/api_services.dart';
import 'package:http/http.dart' as http;

class Roles extends StatefulWidget {

  @override
  _RolesState createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  final ApiServices apiService = ApiServices();
  Role? role;
  List<Role> roles = [] ;

  _getRole()async {
    await ApiServices.fetch('role').then((response) {
      setState((){
        Iterable list = json.decode(response.body);
        roles = list.map((model) => Role.fromJson(model)).toList();
        //  print(response.body);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _getRole();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: appColor,
          child: Icon(Icons.add,color: whiteColor,),
          onPressed: () {  Navigator.push(
              context, MaterialPageRoute(builder: (context) =>   EditRole(mydata: '0',))); },
        ),
        appBar: AppBar(
          title: const Text('Roles',style: TextStyle(color: whiteColor),),
          centerTitle: true,
          backgroundColor: appColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        body: roles.isEmpty
            ? Center(child: Text('Empty'))
            : ListView.builder(
            itemCount: roles.length,
            itemBuilder: (context, index) {
              return Column(children: [
                Card(
                    color: Colors.white,
                    elevation: 1.0,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: null,
                          title: Row(
                            children: [
                              Text(roles[index].key.toString()),
                              widthSizedBox8,
                              Text(roles[index].value.toString()),
                              const Spacer(),
                              ElevatedButton(
                                style: crudButtonStyle,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditRole(
                                                mydata:  roles[index].key.toString()
                                            )));
                                  },
                                  child: editIcon),
                              widthSizedBox,
                              ElevatedButton(
                                style: crudButtonStyle,
                                  onPressed: () async {
                                    await apiService.deleteFn(int.parse(
                                        roles[index].key.toString()),'role');
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                        content:  Text("Role Deleted Successfully")));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Roles(),
                                        ));
                                  },
                                  child: deleteIcon),
                            ],
                          ),),

                      ],
                    ))
              ],);
            }));
  }
}
