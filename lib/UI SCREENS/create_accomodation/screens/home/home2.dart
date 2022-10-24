import 'dart:convert';

import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/searchFilter.dart';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/accommodationPosting.dart';
import 'package:community_new/widgets/genericAppBar.dart';
import 'package:community_new/widgets/genericDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../api_services/api_services.dart';
import '../../../notifications/notification_screen.dart';
import '../../widgets/best_offer.dart';
import '../../widgets/categories.dart';
import '../../widgets/circle_icon_button.dart';
import '../../widgets/recommended_house.dart';
import '../../widgets/search_input.dart';
import '../../widgets/welcome_text.dart';
import '../postAccomodation.dart';
import 'chat.dart';

class home2 extends StatefulWidget {
  const home2({Key? key}) : super(key: key);

  @override
  State<home2> createState() => _home2State();
}

class _home2State extends State<home2> {
  List<AccommodationPosting> accomudationPost = [];
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text(
                  'No',
                  style: TextStyle(color: appColor),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(), // <-- SEE HERE
                child: new Text(
                  'Yes',
                  style: TextStyle(color: appColor),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  List<AccommodationPosting> getaccPosting = [];

  _getaccommodation() async {
    {
      ApiServices.fetch(
        'accommodationposting',
      ) //current user id will pass here
          .then((response) {
        setState(() {
          try {
            Iterable list = json.decode(response.body);
            //print ( response.body );
            accomudationPost = list
                .map((model) => AccommodationPosting.fromJson(model))
                .toList();
            // print(masjids[0].Id);
            //  .text="test";
          } on Exception catch (e) {}
        });
      });
    }
  }

  List<AccommodationPosting> copiedAcc = [];
  void _runFilter(String enteredKeyword) async {
    List<AccommodationPosting> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = await accomudationPost;
    } else {
      results = await accomudationPost
          .where((accpost) => accpost.description!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      copiedAcc = results;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _getaccommodation();
    copiedAcc = accomudationPost;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: genericDrawerForUser(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: genericAppBarForUser(
            isSubScreen: false,
            notificationPress: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotificationScreen()));
            },
            chatPress: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ChatPage()));
            },
            txtfield: SearchInput(
              onChanged: (value) => _runFilter(value!),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: appColor,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PostAccommodation(
                      isNew: true,
                      accId: 0,
                    )));
          },
        ),
        backgroundColor: whiteColor,
        body: Theme(
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                midPadding2, midPadding2,
                //WelcomeText(),
                //const SearchInput(),
                // const Categories(),
                //RecommendedHouse(),

                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: copiedAcc.isEmpty
                      ? accomudationPost.length
                      : copiedAcc.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PostAccommodation(
                                  isNew: false,
                                  accId: accomudationPost[index].id,
                                )));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/offer01.jpeg'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    copiedAcc.isEmpty
                                        ? Text(
                                            accomudationPost[index]
                                                .forRentBy
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          )
                                        : Text(
                                            copiedAcc[index]
                                                .forRentBy
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                    const SizedBox(height: 10),
                                    copiedAcc.isEmpty
                                        ? Text(
                                            accomudationPost[index]
                                                .location
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  fontSize: 14,
                                                ),
                                          )
                                        : Text(
                                            copiedAcc[index]
                                                .location
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  fontSize: 14,
                                                ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                                right: 0,
                                child: CircleIconButton(
                                  iconUrl: 'assets/icons/heart.svg',
                                  color: Colors.grey,
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // BestOffer(
                //   runFilter: _runFilter(),
                // ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
