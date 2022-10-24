import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';

class ElevatedButtonWidgetBlue extends StatefulWidget {
  const ElevatedButtonWidgetBlue({Key? key,required this.buttonText,required this.routing}) : super(key: key);
  final String buttonText;
  final VoidCallback routing;

  @override
  State<ElevatedButtonWidgetBlue> createState() => _ElevatedButtonWidgetBlueState();
}
class _ElevatedButtonWidgetBlueState extends State<ElevatedButtonWidgetBlue> {
  bool _selectedColor =false;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width/4,
      height: MediaQuery.of(context).size.height/16,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedColor= !_selectedColor;
          });
          widget.routing();
        },
        style: ElevatedButton.styleFrom(
            primary: _selectedColor?appColor:Colors.white,
            onPrimary: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))
            )// foreground
        ),
        child: Text(widget.buttonText,style: TextStyle(color: _selectedColor?Colors.white:Colors.black,),),
      ),
    );
  }
}