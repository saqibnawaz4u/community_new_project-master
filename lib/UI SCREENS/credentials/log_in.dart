import 'dart:convert';
import 'package:community_new/UI%20SCREENS/Menues/orgAdmin.dart';
import 'package:community_new/UI%20SCREENS/credentials/forgot_password.dart';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_services/api_services.dart';
import '../../models/user.dart';
import '../Menues/MasjidAdmin.dart';
import '../Menues/RSSTab.dart';
import '../Menues/superUserTab.dart';
import '../Users/userStepper.dart';
import 'lottie_animation.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> with SingleTickerProviderStateMixin {
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();
  User? Currentuser;
  bool _isChecked = false;
  bool _isfav = true;
  Future<bool> _validateLogin() async {
    bool blnResult = false;
    //Map<String,dynamic>   strUserBody;
    await ApiServices.fetch('user',
            actionName: 'loginuser',
            param1: userNameController.text,
            param2: passwordController.text)
        .then((response) {
      setState(() {
        var userBody = json.decode(response.body);
        print(userBody);
        if (userBody == 'false' || userBody == false) {
          blnResult = false;
        } else {
          Currentuser = User.fromJson(userBody);
          //   print('userid in login');
          //  print(Currentuser!.Id);
          //  strUserBody=userBody;
          //Currentuser =//'admin';
          //await prefs.getString ( 'role_name');
          blnResult = true;
          //  print(response.body);
        }
      });
    });
    prefs = await SharedPreferences.getInstance();
    //  await prefs.setString('role_name', 'SuperAdmin');
    //await prefs.setString('userName', 'admin');
    //await prefs.setInt('userId', 5);

    // SharedPreferences pref = await SharedPreferences.getInstance();
    //Map json = jsonDecode(jsonString);
    // String user =jsonEncode(Currentuser);
    //  prefs.setString('userData', user);
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('role_name', Currentuser!.default_Role_Name);
    await prefs.setString('userName', Currentuser!.UserName);
    await prefs.setString('fullName', Currentuser!.FullName);
    await prefs.setString('email', Currentuser!.Email);
    await prefs.setInt('userId', Currentuser!.Id);
    return blnResult;
  }

  _onChanged(bool? value) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _isChecked = value!;
      prefs.setBool("check", _isChecked);
      prefs.setBool("fav", _isfav);
      prefs.setString("username", userNameController.text);
      prefs.setString("password", passwordController.text);
      prefs.commit();
      getCredential();
    });
  }

  getCredential() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _isChecked = prefs.getBool("check");
      if (_isChecked != null) {
        if (_isChecked) {
          userNameController.text = prefs.getString("username");
          passwordController.text = prefs.getString("password");
        } else {
          //userNameController.clear();
          passwordController.clear();
          prefs.clear();
        }
      } else {
        _isChecked = false;
      }
    });
  }

  late ThemeData themeData;
  bool? _passwordVisible = true;
  @override
  void initState() {
    super.initState();
    getCredential();
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
    themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: whiteColor,
          body: Form(
              key: _form,
              child: ListView(
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: Image.asset('assets/greenph.png') // this is green
                      //Image.asset('assets/placeholder.png') //this isblue
                      ),
                  // const Padding(
                  //   padding:  EdgeInsets.only(left: 15.0),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text (
                  //         "Log In", style: blkTextStyle24 ),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFieldWidget(
                              p_prefixicon: Icon(
                                Icons.person_outline,
                                color: appColor,
                              ),
                              p_obsText: false,
                              controller: userNameController,
                              textName: "User Name",
                              inputType: TextInputType.emailAddress,
                              // validator: (value){
                              //   if(value!.isEmpty)
                              //   {
                              //     return 'Please Enter your email';
                              //   }
                              //   if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                              //     return 'Please enter a valid Public Email';
                              //   }
                              //   return null;
                              // },
                              validator: (v) {},
                            ),
                            TextFieldWidget(
                              p_obsText: _passwordVisible!,
                              p_prefixicon: Icon(
                                MdiIcons.lockOutline,
                                color: appColor,
                              ),
                              p_suffixixon: IconButton(
                                icon: Icon(
                                  _passwordVisible!
                                      ? MdiIcons.eyeOffOutline
                                      : MdiIcons.eyeOutline,
                                  color: _passwordVisible!
                                      ? appColor
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible!;
                                  });
                                },
                              ),
                              controller: passwordController,
                              textName: "Password",
                              inputType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                            ),
                            midPadding,
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        color: appColor,
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPassword(
                                                  currentuserid:
                                                      prefs.get('userId'),
                                                )));
                                  },
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              activeColor: appColor,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _isChecked,
                              onChanged: _onChanged,
                              title: Text('Remember me'),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 15,
                              child: elevatedbutton(
                                  buttonText: "\t\t Login \t\t",
                                  routing: () async {
                                    bool blnresult =
                                        await _validateLogin() as bool;
                                    print('user result ' +
                                        Currentuser!.default_Role_Name
                                            .toString());
                                    print(blnresult);
                                    if (_form.currentState!.validate() &&
                                        blnresult) {
                                      if (Currentuser!.default_Role_Name ==
                                          'SuperAdmin') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LottieAnimation(
                                                      classname: superUserTab(),
                                                    )));

                                        //  MaterialApp(
                                        //   debugShowCheckedModeBanner: false,
                                        //   title: 'Community App',
                                        //   theme: ThemeData(
                                        //   ),
                                        //   home: SplashScreenWidget(widget: superUserTab()),
                                        //
                                        // );
                                      } else if (Currentuser!
                                              .default_Role_Name ==
                                          'OrgAdmin') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LottieAnimation(
                                                      classname:
                                                          OrgAdminWidget(),
                                                    )));
                                        //    MaterialApp(
                                        //     debugShowCheckedModeBanner: false,
                                        //     title: 'Community App',
                                        //     theme: ThemeData(
                                        //     ),
                                        //     //home: OrgAdmin(),
                                        //       home: SplashScreenWidget
                                        // (widget: OrgAdminWidget())
                                        //   );
                                      } else if (Currentuser!
                                              .default_Role_Name ==
                                          'MasjidAdmin') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LottieAnimation(
                                                      classname:
                                                          MasjidAdminTab(),
                                                    )));
                                        //  MaterialApp(
                                        //   debugShowCheckedModeBanner: false,
                                        //   title: 'Community App',
                                        //   theme: ThemeData(
                                        //   ),
                                        //   home: SplashScreenWidget(widget: MasjidAdminTab()),
                                        //
                                        // );
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LottieAnimation(
                                                      classname: HomeTab(),
                                                    )));
                                        //  MaterialApp(
                                        //   debugShowCheckedModeBanner: false,
                                        //   title: 'Community App',
                                        //   theme: ThemeData(
                                        //   ),
                                        //   home: SplashScreenWidget(widget: UserHomeTab())
                                        //
                                        // );
                                      }
                                    } else if (passwordController.text !=
                                            Currentuser!.Password ||
                                        userNameController.text !=
                                            Currentuser!.UserName ||
                                        blnresult == false) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text("Invalid User credentials"),
                                      ));
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: 8,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Dont have an account?',
                        style: TextStyle(color: Color(0xFF576C79)),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      InkWell(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: appColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const userStepper(
                                          isNew: true,
                                          userId: 0,
                                          signup: true,
                                        )));
                          })
                    ],
                  ),
                ],
              ))),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {Key? key,
      required this.textName,
      required this.inputType,
      required this.controller,
      this.validator,
      this.p_suffixixon,
      this.p_prefixicon,
      required this.p_obsText})
      : super(key: key);
  final IconButton? p_suffixixon;
  final bool p_obsText;
  final Icon? p_prefixicon;
  final String textName;
  final TextInputType inputType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 15),
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
        ],
        obscureText: p_obsText,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: appColor)),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(8)),
          //   borderSide: BorderSide(width: 1,color: appColor),
          // ),
          hintText: textName,
          hintStyle: TextStyle(color: Color(0xFF576C79)),
          // fillColor: Colors.transparent,
          // filled: true,
          prefixStyle: TextStyle(color: appColor),
          suffixStyle: TextStyle(color: appColor),
          prefixIcon: p_prefixicon,
          suffixIcon: p_suffixixon,
          // border:  OutlineInputBorder(
          //   borderRadius:  BorderRadius.circular(8.0),
          //  //borderSide: BorderSide.none
          // ),
        ),
        keyboardType: inputType,
      ),
    );
  }
}

class elevatedbutton extends StatelessWidget {
  const elevatedbutton(
      {Key? key, required this.buttonText, required this.routing})
      : super(key: key);
  final String buttonText;
  final VoidCallback routing;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        routing();
      },
      style: ElevatedButton.styleFrom(
          elevation: 10,
          primary: appColor, // background
          onPrimary: blackColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))) // foreground
          ),
      child: Text(
        buttonText,
        style: whiteTextStyleNormal,
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  final BuildContext _context;

  MyCustomClipper(this._context);

  @override
  Path getClip(Size size) {
    final path = Path();
    Size size = MediaQuery.of(_context).size;
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.3);
    path.lineTo(0, size.height * 0.6);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}

class PositionWidget extends StatelessWidget {
  final String txt, inkWellTxt;
  final VoidCallback onpress;
  const PositionWidget(
      {Key? key,
      required this.onpress,
      required this.txt,
      required this.inkWellTxt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 35,
      left: 100,
      child: Row(
        children: [
          Text(
            txt,
            style: TextStyle(color: Color(0xFF576C79)),
          ),
          InkWell(
              child: Text(
                inkWellTxt,
                style: TextStyle(
                    color: appColor, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              onTap: onpress)
        ],
      ),
    );
  }
}
