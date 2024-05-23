import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'conversation_provider.dart';
import 'models.dart';
import 'secrets.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userDisplayName = FirebaseAuth.instance.currentUser!.displayName;
    userName() {
      if (user != null && userDisplayName != null) {
        return Text(' $userDisplayName');
      } else {
        return Text('Hello,Anonymous');
      }
    }

    profileImage() {
      if (user != '' && user.photoURL != null) {
        return CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(user.photoURL!),
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/user.png'),
          ),
        );
      }
    }

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Provider.of<ConversationProvider>(context, listen: false)
                      .addEmptyConversation('');
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(color: Color(Colors.grey[300]?.value ?? 0)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    // left align
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add, color: Colors.grey[800], size: 20.0),
                      const SizedBox(width: 15.0),
                      Text(
                        'New Chat',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<ConversationProvider>(
                builder: (context, conversationProvider, child) {
                  return ListView.builder(
                    itemCount: conversationProvider.conversations.length,
                    itemBuilder: (BuildContext context, int index) {
                      Conversation conversation =
                          conversationProvider.conversations[index];
                      return Dismissible(
                        key: UniqueKey(),
                        child: GestureDetector(
                          onTap: () {
                            conversationProvider.currentConversationIndex =
                                index;
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: conversationProvider
                                          .currentConversationIndex ==
                                      index
                                  ? const Color(0xff55bb8e)
                                  : Colors.white,
                              // border: Border.all(color: Color(Colors.grey[200]?.value ?? 0)),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // coversation icon
                                Icon(
                                  Icons.person,
                                  color: conversationProvider
                                              .currentConversationIndex ==
                                          index
                                      ? Colors.white
                                      : Colors.grey[700],
                                  size: 20.0,
                                ),
                                const SizedBox(width: 15.0),
                                Text(
                                  conversation.title,
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: conversationProvider
                                                .currentConversationIndex ==
                                            index
                                        ? Colors.white
                                        : Colors.grey[700],
                                    fontFamily: 'din-regular',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // add a setting button at the end of the drawer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    profileImage(),
                    const SizedBox(width: 15.0),
                    userName()
                  ],
                ),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(vertical: 14.0),
            //   child: GestureDetector(
            //     onTap: () {
            //       showProxyDialog(context);
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           Icon(Icons.settings, color: Colors.grey[700], size: 20.0),
            //           const SizedBox(width: 15.0),
            //           Text(
            //             'Proxy Setting',
            //             style: TextStyle(
            //               fontFamily: 'din-regular',
            //               color: Colors.grey[700],
            //               fontSize: 18.0,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
