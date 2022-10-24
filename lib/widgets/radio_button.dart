import 'package:community_new/constants/styles.dart';
import 'package:flutter/material.dart';

class RadioButtonWidget extends StatefulWidget {
  const RadioButtonWidget({Key? key}) : super(key: key);

  @override
  State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> {
  int _groupValue = -1;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: RadioListTile(
            value: 0,
            groupValue: _groupValue,
            title:const Text("Public Event"),
            onChanged: (newValue) =>
                setState(() => _groupValue = newValue as int),
            activeColor: appColor,
            selected: false,
          ),
        ),
        Expanded(flex: 1,
          child: RadioListTile(
            value: 1,
            groupValue: _groupValue,
            title: const Text("Private Event"),
            onChanged: (newValue) =>
                setState(() => _groupValue = newValue as int),
            activeColor: appColor,
            selected: false,
          ),
        ),
      ],
    );
  }
}
