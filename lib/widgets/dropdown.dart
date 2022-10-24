import 'dart:convert';

import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/CodeBook.dart';
import 'package:community_new/models/keyvalue.dart';
import 'package:community_new/models/role.dart';
import 'package:flutter/material.dart';

import '../api_services/api_services.dart';

class DropDown extends StatefulWidget {
  KeyValue? seletected_value;
  // static KeyValue? SelectKeyValue;
  List<KeyValue> mylist;
  final bool? isSelected;
  DropDown(
      {Key? key, this.seletected_value, required this.mylist, this.isSelected})
      : super(key: key) {
    // DropDown.seletected_default_Role_Id=null;
    //   return seletected_value;
    //SelectKeyValue=seletected_value;
  }

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  // Role? selectedRole;
  /*List<RoleModel> roles =<RoleModel>[ RoleModel( key: 4,value: 'Administrator1'),
    RoleModel(key:5,value: 'ProjectManager'),
    RoleModel(key: 6, value: "User")
  ];*/
  final ApiServices apiService = ApiServices();
  //RoleModel1? selectedrole;
  //List<Role> roles = [] ;
  // list<KeyVale> ListValues
  //   _getRoles() async {
  //
  //    await ApiServices.fetch("role").then((response) {
  //        setState(() {
  //          Iterable list = json.decode(response.body);
  //         // print(list);
  //          roles = list.map((model) => Role.fromJson(model)).toList();
  //
  //          // copy roles into list<KeyVale> ListValues
  //          // for(int i=0;i<roles.length)
  //          //   {
  //          //
  //          //   }
  //
  //
  //         // roles.insert(0, new Role(key:0,value:"please select Role"));
  //          if(roles.length>0){
  //
  //          //print(roles[0].key);
  //          //print(roles[1].key);
  //          //print(roles[2].key);
  //         // print(response.body);
  //            selectedRole=null;
  //           // widget.seletected_default_Role_Id=null;
  //            print(widget.seletected_default_Role_Id.toString() + " from dropdown out side if");
  //           if(widget.seletected_default_Role_Id!="null" &&
  //               widget.seletected_default_Role_Id!=null  ) {
  //
  //               print (
  //                   widget.seletected_default_Role_Id.toString ( ) +
  //                       " from dropdown inside if" );
  //               selectedRole = roles.firstWhere ( (element) => element.key ==
  //                   widget.seletected_default_Role_Id );
  //               }
  //             }
  //             //print("bye");
  //           });
  //     });
  //   }
  //String dropdownValue="";
  @override
  Widget build(BuildContext context) {
    // _getRoles();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: widget.isSelected == true
              ? Container(
                  height: MediaQuery.of(context).size.height / 14,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: blackColor)),
                  child: DropdownButton<KeyValue>(
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 10),
                        child: Icon(Icons.arrow_drop_down_outlined),
                      ),
                      dropdownColor: whiteColor,
                      focusColor: whiteColor,
                      underline: const Text(""),
                      isExpanded: true,
                      value: widget.seletected_value != null
                          ? widget.seletected_value
                          : widget.mylist[0],
                      // value:widget.seletected_value,
                      // value: widget.mylist[4],
                      onChanged: null,
                      items: widget.mylist.map((KeyValue p_keyValue) {
                        return DropdownMenuItem<KeyValue>(
                          value: p_keyValue,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 14.0, bottom: 4, left: 8),
                            child: Text(
                              p_keyValue.value.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }).toList()))
              : widget.mylist.length == 0
                  ? Container(
                      height: MediaQuery.of(context).size.height / 14,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: blackColor)
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(8),)
                          ),
                      child: DropdownButton(
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 8.0, top: 10),
                          child: Icon(Icons.arrow_drop_down_outlined),
                        ),
                        isExpanded: true,
                        dropdownColor: whiteColor,
                        focusColor: whiteColor,
                        underline: Text(""),
                        onChanged: (int? value) {
                          setState(() {
                            //_value = value;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            child: Text("List is empty"),
                            value: 0,
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height / 14,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black54)
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(8),)
                          ),
                      child: DropdownButton<KeyValue>(
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 8.0, top: 10),
                            child: Icon(Icons.arrow_drop_down_outlined),
                          ),
                          dropdownColor: whiteColor,
                          focusColor: whiteColor,
                          underline: const Text(""),
                          isExpanded: true,
                          // value: DropDown.SelectKeyValue!=null?DropDown.SelectKeyValue:widget.mylist[0],
                          // value:widget.isSelected==true?
                          //     widget.mylist[4]
                          //     :widget.seletected_value!=null?
                          // widget.seletected_value:widget.mylist[0],
                          value: widget.seletected_value != null
                              ? widget.seletected_value
                              : widget.mylist[0],
                          onChanged: (KeyValue? newValue) {
                            setState(() {
                              print('org value');
                              print(newValue?.key);
                              // DropDown.SelectKeyValue = newValue;
                              widget.seletected_value = newValue;
                              // _getRoles();
                            });
                          },
                          items: widget.mylist.map((KeyValue p_keyValue) {
                            return DropdownMenuItem<KeyValue>(
                              value: p_keyValue,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 14.0, bottom: 4, left: 8),
                                child: Text(
                                  p_keyValue.value.toString(),
                                  style: TextStyle(color: blackColor),
                                ),
                              ),
                            );
                          }).toList())),
        ),
      ],
    );
  }
}
