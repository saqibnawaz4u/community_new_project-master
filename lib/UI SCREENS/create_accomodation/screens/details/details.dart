import 'package:flutter/material.dart';

import '../../../../constants/styles.dart';
import '../../models/house.dart';
import '../../widgets/about.dart';
import '../../widgets/content_intro.dart';
import '../../widgets/details_app_bar.dart';
import '../../widgets/house_info.dart';


class Details extends StatelessWidget {
  final House house;
  const Details({
    Key? key,
    required this.house,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
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
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailsAppBar(house: house),
              const SizedBox(height: 20),
              ContentIntro(house: house),
              const SizedBox(height: 20),
              const HouseInfo(),
              const SizedBox(height: 20),
              const About(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    primary: appColor,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
