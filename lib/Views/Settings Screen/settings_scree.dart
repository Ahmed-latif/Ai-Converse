// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Theme/shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final userDisplayName = FirebaseAuth.instance.currentUser!.displayName;
  bool isDark = false;
  profileImage() {
    if (user != '' && user.photoURL != null) {
      return CircleAvatar(
        radius: 50,
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

  userName() {
    if (user != null && userDisplayName != null) {
      return Text('Hello, $userDisplayName');
    } else {
      return Text('Hello,Anonymous');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: profileImage()),
            SizedBox(
              height: 10,
            ),
            Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(
                  width: 10,
                ),
                userName()
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Icon(Icons.email_rounded),
                SizedBox(
                  width: 10,
                ),
                Text(
                  user.email!,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'About',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Theme',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            ListTile(
              subtitle: themeChange.darkTheme
                  ? Text(
                      'UnCheck to Light Theme',
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  : Text(
                      'Check to Dark Theme',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
              leading: themeChange.darkTheme
                  ? Icon(
                      Icons.nightlight_round,
                      color: Color.fromARGB(255, 5, 58, 143),
                    )
                  : Icon(
                      Icons.sunny,
                      color: Colors.amber,
                    ),
              title: themeChange.darkTheme
                  ? Text(
                      'Dark Theme',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  : Text('Light Theme',
                      style: Theme.of(context).textTheme.bodyLarge),
              trailing: Checkbox(
                  value: themeChange.darkTheme,
                  side: Theme.of(context).checkboxTheme.side,
                  fillColor: Theme.of(context).checkboxTheme.fillColor,
                  onChanged: (bool? value) {
                    themeChange.darkTheme = value!;
                  }),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Icon(
                  Icons.logout_outlined,
                  color: Colors.red.withOpacity(.8),
                ),
                TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.red.withOpacity(.8)),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
