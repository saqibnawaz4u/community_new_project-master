import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/styles.dart';
import '../../widgets/add_screen_text_field.dart';
import '../../widgets/extra_widgets.dart';
import 'package:intl/intl.dart';

import '../Users/UserEdit.dart';
import '../Users/oldUser/edit_user_data.dart';
class CreatingBusinessScreen extends StatefulWidget {
  const CreatingBusinessScreen({Key? key}) : super(key: key);

  @override
  _CreatingBusinessScreenState createState() => _CreatingBusinessScreenState();
}

class _CreatingBusinessScreenState extends State<CreatingBusinessScreen> {
  int selectedIndex =-1;
  final _form = GlobalKey<FormState>();
  bool selectedColor =false;
  var businessNameController = TextEditingController();
  var aboutController = TextEditingController();
  var locationController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var websiteController = TextEditingController();
  PickedFile? imageFile=null;
  void _openGallery(BuildContext context) async{
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery ,
    );
    setState(() {
      imageFile = pickedFile!;
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context)  async{
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera ,
    );
    setState(() {
      imageFile = pickedFile!;
    });
    Navigator.pop(context);
  }
  //show dialog to give option of gallery and camera on camera icon
  Future<void>_showChoiceDialog(BuildContext context)
  {
    return showDialog(context: context,builder: (BuildContext context){

      return AlertDialog(
        title: const Text("Choose option",style: TextStyle(color: blackColor),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: blackColor),
              ListTile(
                onTap: (){
                  _openGallery(context);
                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color:appColor,),
              ),

              Divider(height: 1,color: blackColor),
              ListTile(
                onTap: (){
                  _openCamera(context);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color:appColor),
              ),
            ],
          ),
        ),);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading:  IconButton(icon:const Icon(Icons.arrow_back,),
            onPressed: (){Navigator.pop(context);},),
          backgroundColor: appColor,
          centerTitle: true,
          title: const Text("Create New Business",style: whiteTextStyleNormal),
        ),
        body:  Form(
          key: _form,
          child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              midPadding2,
              Padding(
                padding: const EdgeInsets.only(left:15.0),
                child: const  RichTextWidget(text1: "Add Photos",text2: "*",),
              ),
              midPadding2,
              ( imageFile==null)? Padding(
                padding: const EdgeInsets.only(left:15.0),
                child: DottedBorder(
                  color: Colors.grey,//color of dotted/dash line
                  strokeWidth: 2, //thickness of dash/dots
                  dashPattern: const [10,3],
                  child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width/3,
                      height: MediaQuery.of(context).size.height/5,
                      child: Center(
                        child: IconButton(
                            onPressed: (){
                              _showChoiceDialog(context);
                            }, //icon: const
                            icon: const Icon(Icons.camera_alt)
                        ),
                      )
                  ),
                ),
              ):Container(
                padding: const EdgeInsets.only(left: 15.0,right: 15),
                // width: MediaQuery.of(context).size.width/3,
                // height: MediaQuery.of(context).size.height/5,
                child:Image.file( File(  imageFile!.path)),),
              AddScreenTextFieldWidget(
                labelText: 'Name',
                obsecureText: false,
                controller: businessNameController,
                textName: "Business Name", inputType: TextInputType.text,
                textFieldLength: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else
                    return null;
                },
              ),
              AddScreenTextFieldWidget(
                labelText: 'About',
                obsecureText: false,
                controller: aboutController,
                textName: "Describe your business", inputType: TextInputType.multiline,
                textFieldLength: 3,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else
                    return null;
                },
              ),
              AddScreenTextFieldWidget(
                labelText: 'Location (Optional)',
                obsecureText: false,
                controller: locationController,
                textName: "Number Street City State Postal code", inputType: TextInputType.streetAddress,
                textFieldLength: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else
                    return null;
                },
              ),
              AddScreenTextFieldWidget(
                labelText: 'Email (Optional)',
                obsecureText: false,
                controller: emailController,
                textName: "Email address", inputType: TextInputType.emailAddress,
                textFieldLength: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else
                    return null;
                },
              ),
              AddScreenTextFieldWidget(
                labelText:'Phone Number (Optional)',
                obsecureText: false,
                controller: phoneController,
                textName: "(000) 000-0000", inputType: TextInputType.number,
                textFieldLength: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else
                    return null;
                },
              ),
              AddScreenTextFieldWidget(
                labelText: 'Website (Optional)',
                obsecureText: false,
                controller: websiteController,
                textName: "http://www...", inputType: TextInputType.text,
                textFieldLength: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else
                    return null;
                },
              ),midPadding,
              const ExpansionTile(
                title: Text("Hours (Optional)"),
                children:  <Widget>[],
              ),
              ButtonBar(
                children: [
                  ElevatedButtonWidget(buttonText: "Cancel", routing: () {},),
                  ElevatedButtonWidget(buttonText: "Create Business", routing: (){}),
                ],
              )
            ],
          ),
        ),)
      ),
    );
  }
}


