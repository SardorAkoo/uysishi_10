import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uysishi_10/controllers/course_controller.dart';
import 'package:uysishi_10/controllers/note_controller.dart';
import 'package:uysishi_10/controllers/plan_controller.dart';
import 'package:uysishi_10/notifier/theme_notifier.dart';
import 'package:uysishi_10/servise/auth_http_services.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteController()),
        ChangeNotifierProvider(create: (_) => PlanController()),
        ChangeNotifierProvider(create: (_) => CourseController()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authHttpServices = AuthHttpServices();

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    authHttpServices.checkAuth().then((value) {
      setState(() {
        isLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeNotifier.currentTheme,
      home: isLoggedIn ? HomeScreen() : const LoginScreen(),
      routes: {
        '/notes': (context) => NoteScreen(),
        '/plans': (context) => PlansScreen(),
        '/courses': (context) => CourseScreen(),
        '/settings': (context) =>
            SettingsScreen(toggleTheme: themeNotifier.toggleTheme),
        '/quiz': (context) => QuizScreen(),
      },
    );
  }
}
