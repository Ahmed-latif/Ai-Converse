import 'package:ai_converse_chatbot_app/components/api_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'conversation_provider.dart';

void showProxyDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String newProxy = 'your proxy';
      return AlertDialog(
        title: const Text('proxy Setting'),
        content: TextField(
          // display the current name of the conversation
          decoration: InputDecoration(
            hintText: Provider.of<ConversationProvider>(context).yourproxy ??
                'Enter API Key',
          ),
          onChanged: (value) {
            newProxy = value;
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xff55bb8e),
              ),
            ),
            onPressed: () {
              if (newProxy == '') {
                Navigator.pop(context);
                return;
              }
              Provider.of<ConversationProvider>(context, listen: false)
                  .yourproxy = newProxy;
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

void showRenameDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String newName = openSourceKey;
      return AlertDialog(
        title: const Text('API Setting'),
        content: TextField(
          // display the current name of the conversation
          decoration: InputDecoration(hintText: 'Type Your Name'),
          onChanged: (value) {
            newName = value;
          },
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                copyText(context);
              },
              icon: Icon(Icons.copy)),
          TextButton(
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              'Save',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onPressed: () {
              if (newName == '') {
                Navigator.pop(context);
                return;
              }
              Provider.of<ConversationProvider>(context, listen: false)
                  .yourapikey = newName;
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

final String text = '$openSourceKey';
Future<void> copyText(BuildContext context) async {
  await Clipboard.setData(ClipboardData(text: text));

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      duration: Duration(seconds: 2),
      closeIconColor: Colors.white,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      width: 200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Text('Text Copied'),
    ),
  );
}
