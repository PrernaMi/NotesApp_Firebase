import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notes/start_screen/change_profile_info.dart';
import 'package:firebase_notes/start_screen/forgot_pass.dart';
import 'package:firebase_notes/start_screen/login_page.dart';
import 'package:firebase_notes/start_screen/set_new_pass.dart';
import 'package:firebase_notes/start_screen/sign_up_page.dart';
import 'package:firebase_notes/start_screen/splash_screen.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

