import 'package:flutter/material.dart';

class DividerLine extends StatelessWidget {
  const DividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(child: Divider()),
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          "or",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      Expanded(child: Divider()),
    ]);
  }
}
