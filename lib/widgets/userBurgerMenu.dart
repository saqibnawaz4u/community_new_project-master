import 'package:community_new/UI%20SCREENS/Events_new/Events.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/chat.dart';
import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';

class burgerMenuUser extends StatefulWidget {
  const burgerMenuUser({Key? key}) : super(key: key);

  @override
  State<burgerMenuUser> createState() => _burgerMenuUserState();
}

class _burgerMenuUserState extends State<burgerMenuUser> {
  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ChatPage()));
        break;
      case 1:
        print("chat Clicked");
        break;
      case 2:
        print("User Logged out");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Events()),
                (route) => false);
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(icon: Icon(Icons.more_vert,color: appColor,),
      color: whiteColor,
      itemBuilder: (context) => [
        PopupMenuItem<int>(
            value: 0, child: Text("chat")),
        PopupMenuItem<int>(
            value: 1, child: Text("Privacy Policy page")),
        PopupMenuDivider(),
        PopupMenuItem<int>(
            value: 2,
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 7,
                ),
                Text("Logout")
              ],
            )),
      ],
      onSelected: (item) => SelectedItem(context, item),
    );
  }
}
