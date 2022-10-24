import 'dart:convert';
import 'package:community_new/UI%20SCREENS/Organizations/edit_organizationnew.dart';
import 'package:community_new/UI%20SCREENS/Organizations/orgStepper.dart';
import 'package:community_new/main.dart';
import 'package:community_new/widgets/genericAppBar.dart';
import 'package:community_new/widgets/genericDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_services/api_services.dart';
import '../../constants/styles.dart';
import '../../models/OrgAdmin.dart';
import '../../models/organization.dart';
import '../credentials/log_in.dart';


class OrgTree extends StatefulWidget {

  @override

  State<OrgTree> createState() => _OrgTreeState();
}

class _OrgTreeState extends State<OrgTree> {
  String currentRole =//'admin';
   prefs.getString ( 'role_name' );
  String currentUserName =  prefs.get('userName');
  List<Organization> organizations = [] ;
  //Organization organization = Organization();
  TextEditingController searchcntrl= TextEditingController();
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: new Text('No',style: TextStyle(color: appColor),),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(), // <-- SEE HERE
            child: new Text('Yes',style: TextStyle(color: appColor),),
          ),
        ],
      ),
    )) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
  //  _getOrganization();
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
       //  floatingActionButton:
       // currentRole!='SuperAdmin'?null:
       //  FloatingActionButton(
       //    backgroundColor: appColor,
       //    child: Icon(Icons.add,color: whiteColor,),
       //    onPressed: () {  Navigator.push(
       //        context, MaterialPageRoute(builder: (context) =>
       //        OrganizationEditnew(
       //          organizationId: 0, isNew: true,parentId: 0,))); },
       //  ),
            //:null,

          drawer: currentRole=='SuperAdmin'?genericDrawerForSA()
              :currentRole=='MasjidAdmin'?genericDrawerForMA():genericDrawerForOA(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: genericAppBarForSA(
            appbarTitle: 'Organizations',
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child:  Padding(
                  padding: const EdgeInsets.only(left:15,right: 15,bottom: 10),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      //onChanged: (value) => _runFilter(value),
                      controller: searchcntrl,
                      decoration:const InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        // fillColor: whiteColor,
                        // filled: true,
                        hintText: 'Search Organization by name',
                        prefixIconColor: appColor,
                        suffixIconColor: appColor,
                        prefixIcon: Icon(Icons.search),
                        border:  OutlineInputBorder(
                          //borderSide: BorderSide.none
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ),
          ),
        ),

          backgroundColor: whiteColor,

        body:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            buildBodyFrame(TreeFromJson()),
              SizedBox(height: 80,),
          ],),
        )
      ),
    );
  }

  /// Adds scrolling and padding to the [content].
  Widget buildBodyFrame(Widget content) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding:const EdgeInsets.all(8),
        child: content,
      ),
    );
  }
}


class TreeFromJson extends StatefulWidget {
  @override
  _TreeFromJsonState createState() => _TreeFromJsonState();
}

