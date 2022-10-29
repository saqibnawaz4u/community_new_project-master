import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/postDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constants/styles.dart';

class BedroomsScreen extends StatefulWidget {
  final bool? isNew;
  const BedroomsScreen({
    super.key,
    this.isNew,
  });

  @override
  State<BedroomsScreen> createState() => _BedroomsScreenState();
}

class _BedroomsScreenState extends State<BedroomsScreen> {
  List<String> bedrooms = [
    '1',
    '1+Den',
    '2',
    '2+Den',
    '3',
    '3+Den',
    '4',
    '4+Den',
    '5+'
  ];
  showAlertDialog(BuildContext context) {
    // Create button
    Widget yesButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.of(context, rootNavigator: true).pop(false);
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => AccommodationPosting()));
        },
        child: Text(
          'yes',
          style: TextStyle(color: appColor),
        ));
    Widget noButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop(false);
        },
        child: Text(
          'no',
          style: TextStyle(color: appColor),
        ));

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text("Alert"),
      content: Text("Are you sure you want to go back?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          color: appColor,
          onPressed: () {
            showAlertDialog(context);
          },
          icon: Icon(CupertinoIcons.chevron_back),
        ),
        backgroundColor: whiteColor,
        title: widget.isNew == false
            ? Text(
                "Edit",
                style: TextStyle(fontSize: 20, color: appColor),
              )
            : Text(
                "UnitType",
                style: TextStyle(fontSize: 20, color: appColor),
              ),
      ),
      body: Container(
        padding: EdgeInsets.all(
          10.0,
        ),
        child: Column(
          children: [
            // SizedBox(
            //   height: 20.0,
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                // border: Border(
                //   bottom: BorderSide(
                //     color: Colors.grey,
                //     width: 1,
                //   ),
                // ),
                borderRadius: BorderRadius.circular(30.0),
                color: Color(0xffddc2ae),
              ),
              padding: EdgeInsets.only(
                top: 15.0,
                bottom: 10,
                left: 20,
              ),
              child: Text(
                'Select Manually',
                style: TextStyle(color: textColor),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                  itemCount: bedrooms.length,
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostingDetails(
                                          isNew: true,
                                          bedrooms: bedrooms[index],
                                        )));
                          },
                          title: Text(
                            bedrooms[index],
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
