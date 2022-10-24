import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../UI SCREENS/create_accomodation/screens/home/chat.dart';
import '../UI SCREENS/create_accomodation/widgets/search_input.dart';
import '../UI SCREENS/notifications/notification_screen.dart';
import '../constants/styles.dart';

class genericAppBarForUser extends StatefulWidget {
  final TabBar? bottom;
  final VoidCallback notificationPress, chatPress;
  final Widget txtfield;
  final bool isSubScreen;
  const genericAppBarForUser(
      {Key? key,
      this.bottom,
      required this.isSubScreen,
      required this.txtfield,
      required this.chatPress,
      required this.notificationPress})
      : super(key: key);

  @override
  State<genericAppBarForUser> createState() => _genericAppBarForUserState();
}

class _genericAppBarForUserState extends State<genericAppBarForUser> {
  bool _isPressed = false;

  // This function is called when the button gets pressed
  void _myCallback() {
    setState(() {
      _isPressed = true;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => NotificationScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      bottom: widget.bottom,
      title: widget.txtfield,
      elevation: 0,
      backgroundColor: whiteColor, //appColor,
      automaticallyImplyLeading: false,
      leading: widget.isSubScreen == true
          ? IconButton(
              icon: Icon(
                CupertinoIcons.chevron_back,
                color: appColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : Builder(
              builder: (context) => IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/menu.svg',
                  color: appColor,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
      // leading: Padding(
      //   padding:const EdgeInsets.only(left: 8.0),
      //   child: IconButton(
      //     onPressed: (){},
      //     icon:const Icon(Icons.search,color: whiteColor),
      //   ),
      // ),
      // title:  RichText(
      //     text: TextSpan(
      //         children: <TextSpan>[
      //           TextSpan(
      //               text: 'Welcome back\n',style: greyTextStyleNormal
      //           ),
      //           TextSpan(
      //               text: currentUserName.toString(),
      //               style: appcolorTextStylebold
      //           )
      //         ]
      //     )),
      actions: [
        // IconButton(
        //     onPressed: () =>
        //         Navigator.of(context)
        //         .push(MaterialPageRoute(builder: (_) => const SearchPage())),
        //     icon:  Icon(Icons.search,color:appColor ,)),

        IconButton(
            onPressed: widget.notificationPress,

            // {
            //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NotificationScreen()));
            // },
            icon: Icon(
              MdiIcons.bell,
              color: appColor,
              size: 20,
            )),

        Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: widget.chatPress,
                icon: Icon(
                  MdiIcons.message,
                  color: appColor,
                  size: 20,
                ))),
      ],
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    bool isClicked = true;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appColor,
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                cursorColor: appColor,
                controller: controller,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: isClicked == true ? appColor : Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      color: isClicked == true ? appColor : Colors.grey,
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          isClicked = !isClicked;
                        });
                        controller.clear();
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
              ),
            ),
          )),
    );
  }
}

class genericAppBarForSA extends StatefulWidget {
  final String? appbarTitle;
  final PreferredSizeWidget? bottom;
  const genericAppBarForSA({Key? key, this.appbarTitle, this.bottom})
      : super(key: key);

  @override
  State<genericAppBarForSA> createState() => _genericAppBarForSAState();
}

class _genericAppBarForSAState extends State<genericAppBarForSA> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      bottom: widget.bottom,
      title: Text(
        widget.appbarTitle.toString(),
        style: TextStyle(color: appColor),
      ),
      elevation: 0,
      backgroundColor: whiteColor, //appColor,
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: SvgPicture.asset(
            'assets/icons/menu.svg',
            color: appColor,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }
}
