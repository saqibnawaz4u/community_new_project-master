import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/styles.dart';

class RichTextWidget extends StatefulWidget {

   const RichTextWidget({Key? key, required this.text1,required this.text2, tapGestureRecognizer, }) : super(key: key) ;
   final String text1;
   final String text2;

  @override
  State<RichTextWidget> createState() => _RichTextWidgetState();
}

class _RichTextWidgetState extends State<RichTextWidget> {
  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.topLeft,
      child: RichText(
        text:  TextSpan(children: <TextSpan>[
          TextSpan(
              text: widget.text1,
              style: const TextStyle(color: Colors.black)),
          TextSpan(
              text: widget.text2,
              style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
class ElevatedButtonWidget extends StatefulWidget {
  const ElevatedButtonWidget({Key? key,required this.buttonText,required this.routing}) : super(key: key);
  final String buttonText;
  final VoidCallback routing;

  @override
  State<ElevatedButtonWidget> createState() => _ElevatedButtonWidgetState();
}

class _ElevatedButtonWidgetState extends State<ElevatedButtonWidget> {
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
            primary: _selectedColor?Colors.black:Colors.white,
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