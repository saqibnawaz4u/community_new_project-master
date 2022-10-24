// ignore_for_file: unused_import

import 'dart:async';
import 'package:community_new/UI%20SCREENS/Events_new/Events.dart';
import 'package:community_new/UI%20SCREENS/Menues/superUserTab.dart';
import 'package:community_new/aladhan.dart';
import 'package:community_new/provider/FavouriteItemProvider.dart';
import 'package:community_new/provider/searching.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI SCREENS/credentials/log_in.dart';
import 'constants/styles.dart';

//String currentRole='user';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: whiteColor,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarColor: whiteColor,
      //color set to transperent or set your own color
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark
      //set brightness for icons, like dark background light icons
      ));
  // prefs = await SharedPreferences.getInstance();
  // await prefs.setString('role_name', 'SuperAdmin');
  // await prefs.setString('userName', 'admin');
  // await prefs.setInt('userId', 5);
  //
  //
  //  currentRole =//'admin';
  // await prefs.getString ( 'role_name');

  runApp(MyApp());
  //await FlutterSession().set("role_name", "admin");
  // Obtain shared preferences.

// Save an boolean value to 'repeat'
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //   if (currentRole == 'SuperAdmin')
    //   {
    //     return MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       title: 'Community App',
    //       theme: ThemeData(
    //       ),
    //       home: SplashScreenWidget(widget: superUserTab()),
    //
    //     );
    //   }
    //   else if(currentRole=='OrgAdmin')
    //   {
    //     return MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       title: 'Community App',
    //       theme: ThemeData(
    //       ),
    //       //home: OrgAdmin(),
    //         home: SplashScreenWidget(widget: OrgAdminWidget())
    //     );
    //   }
    //   else if(currentRole=='MasjidAdmin')
    //   {
    //     return MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       title: 'Community App',
    //       theme: ThemeData(
    //       ),
    //       home: SplashScreenWidget(widget: MasjidAdminTab()),
    //
    //     );
    //   }
    //   else
    //   {
    //     return MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       title: 'Community App',
    //       theme: ThemeData(
    //       ),
    //       home: SplashScreenWidget(widget: UserHomeTab())
    //
    //     );
    //   }
    //
    // }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavouriteItemProvider()),
        ChangeNotifierProvider(create: (_) => SearchEvents())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Community App',
        theme: ThemeData(
          backgroundColor: const Color(0xFFF5F6F6),
          primaryColor: appColor,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: appColor,
          ),
          textTheme: TextTheme(
            headline1: const TextStyle(
              color: Color(0xFF100E34),
            ),
            bodyText1: TextStyle(
              color: const Color(0xFF100E34).withOpacity(0.5),
            ),
          ),
          // pageTransitionsTheme: PageTransitionsTheme(
          //     builders: {
          //       TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          //       TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          //     }
          // )
        ),
        home: //AdhanScreen(),
        SplashScreenWidget(),
        // const SplashScreenWidget (
        //   loadingText: 'Loading Please wait',
        //   appName: 'Muslim Community',
        //   widget: LogIn(), )
      ),
    );
  }
}

class SplashScreenWidget extends StatefulWidget {
  // final Widget widget;
  // final String? appName;
  // final String? loadingText;
  const SplashScreenWidget({
    Key? key,
    //required this.widget,this.appName,this.loadingText
  }) : super(key: key);

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LogIn())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/logo.png'),
              Container(
                  child: Text(
                'Loading... please wait',
                style: TextStyle(color: appColor),
              )),
              CircularProgressIndicator(
                backgroundColor: whiteColor,
                // backgroundColor: Colors.green.shade400,
                color: appColor,
              )
            ],
          )),
    )
        //   SplashScreen(
        //     seconds: 3,
        //     navigateAfterSeconds:widget.widget,
        //     title:  Text(
        //       widget.appName!,
        //       style:const TextStyle(
        //           fontWeight: FontWeight.bold,
        //           fontSize: 20.0,
        //           color: whiteColor),
        //     ),
        //     loadingText: Text(widget.loadingText!,style: whiteTextStyleNormal,),
        //     image:  Image.asset('assets/community.png'),
        //     photoSize: 100.0,
        //     backgroundColor: appColor,
        //     styleTextUnderTheLoader:  TextStyle(),
        //     loaderColor: whiteColor
        // )
        ;
  }
}






// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:packlist/Contracts/ActivityMainCallback.dart';
// import 'package:packlist/utils/CustomColors.dart';
//
// class BottomBar extends StatefulWidget {
//   ActivityMainCallback _view;
//
//   BottomBar(this._view);
//
//   @override
//   _BottomBarState createState() => _BottomBarState(_view);
// }
//
// class _BottomBarState extends State<BottomBar> {
//   ActivityMainCallback _view;
//
//   _BottomBarState(this._view);
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       color: CustomColors.lightBlue,
//       shape: AutomaticNotchedShape(
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.filter_list,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               _view.onFilterClicked();
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.search,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               _view.onSearchClicked();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }