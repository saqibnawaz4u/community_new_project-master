import 'dart:convert';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../api_services/api_services.dart';
import 'package:http/http.dart' as http;

import '../../models/OrgAdmin.dart';


class AssigningOrgAdmins extends StatefulWidget {
  List<OrgAdmin>? selectedOrgUser = [];
   AssigningOrgAdmins({this.selectedOrgUser});
  @override
  _AssigningOrgAdminsState createState() => _AssigningOrgAdminsState();
}


class _AssigningOrgAdminsState extends State<AssigningOrgAdmins> {

  bool isSelected(int? p_Id)
  {
    if(widget.selectedOrgUser==null) return false;
    for(int i=0;i<widget.selectedOrgUser!.length;i++)
      if(widget.selectedOrgUser?[i].user_Id==p_Id) {
       // selectedIndexes[i]=selectedIndexes.length;
        return true;
      }
    return false;

  }
  final ApiServices apiService = ApiServices();
  List<User> users = [];
  _getUser()async {
    String currentRole =await prefs.getString ( 'role_name' );
    int currentUserId = await prefs.get ( 'userId' );
    // await ApiServices.fetch('user').then((response) {
    //   setState(() {
    //     Iterable list = json.decode(response.body);
    //     users = list.map((model) => User.fromJson(model)).toList();
    //     //print(response.body);
    //   });
    // });
    await ApiServices.fetch ( 'user',
        actionName: 'getusersbyrolename',
        param1: 'orgadmin'
    ).then ( (response) {
      setState ( () {
        Iterable list = json.decode ( response.body );
        users = list.map ( (model) => User.fromJson ( model ) ).toList ( );
        //  print(response.body);
      } );
    } );
    // print('user length');
    // print(users.length);
     isChecked=await List<bool>.filled(users.length, false);
    for(int i=0;i<users.length;i++){
      //if(isSelected(users[i].Id)){
        isChecked[i]=isSelected(users[i].Id);
      //}
    }
  /*  if(widget.selectedOrgUser!=null) //return false;
        {
      for (int i = 0; i <users.length; i++) {
        if(isSelected(users[i].Id)) {
          selectedIndexes[i] = selectedIndexes.length;
        }
        }
        //  return true;
      }*/


  }
 //  Map<int,int> selectedIndexes = Map();
  //bool ischecked=false;
  List<bool> isChecked=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //isChecked=List<bool>.filled(7, false);
     _getUser();

  }
 // List<OrgUser> selectedOrgUser = [];
  @override
  Widget build(BuildContext context)  {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text('Assign Admins'),
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
              widget.selectedOrgUser!.clear();
              for(int i=0;i<isChecked.length;i++)
                {
                  if(isChecked[i]==true) {
                    widget.selectedOrgUser!.add ( OrgAdmin (
                        user_Id: users[i].Id,
                      fullName: users[i].FullName,
                        org_Id: 0,
                      userName: users[i].UserName
                    )
                    );

                  }
                }
              Navigator.of(context).pop(widget.selectedOrgUser);

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
                     // value:isSelected(users[index].Id),
                      //selectedIndexes.contains(index),
                      // onChanged: (bool? value){
                      //  widget.selectedOrgUser != null?
                      //      widget.selectedOrgUser!.remove(value):
                      //      debugPrint('ok');
                      //  widget.selectedOrgUser![index]=value as OrgAdmin;
                      //  setState(() {
                      //  });
                      // },
                      onChanged: (bool? value) {
                      setState(() {
                        isChecked[index] = value!;
                      });
                        // print('inside onchange');
                        // print(value);
                        // print('index range');
                        // print(index);
                        // print('before number of  selected index');
                        // print(selectedIndexes.length);
                        // print('before number of selected users');
                        // print(widget.selectedOrgUser!.length);
                        // if (selectedIndexes.length > 0) {
                        //   print ( 'before selectedindexes[index]' );
                        //   print ( selectedIndexes[index] );
                        // }
                        //   if(value==false){
                        //
                        //
                        // if(selectedIndexes.containsKey(index)){
                        //    //selectedIndexes.remove(index);// unselect
                        //   //widget.selectedOrgUser!.remove(index);
                        //   // selectedIndexes.remove(index);
                        //       //OrgAdmin(org_Id: 0 ,user_Id: users[index].Id,
                        //  //     userName:users[index].UserName,
                        //   //    fullName:users[index].FullName));
                        //   if (isSelected(users[index].Id)) {
                        //         widget.selectedOrgUser?.remove(widget
                        //             .selectedOrgUser![selectedIndexes[index]!]);
                        //       }
                        //       selectedIndexes.remove(index);
                        // //  selectedIndexes.remove(selectedIndexes[index]);
                        //  // widget.selectedOrgUser?.remove(widget.selectedOrgUser![index]);
                        //   setState(() {
                        //
                        //   });
                        // } }else {
                        //     if (!selectedIndexes.containsKey ( index )) {
                        //       setState ( () {
                        //         selectedIndexes[index] =
                        //             selectedIndexes.length; //select
                        //         widget.selectedOrgUser?.add ( OrgAdmin (
                        //             org_Id: 0,
                        //             user_Id: users[index].Id,
                        //             userName: users[index].UserName,
                        //             fullName: users[index].FullName ) );
                        //         //  selectedIndexes.removeAt(index);
                        //         //selectedIndexes.add(users[index].UserName.toString());
                        //       } );
                        //       // selectedIndexes.add(users[index].Id.toString());
                        //     }
                        //
                        //   }
                        // if (selectedIndexes.length > 0) {
                        //   print ( 'after selectedindexes[index]' );
                        //   print ( selectedIndexes[index] );
                        // }
                        // print('after number of  selected index');
                        // print(selectedIndexes.length);
                        // print('after number of selected users');
                        // print(widget.selectedOrgUser!.length);
                        // //else{  selectedIndexes.add(users[index].UserName.toString());}

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


