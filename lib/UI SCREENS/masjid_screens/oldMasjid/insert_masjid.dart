import 'dart:convert';
import 'package:community_new/UI%20SCREENS/Users/UserEdit.dart';
import 'package:community_new/widgets/button_widget_blue.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/masjid.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../api_services/api_services.dart';
import '../../../widgets/add_screen_text_field.dart';
import '../../../widgets/extra_widgets.dart';

class InsertMasjid extends StatefulWidget {
  const InsertMasjid({Key? key}) : super(key: key);
  @override
  _CreatingMasjidScreenState createState() => _CreatingMasjidScreenState();
}
class _CreatingMasjidScreenState extends State<InsertMasjid> {
  final _form = GlobalKey<FormState>();
  final String masjidUrl = 'http://localhost:8040/api/masjid';
  var masjidNameController = TextEditingController();
  var descriptiomController = TextEditingController();
  var locationController = TextEditingController();
  var emailController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var countryController = TextEditingController();
  var postalCodeController = TextEditingController();
  var phoneController = TextEditingController();
  Future<void> _saveForm(Masjid masjid) async{
    final isValid = _form.currentState!.validate();
    if (isValid) {
      await ApiServices.postMasjid(masjid);
      ScaffoldMessenger.of(context)
          .showSnackBar(  SnackBar(
        content:Text("Masjid Added Successfully"),));
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar(  SnackBar(
        content:Text("Please fill form correctly"),));
    }
  }
  Future<String> getMasjidData() async {
    var res = await http
        .get(Uri.parse ( masjidUrl ), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    // setState(() {
    //   data = resBody;
    // });

    print(resBody);

    return "Sucess";
  }
  @override
  void initState() {
    super.initState();
    this.getMasjidData();
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
          title: const Text("Add New Masjid"),
        ),
        body:  Form(
          key: _form,
          child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const  RichTextWidget(text1: "Masjid Photos",text2: "*",),
                midPadding2,
                DottedBorder(
                  color: Colors.grey,//color of dotted/dash line
                  strokeWidth: 2, //thickness of dash/dots
                  dashPattern: const [10,3],
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width/3,
                    height: MediaQuery.of(context).size.height/5,
                    child: Center(
                      child: IconButton(
                          onPressed: (){}, icon: const Icon(Icons.camera_alt)),
                    ),
                  ),
                ),midPadding,
                const  RichTextWidget(text1: "Masjid Name",text2: "*",),midPadding2,
                AddScreenTextFieldWidget(
                  obsecureText: false,
                  controller: masjidNameController,
                  textName: "Title", inputType: TextInputType.text,
                  textFieldLength: 1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Required";
                    } else
                      return null;
                  },
                ),midPadding,
                const  RichTextWidget(text1: "Location",text2: "*",),midPadding2,
                AddScreenTextFieldWidget(
                  obsecureText: false,
                  controller: locationController,
                  textName: "Address", inputType: TextInputType.streetAddress,
                  textFieldLength: 1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Required";
                    } else
                      return null;
                  },
                ),
                midPadding,
                const  RichTextWidget(text1: "Description",text2: "",),midPadding2,
                AddScreenTextFieldWidget(
                  obsecureText: false,
                  controller: descriptiomController,
                  textName: "Placeholder text", inputType: TextInputType.text,
                  textFieldLength: 3,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Required";
                    } else
                      return null;
                  },
                ),
                midPadding,
                const  RichTextWidget(text1: "City",text2: "*",),midPadding2,
                AddScreenTextFieldWidget(
                  obsecureText: false,
                  controller: cityController,
                  textName: "City Address", inputType: TextInputType.streetAddress,
                  textFieldLength: 1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Required";
                    } else
                      return null;
                  },
                ), midPadding,
                const  RichTextWidget(text1: "State",text2: "*",),midPadding2,
                AddScreenTextFieldWidget(
                  obsecureText: false,
                  controller: stateController,
                  textName: "State Name", inputType: TextInputType.name,
                  textFieldLength: 1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Required";
                    } else
                      return null;
                  },
                ), midPadding,
                const  RichTextWidget(text1: "Country",text2: "*",),midPadding2,
                AddScreenTextFieldWidget(
                  obsecureText: false,
                  controller: countryController,
                  textName: "Country Name", inputType: TextInputType.name,
                  textFieldLength: 1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Required";
                    } else
                      return null;
                  },
                ),

                midPadding,
                const  RichTextWidget(text1: "Postal Code",text2: "",),midPadding2,
                AddScreenTextFieldWidget(
                  obsecureText: false,
                  controller: postalCodeController,
                  textName: "City Postal Code", inputType: TextInputType.number,
                  textFieldLength: 1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Required";
                    } else
                      return null;
                  },
                ), midPadding,
                const  RichTextWidget(text1: "Email",text2: "",),midPadding2,
                AddScreenTextFieldWidget(
                  obsecureText: false,
                  controller: emailController,
                  textName: "Enter Your Email", inputType: TextInputType.emailAddress,
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
                ), midPadding,
                const  RichTextWidget(text1: "Phone Number",text2: "",),midPadding2,
                AddScreenTextFieldWidget(
                  obsecureText: false,
                  controller: phoneController,
                  textName: "Enter Your Phone Number", inputType: TextInputType.streetAddress,
                  textFieldLength: 1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Required";
                    } else
                      return null;
                  },
                ),
                midPadding2,
                ButtonBar(
                  children: [
                    ElevatedButtonWidgetBlue(
                      buttonText: "Cancel", routing: () {},),
                    ElevatedButtonWidgetBlue(
                        buttonText: "Create Masjid",
                        routing: ()async{
                          Masjid masjid = Masjid(
                            Name: masjidNameController.text,Country: countryController.text,
                            Email: emailController.text,Location: locationController.text,
                            Description: descriptiomController.text,City: cityController.text,
                            State: stateController.text,PostalCode: postalCodeController.text,
                            Phone1: phoneController.text
                          );
                          await _saveForm(masjid);
                    }),
                  ],
                )
              ],
            ),
          ),
        ),)
      ),
    );
  }
}


