import 'package:ai_converse_chatbot_app/History/chat_history.dart';
import 'package:ai_converse_chatbot_app/Image%20Generator/Views/image_generator_screen.dart';
import 'package:ai_converse_chatbot_app/Views/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Settings Screen/settings_scree.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyButtomNavBarState();
}

class _MyButtomNavBarState extends State<MyBottomNavBar> {
  int myCurrentIndex = 0;
  final user = FirebaseAuth.instance.currentUser!;
  List pages = const [
    ChatPage(),
    ImageGeneratorScreen(),
    HomeScreen(),
    SettingsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: Drawer(
        child: Column(
          children: [],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(

          // backgroundColor: Colors.transparent,
          selectedItemColor: Theme.of(context).iconTheme.color,
          unselectedItemColor: Theme.of(context).primaryIconTheme.color,
          currentIndex: myCurrentIndex,
          onTap: (index) {
            setState(() {
              myCurrentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "AI Converse"),
            BottomNavigationBarItem(
                icon: Icon(Icons.color_lens), label: "Image Generator"),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), label: "Different Models"),
            BottomNavigationBarItem(label: 'Settings', icon: Icon(Icons.person))
          ]),
      body: pages[myCurrentIndex],
    );
  }
}
