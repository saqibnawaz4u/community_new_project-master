import 'package:flutter/material.dart';

import '../constants/styles.dart';

class AddScreenTextFieldWidget extends StatelessWidget {
  const AddScreenTextFieldWidget(
      {Key? key,
      required this.textName,
      required this.obsecureText,
      required this.inputType,
      this.labelText,
      this.validator,
      this.textFieldLength,
      required this.controller,
      this.p_readOnly = false,
      this.ontap,
      this.locationIcon,
      this.icn})
      : super(key: key);

  final String textName;
  final VoidCallback? locationIcon;
  final TextInputType inputType;
  final TextEditingController controller;
  final bool obsecureText;
  final String? labelText;
  final IconData? icn;
  final int? textFieldLength;
  final Future? Function()? ontap;

  final String? Function(String?)? validator;
  final bool p_readOnly;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                labelText.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              )),
        ),
        TextFormField(
          onTap: ontap,
          readOnly: p_readOnly,
          validator: validator,
          obscureText: obsecureText,
          maxLines: textFieldLength,
          //initialValue:  widget.textName,
          // initialValue: "i am initial",
          controller: controller,
          decoration: InputDecoration(
            // hintText: textName,
            fillColor: Colors.white,
            filled: true,
            suffixIcon: IconButton(
                color: appColor, onPressed: locationIcon, icon: Icon(icn)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(width: 1, color: appColor),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(width: 1, color: Colors.red)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              //borderSide: BorderSide.a
            ),
          ),
          keyboardType: inputType,
        ),
      ],
    );
  }
}
