import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sam_beckman/view/onboarding/onboarding.dart';
import 'package:sam_beckman/view/screens/home_page.dart';
import 'package:sam_beckman/view/screens/obBoardingScreen.dart';
import 'package:sam_beckman/view/screens/onboarding_page.dart';
import 'package:sam_beckman/view/screens/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/mybehaviour.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 812),
      builder: () => MaterialApp(
        title: 'Shelf',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color.fromARGB(255, 254, 192, 1),
          fontFamily: 'Satoshi',
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color.fromARGB(255, 254, 192, 1),
          fontFamily: 'Satoshi',
        ),
        home: OnboardingView(),
      ),
    );
  }
}
