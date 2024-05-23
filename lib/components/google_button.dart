import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  var title = '';
  final TextStyle? textStyle;
  final VoidCallback onPressed;
  GoogleButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 15,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 233, 40, 40).withOpacity(.6),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}
