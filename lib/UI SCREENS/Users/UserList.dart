import 'dart:convert';
import 'package:community_new/UI%20SCREENS/Users/userStepper.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../api_services/api_services.dart';
import '../../widgets/genericAppBar.dart';
import '../../widgets/genericDrawer.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final ApiServices apiService = ApiServices();
  //User? user;
  List<User> users = [];
  List<User> copiedListUsers = [];
  var errorController = TextEditingController();
  String currentRole = //'admin';
      prefs.getString('role_name');
  _getUser() async {
    String currentRole = await prefs.getString('role_name');
    int currentUserId = await prefs.get('userId');
    if (currentRole == 'SuperAdmin') {
      ApiServices.fetch('user', actionName: null, param1: null)
          .then((response) {
        setState(() {
          try {
            errorController.text = "";
            Iterable list = json.decode(response.body);
            //print ( response.body );
            users = list.map((model) => User.fromJson(model)).toList();
            // print(masjids[0].Id);
            //  errorController.text="test";
          } on Exception catch (e) {
            errorController.text = "wow : " + e.toString();
          }
        });
      });
    } else if (currentRole == 'OrgAdmin') {
      await ApiServices.fetch('user',
              actionName: 'getusersbyrolename',
              param1:
                  'orgadmin' //currentUserId.toString() //current user id will pass here
              )
          .then((response) {
        setState(() {
          Iterable list = json.decode(response.body);
          users = list.map((model) => User.fromJson(model)).toList();
          //  print(response.body);
        });
      });
    } else if (currentRole == 'MasjidAdmin') {
      ApiServices.fetch('user',
              actionName: 'getusersbyrolename',
              param1: 'masjidadmin') //current user id will pass here
          .then((response) {
        setState(() {
          try {
            errorController.text = "";
            Iterable list = json.decode(response.body);
            //print ( response.body );
            users = list.map((model) => User.fromJson(model)).toList();
            // print(masjids[0].Id);
            //  .text="test";
          } on Exception catch (e) {
            errorController.text = "wow : " + e.toString();
          }
        });
      });
    }
  }

  final searchcntrl = TextEditingController();
  bool isGrid = true;
  @override
  initState() {
    // at the beginning, all users are shown
    copiedListUsers = users;
    super.initState();
  }

  void _runFilter(String enteredKeyword) async {
    List<User> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = await users;
    } else {
      results = await users
          .where((user) => user.FullName!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      copiedListUsers = results;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text(
                  'No',
                  style: TextStyle(color: appColor),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(), // <-- SEE HERE
                child: new Text(
                  'Yes',
                  style: TextStyle(color: appColor),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    _getUser();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          drawer: currentRole == 'SuperAdmin'
              ? genericDrawerForSA()
              : currentRole == 'MasjidAdmin'
                  ? genericDrawerForMA()
                  : genericDrawerForOA(),
          //resizeToAvoidBottomInset: true,
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: appColor,
          //   child: Icon(Icons.add,color: whiteColor,),
          //   onPressed: () {  Navigator.push(
          //       context, MaterialPageRoute(builder: (context) =>
          //   const UserEdit(userId: 0, isNew: true)));
          //     },
          // ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: genericAppBarForSA(
              appbarTitle: 'Users',
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      onChanged: (value) => _runFilter(value),
                      controller: searchcntrl,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        // fillColor: whiteColor,
                        // filled: true,
                        hintText: 'Search user by name',
                        prefixIconColor: appColor,
                        suffixIconColor: appColor,
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.tune,
                          ),
                        ),
                        border: const OutlineInputBorder(
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
          body: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     onChanged: (value) => _runFilter(value),
              //     controller: searchcntrl,
              //     decoration: InputDecoration(
              //       fillColor: whiteColor,
              //       filled: true,
              //       hintText: 'Search user by name',
              //       prefixIconColor: appColor,
              //       suffixIconColor: appColor,
              //       prefixIcon: Icon(Icons.search),
              //       suffixIcon: IconButton(
              //           onPressed: (){},
              //           icon: Icon(Icons.filter_alt_outlined),),
              //       border: const OutlineInputBorder(
              //         borderSide: BorderSide.none
              //         //borderSide: BorderSide.none
              //       ),
              //     ),
              //     keyboardType: TextInputType.text,
              //   ),
              // ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    if (isGrid == true) {
                      setState(() {
                        isGrid = false;
                      });
                    } else if (isGrid == false) {
                      setState(() {
                        isGrid = true;
                      });
                    }
                  },
                  icon: isGrid == false
                      ? Icon(Icons.list)
                      : Icon(Icons.grid_on_outlined),
                ),
              ),
              users.isEmpty
                  ? const Center(child: Text('Empty'))
                  : isGrid
                      ?
                      // Expanded(
                      //   child: ListView.builder(
                      //       itemCount:copiedListUsers.isEmpty?users.length:copiedListUsers.length,
                      //       itemBuilder:  (_, index) {
                      //         return Padding(
                      //           padding: const EdgeInsets.only(left:15.0,right: 15),
                      //           child: Card(
                      //               shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(8)
                      //               ),
                      //               color: Colors.white,
                      //               elevation: 2.0,
                      //               child: Column(
                      //                 children: [
                      //                   ListTile(
                      //                       leading:const CircleAvatar(
                      //                         radius: 20,
                      //                         backgroundImage: AssetImage('assets/user.png'),
                      //                       ),
                      //                       title:Row(children: [
                      //                         copiedListUsers.isEmpty?Text(users[index].FullName.toString())
                      //                             :Text(copiedListUsers[index].FullName.toString()),
                      //                         Spacer(),
                      //                         ElevatedButton(
                      //                             style: crudButtonStyle,
                      //                             onPressed: () {
                      //                               Navigator.push(
                      //                                   context,
                      //                                   MaterialPageRoute(
                      //                                       builder: (context) =>
                      //                                           userStepper(
                      //                                               isNew:
                      //                                               false,
                      //                                               userId: users[
                      //                                               index]
                      //                                                   .Id)));
                      //                             },
                      //                             child: Image.asset('assets/edit.png',color: appColor,)),
                      //                         widthSizedBox,
                      //                         ElevatedButton(
                      //                             child: deleteIcon,
                      //                             style: crudButtonStyle,
                      //                             onPressed: () async {
                      //                               await apiService.deleteFn(
                      //                                   int.parse(users[index]
                      //                                       .Id
                      //                                       .toString()),
                      //                                   'user');
                      //                               ScaffoldMessenger.of(
                      //                                   context)
                      //                                   .showSnackBar(
                      //                                   const SnackBar(
                      //                                       content: Text(
                      //                                           "User Deleted Successfully")));
                      //                               Navigator.push(
                      //                                   context,
                      //                                   MaterialPageRoute(
                      //                                     builder: (context) =>
                      //                                         UserList(),
                      //                                   ));
                      //                             }),
                      //                       ],)
                      //                   ),
                      //
                      //
                      //
                      //                 ],
                      //               )),
                      //         );
                      //       }),
                      // )

                      Expanded(
                          child: ListView.builder(
                              itemCount: copiedListUsers.isEmpty
                                  ? users.length
                                  : copiedListUsers.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 150,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/user.png'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              copiedListUsers.isEmpty
                                                  ? Text(
                                                      users[index]
                                                          .FullName
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline1!
                                                          .copyWith(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    )
                                                  : Text(
                                                      copiedListUsers[index]
                                                          .FullName
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline1!
                                                          .copyWith(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                              const SizedBox(height: 10),
                                              copiedListUsers.isEmpty
                                                  ? Text(
                                                      users[index]
                                                              .UserName
                                                              .toString() +
                                                          '\n',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                            fontSize: 12,
                                                          ),
                                                    )
                                                  : Text(
                                                      copiedListUsers[index]
                                                              .UserName
                                                              .toString() +
                                                          '\n',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                            fontSize: 12,
                                                          ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                          right: 0,
                                          child: PopupMenuButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            itemBuilder: (context) {
                                              return [
                                                _buildPopupMenuItem(
                                                    //'Edit',
                                                    'assets/edit.png',
                                                    //Icons.edit,
                                                    'edit'),
                                                _buildPopupMenuItem(
                                                    //'Delete',
                                                    'assets/delete.png',
                                                    //Icons.delete_outline,
                                                    'delete'),
                                              ];
                                            },
                                            onSelected: (value) {
                                              if (value == 'edit') {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            userStepper(
                                                              isNew: false,
                                                              userId:
                                                                  users[index]
                                                                      .Id,
                                                              signup: false,
                                                            )));
                                              } else if (value == 'delete') {
                                                // await
                                                apiService.deleteFn(
                                                    int.parse(users[index]
                                                        .Id
                                                        .toString()),
                                                    'user');
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "User Deleted Successfully")));
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserList(),
                                                    ));
                                              }
                                            },
                                          ))
                                    ],
                                  ),
                                );
                                //   Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 8.0, right: 8, top: 5),
                                //   child: Card(
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.circular(8)
                                //       ),
                                //       color: Colors.white,
                                //       elevation: 10.0,
                                //       child: Column(
                                //         children: [
                                //           ListTile(
                                //             leading:const CircleAvatar(
                                //               radius: 25,
                                //               backgroundImage: AssetImage('assets/darussalam.jpg'),
                                //             ),
                                //             subtitle: Text(
                                //               events[index]
                                //                   .description
                                //                   .toString() +
                                //                   '\n',
                                //               textAlign:
                                //               TextAlign.justify,
                                //             ),
                                //             onTap: null,
                                //             title: Row(
                                //               children: [
                                //                 Text(events[index]
                                //                     .name
                                //                     .toString() ),
                                //                 const Spacer(),
                                //                 currentRole=='User'?
                                //                 IconButton(
                                //                   onPressed: () async{
                                //                     if(favouriteItemProvider.selectedItem.contains(index))
                                //                     {
                                //                       favouriteItemProvider.removeItem(index);
                                //                       ScaffoldMessenger.of(context)
                                //                           .showSnackBar( SnackBar(
                                //                           content:  Text(events[index].name.toString()
                                //                               +" Deleted Successfully")));
                                //                     }else{
                                //                       favouriteItemProvider.addItem(index);
                                //                       ScaffoldMessenger.of(context)
                                //                           .showSnackBar(  SnackBar(
                                //                         content:Text(events[index].name.toString()
                                //                             +" added "),));
                                //                     }
                                //
                                //                   },
                                //                   icon: Icon(
                                //                     favouriteItemProvider.selectedItem.contains(index)
                                //                     ||isSelected(events[index].Id)
                                //                         ? Icons.favorite
                                //                         : Icons.favorite_border,
                                //                     color: Colors.red,
                                //                   ),
                                //                 )
                                //                     :ElevatedButton(
                                //                     style:
                                //                     crudButtonStyle,
                                //                     onPressed: () {
                                //                       Navigator.push(
                                //                           context,
                                //                           MaterialPageRoute(
                                //                               builder: (context) => EventEditnew(
                                //                                   isNew:
                                //                                   false,
                                //                                   eventId:
                                //                                   events[index].Id)));
                                //                     },
                                //                     child: const FaIcon(FontAwesomeIcons.edit,
                                //                       color: Color(0xFF8BBAF0),size: size,)),
                                //                 currentRole=='User'?
                                //                 Container()
                                //                     :
                                //                 ElevatedButton(
                                //                     style:
                                //                     crudButtonStyle,
                                //                     onPressed:
                                //                         () async {
                                //                       await apiService.deleteFn(
                                //                           int.parse(events[
                                //                           index]
                                //                               .Id
                                //                               .toString()),
                                //                           'communityevent');
                                //                       ScaffoldMessenger
                                //                           .of(
                                //                           context)
                                //                           .showSnackBar(
                                //                           const SnackBar(
                                //                               content:
                                //                               Text("Event Deleted Successfully")));
                                //                       Navigator.push(
                                //                           context,
                                //                           MaterialPageRoute(
                                //                             builder:
                                //                                 (context) =>
                                //                                 Events(),
                                //                           ));
                                //                     },
                                //                     child: deleteIcon),
                                //               ],
                                //             ),
                                //           ),
                                //         ],
                                //       )),
                                // );
                              }),
                        )
                      : Expanded(
                          child: GridView.builder(
                              padding: EdgeInsets.all(4),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemCount: copiedListUsers.isEmpty
                                  ? users.length
                                  : copiedListUsers.length,
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.0, right: 2, bottom: 2),
                                  child: Card(
                                      key: ValueKey(users[index].Id),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: whiteColor,
                                      elevation: 2.0,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, right: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Expanded(
                                                  child: Text(''),
                                                ),
                                                const Expanded(
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage: AssetImage(
                                                        'assets/user.png'),
                                                  ),
                                                ),
                                                widthSizedBox12,
                                                Expanded(
                                                  child: PopupMenuButton(
                                                    position:
                                                        PopupMenuPosition.under,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    itemBuilder: (context) {
                                                      return [
                                                        _buildPopupMenuItem(
                                                            'assets/edit.png',
                                                            // 'Edit',
                                                            //Icons.edit,
                                                            'edit'),
                                                        _buildPopupMenuItem(
                                                            'assets/delete.png',
                                                            // 'Delete',
                                                            //Icons.delete_outline,
                                                            'delete'),
                                                      ];
                                                    },
                                                    onSelected: (value) {
                                                      if (value == 'edit') {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        userStepper(
                                                                          isNew:
                                                                              false,
                                                                          userId:
                                                                              users[index].Id,
                                                                        )));
                                                      } else if (value ==
                                                          'delete') {
                                                        // await
                                                        apiService.deleteFn(
                                                            int.parse(users[
                                                                    index]
                                                                .Id
                                                                .toString()),
                                                            'user');
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "User Deleted Successfully")));
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      UserList(),
                                                            ));
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          midPadding2,
                                          copiedListUsers.isEmpty
                                              ? Text(
                                                  users[index]
                                                      .FullName
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis)
                                              : Text(
                                                  copiedListUsers[index]
                                                      .FullName
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                          midPadding2,
                                          Text(users[index].UserName.toString(),
                                              overflow: TextOverflow.ellipsis),
//                       ListTile(
//                         subtitle: Text(users[index].FullName.toString()),
//                         leading:Text(users[index].Id.toString()),
//                         onTap: null,
//                         title: Row(
//                           children: [
//                             Text(users[index].UserName.toString()),
//                             const Spacer(),
// Padding(
//   padding: const EdgeInsets.only(top:16.0),
//   child: ButtonTheme(
//     minWidth: MediaQuery.of(context).size.width / 7,
//     height: MediaQuery.of(context).size.height / 18,
//     child: ElevatedButton(
//       onPressed: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => UserEdit(
//                   isNew: false,
//                   userId: users[index]
//                       .Id
//                       .toString(),
//                 )));
//       },
//       style: ElevatedButton.styleFrom(
//           shadowColor: Colors.black,
//           primary: Colors.white,
//           onPrimary: Colors.white,
//           shape: CircleBorder()// foreground
//       ),
//       child:FaIcon(FontAwesomeIcons.edit,color: blackColor,)
//     ),
//   ),
// ),
//                             ElevatedButton(
//                                 style: crudButtonStyle,
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => UserEdit(
//                                               isNew: false,
//                                               userId: users[index]
//                                                   .Id
//                                           )));
//                                 },
//                                 child: editIcon),
//                             widthSizedBox,
//                             ElevatedButton(
//                                 style: crudButtonStyle,
//                                 onPressed: () async {
//                                   await apiService.deleteFn(int.parse(
//                                       users[index].Id.toString()),'user');
//                                   ScaffoldMessenger.of(context)
//                                       .showSnackBar(const SnackBar(
//                                       content:  Text("User Deleted Successfully")));
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             UserList(),
//                                       ));
//                                 },
//                                 child: deleteIcon),
// Padding(
//   padding: const EdgeInsets.only(top: 16.0),
//   child: ButtonTheme(
//     minWidth: MediaQuery.of(context).size.width / 7,
//     height:
//     MediaQuery.of(context).size.height / 18,
//     child: ElevatedButton(
//       onPressed: () async {
//         await apiService.deleteFn(int.parse(
//             users[index].Id.toString()),'user');
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(
//             content:  Text("User Deleted Successfully")));
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   UserList(),
//             ));
//       },
//       style: ElevatedButton.styleFrom(
//           shadowColor: Colors.white,
//           primary: Colors.black,
//           onPrimary: Colors.white,
//           shape:  CircleBorder() // foreground
//       ),
//       child: Icon(Icons.delete_outline)
//     ),
//   ),
// )
//                           ],
//                         )
                                        ],
                                      )),
                                );
                              }),
                        )
            ],
          )),
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      String imageUrl,
      // IconData iconData,
      String position) {
    return PopupMenuItem(
      value: position,
      child: Container(
          width: 20,
          child: Center(
            child: Image.asset(
              imageUrl,
              color: appColor,
            ),
          )),
      //Text(title),
    );
  }
}

