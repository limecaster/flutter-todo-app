import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Local imports
import '../utils/color_palette.dart';
import '../utils/font_sizes.dart';
import '../utils/build_text.dart';
import '../routes/screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //startTimer();
    super.initState();
  }

  Future<void> checkAuthenticatedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

    Future.delayed(const Duration(seconds: 3), () {
      if (isAuthenticated) {
        Navigator.pushNamedAndRemoveUntil(context, Screens.home, (route)=>false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, Screens.login, (route)=>false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/app_logo.png', width: 100,),
            const SizedBox(height: 20,),
            buildText('Todo List', kWhiteColor, textBold,
                FontWeight.w600, TextAlign.center, TextOverflow.clip),
            const SizedBox(
              height: 10,
            ),
            buildText('Todo-list application', kWhiteColor, textTiny,
                FontWeight.normal, TextAlign.center, TextOverflow.clip),
          ],
        )));
  }
}