import 'package:community_new/UI%20SCREENS/credentials/log_in.dart';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';

import '../Menues/oldMenus/home_screen.dart';

class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  var invitationCodeController = TextEditingController();
  var emailController = TextEditingController();
  var fullNameController =TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Form(
            key: _form,
            child: Stack(
          children: [
            ClipPath(
                clipper: MyCustomClipper(context),
                child: Container(
                  alignment: Alignment.center,
                  color: appColor,
                )),
            Column(
              children:   [
                SizedBox(height: MediaQuery.of(context).size.height/10,),
                const Center(child: Text("Sign Up",style: TextStyle(fontSize: 24),),),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: (){},
                      child: const Text("What's New",style: TextStyle(decoration: TextDecoration.underline),),),
                  ),
                ),
                 TextFieldWidget(
                     p_obsText: false,
                     validator: (value) {
                       if (value!.isEmpty) {
                         return "* Required";
                       } else
                         return null;
                     },
                     controller:invitationCodeController,
                     textName: "Invitation Code", inputType: TextInputType.number),
                 TextFieldWidget(
                   p_obsText: false,
                     controller: fullNameController,
                     textName: "Full Name",  inputType: TextInputType.name,
                   validator: (value) {
                     if (value!.isEmpty) {
                       return "* Required";
                     }else if(value.length<6){
                       return "full name should be atleast 6 characters";
                     }else
                       return null;
                   },
                 ),
                 TextFieldWidget(
                   p_obsText: false,
                     controller: emailController,
                     textName: "Email",  inputType: TextInputType.emailAddress,
                   validator: (value){
                     if(value!.isEmpty)
                     {
                       return 'Please Enter your email';
                     }
                     if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                       return 'Please enter a valid Public Email';
                     }
                     return null;
                   },
                 ),
                 TextFieldWidget(
                   p_obsText: true,
                     controller: passwordController,
                     textName: "Password",  inputType: TextInputType.text,
                   validator: (value){
                     if(value!.isEmpty)
                     {
                       return 'Please enter password';
                     }
                     if(passwordController.text!=confirmPasswordController.text){
                       return "Password does not match";
                     }
                     return null;
                   },
                 ),
                 TextFieldWidget(
                   p_obsText: true,
                     controller: confirmPasswordController,
                     textName: "Retype Password",  inputType: TextInputType.text,
                   validator: (value){
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
                midPadding,
                elevatedbutton(buttonText: "Signup", routing: () {
                  if(_form.currentState!.validate()){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) =>  MyHomeOld())); }})
                ],
            ),
            PositionWidget(
              inkWellTxt: 'Login',
                onpress:  (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                  const LogIn()));
                },
                txt: 'Already have an account?')
          ],
        ))
      ),
    );
  }
}

