import 'package:carousel_slider/carousel_slider.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/screens/home/filterList.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/widgets/buttons.dart';
import 'package:community_new/UI%20SCREENS/create_accomodation/widgets/customRow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/styles.dart';

class FilterDetails extends StatefulWidget {
  final String? title, description, location;
  final String? forRentBy,
      petFriendly,
      furnished,
      laundryInUnit,
      laundryInBuilding,
      dishwasher,
      fridge,
      airCondition,
      yard,
      balcony,
      smoking,
      barrier,
      visualAids,
      accessible,
      hydro,
      heat,
      water,
      cable,
      internet,
      parking,
      adType;
  final int? price;
  final int? size;
  const FilterDetails({
    this.accessible,
    this.adType,
    this.airCondition,
    this.balcony,
    this.barrier,
    this.cable,
    this.description,
    this.dishwasher,
    this.forRentBy,
    this.fridge,
    this.furnished,
    this.heat,
    this.hydro,
    this.internet,
    this.laundryInBuilding,
    this.laundryInUnit,
    this.location,
    this.parking,
    this.petFriendly,
    this.price,
    this.size,
    this.smoking,
    this.title,
    this.visualAids,
    this.water,
    this.yard,
    super.key,
  });

  @override
  State<FilterDetails> createState() => _FilterDetailsState();
}

