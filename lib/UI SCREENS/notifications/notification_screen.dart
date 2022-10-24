import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/chat.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/widgets/search_input.dart';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';

import '../../widgets/genericAppBar.dart';
import '../../widgets/genericDrawer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: genericDrawerForUser(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: genericAppBarForUser(
          isSubScreen: true,
          notificationPress:(){},
          chatPress:() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatPage()));
          },
            txtfield: SearchInput(),
            ),
      ),
      backgroundColor: whiteColor,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('notifications')
          ],
        ),

    );
  }
}
