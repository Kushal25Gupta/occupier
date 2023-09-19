import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:occupier/Screens/Authentication/Login_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: InkWell(
              onTap: () async {
                await GoogleSignIn().signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Home Screen'),
            ),
          ),
        ),
      ),
    );
  }
}
