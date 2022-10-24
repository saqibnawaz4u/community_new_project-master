import 'package:community_new/UI%20SCREENS/credentials/log_in.dart';
import 'package:community_new/widgets/view_profile_widget.dart';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../widgets/listitle_widget.dart';
import '../../widgets/switch_profile_widget.dart';
class ChoosingProfile extends StatefulWidget {
  const ChoosingProfile({Key? key}) : super(key: key);

  @override
  _ChoosingProfileState createState() => _ChoosingProfileState();
}

class _ChoosingProfileState extends State<ChoosingProfile> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
              leading: IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: const Icon(Icons.arrow_back,color: Colors.black,),),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: elevatedbutton(routing: (){},buttonText: "Invite friends", ),
                )
              ],
              backgroundColor: Colors.grey.shade50
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.17,
                  color: Colors.black,
                child: const ViewProfileListTile()
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(children: [
                         const Align(
                               alignment: Alignment.bottomLeft,
                               child:  Text("Switch profiles",
                                 style: TextStyle(color: blackColor,fontWeight: FontWeight.bold),)),
                          midPadding2,
                          SwitchProfileWidget(businessname: "Business Name",
                            subNameOfBusiness: "My Business",
                            routing: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>  const ChoosingProfile()));
                          },),midPadding2,
                          SwitchProfileWidget(businessname: "Masjid Name",
                            subNameOfBusiness: "My Masjid",
                            routing: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) =>  const ChoosingProfile()));
                            },),
                        ],)
                    )),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height ,
              color: backgroundColor,
              child: Column(
                children: const [
                   ListTileInProfileScreen(
                    icon: Icon(
                      Icons.store,
                      color: Colors.black,
                      size: 20.0,
                    ),
                     text: "My Shop",
                  ),
                  ListTileInProfileScreen(
                    icon: Icon(
                      Icons.work,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    text: "My Job Portal",
                  ),
                  ListTileInProfileScreen(
                    icon: Icon(
                      Icons.hotel,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    text: "My Accommodations",
                  ),
                  ListTileInProfileScreen(
                    icon: Icon(
                      Icons.spa,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    text: "My Funeral Requests",
                  ),
                  ListTileInProfileScreen(
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    text: "Add Masjid, Organization, or Business Profile",
                  ),
                  ListTileInProfileScreen(
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    text: "Following",
                  ),
                  ListTileInProfileScreen(
                    icon: Icon(
                      Icons.supervisor_account,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    text: "Followers",
                  ),
                  ListTileInProfileScreen(
                    icon: Icon(
                      Icons.bookmark,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    text: "Saved",
                  ),
                  ListTileInProfileScreen(
                    icon: Icon(
                      Icons.timeline,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    text: "Activity Log",
                  ),
                ],
              )
            )
        ],
            ),
          ),
        ));
  }
}




