import 'dart:convert';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/user.dart';
import 'package:flutter/material.dart';
import '../../../api_services/api_services.dart';
import 'package:http/http.dart' as http;

import 'edit_user_data.dart';

class UserView extends StatefulWidget {

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<UserView> {
  final ApiServices apiService = ApiServices();
  User? user;
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

  @override
  Widget build(BuildContext context) {
    _getUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users',style: TextStyle(color: blackColor),),
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
                    Card(
                        color: Colors.white,
                        elevation: 1.0,
                        child: Column(
                          children: [
                            ListTile(
                              subtitle: Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Text(users[index].FullName.toString()),
                              ),
                              onTap: null,
                              title: Row(
                                children: [
                                  Text(users[index].Id.toString()),
                                  widthSizedBox,
                                  Text(users[index].UserName.toString()),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(top:16.0),
                                    child: ButtonTheme(
                                      minWidth: MediaQuery.of(context).size.width / 7,
                                      height: MediaQuery.of(context).size.height / 18,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => EditUser(

                                                    mydata: users[index]
                                                        .Id
                                                        .toString(),
                                                  )));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shadowColor: Colors.black,
                                            primary: Colors.white,
                                            onPrimary: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        24))) // foreground
                                        ),
                                        child:const Text(
                                          "Edit",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  widthSizedBox,
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: ButtonTheme(
                                      minWidth: MediaQuery.of(context).size.width / 7,
                                      height:
                                      MediaQuery.of(context).size.height / 18,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await apiService.deleteFn(int.parse(
                                              users[index].Id.toString()),'user');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                              content:  Text("User Deleted Successfully")));
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserView(),
                                              ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shadowColor: Colors.white,
                                            primary: Colors.black,
                                            onPrimary: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        24))) // foreground
                                        ),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),),

                          ],
                        ))
                  ],);
                }));
  }
}
