import 'dart:convert';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../api_services/api_services.dart';
import '../../models/keyvalue.dart';
import '../../models/organization.dart';
import '../../models/role.dart';
import '../../models/user.dart';
import '../../widgets/add_screen_text_field.dart';
import '../../widgets/dropdown.dart';
import '../credentials/log_in.dart';
import 'UserList.dart';


class userStepper extends StatefulWidget {
  final int? userId;
  final bool isNew;
  final bool? signup;
  const userStepper({Key? key,required this.userId,
    required this.isNew,this.signup}) : super(key: key);
  @override
  _userStepperState createState() => _userStepperState();
}
class _userStepperState extends State<userStepper>
    with SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<userStepper>{
  var fullNameController = TextEditingController();
  var idcontroller = TextEditingController();
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var publicEmailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var default_Role_IdController = TextEditingController();
  int _activeStepIndex = 0;
  var dropdown = new DropDown(mylist: [],);

  GlobalKey<FormState> _formKey =  GlobalKey<FormState>(); //for storing form state.
  List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>()];
  Future<void> _saveForm(User user) async{
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if(widget.isNew)
      {
        await ApiServices.postUser(user);
        ScaffoldMessenger.of(context)
            .showSnackBar(  SnackBar(
          behavior: SnackBarBehavior.floating,
          content:widget.signup==true?Text("User Created Successfully"):Text("User Added Successfully"),));
      }
      else {
        await ApiServices.postUserbyid ( idcontroller.text, user );
        ScaffoldMessenger.of ( context )
            .showSnackBar ( const SnackBar (
          behavior: SnackBarBehavior.floating,
          content: Text ( "User Updated Successfully" ), ) );
      }
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar( const SnackBar(
        behavior: SnackBarBehavior.floating,
        content:Text("Please fill form correctly"),));
    }
  }
  var user =  User();
  var role =  Role();
  List<Role> roles = [];
  List<KeyValue> Keyvaleusorg= [];
  List<KeyValue> Keyvaleus= [];
  KeyValue? selectedKeyValue;
  KeyValue? selectedKeyValueOrgId;
  List<Organization> organizations=[];
  FocusNode myFocusNode= FocusNode();
  var drpOrg =  new DropDown(mylist: [] );

  _getUser() async{
    int currentUserId = await prefs.get ( 'userId' );
    await ApiServices.fetch("role").then((response) {
      setState ( () {
        Iterable listroles = json.decode ( response.body);
        // print(list);
        roles = listroles.map ( (model) => Role.fromJson
          ( model ) ).toList ( );
//print(response.body);
        // copy roles into list<KeyVale> ListValues
        // for(int i=0;i<roles.length)
        //   {
        //
        //   }
        // Keyvaleus=[];

        // roles.insert(0, new Role(key:0,value:"please select Role"));
        if (roles.length > 0) {
          Keyvaleus.add ( new KeyValue( key: '0', value: "Please Select Role" ) );
          for (int i = 0; i < roles.length; i++) {
            Keyvaleus.add (
                new KeyValue( key: roles[i].key.toString(),
                    value: roles[i].value ));
          }
          //dropdown=new DropDown(mylist: Keyvaleus);
        }
      }
      );
    });
    await ApiServices.fetch("organization",
      //actionName: 'GetOrgForUserId',
      // param1: currentUserId.toString()
    ).then((response) {
      setState ( () {
        Iterable listorganizations = json.decode ( response.body);
        organizations = listorganizations.map (
                (model) => Organization.fromJson ( model ) ).toList ( );
        //org parent id dropdown
        if (organizations.length > 0){
          Keyvaleusorg.add (
              KeyValue( key: '0',
                  value: "Please select Organzation") );
          for (int i = 0; i < organizations.length; i++){
            Keyvaleusorg.add (
                KeyValue( key: organizations[i].Id.toString(),
                    value: organizations[i].description.toString()));
          }
        }
      }
      );
    });

    print(Keyvaleus.length);
    if(widget.isNew==false) {
      await ApiServices.fetchForEdit (widget.userId , 'user' )
          .then ( (response) {
        setState ( () {
          var userBody = json.decode ( response.body );
          user = User.fromJson ( userBody );

          if (user != null) {
            idcontroller.text = user.Id.toString ( );
            emailController.text = user.Email.toString ( );
            publicEmailController.text = user.PublicEmail.toString ( );
            fullNameController.text = user.FullName.toString ( );
            userNameController.text = user.UserName.toString ( );
            passwordController.text = user.Password.toString ( );
            confirmPasswordController.text = user.Password.toString ( );


            KeyValue testforOrgId;
            if (user.org_id != "null" && user.org_id != null) {
              try {
                // print('try assign  masjid ' +selectedKeyValueOrgId!.key.toString());
                testforOrgId = Keyvaleusorg.firstWhere(
                        (element) => element.key == user.org_id.toString());
              } catch (e) {

                testforOrgId = Keyvaleusorg[0];
              }
            } else {
              //print('after assign  masjid ' +
              //    selectedKeyValueOrgId!.value.toString());
              //print('inside if from masjid ' + masjid.Org_Id.toString());
              testforOrgId = Keyvaleusorg[0];
            }

            selectedKeyValueOrgId = testforOrgId;
            // _selected_default_Role_Id=null;
            if (user.default_Role_Id != "null" &&
                user.default_Role_Id != null) {
              selectedKeyValue = Keyvaleus.firstWhere ( (element) =>
              element.key == user.default_Role_Id.toString());
            }
            // print(userBody);
          }

          if (widget.signup==true && user.default_Role_Id != "null" &&
              user.default_Role_Id != null) {
            selectedKeyValue = Keyvaleus[4];
            drpOrg= DropDown(mylist: Keyvaleusorg,
                seletected_value: selectedKeyValueOrgId);
          }
        } );
      } );
    }
    drpOrg= DropDown(mylist: Keyvaleusorg,
        seletected_value: selectedKeyValueOrgId);
    dropdown= DropDown(mylist: Keyvaleus,
      seletected_value: selectedKeyValue,);

  }
  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
      print('Has focus: $myFocusNode.hasFocus');
    });
    //if(widget.isNew==false){
    _getUser();
    // }
  }



  @override
  void dispose() {
    super.dispose();
  }



  showAlertDialog(BuildContext context) {
    // Create button
    Widget yesButton = TextButton(

        onPressed: (){
          Navigator.of(context, rootNavigator: true)
              .pop(true);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>
              UserList()));
        },
        child: Text('yes',style: TextStyle(
            color: appColor
        ),));
    Widget noButton =   TextButton(onPressed: (){
      Navigator.of(context, rootNavigator: true)
          .pop(false);
    },
        child: Text('no',style: TextStyle(
            color: appColor
        ),));

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      title: Text("Alert"),
      content: Text("Are you sure you want to go back?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: new Text('No',style: TextStyle(color: appColor),),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(), // <-- SEE HERE
            child:  Text('Yes',style: TextStyle(color: appColor),),
          ),
        ],
      ),
    )) ??
        false;
  }
 Future<bool> Navigatorfn(){
    Navigator.of(context).pop();
    return Future(() => false);
 }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.signup==true?_onWillPop:Navigatorfn,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading:widget.signup==true?Container(): IconButton(
            color: appColor,
            onPressed: (){
             showAlertDialog(context);
            },
            icon: Icon(CupertinoIcons.chevron_back),
          ),
          backgroundColor: whiteColor,
          title:  widget.signup==true?
          Text("Sign up",style: TextStyle(fontSize: 20,color: appColor),)
              :(widget.isNew==false?
          Text("Edit User",style: TextStyle(fontSize: 20,color: appColor),):
          Text("Add User",style: TextStyle(fontSize: 20,color: appColor),)),
        ),
        body: NestedTabBarUser(
          tabbarbarLength: 2,
          frmNested: _formKey,
          nestedTabbarView: [
            Form(
              key: formKeys[0],
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  widget.signup!=true?const Padding(
                    padding:  EdgeInsets.only(top: 8.0,bottom: 8),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Role Id",style: BlackTextStyleNormal16,)),
                  ):Container(),
                  // widget.signup==true
                  //     ?IgnorePointer(
                  //   child: selectedDrpUser,
                  //   ignoring: true,
                  // )
                  // :
                  widget.signup!=true?dropdown:
                  Container(),
                  const Padding(
                    padding:  EdgeInsets.only(top: 10.0,bottom: 10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Organization ",
                          style: BlackTextStyleNormal16,)),
                  ),
                  drpOrg,
                  //selectedDrpUser,
                  AddScreenTextFieldWidget(
                    labelText: "Full Name",
                    obsecureText: false,
                    controller: fullNameController,
                    textName:  user.FullName.toString(),  inputType: TextInputType.name,
                    validator: (text) {
                      if (!(text!.length > 5) && text.isEmpty) {
                        return "Enter full name of more then 5 characters!";
                      }
                      return null;
                    },
                  ),
                  AddScreenTextFieldWidget(
                    labelText: "User Name",
                    obsecureText: false,
                    controller: userNameController,
                    textName: user.UserName.toString(),  inputType: TextInputType.name,
                    validator: (text) {
                      if (!(text!.length > 3) && text.isEmpty) {
                        return "Enter valid username of more then 3 characters!";
                      }
                      return null;
                    },
                  ),
                  midPadding,
                ],
              ),
            ),
            Form(
              key: formKeys[1],
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  children: [
                    midPadding2,
                    AddScreenTextFieldWidget(
                      labelText: "Public Email",
                      obsecureText: false,
                      controller: publicEmailController,
                      textName: user.PublicEmail.toString(),  inputType: TextInputType.emailAddress,
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return 'Please Enter your email';
                        }
                        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                          return 'Please enter a valid Email';
                        }
                        return null;
                      },
                    ),
                    AddScreenTextFieldWidget(
                      labelText: "Email",
                      obsecureText: false,
                      controller: emailController,
                      textName:user.Email.toString(),  inputType: TextInputType.emailAddress,
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return 'Please Enter your email';
                        }
                        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                          return 'Please enter a valid Email';
                        }
                        return null;
                      },

                    ),
                    AddScreenTextFieldWidget(
                      labelText: "Password",
                      obsecureText: true,
                      textFieldLength: 1,
                      controller: passwordController,
                      textName: user.Password.toString(),  inputType: TextInputType.text,
                      validator: ( value){
                        if(value!.isEmpty)
                        {
                          return 'Please re-enter password';
                        }
                        if(passwordController.text!=confirmPasswordController.text){
                          return "Password does not match";
                        }
                        return null;
                      },
                    ),
                    AddScreenTextFieldWidget(
                      textFieldLength: 1,
                      labelText: "Confirm Password",
                      obsecureText: true,
                      controller: confirmPasswordController,
                      textName: user.ConfirmPassword.toString(),  inputType: TextInputType.text,
                      validator: ( value){
                        if(value!.isEmpty)
                        {
                          return 'Please re-enter password';
                        }
                        if(passwordController.text!=confirmPasswordController.text){
                          return "Password does not match";
                        }
                        return null;
                      },
                    ),
                    midPadding2,midPadding2,
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height/16,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: appColor, // background
                                          onPrimary: Colors.white,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20))
                                          )// foreground
                                      ),
                                    onPressed: ()async{
                                          User user ;
                                          if(!widget.isNew) {
                                            user= User.WithId (
                                                Id: int.parse ( idcontroller.text ),
                                                org_id:int.parse(drpOrg.seletected_value!.key.toString()),
                                                UserName: userNameController.text,
                                                Email: emailController.text,
                                                FullName: fullNameController.text,
                                                PublicEmail: publicEmailController.text,
                                                Password: passwordController.text,
                                                ConfirmPassword: confirmPasswordController
                                                    .text,
                                                // default_Role_Id: DropDown.SelectKeyValue?.key
                                                default_Role_Id: int.parse(dropdown.seletected_value!.key)
                                              // default_Role_Id:int.parse(dropdown.seletected_value!.key)
                                            );
                                          }
                                          else
                                          {
                                            user=User(
                                              default_Role_Id:widget.signup!=true?
                                              int.parse(dropdown.seletected_value!.key):7,
                                              org_id:int.parse(drpOrg.seletected_value!.key.toString()),
                                              // default_Role_Id:int.parse(dropdown.seletected_value!.key),
                                              UserName:userNameController.text,
                                              Email: emailController.text,
                                              FullName:fullNameController.text,
                                              PublicEmail:publicEmailController.text,
                                              Password:passwordController.text,
                                              ConfirmPassword:confirmPasswordController.text,

                                            );
                                          }
                                          await _saveForm(user);
                                          if(widget.signup==true)
                                            {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                return LogIn();
                                              },));
                                            }
                                    },
                                      child: const Text('Save')

                                                  ),
                                ),

                  ],
                ),
              ),
            )
          ],
        )
        // Form(
        //   key: _formKey,
        //   child: Theme(
        //     data: ThemeData(
        //       canvasColor: backgroundColor,
        //       colorScheme:const ColorScheme.light(
        //           onPrimary: Colors.white,
        //           primary: Colors.green),
        //
        //     ),
        //     child: Stepper(
        //       elevation: 0,
        //       type: StepperType.horizontal,
        //       currentStep: _activeStepIndex,
        //       steps: stepList(),
        //       onStepContinue: () {
        //         if (_activeStepIndex < (stepList().length - 1)) {
        //           setState(() {
        //             _activeStepIndex += 1;
        //           });
        //         } else {
        //           print('Submited');
        //         }
        //       },
        //       onStepCancel: () {
        //         if (_activeStepIndex == 0) {
        //           return;
        //         }
        //         setState(() {
        //           _activeStepIndex -= 1;
        //         });
        //       },
        //       onStepTapped: (int index) {
        //         setState(() {
        //           _activeStepIndex = index;
        //         });
        //       },
        //       controlsBuilder: (
        //           BuildContext context, ControlsDetails details) {
        //         final isLastStep = _activeStepIndex == stepList().length - 1;
        //         return Row(
        //           children: [
        //             Expanded(
        //               child: ElevatedButton(
        //                 style: ElevatedButton.styleFrom(
        //                   primary: appColor,
        //                 ),
        //                 onPressed: isLastStep?
        //                     ()async{
        //                       User user ;
        //                       if(!widget.isNew) {
        //                         user= User.WithId (
        //                             Id: int.parse ( idcontroller.text ),
        //                             org_id:int.parse(drpOrg.seletected_value!.key.toString()),
        //                             UserName: userNameController.text,
        //                             Email: emailController.text,
        //                             FullName: fullNameController.text,
        //                             PublicEmail: publicEmailController.text,
        //                             Password: passwordController.text,
        //                             ConfirmPassword: confirmPasswordController
        //                                 .text,
        //                             // default_Role_Id: DropDown.SelectKeyValue?.key
        //                             default_Role_Id: int.parse(dropdown.seletected_value!.key)
        //                           // default_Role_Id:int.parse(dropdown.seletected_value!.key)
        //                         );
        //                       }
        //                       else
        //                       {
        //                         user=User(
        //                           default_Role_Id:widget.signup!=true?
        //                           int.parse(dropdown.seletected_value!.key):7,
        //                           org_id:int.parse(drpOrg.seletected_value!.key.toString()),
        //                           // default_Role_Id:int.parse(dropdown.seletected_value!.key),
        //                           UserName:userNameController.text,
        //                           Email: emailController.text,
        //                           FullName:fullNameController.text,
        //                           PublicEmail:publicEmailController.text,
        //                           Password:passwordController.text,
        //                           ConfirmPassword:confirmPasswordController.text,
        //
        //                         );
        //                       }
        //                       await _saveForm(user);
        //                 }
        //                     :details.onStepContinue,
        //                 child: (isLastStep)
        //                     ? const Text('Submit')
        //                     : const Text('Next'),
        //               ),
        //             ),
        //             const SizedBox(
        //               width: 10,
        //             ),
        //             if (_activeStepIndex > 0)
        //               Expanded(
        //                 child: ElevatedButton(
        //                   style: ElevatedButton.styleFrom(
        //                     primary: appColor,
        //                   ),
        //                   onPressed: details.onStepCancel,
        //                   child: const Text('Back'),
        //                 ),
        //               )
        //           ],
        //         );
        //       },
        //     ),
        //   ),
        // ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
