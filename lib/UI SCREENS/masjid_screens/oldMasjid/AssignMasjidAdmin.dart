import 'dart:convert';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/MasjidAdmin.dart';
import 'package:community_new/models/user.dart';
import 'package:flutter/material.dart';
import '../../../api_services/api_services.dart';

class AssigningMasjidAdmins extends StatefulWidget {
  List<MasjidAdminModel>? selectedMasjidUser = [];
  AssigningMasjidAdmins({this.selectedMasjidUser});
  @override
  _AssigningMasjidAdminsState createState() => _AssigningMasjidAdminsState();
}


class _AssigningMasjidAdminsState extends State<AssigningMasjidAdmins> {

  bool isSelected(int? p_Id)
  {
    if(widget.selectedMasjidUser==null) return false;
    for(int i=0;i<widget.selectedMasjidUser!.length;i++)
      if(widget.selectedMasjidUser?[i].user_Id==p_Id)
        return true;
    return false;
  }
  final ApiServices apiService = ApiServices();
  List<User> users = [] ;
  List<bool> isChecked=[];
  _getUser()async {
    // await ApiServices.fetch ( 'user' ).then ( (response) {
    //   setState ( () {
    //     Iterable list = json.decode ( response.body );
    //     users = list.map ( (model) => User.fromJson ( model ) ).toList ( );
    //     //print(response.body);
    //   } );
    // } );
    await ApiServices.fetch ( 'user',
        actionName: 'getusersbyrolename',
        param1: 'masjidadmin'
    ).then ( (response) {
      setState ( () {
        Iterable list = json.decode ( response.body );
        users = list.map ( (model) => User.fromJson ( model ) ).toList ( );
        //  print(response.body);
      } );
    } );
    isChecked = await List<bool>.filled( users.length, false );
    for (int i = 0; i < users.length; i++) {
      //if(isSelected(users[i].Id)){
      isChecked[i] = isSelected ( users[i].Id );
    }
    // List<OrgUser> selectedOrgUser = [];
    // bool _value = false;
    }
  @override
  void initState() {
    // TODO: implement initState
    super.initState ( );
    _getUser();
  }
  @override
  Widget build(BuildContext context) {
   // _getUser();
    return Scaffold(
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerTop,
        appBar: AppBar(
          shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
          backgroundColor: appColor,
          title:const Text('Assign Admins'),
          centerTitle: true,
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width/5,
            child: FloatingActionButton(
              onPressed: () {
                // setState(() {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) =>
                //               OrganizationEditnew(
                //                   isNew: false,
                //                   organizationId: 0,
                //                   selectedindex:
                //                   selectedIndexes,
                //                   objOrgusers1:widget.selectedOrgUser
                //               )
                //       ));
                // });
                setState(() {
                  widget.selectedMasjidUser!.clear();
                  for(int i=0;i<isChecked.length;i++)
                  {
                    if(isChecked[i]==true) {
                      widget.selectedMasjidUser!.add ( MasjidAdminModel (
                          user_Id: users[i].Id,
                          fullName: users[i].FullName,
                          masjid_Id : 0,
                          userName: users[i].UserName
                      )
                      );
                    }
                  }
                    Navigator.of ( context ).pop ( widget.selectedMasjidUser);
                });
              },
              child:const Text("Assign"),
              backgroundColor: appColor,
              shape:const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))
              ),
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        body: users.isEmpty
            ? Center(child: Text(
          'No User Found',
        ))
            : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Column(children: [
                Card(
                  color: Colors.white,
                  elevation: 1.0,
                  child: CheckboxListTile(
                    value: isChecked[index],
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked[index] = value!;
                      });
                      },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(users[index].UserName.toString()),

                    //checkColor: Colors.greenAccent,
                    activeColor: appColor,
                  ),
                ),
              ]
              );
            }));
  }
}


