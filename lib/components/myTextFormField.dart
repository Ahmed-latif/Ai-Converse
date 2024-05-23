import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  bool obscureText;
  String hintText = '';
  String labelText = '';
  final styleTextField;
  final Icon? icon;
  final TextEditingController myController;

  MyTextFormField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.obscureText,
    required this.myController,
    this.icon,
    this.styleTextField,
  });

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: TextFormField(
              showCursor: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              cursorColor: Colors.red.shade500,
              style: styleTextField,
              controller: myController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  prefixIcon: icon,
                  labelText: labelText),
            ),
          ),
        ),
      ),
    );
  }
}
