import 'dart:convert';

import 'package:community_new/models/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api_services/api_services.dart';
import '../../constants/styles.dart';

class EevntAddScreen extends StatefulWidget {
  final int event_id;
  final String descrtiption, title;
  final String name;
  final Widget image;
  const EevntAddScreen({
    Key? key,
    required this.image,
    required this.event_id,
    required this.descrtiption,
    required this.title,
    required this.name,
  }) : super(key: key);

  @override
  State<EevntAddScreen> createState() => _EevntAddScreenState();
}

class _EevntAddScreenState extends State<EevntAddScreen> {
  var event = Event();
  _getEvents() async {
    await ApiServices.fetchForEdit(widget.event_id, 'communityevent')
        .then((response) {
      setState(() {
        var eventBody = json.decode(response.body);
        event = Event.fromJson(eventBody);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getEvents();
  }

  @override
  Widget build(BuildContext context) {
    _getEvents();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 2.0,
      ),
      width: double.infinity,
      // color: whiteColor,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            blurRadius: 2.0,
            offset: Offset(0.0, 0.75),
          )
        ],
        // image:const DecorationImage(
        //     image: AssetImage('assets/mosque.png'),
        //     fit:BoxFit.cover
        // ),
        //   //color: appColor.withOpacity(0.5)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(
                    Icons.person,
                    color: appColor,
                  ),
                ),
                widthSizedBox8,
                Text(
                  // widget.event_id.toString()+" "+
                  //     event.masjiId.toString()+" "+
                  widget.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: appColor,
                  ),
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: appColor,
                  ),
                ),
                // Spacer(),
                // Text(widget.date)//dtaetime
              ],
            ),
          ),
          midPadding2,
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
            child: Text(
              widget.descrtiption,
              style: TextStyle(
                color: appColor,
              ),
            ),
          ),
          widget.image,
          // Padding(
          //   padding: const EdgeInsets.all(6.0),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       children: [
          //
          //         widthSizedBox8,
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(event.description.toString()),
          //             midPadding2,
          //             Text('Date: '+event.startDate.toString()+
          //                 ' - '+event.endDate.toString()),
          //             midPadding2,
          //             Text('Time: '+event.startTime.toString()+
          //                 ' - '+event.endTime.toString()),
          //           ],)
          //       ],),
          //   ),
          // ),

          // ListTile(
          //   leading: widget.image,
          //   title: Text(event.name.toString()),
          //   subtitle: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text('Start Date : '+event.startDate.toString()+'\n'+
          //           'End Date : '+
          //           event.endDate.toString()),
          //       Text('Start Time : '+event.startTime.toString()+'\n'+
          //           'End Time : '+
          //           event.endTime.toString()),
          //      // Text(widget.location + ': ' + widget.eventDesc),
          //     ],
          //   ),
          // ),
          // Divider(
          //   color: backgroundColor,
          //   height: 8,
          //   thickness: 8,
          // )
        ],
      ),
    );
  }
}
