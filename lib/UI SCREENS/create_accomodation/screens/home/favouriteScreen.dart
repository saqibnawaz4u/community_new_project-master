import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';

class favouriteScreen extends StatefulWidget {
  const favouriteScreen({Key? key}) : super(key: key);

  @override
  State<favouriteScreen> createState() => _favouriteScreenState();
}

class _favouriteScreenState extends State<favouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          Center(
            child: Text('ok',style: TextStyle(color: blackColor,fontSize: 25),),
          )
        ],
      ),
    );
  }
}
