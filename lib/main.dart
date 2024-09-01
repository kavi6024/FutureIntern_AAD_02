import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/screens/homepage.dart';
import 'package:todo_app/screens/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String? isLoggedIn = "";

  @override
  void initState() {
    isLogged();
    super.initState();
  }

  void isLogged() {
    String? ret = SharedPrefs().getString("user");
    setState(() {
      isLoggedIn = ret;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.galdeanoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: (isLoggedIn == null) ? const LoginPage() : const Homepage(),
    );
  }
}
