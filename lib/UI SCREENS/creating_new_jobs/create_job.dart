import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/styles.dart';
import '../../widgets/add_screen_text_field.dart';
import '../../widgets/button_widget_blue.dart';
import '../../widgets/extra_widgets.dart';
import '../Users/UserEdit.dart';

class CreatingJobScreen extends StatefulWidget {
  const CreatingJobScreen({Key? key}) : super(key: key);

  @override
  _CreatingJobScreenState createState() => _CreatingJobScreenState();
}

class _CreatingJobScreenState extends State<CreatingJobScreen> {
  int selectedIndex =-1;
  bool selectedColor =false;
  bool status = false;
  final _form = GlobalKey<FormState>();
  var jobNameController = TextEditingController();
  var locationController = TextEditingController();
  var descriptionController = TextEditingController();
  var employmentTypeController = TextEditingController();
  var salaryController = TextEditingController();
  var emailController = TextEditingController();
  var phoneNumberController = TextEditingController();
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
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading:  IconButton(icon:const Icon(Icons.arrow_back,),
            onPressed: (){Navigator.pop(context);},),
          backgroundColor: appColor,
          centerTitle: true,
          title: const Text("List New Job"),
        ),
        body: Form(
          key: _form,
          child:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              midPadding2,
               const Padding(
                  padding:  EdgeInsets.only(left:15.0),
                  child:  RichTextWidget(text1: "Add Photo",text2: "*",),
                ),
              midPadding2,
              ( imageFile==null)? Padding(
                padding: const EdgeInsets.only(left: 15.0),
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
                labelText: 'Job Title',
                obsecureText: false,
                controller: jobNameController,
                textName: "Position", inputType: TextInputType.text,
                textFieldLength: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else
                    return null;
                },
              ),
              AddScreenTextFieldWidget(
                labelText: 'Location',
                obsecureText: false,
                controller: locationController,
                textName: "Number, Street, City, State, Postal code", inputType: TextInputType.streetAddress,
                textFieldLength: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else
                    return null;
                },
              ),
              AddScreenTextFieldWidget(
                labelText: 'Job Description',
                obsecureText: false,
                controller: descriptionController,
                textName: "Describe this job position", inputType: TextInputType.multiline,
                textFieldLength: 3,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else
                    return null;
                },
              ),
              Row(children: [
                Expanded(
                  child: AddScreenTextFieldWidget(
                    labelText: "Employment Type",
                    obsecureText: false,
                    controller: employmentTypeController,
                    textName: "",
                    inputType: TextInputType.text,
                    validator: (text) {
                      if ( text!.isEmpty) {
                        return "*Required";
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: AddScreenTextFieldWidget(
                    labelText: "Salary",
                    obsecureText: false,
                    controller: salaryController,
                    textName: "",
                    inputType: TextInputType.number,
                    validator: (text) {
                      if ( text!.isEmpty) {
                        return "*Required";
                      }
                      return null;
                    },
                  ),
                ),
              ],),
              AddScreenTextFieldWidget(
                labelText: 'Email (Optional)',
                obsecureText: false,
                controller: emailController,
                textName: "Email address", inputType: TextInputType.emailAddress,
                textFieldLength: 1,
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
              AddScreenTextFieldWidget(
                labelText: 'Phone Number (Optional)',
                obsecureText: false,
                controller: phoneNumberController,
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
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(children: [
                  const Text("Public",style: TextStyle(fontSize: 15),),
                  widthSizedBox,
                  FlutterSwitch(
                    activeColor: Colors.green,
                    toggleSize: 15,
                    height: 20,
                    width: 40,
                    value: status,
                    onToggle: (val) {
                      setState(() {
                        status = val;
                      });
                    },
                  ),
                ],),
              ),midPadding,
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButtonWidgetBlue(buttonText: "Cancel", routing: () {},),
                  ElevatedButtonWidgetBlue(buttonText: "List Job", routing: (){}),
                ],
              )
            ],
          ),
        ),)
      ),
    );
  }
}