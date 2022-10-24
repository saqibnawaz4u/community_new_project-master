import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/house.dart';
import '../screens/details/details.dart';
import '../screens/home/favouriteScreen.dart';
import 'circle_icon_button.dart';


class RecommendedHouse extends StatefulWidget {

  RecommendedHouse({Key? key}) : super(key: key);

  @override
  State<RecommendedHouse> createState() => _RecommendedHouseState();
}

class _RecommendedHouseState extends State<RecommendedHouse> {
  final recommendedList = House.generateRecommended();

  _handleNavigateToDetails(BuildContext context, House house) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Details(house: house),
      ),
    );
  }

  bool _favStatus=false;

  void checkFavStatus(String name)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var boolValue = prefs.getBool(name);
    if(boolValue==null||boolValue==false){
      _favStatus=false;
    }
    else{
      _favStatus=true;
    }
  }

   setFav(String name,bool _currentFavStatus) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(name,!_currentFavStatus);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        height: 340,
        child:ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) =>
              GestureDetector(
            onTap: () =>
                _handleNavigateToDetails(context, recommendedList[index]),
            child: Container(
              height: 300,
              width: 230,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          recommendedList[index].imageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 15,
                    child: GestureDetector(
                      onTap: (){
                        ScaffoldMessenger.of(
                            context)
                            .showSnackBar(SnackBar(
                            duration:
                            Duration(
                                seconds:
                                1),
                            content: Text(recommendedList[index].name+' added to list')));
                        setFav(recommendedList[index].name,_favStatus);
                        },
                      child: Container(
                        width: 22,height: 22,
                        child: CircleIconButton(
                          iconUrl: 'assets/icons/mark.svg',
                          color:_favStatus==true?Colors.amber: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.white54,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recommendedList[index].name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                recommendedList[index].address,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Container(
                           height: 22,width: 22,
                            child: CircleIconButton(
                              iconUrl: 'assets/icons/mark.svg',
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          separatorBuilder: (_, index) => const SizedBox(width: 20),
          itemCount: recommendedList.length,
        ),
      ),
    );
  }
}
