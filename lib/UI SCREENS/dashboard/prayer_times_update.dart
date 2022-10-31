import 'dart:convert';

import 'package:community_new/UI%20SCREENS/Menues/constantMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api_services/api_services.dart';
import '../../constants/styles.dart';
import '../../models/RSS.dart';
import '../../models/masjid.dart';

class PrayerTimesAdd extends StatefulWidget {
  final Widget prayertimes;
  final int masjid_id;
  final String title, description;
  final String name;
  const PrayerTimesAdd({
    Key? key,
    required this.prayertimes,
    required this.masjid_id,
    required this.title,
    required this.description,
    required this.name,
  }) : super(key: key);

  @override
  State<PrayerTimesAdd> createState() => _PrayerTimesAddState();
}

class _PrayerTimesAddState extends State<PrayerTimesAdd> {
  var masjid = Masjid();

  _getMasjids() async {
    await ApiServices.fetchForEdit(
      widget.masjid_id,
      'masjid',
    ).then((response) {
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
                    masjid.Name.toString() + ' ',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                (widget.description).substring(24, 36),
                                style: TextStyle(
                                  color: appColor,
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            children: [
                              Text(
                                'OLD',
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text((widget.description).substring(48, 52)),
                            ],
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            children: [
                              Text(
                                'NEW',
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text((widget.description).substring(54, 61)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    midPadding2,
                    widget.prayertimes,
                  ],
                )
                // Text('Fajar: 4:40AM, Zuhar: 1:30PM, Asr: 5:30PM, Maghrib: 7:20PM, Isha:9:20PM')
                // Row(
                //   children: [
                //     Card(
                //         color: LightBlueColor,
                //         child: Padding(
                //           padding: const EdgeInsets.all(3.0),
                //           child: Text('\t\t\t\tFajr\n'+masjid.Fajr.toString()+' AM',style: TextStyle(
                //             color: blueColor
                //           ),),
                //         )),
                //     Card(
                //         color: LightBlueColor,
                //         child: Padding(
                //           padding: const EdgeInsets.all(3.0),
                //           child: Text('\t\t\t\tDuhr\n'+masjid.Duhr.toString()+' PM',style: TextStyle(
                //               color: blueColor
                //           ),),
                //         )),
                //     Card(
                //         color: LightBlueColor,
                //         child: Padding(
                //           padding: const EdgeInsets.all(3.0),
                //           child: Text('\t\t\t\t\tAsr\n'+masjid.Asr.toString()+' PM',style: TextStyle(
                //               color: blueColor
                //           ),),
                //         )),
                //     Card(
                //         color: LightBlueColor,
                //         child: Padding(
                //           padding: const EdgeInsets.all(3.0),
                //           child: Text('\tMaghrib\n'+masjid.Maghrib.toString()+' PM',style: TextStyle(
                //               color: blueColor
                //           ),),
                //         )),
                //     Card(
                //         color: LightBlueColor,
                //         child: Padding(
                //           padding: const EdgeInsets.all(3.0),
                //           child: Text('\t\t\t\tIsha\n'+masjid.Isha.toString()+' PM',style: TextStyle(
                //               color: blueColor
                //           ),),
                //         )),
                // ],),
                ),
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     salahTimes(
          //       prayerTimes: Text(masjids[index].Fajr.toString()),
          //       PrayerLetter: 'F',),
          //     salahTimes(
          //       prayerTimes:  Text(masjids[index].Duhr.toString()),
          //       PrayerLetter: 'Z',),
          //     salahTimes(
          //       prayerTimes: Text(masjids[index].Asr.toString()),
          //       PrayerLetter: 'A',),
          //     salahTimes(
          //       prayerTimes:  Text(masjids[index].Maghrib.toString()),
          //       PrayerLetter: 'M',),
          //     salahTimes(
          //       prayerTimes:  Text(masjids[index].Isha.toString()),
          //       PrayerLetter: 'I',)
          //   ],)
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