class NestedTabBarUser extends StatefulWidget {
  final List<Widget> nestedTabbarView;
  final int tabbarbarLength;
  final GlobalKey<FormState> frmNested;
  NestedTabBarUser({Key? key,required this.nestedTabbarView,required this.frmNested,
    required this.tabbarbarLength
  }) : super(key: key);
  @override
  _NestedTabBarUserState createState() => _NestedTabBarUserState();
}
class _NestedTabBarUserState extends State<NestedTabBarUser>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<NestedTabBarUser> {

  late TabController _tabController;
  FocusNode myFocusNode= FocusNode();
  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
      print('Has focus: $myFocusNode.hasFocus');
    });
    _tabController = TabController(length: widget.tabbarbarLength, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    _tabController.notifyListeners();
  }
  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView(
      padding: EdgeInsets.only(left: 15,right: 15,top: 15),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: whiteColor,
                border: Border.all(color: appColor)
            ),
            child: TabBar(
              labelPadding: EdgeInsets.only(left:2,right: 2),
              indicatorWeight: 0.01,
              controller: _tabController,
              labelColor: appColor,
              unselectedLabelColor: Colors.black54,
              isScrollable: false,
              // indicatorPadding: EdgeInsets.symmetric(horizontal: 25),
              // labelPadding: EdgeInsets.symmetric(horizontal: 25),
              tabs: <Widget>[
                _tabController.index==0?
                Container(
                    height: 42,
                    decoration: BoxDecoration(
                        color:appColor,//:appColor,
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child:Center(
                      child: const Text('User Details',style: TextStyle(
                          color: whiteColor
                      ),
                        //style: appcolorTextStylebold,
                      ),
                    )):
                Tab(
                  text: "User Details",
                ),
                _tabController.index==1?
                Container(
                    height: 42,
                    decoration: BoxDecoration(
                        color:appColor,//:appColor,
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child:Center(
                      child: const Text('Address',style: TextStyle(
                          color: whiteColor
                      ),
                        //style: appcolorTextStylebold,
                      ),
                    )):
                Tab(
                  text: "Address",
                ),


              ],
            ),
          ),
        ),
        // TabBar(
        //   controller: _tabController,
        //   indicatorColor: appColor,
        //   labelColor: appColor,
        //   unselectedLabelColor: Colors.black54,
        //   isScrollable: false,
        //   tabs: <Widget>[
        //     Tab(
        //       text: "User Details",
        //     ),
        //     Tab(
        //       text: "Address",
        //     ),
        //
        //
        //   ],
        // ),
        Form(
          key: widget.frmNested,
          child: Container(
              height: screenHeight * 0.70,
              child: TabBarView(
                controller: _tabController,
                children: widget.nestedTabbarView,
              )
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

// List<Step> stepList() => [
//   Step(
//     state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
//     isActive: _activeStepIndex >= 0,
//     title: const Text('User Detail'),
//     content: Form(
//       key: formKeys[0],
//       child: Container(
//         child: Column(
//           children: [
//             widget.signup!=true?const Padding(
//               padding:  EdgeInsets.only(top: 8.0,bottom: 8),
//               child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text("Role Id",style: BlackTextStyleNormal16,)),
//             ):Container(),
//             // widget.signup==true
//             //     ?IgnorePointer(
//             //   child: selectedDrpUser,
//             //   ignoring: true,
//             // )
//             // :
//             widget.signup!=true?dropdown:
//             Container(),
//             const Padding(
//               padding:  EdgeInsets.only(top: 10.0,bottom: 10),
//               child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text("Organization ",
//                     style: BlackTextStyleNormal16,)),
//             ),
//             drpOrg,
//             //selectedDrpUser,
//             AddScreenTextFieldWidget(
//               labelText: "Full Name",
//               obsecureText: false,
//               controller: fullNameController,
//               textName:  user.FullName.toString(),  inputType: TextInputType.name,
//               validator: (text) {
//                 if (!(text!.length > 5) && text.isEmpty) {
//                   return "Enter full name of more then 5 characters!";
//                 }
//                 return null;
//               },
//             ),
//             AddScreenTextFieldWidget(
//               labelText: "User Name",
//               obsecureText: false,
//               controller: userNameController,
//               textName: user.UserName.toString(),  inputType: TextInputType.name,
//               validator: (text) {
//                 if (!(text!.length > 3) && text.isEmpty) {
//                   return "Enter valid username of more then 3 characters!";
//                 }
//                 return null;
//               },
//             ),
//             midPadding,
//           ],
//         ),
//       ),
//     ),
//   ),
//   Step(
//       state:
//       _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
//       isActive: _activeStepIndex >= 1,
//       title: const Text('Address'),
//       content: Form(
//         key: formKeys[1],
//         child: Container(
//           child: Column(
//             children: [
//               AddScreenTextFieldWidget(
//                 labelText: "Public Email",
//                 obsecureText: false,
//                 controller: publicEmailController,
//                 textName: user.PublicEmail.toString(),  inputType: TextInputType.emailAddress,
//                 validator: (value){
//                   if(value!.isEmpty)
//                   {
//                     return 'Please Enter your email';
//                   }
//                   if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
//                     return 'Please enter a valid Email';
//                   }
//                   return null;
//                 },
//               ),
//               AddScreenTextFieldWidget(
//                 labelText: "Email",
//                 obsecureText: false,
//                 controller: emailController,
//                 textName:user.Email.toString(),  inputType: TextInputType.emailAddress,
//                 validator: (value){
//                   if(value!.isEmpty)
//                   {
//                     return 'Please Enter your email';
//                   }
//                   if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
//                     return 'Please enter a valid Email';
//                   }
//                   return null;
//                 },
//
//               ),
//               AddScreenTextFieldWidget(
//                 labelText: "Password",
//                 obsecureText: true,
//                 textFieldLength: 1,
//                 controller: passwordController,
//                 textName: user.Password.toString(),  inputType: TextInputType.text,
//                 validator: ( value){
//                   if(value!.isEmpty)
//                   {
//                     return 'Please re-enter password';
//                   }
//                   if(passwordController.text!=confirmPasswordController.text){
//                     return "Password does not match";
//                   }
//                   return null;
//                 },
//               ),
//               AddScreenTextFieldWidget(
//                 textFieldLength: 1,
//                 labelText: "Confirm Password",
//                 obsecureText: true,
//                 controller: confirmPasswordController,
//                 textName: user.ConfirmPassword.toString(),  inputType: TextInputType.text,
//                 validator: ( value){
//                   if(value!.isEmpty)
//                   {
//                     return 'Please re-enter password';
//                   }
//                   if(passwordController.text!=confirmPasswordController.text){
//                     return "Password does not match";
//                   }
//                   return null;
//                 },
//               ),
//               midPadding,
//             ],
//           ),
//         ),
//       )),
//
// ];