import 'package:ai_converse_chatbot_app/Theme/common_style.dart';
import 'package:ai_converse_chatbot_app/Theme/shared_preferences/shared_preferences.dart';
import 'package:ai_converse_chatbot_app/Views/Auth/auth_page.dart';
import 'package:ai_converse_chatbot_app/Views/Bottom%20Navigation%20Bar/bottom_nav.dart';
import 'package:ai_converse_chatbot_app/Views/Splash/splash_screen.dart';
import 'package:ai_converse_chatbot_app/firebase_options.dart';
import 'package:ai_converse_chatbot_app/providers/chat_provider.dart';
import 'package:ai_converse_chatbot_app/providers/model_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'History/conversation_provider.dart';
import 'Hive History/Hive Model/chat_item.dart';
import 'Hive History/Hive Model/message_item.dart';
import 'Hive History/Hive Model/message_role.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(ChatItemAdapter());
  Hive.registerAdapter(MessageItemAdapter());
  Hive.registerAdapter(MessageRoleAdapter());
  await Hive.openBox('chats');
  await Hive.openBox('messages');
  runApp(
    ChangeNotifierProvider(
      create: (_) => ConversationProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ModelsProvider(),
          ),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
          ChangeNotifierProvider(create: (_) => ConversationProvider()),
          ChangeNotifierProvider(
            create: (_) {
              return themeChangeProvider;
            },
          )
        ],
        child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'AI Converse Chatbot App',
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
              home: const SplashScreen(),
              // home: StreamBuilder<User?>(
              //   stream: FirebaseAuth.instance.authStateChanges(),
              //   builder: (context, snapshot) {
              //     // Handle different connection states
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const SplashScreen(); // Display splash screen while waiting
              //     } else if (snapshot.hasData) {
              //       // Determine appropriate content based on user state
              //       return const MyBottomNavBar();
              //     } else if (snapshot.hasData) {
              //       return const AuthPage();
              //     } else {
              //       return SplashScreen();
              //     }
              //   },
              // ),
            );
          },
        ));
  }
}
