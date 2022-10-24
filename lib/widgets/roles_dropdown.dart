
import 'dart:convert';

import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/CodeBook.dart';
import 'package:community_new/models/keyvalue.dart';
import 'package:community_new/models/role.dart';
import 'package:flutter/material.dart';

import '../api_services/api_services.dart';

class DropDowncheck extends StatefulWidget {
  KeyValue? seletected_value;
  // static KeyValue? SelectKeyValue;
  List<KeyValue> mylist;
  final bool? isSelected;
  DropDowncheck({Key? key, this.seletected_value,
    required this.mylist,this.isSelected})
      : super(key: key)
  {
    // DropDown.seletected_default_Role_Id=null;
    //   return seletected_value;
    //SelectKeyValue=seletected_value;
  }

  @override
  _DropDowncheckState createState() => _DropDowncheckState();
}

class _DropDowncheckState extends State<DropDowncheck> {

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
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child:
          widget.mylist.length==0?
          Padding(
            padding: const EdgeInsets.only(left:15.0,right: 15,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height/14,
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey)
              ),
              child: DropdownButton(
                isExpanded: true,
                dropdownColor: backgroundColor,
                focusColor: whiteColor,
                underline: Text(""),
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
              ),
            ),
          ):
            widget.isSelected==true? Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15,
              ),
              child: Container(
                  height: MediaQuery.of(context).size.height / 14,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey)
                      ),
                  child: DropdownButton<KeyValue>(
                      dropdownColor: backgroundColor,
                      focusColor: whiteColor,
                      underline: const Text(""),
                      isExpanded: true,
                      // value: widget.seletected_value != null
                      //     ? widget.seletected_value
                      //     : widget.mylist[4],
                      value:widget.seletected_value==null?
                      widget.seletected_value:widget.mylist[4],
                      //value: widget.mylist[4],
                      onChanged:null,
                      items: widget.mylist.map((KeyValue p_keyValue) {
                        return DropdownMenuItem<KeyValue>(
                          value: p_keyValue,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 12.0, bottom: 8, left: 8),
                            child: Text(
                              p_keyValue.value.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }).toList())))



              : Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15,
              ),
              child: Container(
                  height: MediaQuery.of(context).size.height/14,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey)
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(8),)
                  ),
                  child:
                  DropdownButton<KeyValue>(
                      dropdownColor: backgroundColor,
                      focusColor: whiteColor,
                      underline:const Text(""),isExpanded: true,
                      // value: DropDown.SelectKeyValue!=null?DropDown.SelectKeyValue:widget.mylist[0],
                      value:widget.seletected_value!=null?
                      widget.seletected_value:
                      widget.isSelected==true?widget.mylist[4]
                          :
                      widget.mylist[0],
                      //value:widget.seletected_value!=null?widget.seletected_value:widget.mylist[0],
                      onChanged:
                          (KeyValue? newValue) {
                        setState(() {
                          print(newValue?.key);
                          // DropDown.SelectKeyValue = newValue;
                          widget.seletected_value=newValue;
                          // _getRoles();

                        });
                      },
                      items: widget.mylist.map((KeyValue p_keyValue)
                      {
                        return DropdownMenuItem<KeyValue>(
                          value: p_keyValue,
                          child:  Padding(
                            padding: const EdgeInsets.only
                              (top:12.0,bottom: 8,left: 8),
                            child: Text(
                              p_keyValue.value.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }).toList()
                  )
              )
          ),
        ),
        // new Text("selected user name is ${selectedRole!.value} :
        // and key is : ${selectedRole!.key}"),
      ],

    );
  }
}