//                       ListTile(
//                         subtitle: Text(users[index].FullName.toString()),
//                         leading:Text(users[index].Id.toString()),
//                         onTap: null,
//                         title: Row(
//                           children: [
//                             Text(users[index].UserName.toString()),
//                             const Spacer(),
// Padding(
//   padding: const EdgeInsets.only(top:16.0),
//   child: ButtonTheme(
//     minWidth: MediaQuery.of(context).size.width / 7,
//     height: MediaQuery.of(context).size.height / 18,
//     child: ElevatedButton(
//       onPressed: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => UserEdit(
//                   isNew: false,
//                   userId: users[index]
//                       .Id
//                       .toString(),
//                 )));
//       },
//       style: ElevatedButton.styleFrom(
//           shadowColor: Colors.black,
//           primary: Colors.white,
//           onPrimary: Colors.white,
//           shape: CircleBorder()// foreground
//       ),
//       child:FaIcon(FontAwesomeIcons.edit,color: blackColor,)
//     ),
//   ),
// ),
//                             ElevatedButton(
//                                 style: crudButtonStyle,
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => UserEdit(
//                                               isNew: false,
//                                               userId: users[index]
//                                                   .Id
//                                           )));
//                                 },
//                                 child: editIcon),
//                             widthSizedBox,
//                             ElevatedButton(
//                                 style: crudButtonStyle,
//                                 onPressed: () async {
//                                   await apiService.deleteFn(int.parse(
//                                       users[index].Id.toString()),'user');
//                                   ScaffoldMessenger.of(context)
//                                       .showSnackBar(const SnackBar(
//                                       content:  Text("User Deleted Successfully")));
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             UserList(),
//                                       ));
//                                 },
//                                 child: deleteIcon),
// Padding(
//   padding: const EdgeInsets.only(top: 16.0),
//   child: ButtonTheme(
//     minWidth: MediaQuery.of(context).size.width / 7,
//     height:
//     MediaQuery.of(context).size.height / 18,
//     child: ElevatedButton(
//       onPressed: () async {
//         await apiService.deleteFn(int.parse(
//             users[index].Id.toString()),'user');
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(
//             content:  Text("User Deleted Successfully")));
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   UserList(),
//             ));
//       },
//       style: ElevatedButton.styleFrom(
//           shadowColor: Colors.white,
//           primary: Colors.black,
//           onPrimary: Colors.white,
//           shape:  CircleBorder() // foreground
//       ),
//       child: Icon(Icons.delete_outline)
//     ),
//   ),
// )
//                           ],
//                         )