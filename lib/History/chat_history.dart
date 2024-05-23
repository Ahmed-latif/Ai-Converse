import 'dart:convert';
import 'dart:io';
import 'dart:html';

import 'package:ai_converse_chatbot_app/History/drawer.dart';
import 'package:ai_converse_chatbot_app/History/popmenu.dart';
import 'package:ai_converse_chatbot_app/components/api_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'models.dart';
import 'conversation_provider.dart';
import 'secrets.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final client = HttpClient();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Message?> _sendMessage(List<Map<String, String>> messages) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final apiKey =
        Provider.of<ConversationProvider>(context, listen: false).yourapikey;
    final proxy =
        Provider.of<ConversationProvider>(context, listen: false).yourproxy;
    final converter = JsonUtf8Encoder();

    // send all current conversation to OpenAI
    final body = {
      'model': model,
      'messages': messages,
    };
    // _client.findProxy = HttpClient.findProxyFromEnvironment;
    // if (proxy != "") {
    //   client.findProxy = (url) {
    //     return HttpClient.findProxyFromEnvironment(url,
    //         environment: {"http_proxy": proxy, "https_proxy": proxy});
    //   };
    // }

    try {
      return await client.postUrl(url).then((HttpClientRequest request) {
        request.headers.set('Content-Type', 'application/json');
        request.headers.set('Authorization', 'Bearer $openSourceKey');
        request.add(converter.convert(body));
        return request.close();
      }).then((HttpClientResponse response) async {
        var retBody = await response.transform(utf8.decoder).join();
        if (response.statusCode == 200) {
          final data = json.decode(retBody);
          final completions = data['choices'] as List<dynamic>;
          if (completions.isNotEmpty) {
            final completion = completions[0];
            final content = completion['message']['content'] as String;
            // delete all the prefix '\n' in content
            final contentWithoutPrefix =
                content.replaceFirst(RegExp(r'^\n+'), '');
            return Message(
                senderId: systemSender.id, content: contentWithoutPrefix);
          }
        } else {
          // invalid api key
          // create a new dialog
          return Message(
              content: "API KEY is Invalid", senderId: systemSender.id);
        }
      });
    } on Exception catch (_) {
      return Message(content: _.toString(), senderId: systemSender.id);
    }
  }

  //scroll to last message
  void _scrollToLastMessage() {
    final double height = _scrollController.position.maxScrollExtent;
    final double lastMessageHeight =
        _scrollController.position.viewportDimension;
    _scrollController.animateTo(
      height,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void _sendMessageAndAddToChat() async {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      _textController.clear();
      final userMessage = Message(senderId: userSender.id, content: text);
      setState(() {
        // add to current conversation
        Provider.of<ConversationProvider>(context, listen: false)
            .addMessage(userMessage);
      });

      // TODO:scroll to last message
      _scrollToLastMessage();

      final assistantMessage = await _sendMessage(
          Provider.of<ConversationProvider>(context, listen: false)
              .currentConversationMessages);
      if (assistantMessage != null) {
        setState(() {
          Provider.of<ConversationProvider>(context, listen: false)
              .addMessage(assistantMessage);
        });
      }

      // TODO:scroll to last message
      _scrollToLastMessage();
    }
  }

  final user = FirebaseAuth.instance.currentUser!;
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
          radius: 50,
          backgroundImage: AssetImage('assets/user.png'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String newName = '';
                  return AlertDialog(
                    title: const Text('Rename Conversation'),
                    content: TextField(
                      // display the current name of the conversation
                      decoration: InputDecoration(
                        hintText: Provider.of<ConversationProvider>(context,
                                listen: false)
                            .currentConversation
                            .title,
                      ),
                      onChanged: (value) {
                        newName = value;
                      },
                    ),
                    actions: <Widget>[
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
                        child: Text('Rename',
                            style: Theme.of(context).textTheme.headlineSmall),
                        onPressed: () {
                          // Call renameConversation method here with the new name
                          Provider.of<ConversationProvider>(context,
                                  listen: false)
                              .renameConversation(newName);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
                Provider.of<ConversationProvider>(context, listen: true)
                    .currentConversationTitle
                    .toUpperCase(),
                style: Theme.of(context).textTheme.headlineLarge),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0, // remove box shadow
          toolbarHeight: 50,
          actions: [
            CustomPopupMenu(),
          ],
        ),
        drawer: MyDrawer(),
        // resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Consumer<ConversationProvider>(
                  builder: (context, conversationProvider, child) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: conversationProvider.currentConversationLength,
                      itemBuilder: (BuildContext context, int index) {
                        Message message = conversationProvider
                            .currentConversation.messages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message.senderId != userSender.id)
                                CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/applogo.png'))
                              else
                                const SizedBox(
                                  width: 10,
                                ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Align(
                                  alignment: message.senderId == userSender.id
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      color: message.senderId == userSender.id
                                          ? Color(0xff55bb8e)
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(16.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          message.content,
                                          style: TextStyle(
                                            color: message.senderId ==
                                                    userSender.id
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        message.senderId == userSender.id
                                            ? SizedBox.shrink()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.copy)),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.share))
                                                ],
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              if (message.senderId == userSender.id)
                                profileImage()
                              else
                                const SizedBox(width: 24.0),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // input box
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 15,
                            child: TextFormField(
                              controller: _textController,
                              decoration: InputDecoration.collapsed(
                                  hintText: "Ask Anything..",
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromARGB(202, 253, 253, 253))),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 5, bottom: 5, right: 5),
                      child: IconButton(
                        onPressed: () {
                          _sendMessageAndAddToChat();
                        },
                        icon: Icon(
                          Icons.arrow_upward_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
