import 'package:community_new/UI%20SCREENS/create_accomodation/widgets/search_input.dart';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../models/chatUsersModel.dart..dart';
import '../../../../widgets/genericAppBar.dart';
import '../../../../widgets/genericDrawer.dart';
import '../../../notifications/notification_screen.dart';
import 'chatDetail.dart';
import 'conversationList.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(name: "Jane Russel", messageText: "Awesome Setup", imageURL: "assets/bilalmasjid.png", time: "Now"),
    ChatUsers(name: "Glady's Murphy", messageText: "That's Great", imageURL: "assets/community.png", time: "Yesterday"),
    ChatUsers(name: "Jorge Henry", messageText: "Hey where are you?", imageURL: "assets/community.png", time: "31 Mar"),
    ChatUsers(name: "Philip Fox", messageText: "Busy! Call me in 20 mins", imageURL: "assets/greenph.png", time: "28 Mar"),
    ChatUsers(name: "Debra Hawkins", messageText: "Thankyou, It's awesome", imageURL: "assets/mosque.png", time: "23 Mar"),
    ChatUsers(name: "Jacob Pena", messageText: "will update you in evening", imageURL: "assets/nwsc.png", time: "17 Mar"),
    ChatUsers(name: "Andrey Jones", messageText: "Can you please share the file?", imageURL: "assets/placeholder.png", time: "24 Feb"),
    ChatUsers(name: "John Wick", messageText: "How are you?", imageURL: "assets/user.png", time: "18 Feb"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: genericDrawerForUser(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: genericAppBarForUser( isSubScreen: true,
            notificationPress:(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NotificationScreen()));
            },
            chatPress:(){},
            txtfield:SizedBox(
              height: 40,
              child: Theme(
                data: ThemeData(
                  colorScheme: ThemeData().colorScheme.copyWith(
                    primary: appColor,
                  ),
                ),
                child: TextFormField(
                  // onChanged: (value) => _runFilter(value),
                  // controller: _controller,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    contentPadding: EdgeInsets.all(0),
                    // fillColor: whiteColor,
                    // filled: true,
                    hintText: 'Search here...',
                    prefixIconColor: appColor,
                    suffixIconColor: appColor,
                    prefixIcon: Icon(Icons.search,color: appColor,),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.filter_alt_outlined,color: appColor,),
                    ),

                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
           ),
      ),
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SafeArea(
            //   child: Padding(
            //     padding: EdgeInsets.only(left: 16,right: 16,top: 18),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         Text("Conversations",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
            //         Container(
            //           padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
            //           height: 30,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(30),
            //             color: Colors.pink[50],
            //           ),
            //           child: Row(
            //             children: <Widget>[
            //               Icon(Icons.add,color: Colors.pink,size: 20,),
            //               SizedBox(width: 2,),
            //               Text("Add New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            //             ],
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),


            // Padding(
            //   padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       // fillColor: Colors.white,
            //       //filled: true,
            //       border: OutlineInputBorder(
            //
            //         //borderSide: BorderSide.none,
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       hintText: 'Search here...',
            //       prefixIcon: Container(
            //         padding: const EdgeInsets.all(15),
            //         child: SvgPicture.asset('assets/icons/search.svg'),
            //       ),
            //       contentPadding: const EdgeInsets.all(2),
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ChatDetailPage();
                }));
              },
              child: ListView.builder(
                itemCount: chatUsers.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return ConversationList(
                    name: chatUsers[index].name,
                    messageText: chatUsers[index].messageText,
                    imageUrl: chatUsers[index].imageURL,
                    time: chatUsers[index].time,
                    isMessageRead: (index == 0 || index == 3)?true:false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}