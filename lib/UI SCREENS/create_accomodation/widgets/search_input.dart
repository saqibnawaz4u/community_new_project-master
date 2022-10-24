import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/styles.dart';
import '../screens/home/searchFilter.dart';

class SearchInput extends StatelessWidget {
  final bool? isPrayerTime;
  final void Function(String?)? onChanged;
  const SearchInput({
    Key? key,
    this.isPrayerTime,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        onChanged: onChanged!,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColor),
          ),
          // fillColor: Colors.white,
          //filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: appColor),
            //borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: 'Search here...',
          suffixIcon: isPrayerTime == true
              ? IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.tune,
                    color: appColor,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchFilter(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.tune,
                    color: appColor,
                  ),
                ),
          prefixIcon: Icon(
            Icons.search,

            color: appColor,

          ),
          // Container(
          //   padding: const EdgeInsets.all(12),
          //   child: SvgPicture.asset('assets/icons/search.svg', color: appColor),
          // ),
          contentPadding: const EdgeInsets.all(2),
        ),
      ),
    );
  }
}
