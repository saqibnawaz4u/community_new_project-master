import 'package:community_new/constants/styles.dart';
import 'package:community_new/widgets/genericAppBar.dart';
import 'package:community_new/widgets/genericDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../widgets/add_screen_text_field.dart';


class yearlyIqamaTime extends StatefulWidget {
  const yearlyIqamaTime({Key? key}) : super(key: key);

  @override
  State<yearlyIqamaTime> createState() => _yearlyIqamaTimeState();
}

class _yearlyIqamaTimeState extends State<yearlyIqamaTime> {
  String condition='';
  _renderWidget() {
    if(condition == 'After 7 days') {
      return sevenDayWidget(
        rangeSelection: PickerDateRange(
            DateTime.now(),
            DateTime.now().add(const Duration(days: 6))),
      ); // this could be any Widget
    } else if(condition == 'After 15 days') {
      return sevenDayWidget(
        rangeSelection: PickerDateRange(
            DateTime.now(),
            DateTime.now().add(const Duration(days: 14))),
      );
    }
    else if(condition == 'Once in a month') {
      return sevenDayWidget(
        rangeSelection: PickerDateRange(
            DateTime.now(),
            DateTime.now().add(const Duration(days: 29))),
      );
    }
    else {
      return Container();
    }
  }
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: genericDrawerForMA(),
        backgroundColor: whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: genericAppBarForSA(
            appbarTitle: 'Set Time',
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(left: 15,right: 15),
          children: [
            midPadding2,midPadding2,
            Container(
              padding: EdgeInsets.only(left: 15,top: 5,right: 10),
                height: MediaQuery.of(context).size.height / 14,
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: blackColor)
                ),
                child:DropdownButton<String>(
                  hint: Text('Select date'),
                    icon: Icon(Icons.arrow_drop_down_outlined),
                    dropdownColor: whiteColor,
                    focusColor: whiteColor,
                    underline: const Text(""),
                    isExpanded: true,
                    value: 'After 7 days',
                    onChanged: (String? val){
                      if(val == 'After 7 days') {
                        setState(() {
                          condition = 'After 7 days'; // A, B or C
                        });
                      }
                      else if(val=='After 15 days')
                      {
                        setState(() {
                          condition='After 15 days';
                        });
                      }
                      else if(val=='Once in a month')
                      {
                        setState(() {
                          condition='Once in a month';
                        });
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'After 7 days',
                        child: Text('After 7 days'),
                      ),
                      DropdownMenuItem(
                        value: 'After 15 days',
                        child: Text('After 15 days'),
                      ),
                      DropdownMenuItem(
                        value: 'Once in a month',
                        child: Text('Once in a month'),
                      ),
                    ]
                )),midPadding2,
            Container(
              child: _renderWidget(),
            )
          ],
        ),
      ),
    );
  }
}

class sevenDayWidget extends StatefulWidget {
  final PickerDateRange rangeSelection;
  const sevenDayWidget({Key? key,required this.rangeSelection}) : super(key: key);

  @override
  State<sevenDayWidget> createState() => _sevenDayWidgetState();
}

