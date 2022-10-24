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

class EditEventchk extends StatefulWidget {
  final String eventId;
  final bool isNew;
  const EditEventchk({Key? key,required this.eventId,required this.isNew,}) : super(key: key);
  @override
  _EditEventState createState() => _EditEventState();
}
class _EditEventState extends State<EditEventchk> {
  PickedFile? imageFile=null;
  var eventIdController = TextEditingController();
  var eventNameController = TextEditingController();
  var locationController = TextEditingController();
  var startDateController = TextEditingController();
  var startTimeController = TextEditingController();
  var endDateController = TextEditingController();
  var endTimeController = TextEditingController();
  var descriptionController = TextEditingController();
  var fullNameController = TextEditingController();
  var masjidIdController = TextEditingController();
  final _form = GlobalKey<FormState>();

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
  final String eventUrl = 'http://localhost:8040/api/communityevent';
  var event =  Event();
//saving form after validation
  Future<void> _saveForm(Event event) async{
    final isValid = _form.currentState!.validate();
    if (isValid) {
      if(widget.isNew)
      {
        await ApiServices.postEvent(event);
        ScaffoldMessenger.of(context)
            .showSnackBar(  SnackBar(
          content:Text("Event Added Successfully"),));
      }
      else {
        await ApiServices.postEventbyid (eventIdController.text, event );
        ScaffoldMessenger.of ( context )
            .showSnackBar ( SnackBar (
          content: Text ( "Event Updated Successfully" ), ) );
      }
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar(  SnackBar(
        content:Text("Please fill form correctly"),));
    }
  }



  _getEvent() {
    ApiServices.fetchForEdit(int.parse(widget.eventId) ,'communityevent' ).then((response) {
      setState(() {
        var eventBody=json.decode(response.body);
        event=Event.fromJson(eventBody);
        eventIdController.text=event.Id.toString();
        startDateController.text = event.startDate.toString();
        fullNameController.text = event.fullName.toString();
        eventNameController.text=event.name.toString();
        locationController.text = event.location.toString();
        startTimeController.text=event.startTime.toString();
        endDateController.text=event.endDate.toString();
        endTimeController.text=event.endTime.toString();
        descriptionController.text=event.description.toString();
        masjidIdController.text = event.masjiId.toString();
      });
    });
  }
  @override
  void initState() {
    super.initState();
    if(widget.isNew==false){
    _getEvent();}

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
            title: widget.isNew==false? Text("Edit Event",style: TextStyle(fontSize: 24),):
            Text("Add Event",style: TextStyle(fontSize: 24),),
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
                    ( imageFile==null)? DottedBorder(
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
                    const RichTextWidget(text1: "Id",text2: "*",),midPadding2,
                    AddScreenTextFieldWidget(
                  obsecureText: false,
                      p_readOnly: true,
                      controller: eventIdController,
                      textName: event.Id.toString(),
                      inputType: TextInputType.text,
                      textFieldLength: 1,
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "* Required";
                      //   } else if (value.length < 6) {
                      //     return "Event name should be atleast 6 characters";
                      //   } else
                      //     return null;
                      // },
                    ),midPadding,
                    const RichTextWidget(text1: "Event Name",text2: "*",),midPadding2,
                    AddScreenTextFieldWidget(
                  obsecureText: false,
                      controller: eventNameController,
                      textName: event.name.toString(), inputType: TextInputType.text,
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
                      textName: event.location.toString(), inputType: TextInputType.streetAddress,
                      textFieldLength: 1,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "* Required";
                        } else if (value.length < 6) {
                          return "Address should be atleast 6 characters";
                        } else
                          return null;
                      },
                    ), midPadding,
                    midPadding,
                    const  RichTextWidget(text1: "Description",text2: "",),midPadding2,
                    AddScreenTextFieldWidget(
                  obsecureText: false,
                      controller: descriptionController,
                      textName: event.description.toString(), inputType: TextInputType.text,
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
                      textName: event.fullName.toString(), inputType: TextInputType.text,
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
                      controller: masjidIdController,
                      textName: event.masjiId.toString(), inputType: TextInputType.text,
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
                              Event event ;

                              if(!widget.isNew) {
                                     event =Event.withId(
                                Id: int.parse(eventIdController.text),
                                name:eventNameController.text,location: locationController.text,
                                description: descriptionController.text,
                               // startDate: DateTime.parse(startDateController.toString()),
                                startTime: startTimeController.text,
                               // endDate: DateTime.parse(endDateController.toString()),
                                endTime: endTimeController.text,
                                fullName: fullNameController.text,
                                       masjiId: int.parse(masjidIdController.text)

                              );}else{
                                event =Event(
                                  name:eventNameController.text,location: locationController.text,
                                  description: descriptionController.text,
                                  // startDate: DateTime.parse(startDateController.toString()),
                                  startTime: startTimeController.text,
                                  // endDate: DateTime.parse(endDateController.toString()),
                                  endTime: endTimeController.text,
                                  fullName: fullNameController.text,
                                    masjiId: int.parse(masjidIdController.text)
                                );
                              }
                              await _saveForm(event);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue, // background
                                onPrimary: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(24))
                                )// foreground
                            ),
                            child: const Text("Save"),
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
//   Future ontappedFunctionOfStartTime() async {
//     TimeOfDay? pickedTime =  await showTimePicker(
//       initialTime: TimeOfDay.now(),
//       context: context,
//     );
//
//     if(pickedTime != null ){
//       DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
//       String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
//       setState(() {
//         startTimeController.text = formattedTime; //set the value of text field.
//       });
//     }else{
//       print("Time is not selected");
//     }
//   }
// // start date function
//   Future onTappedFunctionOfStartDate () async {
//     DateTime? pickedDate = await showDatePicker(
//         context: context, initialDate: DateTime.now(),
//         firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
//         lastDate: DateTime(2101)
//     );
//     if(pickedDate != null ){
//       String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//       setState(() {
//         startDateController.text = formattedDate; //set output date to TextField value.
//       });
//     }else{
//       print("Date is not selected");
//     }
//   }
//   //end time function
//   Future ontappedFunctionOfEndTime() async {
//     TimeOfDay? pickedTime =  await showTimePicker(
//       initialTime: TimeOfDay.now(),
//       context: context,
//     );
//     if(pickedTime != null ){
//       DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
//       String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
//       setState(() {
//         endTimeController.text = formattedTime; //set the value of text field.
//       });
//     }else{
//       print("Time is not selected");
//     }
//   }
//   //end date function
//   Future onTappedFunctionOfEndDate () async {
//     DateTime? pickedDate = await showDatePicker(
//         context: context, initialDate: DateTime.now(),
//         firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
//         lastDate: DateTime(2101)
//     );
//     if(pickedDate != null ){
//       String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//       setState(() {
//         endDateController.text = formattedDate; //set output date to TextField value.
//       });
//     }else{
//       print("Date is not selected");
//     }
//   }
}