class _TreeFromJsonState extends State<TreeFromJson>{
 // bool isDeleteDisable = false;
  final TreeController _treeController =
  TreeController(allNodesExpanded: false);
  final ApiServices apiService = ApiServices();
String responseBody='[]';
  List<Organization> organizations = [] ;
  List<Organization> copiedorganization = [] ;
  @override
  void initState() {
    // at the beginning, all users are shown
    copiedorganization = organizations;
    super.initState();
  }
  void _runFilter(String enteredKeyword) async{
    List<Organization> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results =await organizations;
    } else {
      results =await  organizations
          .where((organizationchk) =>
          organizationchk.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      copiedorganization = results;
    });
  }
  _getOrganization()async {
  //  SharedPreferences pref = await SharedPreferences.getInstance();
   // Map<String,dynamic> json = jsonDecode(prefs.getString('userData'));
   // var currentUser = User.fromJson(json);
    String currentRole =//'admin';
    await prefs.getString ( 'role_name' );
    //print(prefs.getString ( 'role_name' ));
   // print(currentRole);
    if (currentRole== 'SuperAdmin')
      {
      await ApiServices.fetch (
          'organization', actionName: 'GetTree')
          .then ( (response) {
        setState ( () {
          responseBody = response.body;
          // Iterable list = json.decode(response.body);
          // organizations = list.map((model) => Organization.fromJson(model)).toList();
          //  print(response.body);
        } );
      } );
  }
    else if(currentRole=='OrgAdmin')
      {
       int  currentUserId=  await prefs.get ( 'userId' );
        await ApiServices.fetch (
            'organization', actionName: 'GetTreefororgadmin',
            param1:currentUserId.toString() )
            .then ( (response) {
          setState ( () {
            responseBody = response.body;
            // Iterable list = json.decode(response.body);
            // organizations = list.map((model) => Organization.fromJson(model)).toList();
            //  print(response.body);
          } );
        } );
      }
  }
  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildTree(),
      ],
    );
  }
  /// Builds tree or error message out of the entered content.
  Widget buildTree() {

    try {
      _getOrganization();
     // print(responseBody);
      //var parsedJson = json.decode(_textController.text);
      var parsedJson = json.decode(responseBody);
      return
        // Card(
        // shape:const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(10))
        // ),
        // elevation: 5,
        // child:
        TreeView(
          indent: 10,
          nodes: toTreeNodes(parsedJson),
          treeController: _treeController,
        );
      //);

    } on FormatException catch (e) {
      return Text(e.message);
    }
  }


  List<TreeNode> toTreeNodes(dynamic parsedJson){
   /* Widget printGroupTree(
        Map group, {
          double level = 0,
        }) {
      if (group['children'] != null) {
        List<Widget> subGroups = List<Widget>();

      for (Map subGroup in group['children']) {
      subGroups.add(
      printGroupTree(
      subGroup,
      level: level + 1,
      ),
      );
      }
      return Parent(
      parent: _card(
      group['name'],
      level * 20,
      ),
      childList: ChildList(
      children: subGroups,
      ),
       );
      } else {
      return _card(
      group['name'],
      level * 20,
      );
      }
    }*/

    if (parsedJson is Map<String, dynamic>) {
    /* if(parsedJson['children']!= null) {
        for (int i = 0; i < parsedJson['children'].length; i++) {
          print ( parsedJson['children'] [i] );*/
          // if (parsedJson['children'] != null) {
           /*  return parsedJson.entries
                 .map ( (k) =>
                 TreeNode (
                     content: Text ( parsedJson['id'].toString() ),
                     children:parsedJson['children']!=null? toTreeNodes ( parsedJson['children'] ):null ) )
                 .toList ( );*/
        //   }
      List<TreeNode> l = [];
          l.add ( TreeNode (
              content: Text ( parsedJson['name'] ),
              children: parsedJson['children']!=null?
              toTreeNodes (parsedJson['children']) :null)
          );
          return l;
      //}
      //}*/
      /*  else {
          List<TreeNode> l = [];
          l.add ( new TreeNode (
              content: Text ( parsedJson['name'] ),
              children: null
          ) )
          ;
          return l;
        }*/
      }
    //}
    if (parsedJson is List<dynamic>) {
      List<TreeNode> l = [];
      for(int i =0;i<parsedJson.length;i++){
        print(parsedJson[i]['children']);

      l.add ( TreeNode (
          key:  Key(parsedJson[i]['id'].toString()),
          content: Padding(
            padding:const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8,
                  top: 3,bottom: 3
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width/1.3,

                child: Padding(
                  padding:const EdgeInsets.only(left:10),
                  child: Column(children: [
                    Row(
                      children: [
                        // Text ( parsedJson[i]['id'].toString() ),
                        Text ( parsedJson[i]['name'] ,style: TextStyle(
                          fontSize: 14
                        ),),

                        // IconButton(
                        //     onPressed: (){
                        //       Navigator.push(
                        //           context, MaterialPageRoute(builder: (context) =>
                        //           OrganizationEdit(isNew: false, organizationId: 0,parentId: 0,
                        //           jsondata: parsedJson[i]['id'],
                        //           )));
                        //     },
                        //     icon : FaIcon(FontAwesomeIcons.edit,color: Colors.black,)),\

                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      ElevatedButton(
                        style: crudButtonStyle,
                        child  :const FaIcon(FontAwesomeIcons.plus, size: size,
                          color: addColor,
                        ),
                        onPressed: (){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>
                              stepper(
                                isNew: true, organizationId: 0,
                                parentId: parsedJson[i]['id'],)
                          ));
                        },
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: appColor,
                            onPrimary: appColor,
                          ),
                          onPressed: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>
                                stepper(
                                  isNew: false, organizationId: parsedJson[i]['id'],
                                  parentId: parsedJson[i]['parentId'],
                                )
                              // OrganizationEditnew(
                              //   isNew: false, organizationId: parsedJson[i]['id'],
                              //   parentId: parsedJson[i]['parentId'],)
                            ));
                          }, child  : Image.asset('assets/edit.png',color: whiteColor,)),

                      parsedJson[i]['children'].toString()=='[]'?
                      ElevatedButton(
                          style: crudButtonStyle,
                          onPressed: () async {
                            await apiService.deleteFn(int.parse(
                                parsedJson[i]['id'].toString()),'organization');
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                content:  Text("Organization Deleted Successfully")));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrgTree(),
                                ));
                          },
                          child: deleteIcon)
                          :Text("")
                    ],)
                  ],),
                ),
              )
            ),
          ),
          children: parsedJson[i]['children']!=null?
          toTreeNodes (  parsedJson[i]['children']) :null) );
      }
      return l;
      // List<TreeNode> l = [];
      // l.add ( new TreeNode (
      //     content: Text ( 'test' ),
      //     children: null
      // ) )
      // ;
      // return l;
    /* return parsedJson
          .asMap()
          .map((i, element) => MapEntry(i,
          TreeNode(content: Text(parsedJson[i]['name']),
              children:element!=null? toTreeNodes(element):null)))
          .values
          .toList();*/
      /*  for(int i=0;i<parsedJson.length;i++) {
      //  toTreeNodes(parsedJson[i]);
        if(parsedJson[i]['children']!=null) {
           return parsedJson.keys
             .map ( (k) =>
             TreeNode (
                 content: Text ( '$k:' ),
                 children: toTreeNodes ( parsedJson['children'] ) ) )
             .toList ( );

          List<TreeNode> l=[];
          l.add(new TreeNode (
              content: Text ( parsedJson[i]['name'] ),
              children: toTreeNodes ( parsedJson[i]['children'] )));
          return l;
        }
        else
        {
          List<TreeNode> l=[];
          l.add(new TreeNode (
              content: Text ( parsedJson[i]['name'] ),
              children: null) )
          ;
          return l;
        }*/

        /*
        return TreeView(
          nodes: toTreeNodes(parsedJson[i]),
          treeController: _treeController,
        ).nodes;
      }*/

    }
    return [TreeNode(content: Text(parsedJson.toString()))];

  }
}