class _sevenDayWidgetState extends State<sevenDayWidget> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  var fajrController = TextEditingController();
  var duhrController = TextEditingController();
  var asrController = TextEditingController();
  var maghribController = TextEditingController();
  var ishaController = TextEditingController();
  var firstJumaController = TextEditingController();
  var secondJumaController = TextEditingController();
  var thirdJumaController = TextEditingController();
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }
  Future fajrTime() async {
    TimeOfDay? pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if(pickedTime != null ){
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.replacing(hour: pickedTime.hourOfPeriod).
      format(context).toString());
      String formattedTime = DateFormat('HH:mm a').format(parsedTime);

      setState(() {
        fajrController.text = formattedTime; //set the value of text field.
      });
    }else{
      //print("Time is not selected");
    }
  }
  Future duhrTime() async {
    TimeOfDay? pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if(pickedTime != null ){
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.replacing(hour: pickedTime.hourOfPeriod).
      format(context).toString());
      String formattedTime = DateFormat('HH:mm a').format(parsedTime);

      setState(() {
        duhrController.text = formattedTime; //set the value of text field.
      });
    }else{
      //print("Time is not selected");
    }
  }
  Future asrTime() async {
    TimeOfDay? pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if(pickedTime != null ){
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.replacing(hour: pickedTime.hourOfPeriod).
      format(context).toString());
      String formattedTime = DateFormat('HH:mm a').format(parsedTime);

      setState(() {
        asrController.text = formattedTime; //set the value of text field.
      });
    }else{
      //print("Time is not selected");
    }
  }
  Future maghribTime() async {
    TimeOfDay? pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if(pickedTime != null ){
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.replacing(hour: pickedTime.hourOfPeriod).
      format(context).toString());
      String formattedTime = DateFormat('HH:mm a').format(parsedTime);

      setState(() {
        maghribController.text = formattedTime; //set the value of text field.
      });
    }else{
      //print("Time is not selected");
    }
  }
  Future ishaTime() async {
    TimeOfDay? pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if(pickedTime != null ){
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.replacing(hour: pickedTime.hourOfPeriod).
      format(context).toString());
      String formattedTime = DateFormat('HH:mm a').format(parsedTime);

      setState(() {
        ishaController.text = formattedTime; //set the value of text field.
      });
    }else{
      //print("Time is not selected");
    }
  }
  Future firstJumaTime() async {
    TimeOfDay? pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if(pickedTime != null ){
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.replacing(hour: pickedTime.hourOfPeriod).
      format(context).toString());
      String formattedTime = DateFormat('HH:mm a').format(parsedTime);

      setState(() {
        firstJumaController.text = formattedTime; //set the value of text field.
      });
    }else{
      //print("Time is not selected");
    }
  }
  Future secondJumaTime() async {
    TimeOfDay? pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if(pickedTime != null ){
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.replacing(hour: pickedTime.hourOfPeriod).
      format(context).toString());
      String formattedTime = DateFormat('HH:mm a').format(parsedTime);

      setState(() {
        secondJumaController.text = formattedTime; //set the value of text field.
      });
    }else{
      //print("Time is not selected");
    }
  }
  Future thirdJumaTime() async {
    TimeOfDay? pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if(pickedTime != null ){
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.replacing(hour: pickedTime.hourOfPeriod).
      format(context).toString());
      String formattedTime = DateFormat('HH:mm a').format(parsedTime);

      setState(() {
        thirdJumaController.text = formattedTime; //set the value of text field.
      });
    }else{
      //print("Time is not selected");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      //shrinkWrap: true,
      children: [
        SfDateRangePicker(
          startRangeSelectionColor: appColor,
          endRangeSelectionColor: appColor,
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.range,
          initialSelectedRange: widget.rangeSelection
        ),
        //Text('Selected date: $_selectedDate'),
        //Text('Selected date count: $_dateCount'),
        Text('Selected range: $_range'),
        Row(
          children: [
          Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text('Fajr          ',style: const TextStyle(
            fontSize: 16, ),),
              )),
          widthSizedBox8,
          Flexible(
            flex: 4,
            child: AddScreenTextFieldWidget(
              ontap: fajrTime,
              labelText: '',
              obsecureText: false,
              controller: fajrController,
              textName:  '',
              inputType: TextInputType.none,
              validator: (text) {
                if (!(text!.length > 3) || text.isEmpty) {
                  return "Please enter valid time";
                }
                return null;
              },
            ),
          ),
        ],),
        Row(
          children: [
            Flexible(child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text('Duhr          ',style: const TextStyle(
                fontSize: 16, ),),
            )), widthSizedBox8,
            Flexible(
              flex: 4,
              child: AddScreenTextFieldWidget(
                ontap: duhrTime,
                labelText: "",
                obsecureText: false,
                controller: duhrController,
                textName: '',
                inputType: TextInputType.none,
                validator: (value){
                  if (!(value!.length > 3) || value.isEmpty) {
                    return "Please enter valid time";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        Row(children: [
          Flexible(child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text('Asr           ',style: const TextStyle(
              fontSize: 16, ),),
          )), widthSizedBox8,
          Flexible(
            flex: 4,
            child: AddScreenTextFieldWidget(
              ontap: asrTime,
              labelText: "",
              obsecureText: false,
              controller: asrController,
              textName: '',
              inputType: TextInputType.none,
              validator: (value){
                if (!(value!.length > 3) || value.isEmpty) {
                  return "Please enter valid time";
                }
                return null;
              },
            ),
          ),
        ],),
        Row(children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text('Maghrib',style: const TextStyle(
              fontSize: 16, ),),
          )),
          widthSizedBox8,
          Flexible(
            flex: 4,
            child: AddScreenTextFieldWidget(
              ontap: maghribTime,
              labelText: "",
              obsecureText: false,
              controller: maghribController,
              textName: '',
              inputType: TextInputType.none,
              validator: (value){
                if (!(value!.length > 3) || value.isEmpty) {
                  return "Please enter valid time";
                }
                return null;
              },
            ),
          ),
        ],),
        Row(children: [
          Flexible(child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text('Isha          ',style: const TextStyle(
              fontSize: 16, ),),
          )), widthSizedBox8,
          Flexible(
            flex: 4,
            child: AddScreenTextFieldWidget(
              ontap: ishaTime,
              labelText: "",
              obsecureText: false,
              controller: ishaController,
              textName: '',
              inputType: TextInputType.none,
              validator: (value){
                if (!(value!.length > 3) || value.isEmpty) {
                  return "Please enter valid time";
                }
                return null;
              },
            ),
          ),
        ],),
        Row(children: [
          Flexible(child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text('First Juma',style: const TextStyle(
              fontSize: 16, ),),
          )), widthSizedBox8,
          Flexible(
            flex: 4,
            child: AddScreenTextFieldWidget(
              ontap: firstJumaTime,
              labelText: "",
              obsecureText: false,
              controller: firstJumaController,
              textName: '',
              inputType: TextInputType.none,
              validator: (value){
                if (!(value!.length > 3) || value.isEmpty) {
                  return "Please enter valid time";
                }
                return null;
              },
            ),
          ),
        ],),
        Row(children: [
          Flexible(child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text('Second Juma',style: const TextStyle(
              fontSize: 16, ),),
          )), widthSizedBox8,
          Flexible(
            flex: 4,
            child: AddScreenTextFieldWidget(
              ontap: secondJumaTime,
              labelText: "",
              obsecureText: false,
              controller: secondJumaController,
              textName: '',
              inputType: TextInputType.none,
              validator: (value){
                if (!(value!.length > 3) || value.isEmpty) {
                  return "Please enter valid time";
                }
                return null;
              },
            ),
          ),
        ],),
        Row(children: [
          Flexible(child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text('Third Juma',style: const TextStyle(
              fontSize: 16, ),),
          )), widthSizedBox8,
          Flexible(
            flex: 4,
            child: AddScreenTextFieldWidget(
              ontap: thirdJumaTime,
              labelText: "",
              obsecureText: false,
              controller: thirdJumaController,
              textName: '',
              inputType: TextInputType.none,
              validator: (value){
                if (!(value!.length > 3) || value.isEmpty) {
                  return "Please enter valid time";
                }
                return null;
              },
            ),
          ),
        ],),
        midPadding2,midPadding2,
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/16,
          child: ElevatedButton(
            onPressed: ()async{
              setState(() {
                
              });
            },
            child: const Text('Save'),
            style: ElevatedButton.styleFrom(
                primary: appColor, // background
                onPrimary: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                )// foreground
            ),

          ),
        ),
        SizedBox(height: 90,)
      ],
    );
  }
}








