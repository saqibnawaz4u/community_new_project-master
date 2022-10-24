import 'dart:convert';
import 'dart:io';
import 'package:community_new/widgets/button_widget_blue.dart';
import 'package:community_new/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:community_new/constants/styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../api_services/api_services.dart';
import '../../../widgets/add_screen_text_field.dart';
import '../../../widgets/extra_widgets.dart';
import '../../../widgets/radio_button.dart';

class CreatingEventScreen extends StatefulWidget {
  const CreatingEventScreen({Key? key}) : super(key: key);
  @override
  _CreatingEventScreenState createState() => _CreatingEventScreenState();
}
class _CreatingEventScreenState extends State<CreatingEventScreen> {
  PickedFile? imageFile=null;
  var eventNameController = TextEditingController();
  var locationController = TextEditingController();
  var startDateController = TextEditingController();
  var startTimeController = TextEditingController();
  var endDateController = TextEditingController();
  var endTimeController = TextEditingController();
  var descriptionController = TextEditingController();
  var fullNameController = TextEditingController();
 var masjidId = TextEditingController();
  final _form = GlobalKey<FormState>();
  //form validation
  Future<void> _saveForm(Event event) async{
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
  }
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
  //event api url
  final String url = 'http://192.168.10.3:8040/api/communityevent';
  Future<String> getEventData() async {
    var res = await http
        .get(Uri.parse ( url ), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    return "Sucess";
  }
  @override
  void initState() {
    startTimeController.text='';
    endTimeController.text='';
    super.initState();
    this.getEventData();
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
          title: const Text("New Event"),
        ),
        body: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const  RichTextWidget(text1: "Event Photos",text2: "*",),
                  midPadding2,
                  ( imageFile==null)?DottedBorder(
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
                  ):Container(
                    width: MediaQuery.of(context).size.width/3,
                    height: MediaQuery.of(context).size.height/5,
                    child:Image.file( File(  imageFile!.path)),),
                  midPadding,

                 const RichTextWidget(text1: "Event Name",text2: "*",),midPadding2,
                  AddScreenTextFieldWidget(
                  obsecureText: false,
                    controller: eventNameController,
                    textName: "Title", inputType: TextInputType.text,
                    textFieldLength: 1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* Required";
                      } else if (value.length < 6) {
                        return "Event name should be atleast 6 characters";
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
                      } else if (value.length < 6) {
                        return "Address should be atleast 6 characters";
                      } else
                        return null;
                    },
                  ),
                  midPadding,
                  const  RichTextWidget(text1: "Description",text2: "",),midPadding2,
                  AddScreenTextFieldWidget(
                  obsecureText: false,
                    controller: descriptionController,
                    textName: "Placeholder text", inputType: TextInputType.text,
                    textFieldLength: 3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* Required";
                      } else
                        return null;
                    },
                  ),midPadding2,
                  AddScreenTextFieldWidget(
                  obsecureText: false,
                    controller: fullNameController,
                    textName: "Full Name", inputType: TextInputType.text,
                    textFieldLength: 1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* Required";
                      } else
                        return null;
                    },
                  ),
                  AddScreenTextFieldWidget(
                  obsecureText: false,
                    controller: masjidId,
                    textName: "masjid id", inputType: TextInputType.text,
                    textFieldLength: 1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* Required";
                      } else
                        return null;
                    },
                  ),
                  const RadioButtonWidget(),
                  ButtonBar(
                    children: [
                      ElevatedButtonWidgetBlue(
                        buttonText: "Cancel", routing: () {},),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width/4,
                        height: MediaQuery.of(context).size.height/16,
                        child: ElevatedButton(
                          onPressed: () async{
                            Event event =  Event(
                                name:eventNameController.text,location: locationController.text,
                                description: descriptionController.text,
                               // startDate: DateTime.parse(startDateController.text),
                              startDate: startDateController.text,
                                startTime: startTimeController.text,
                                // endDate: endDateController.text,
                                endTime: endTimeController.text,
                              fullName: fullNameController.text,
                              masjiId: int.parse(masjidId.text)

                            );
                           await _saveForm(event);
                            var tes = ApiServices.postEvent(event);

                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // background
                              onPrimary: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(24))
                              )// foreground
                          ),
                          child: const Text("Create Event"),
                        ),)
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
  //start time function
  Future ontappedFunctionOfStartTime() async {
    TimeOfDay? pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if(pickedTime != null ){
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      setState(() {
        startTimeController.text = formattedTime; //set the value of text field.
      });
    }else{
      print("Time is not selected");
    }
  }
// start date function
  Future onTappedFunctionOfStartDate () async {
    DateTime? pickedDate = await showDatePicker(
        context: context, initialDate: DateTime.now(),
        firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101)
    );
    if(pickedDate != null ){
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        startDateController.text = formattedDate; //set output date to TextField value.
      });
    }else{
      print("Date is not selected");
    }
  }
  //end time function
  Future ontappedFunctionOfEndTime() async {
    TimeOfDay? pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if(pickedTime != null ){
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      setState(() {
        endTimeController.text = formattedTime; //set the value of text field.
      });
    }else{
      print("Time is not selected");
    }
  }
  //end date function
  Future onTappedFunctionOfEndDate () async {
    DateTime? pickedDate = await showDatePicker(
        context: context, initialDate: DateTime.now(),
        firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101)
    );
    if(pickedDate != null ){
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        endDateController.text = formattedDate; //set output date to TextField value.
      });
    }else{
      print("Date is not selected");
    }
  }
}


