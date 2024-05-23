import 'package:ai_converse_chatbot_app/components/drop_down.dart';
import 'package:ai_converse_chatbot_app/components/text_widget.dart';
import 'package:flutter/material.dart';

class ServiceModal {
  static Future<void> showModelSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: TextWidget(label: 'Choose Model')),
                Flexible(flex: 2, child: ModelsDrowDownWidget()),
              ],
            ),
          );
        });
  }
}