class _FilterDetailsState extends State<FilterDetails>
    with SingleTickerProviderStateMixin {
  ScrollController? scrollController;

  TabController? _tabController;
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 4, vsync: this);
    _tabController!.addListener(_handleTabIndex);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 400,
                  child: Stack(
                    children: [
                      CarouselSlider(
                          options: CarouselOptions(
                            height: 400,
                            enableInfiniteScroll: false,
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,

                            // autoPlay: false,
                          ),
                          items: [
                            Image.asset(
                              'assets/images/offer01.jpeg',
                              fit: BoxFit.fill,
                              height: double.infinity,
                            ),
                            Image.asset(
                              'assets/images/offer01.jpeg',
                              fit: BoxFit.fill,
                              height: double.infinity,
                            ),
                            Image.asset(
                              'assets/images/offer01.jpeg',
                              fit: BoxFit.fill,
                              height: double.infinity,
                            ),
                            // Image.asset(
                            //   'assets/bilalmasjid.png',
                            //   fit: BoxFit.fill,
                            //   height: double.infinity,
                            // ),
                            // Image.asset(
                            //   'assets/bilalmasjid.png',
                            //   fit: BoxFit.fill,
                            //   height: double.infinity,
                            // ),
                            // Image.asset(
                            //   'assets/bilalmasjid.png',
                            //   fit: BoxFit.fill,
                            //   height: double.infinity,
                            // ),
                          ]),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                // onTap: () => Navigator.of(context)
                                //     .push(MaterialPageRoute(
                                //   builder: (
                                //     context,
                                //   ) =>
                                //       // FilterList(),
                                // )),
                                child: Icon(
                                  Icons.arrow_back_ios_new_sharp,
                                  size: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.ios_share,
                                color: Colors.white,
                              )
                              // Container(
                              //   height: 25,
                              //   width: 25,
                              //   padding: const EdgeInsets.all(6),
                              //   decoration: BoxDecoration(
                              //     color: appColor,
                              //     shape: BoxShape.circle,
                              //   ),
                              //   child: SvgPicture.asset('assets/icons/mark.svg'),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // DetailsAppBar(house: house),
                Column(
                  children: [
                    Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        widget.title!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.favorite_border,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //ContentIntro(house: house),
                          // const SizedBox(height: 20),
                          // const HouseInfo(),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${widget.price!}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: appColor,
                                      size: 20,
                                    ),
                                    Text(
                                      'Kohat',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize: 10,
                                            color: appColor,
                                          ),
                                    ),
                                  ],
                                ),
                                // SizedBox(
                                //   height: 5.0,
                                // ),
                                // Row(
                                //   children: [
                                //     SizedBox(
                                //       width: 20.0,
                                //     ),
                                //     Text(
                                //       'KDA Gate 2 Kohat',
                                //       style: Theme.of(context)
                                //           .textTheme
                                //           .bodyText1!
                                //           .copyWith(
                                //             fontSize: 10,
                                //             color: blackColor,
                                //           ),
                                //     ),
                                //   ],
                                // ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/bilalmasjid.png'),
                        ),
                        title: RichText(
                          text: TextSpan(
                            text: 'Community User ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                            ),
                            children: const <TextSpan>[
                              TextSpan(
                                  text: '(1 listing)',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          'MEMBER SINCE 2008',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.description!,
                          style: TextStyle(
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                    _tabSection(
                      context,
                      _tabController!,
                      widget.adType,
                      widget.accessible,
                      widget.airCondition,
                      widget.balcony,
                      widget.barrier,
                      widget.cable,
                      widget.dishwasher,
                      widget.forRentBy,
                      widget.fridge,
                      widget.furnished,
                      widget.heat,
                      widget.hydro,
                      widget.internet,
                      widget.parking,
                      widget.petFriendly,
                      widget.smoking,
                      widget.visualAids,
                      widget.water,
                      widget.yard,
                      widget.size,
                    ),
                    // DefaultTabController(
                    //   length: 4,
                    //   child: Card(
                    //       elevation: 5,
                    //       child: Column(
                    //         children: [

                    //           Expanded(
                    //             child: new      ),
                    //         ],
                    //       )),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                // NestedTabBar(nestedTabbarView: [
                //   Form(key: formKeys[0], child: Container()),
                //   Form(key: formKeys[1], child: Container()),
                // ], frmNested: _form, tabbarbarLength: 2)
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // decoration: BoxDecoration(
              //   boxShadow: [
              //     new BoxShadow(
              //       color: Colors.black,
              //       // blurRadius: 0.1,
              //     ),
              //   ],
              // ),
              height: 80,
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: customCallBtn(() {}, 'Call'),
                      ),
                      Expanded(
                        child: customEmailBtn(() {}, "Chat"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

Widget _tabSection(
  BuildContext context,
  TabController _tabController,
  String? forRentBy,
  petFriendly,
  furnished,
  dishwasher,
  fridge,
  airCondition,
  yard,
  balcony,
  smoking,
  barrier,
  visualAids,
  hydro,
  heat,
  water,
  cable,
  internet,
  parking,
  accessible,
  adType,
  int? size,
) {
  // TabController? _tabController;
  return DefaultTabController(
    length: 4,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          // color: Color(0xffFFEFCD),
          // margin: EdgeInsets.only(
          //   top: 5.0,
          // ),
          child: TabBar(
            labelPadding: EdgeInsets.symmetric(horizontal: 5),
            isScrollable: true,
            controller: _tabController,
            labelColor: appColor,
            unselectedLabelColor: Colors.black26,
            indicatorColor: whiteColor,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              _tabController.index == 0
                  ? Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffd08e63),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Overview',
                        style: TextStyle(
                          color: whiteColor,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2.0,
                              offset: Offset(0.0, 0.75))
                        ],
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Overview',
                        style: TextStyle(
                          color: Color(0xff93573c),
                        ),
                      ),
                    ),

              _tabController.index == 1
                  ? Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffd08e63),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'The Unit',
                        style: TextStyle(
                          color: whiteColor,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2.0,
                              offset: Offset(0.0, 0.75))
                        ],
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'The Unit',
                        style: TextStyle(
                          color: Color(0xff93573c),
                        ),
                      ),
                    ),

              _tabController.index == 2
                  ? Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffd08e63),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'The Building',
                        style: TextStyle(
                          color: whiteColor,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2.0,
                              offset: Offset(0.0, 0.75))
                        ],
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'The Building',
                        style: TextStyle(
                          color: Color(0xff93573c),
                        ),
                      ),
                    ),
              _tabController.index == 3
                  ? Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffd08e63),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Accessibility',
                        style: TextStyle(
                          color: whiteColor,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 2.0,
                              offset: Offset(0.0, 0.75))
                        ],
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Accessibility',
                        style: TextStyle(
                          color: Color(0xff93573c),
                        ),
                      ),
                    ),

              // Tab(
              //   text: "Overview",
              // ),
              // Tab(text: "The Unit"),
              // Tab(text: "The Building"),
              // Tab(
              //   text: 'Accessibility',
              // ),
              // Tab(
              //   text: 'Ramadan Times',
              // ),
              // Tab(
              //   text: 'Eid Timings',
              // )
            ],
          ),
        ),
        Container(
          // color: Color(0xfffff),
          //Add this to give height
          height: MediaQuery.of(context).size.height / 2,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Overview',
                        style: BlackTextStyleBold18,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.house,
                        iconcolor: textColor,
                        text: 'Unit Type',
                        size: 20.0,
                        textColor: Colors.grey,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text('Apartment'),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.bedroom_baby,
                        text: 'Bedrooms',
                        size: 20.0,
                        textColor: Colors.grey,
                        iconcolor: textColor,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text('3'),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.bathroom,
                        iconcolor: textColor,
                        text: 'Bathrooms',
                        textColor: Colors.grey,
                        size: 20.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text('2.5'),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.heat_pump,
                        text: 'Utilities Included',
                        textColor: Colors.grey,
                        iconcolor: textColor,
                        size: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.check,
                              iconcolor: appColor,
                              text: hydro,
                              textColor: blackColor,
                              size: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.check,
                              iconcolor: appColor,
                              text: heat,
                              textColor: blackColor,
                              size: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.check,
                              iconcolor: appColor,
                              text: water,
                              textColor: blackColor,
                              size: 10.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.file_copy_outlined,
                        text: 'Also Included',
                        textColor: Colors.grey,
                        iconcolor: textColor,
                        size: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.clear,
                              iconcolor: Colors.red,
                              text: cable,
                              textColor: Colors.grey,
                              size: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.check,
                              iconcolor: appColor,
                              text: internet,
                              textColor: blackColor,
                              size: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.local_parking,
                        iconcolor: textColor,
                        text: 'Parking Included',
                        textColor: Colors.grey,
                        size: 20.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text(parking),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.lock_clock,
                        iconcolor: textColor,
                        text: 'Agreement Type',
                        textColor: Colors.grey,
                        size: 20.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text('1 Year'),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.calendar_month,
                        iconcolor: textColor,
                        text: 'Move-In Date',
                        textColor: Colors.grey,
                        size: 20.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text('1-Nov-2022'),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.pets,
                        iconcolor: textColor,
                        text: 'Pet Friendly',
                        textColor: Colors.grey,
                        size: 20.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text(petFriendly),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.local_offer_outlined,
                        iconcolor: textColor,
                        text: 'For Rent By',
                        textColor: Colors.grey,
                        size: 20.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text(petFriendly),
                      ),
                      SizedBox(
                        height: 70.0,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'The Unit',
                        style: BlackTextStyleBold18,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.square_foot,
                        iconcolor: textColor,
                        text: 'Size (sqft)',
                        size: 20.0,
                        textColor: Colors.grey,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text(size.toString()),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.chair_alt_outlined,
                        text: 'Funished',
                        size: 20.0,
                        textColor: Colors.grey,
                        iconcolor: textColor,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text(furnished),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.card_travel,
                        iconcolor: textColor,
                        text: 'Appliances',
                        textColor: Colors.grey,
                        size: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.check,
                              iconcolor: appColor,
                              text: 'Laundry (In Unit)',
                              textColor: blackColor,
                              size: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.clear,
                              iconcolor: Colors.red,
                              text: 'Laundry (In Building)',
                              textColor: Colors.grey,
                              size: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.check,
                              iconcolor: appColor,
                              text: dishwasher,
                              textColor: blackColor,
                              size: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.check,
                              iconcolor: appColor,
                              text: fridge,
                              textColor: blackColor,
                              size: 10.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.flood,
                        text: 'Air Conditioning',
                        textColor: Colors.grey,
                        iconcolor: textColor,
                        size: 20.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text(airCondition),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.file_copy_outlined,
                        text: 'Personal Outdoor Space',
                        textColor: Colors.grey,
                        iconcolor: textColor,
                        size: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.check,
                              iconcolor: appColor,
                              text: yard,
                              textColor: Colors.grey,
                              size: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.check,
                              iconcolor: appColor,
                              text: balcony,
                              textColor: blackColor,
                              size: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.smoking_rooms_outlined,
                        iconcolor: textColor,
                        text: 'Smoking Permitted',
                        textColor: Colors.grey,
                        size: 20.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text(smoking),
                      ),
                      SizedBox(
                        height: 70.0,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'The Building',
                        style: BlackTextStyleNormal16,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.card_travel,
                        iconcolor: textColor,
                        text: 'Appliances',
                        textColor: Colors.grey,
                        size: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.clear,
                              iconcolor: Colors.red,
                              text: 'Gym',
                              textColor: Colors.grey,
                              size: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.clear,
                              iconcolor: Colors.red,
                              text: 'Pool',
                              textColor: Colors.grey,
                              size: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.clear,
                              iconcolor: Colors.red,
                              text: 'Concierge',
                              textColor: Colors.grey,
                              size: 10.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            customRow(
                              icon: Icons.clear,
                              iconcolor: Colors.red,
                              text: '24 Hour Security',
                              textColor: Colors.grey,
                              size: 10.0,
                            ),
                            customRow(
                              icon: Icons.clear,
                              iconcolor: Colors.red,
                              text: 'Bicycle Parking',
                              textColor: Colors.grey,
                              size: 10.0,
                            ),
                            customRow(
                              icon: Icons.clear,
                              iconcolor: Colors.red,
                              text: 'Storage Space',
                              textColor: Colors.grey,
                              size: 10.0,
                            ),
                            customRow(
                              icon: Icons.clear,
                              iconcolor: Colors.red,
                              text: 'Elevator in Building',
                              textColor: Colors.grey,
                              size: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Accessibility',
                        style: BlackTextStyleNormal16,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.smoking_rooms_outlined,
                        iconcolor: textColor,
                        text: 'Barrier-free Entrance and Ramps',
                        textColor: Colors.grey,
                        size: 20.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text(barrier),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.smoking_rooms_outlined,
                        iconcolor: textColor,
                        text: 'Visual Aids',
                        textColor: Colors.grey,
                        size: 20.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text(visualAids),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      customRow(
                        icon: Icons.smoking_rooms_outlined,
                        iconcolor: textColor,
                        text: 'Accessible Washrooms in Suite',
                        textColor: Colors.grey,
                        size: 20.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                        ),
                        child: Text(accessible),
                      ),
                    ],
                  ),
                ),
              ),
              // new TabScreen("Detail"),
              // new TabScreen("Address"),
              // new TabScreen("Earning"),
            ],
          ),
        ),
      ],
    ),
  );
}
