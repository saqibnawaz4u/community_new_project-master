import 'package:flutter/material.dart';

import '../../../constants/styles.dart';

class SwitchProfileWidget extends StatelessWidget {
  const SwitchProfileWidget({Key? key,required this.routing,
    required this.businessname,required this.subNameOfBusiness}) : super(key: key);
  final VoidCallback routing;
  final String businessname;
  final String subNameOfBusiness;
  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: IconButton(onPressed: (){
              routing();
            },
                icon: const Icon(Icons.person,color: Colors.black,)),),
          widthSizedBox8,
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(businessname,style: BlackTextStyleNormal,),

                  ],),
                Align(
                  alignment: Alignment.bottomLeft,
                  child:Text(subNameOfBusiness,style:greyTextStyleNormal),
                ),
              ]
          ),

        ],
      ),
    );
  }
}