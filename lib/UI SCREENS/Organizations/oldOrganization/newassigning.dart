import 'dart:convert';
import 'package:community_new/UI%20SCREENS/Organizations/edit_organizationnew.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../api_services/api_services.dart';
import 'package:http/http.dart' as http;


class AssigningAdminsnew extends StatefulWidget {

   AssigningAdminsnew();
  @override
  _AssigningAdminsnewState createState() => _AssigningAdminsnewState();
}

class _AssigningAdminsnewState extends State<AssigningAdminsnew> {
  final ApiServices apiService = ApiServices();
   List<User> users = [] ;
  _getUser()async {
    await ApiServices.fetch('user').then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) => User.fromJson(model)).toList();
        //  print(response.body);
      });
    });
  }

  List<bool>? _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(users.length, false);
  }

  @override
  Widget build(BuildContext context) {
    _getUser();
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width/5,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OrganizationEditnew(
                            isNew: false,organizationId: 0,
                          )
                  ));
            },
            child: Text("Assign"),
            backgroundColor: appColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
          ),
        ),
      ),
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
        backgroundColor: backgroundColor,
        body: users.isEmpty
            ? Center(child: Text('Empty'))
            : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Column(children: [
                CheckboxListTile(
                  title: Text(users[index].UserName.toString()),
                  value: _isChecked![index],
                  onChanged: (val) {
                    setState(
                          () {
                        _isChecked![index] = val!;
                      },
                    );
                  },
                )
              ]
              );
            }));
  }
}


