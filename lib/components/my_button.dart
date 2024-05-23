// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  var title = '';
  final TextStyle? textStyle;
  final VoidCallback onPressed;
  MyButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 15,
        decoration: BoxDecoration(
            color: Color.fromRGBO(0, 151, 54, .8),
            borderRadius: BorderRadius.circular(12)),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            '$title',
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
