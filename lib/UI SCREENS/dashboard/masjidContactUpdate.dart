import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api_services/api_services.dart';
import '../../constants/styles.dart';
import '../../models/masjid.dart';

class masjidContactUpdate extends StatefulWidget {
  final int masjid_id;
  final String title, date, description;
  final String name;
  const masjidContactUpdate({
    Key? key,
    required this.date,
    required this.masjid_id,
    required this.title,
    required this.description,
    required this.name,
  }) : super(key: key);

  @override
  State<masjidContactUpdate> createState() => _masjidContactUpdate();
}

class _masjidContactUpdate extends State<masjidContactUpdate> {
  var masjid = Masjid();
  _getMasjids() async {
    await ApiServices.fetchForEdit(
      widget.masjid_id,
      'masjid',
    ).whenComplete(() => setState(() {})).then((response) {
      setState(() {
        try {
          //  errorController.text = "";
          // Iterable list = json.decode ( response.body );
          // //print ( response.body );
          // masjids =
          //     list.map ( (model) => Masjid.fromJson ( model ) ).toList ( );
          var masjidBody = json.decode(response.body);
          masjid = Masjid.fromJson(masjidBody);
          // print(masjids[0].Id);
          //  errorController.text="test";
        } on Exception catch (e) {
          // errorController.text = "wow : " + e.toString ( );
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMasjids();
  }

  @override
  Widget build(BuildContext context) {
    //_getMasjids();
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
              color: Colors.black54, blurRadius: 2.0, offset: Offset(0.0, 0.75))
        ],
        // image:const DecorationImage(
        //     image: AssetImage('assets/mosque.png'),
        //     fit:BoxFit.cover
        // ),
        //   //color: appColor.withOpacity(0.5)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
                    // widget.masjid_id.toString()+" "+
                    widget.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appColor),
                  ),
                  //widthSizedBox8,

                  Text(
                    widget.title,
                    style: TextStyle(
                      color: appColor,
                    ),
                  ),
                  // Spacer(),
                  // Text(widget.date),
                ],
              ),
            ),
          ),
          midPadding2,
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          color: appColor,
                        ),
                      ),
                    ),
                    midPadding2,
                  ],
                )),
          ),
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
