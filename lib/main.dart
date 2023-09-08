import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/otp_verify_page.dart';
import 'pages/fingerprint_page.dart';
import 'pages/register_page.dart';

import 'services/shared_service.dart';

Widget _defaultHome = const LoginPage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get result of the login function.
  bool result = await SharedService.isLoggedIn();
  if (result) {
    _defaultHome = const LoginPage();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PassLock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => _defaultHome,
        '/home': (context) => const HomePage(),
        '/otpVerify': (context) => const OtpVerifyPage(),
        '/login': (context) => const LoginPage(),
        '/fingerprint': (context) => const FingerPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
