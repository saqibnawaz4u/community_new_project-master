import 'package:community_new/UI%20SCREENS/Menues/MasjidAdmin.dart';
import 'package:community_new/UI%20SCREENS/Menues/superUserTab.dart';
import 'package:community_new/UI%20SCREENS/credentials/log_in.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_services/api_services.dart';
import '../../constants/styles.dart';
import '../../models/user.dart';
import '../Menues/UserHomeTab.dart';
import '../Menues/orgAdmin.dart';

class LottieAnimation extends StatefulWidget {
  final Widget classname;
  const LottieAnimation({required this.classname});

  @override
  _LottieAnimationState createState() => _LottieAnimationState();
}

class _LottieAnimationState extends State<LottieAnimation>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: (3)),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Lottie.asset(
        'assets/login.json',
        controller: _controller,
        height: MediaQuery.of(context).size.height * 1,
        animate: true,
        onLoaded: (composition) {
          _controller!
            ..duration = composition.duration
            ..forward().whenComplete(() => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => widget.classname),
            ));
        },
      ),
    );
  }
}
