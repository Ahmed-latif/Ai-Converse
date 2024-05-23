import 'dart:convert';
import 'dart:math';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:hive/hive.dart';

import '../Hive Model/chat_item.dart';
import '../Hive Model/message_item.dart';
import '../Hive Model/message_role.dart';

class ChatPage2 extends StatefulWidget {
  final ChatItem chatItem;

  const ChatPage2({super.key, required this.chatItem});

  @override
  State<ChatPage2> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage2> {
  final List<types.Message> _messages = [];
  final List<OpenAIChatCompletionChoiceMessageModel> _aiMessages = [];
  late types.User ai;
  late types.User user;
  late Box messageBox;

  late String appBarTitle;

  var chatResponseId = '';
  var chatResponseContent = '';
  bool isAiTyping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: SafeArea(
        child: Chat(
          typingIndicatorOptions: TypingIndicatorOptions(
            typingUsers: [if (isAiTyping) ai],
          ),
          inputOptions: InputOptions(enabled: !isAiTyping),
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: user,
          theme: DefaultChatTheme(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ai = const types.User(id: 'ai', firstName: 'AI');
    user = const types.User(id: 'user', firstName: 'You');

    messageBox = Hive.box('messages');

    appBarTitle = widget.chatItem.title;

    // read chat history from Hive
    for (var messageItem in widget.chatItem.messages) {
      messageItem as MessageItem;
      // Add to chat view
      final textMessage = types.TextMessage(
        author: messageItem.role == MessageRole.ai ? ai : user,
        createdAt: messageItem.createdAt.millisecondsSinceEpoch,
        id: randomString(),
        text: messageItem.message,
      );

      _messages.insert(0, textMessage);

      // construct chatgpt messages
      _aiMessages.add(OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
              messageItem.message)
        ],
        role: messageItem.role == MessageRole.ai
            ? OpenAIChatMessageRole.assistant
            : OpenAIChatMessageRole.user,
      ));
    }
  }

  void onMessageReceived({String? id, required String message}) {
    var newMessage = types.TextMessage(
      author: ai,
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: message,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    _addMessage(newMessage);
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  // add new bubble to chat
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  // modify last bubble in chat
  void _addMessageStream(String message) {
    setState(() {
      _messages.first =
          (_messages.first as types.TextMessage).copyWith(text: message);
    });
  }

  void _completeChat(String prompt) async {
    _aiMessages.add(OpenAIChatCompletionChoiceMessageModel(
      content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)],
      role: OpenAIChatMessageRole.user,
    ));

    Stream<OpenAIStreamChatCompletionModel> chatStream =
        OpenAI.instance.chat.createStream(
      model: "gpt-3.5-turbo",
      messages: _aiMessages,
    );

    chatStream.listen((streamChatCompletion) {
      // existing id: just update to the same text bubble
      if (chatResponseId == streamChatCompletion.id) {
        chatResponseContent =
            streamChatCompletion.choices.first.delta.content.toString();
        _addMessageStream(chatResponseContent.toString());
        if (streamChatCompletion.choices.first.finishReason == "stop") {
          isAiTyping = false;
          _aiMessages.add(OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                  chatResponseContent.toString())
            ],
            role: OpenAIChatMessageRole.assistant,
          ));
          _saveMessage(chatResponseContent.toString(), MessageRole.ai);
          chatResponseId = '';
          chatResponseContent;
        }
      } else {
        // new id: create new text bubble
        chatResponseId = streamChatCompletion.id;
        final chatResponseContent =
            streamChatCompletion.choices.first.delta.content;
        onMessageReceived(
            id: chatResponseId, message: chatResponseContent.toString());
        isAiTyping = true;
      }
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
    _saveMessage(message.text, MessageRole.user);
    _completeChat(message.text);
  }

  /// Save message to Hive database
  void _saveMessage(String message, MessageRole role) {
    final messageItem = MessageItem(message, role, DateTime.now());
    messageBox.add(messageItem);
    widget.chatItem.messages.add(messageItem);
    widget.chatItem.save();
  }
}
