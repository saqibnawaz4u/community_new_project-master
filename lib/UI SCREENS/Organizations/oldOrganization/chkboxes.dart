import 'dart:convert';

import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';

import '../../../api_services/api_services.dart';
import '../../../models/user.dart';

class chkboxes extends StatefulWidget {
  const chkboxes({Key? key}) : super(key: key);

  @override
  _chkboxesState createState() => _chkboxesState();
}

class _chkboxesState extends State<chkboxes> {
  // Generate a list of available hobbies here
  List<Map> availableHobbies = [
    {"name": "Foobball", "isChecked": false},
    {"name": "Baseball", "isChecked": false},
    {
      "name": "Video Games",
      "isChecked": false,
    },
    {"name": "Readding Books", "isChecked": false},
    {"name": "Surfling The Internet", "isChecked": false}
  ];

  final ApiServices apiService = ApiServices();
  List<User> users = [];
  _getUser()async {
    await ApiServices.fetch('user').then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) => User.fromJson(model)).toList();
        //  print(response.body);
      });
    });
  }
var checkboxClicked=false;
  var currentcheckboxClicked = false;
  @override
  Widget build(BuildContext context) {
    _getUser();
    return Scaffold(
        appBar: AppBar(
          title:  Text('Assign Admins',
            style: TextStyle(color: whiteColor),),
          centerTitle: true,
          backgroundColor: appColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
      body:
      Column(
        children: [

        const SizedBox(height: 10),
        // The checkboxes will be here
        Column(
            children: availableHobbies.map((hobby) {
              return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: hobby["isChecked"],
                  title: Text(users[users.length-1].UserName.toString()),
                  onChanged: (newValue) {
                    setState(() {
                      hobby["isChecked"] = newValue;
                    });
                  });
            }).toList()),


        //   Column(
        //     children: List.generate(users.length,(index){
        //      return CheckboxListTile(
        //        controlAffinity: ListTileControlAffinity.leading,
        //        title: Text(users[index].UserName.toString()),
        //          value: checkboxClicked,
        //          onChanged: ( newValue){
        //          setState(() {
        //            checkboxClicked=newValue!;
        //          });
        //          }
        //          );
        //     }),
        //   ),
        // Display the result here
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
        Wrap(
          children: availableHobbies.map((hobby) {
            if (hobby["isChecked"] == true) {
              return Card(
                elevation: 3,
                color: appColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(hobby["name"]),
                ),
              );
            }
            return Container();
          }).toList(),
        )
      ],)
    );
  }
}