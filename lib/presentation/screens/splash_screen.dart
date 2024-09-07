import 'dart:convert';

import 'package:flutter/material.dart';

import '../size_config/size_config.dart';
import '../widgets/animated_text.dart';
import 'home_screen.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  static const String routeName = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final String quoteURL = "https://api.adviceslip.com/advice";
  String quote = '';
  generateQuote() async {
    var res = await http.get(Uri.parse(quoteURL));
    var result = jsonDecode(res.body);
    print(result["slip"]["advice"]);
    setState(() {
      quote = result["slip"]["advice"];
    });
  }

  @override
  void initState() {
    super.initState();

    initializeAnimation();

    navigateToHomeScreen();
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _getImage(context),
              AnimatedText(
                  title: 'Task Management App or To Do App',
                  slideAnimation: _slideAnimation),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
                    child: Text(
                      quote,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      generateQuote();
                    },
                    child: Text('View Quote'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getImage(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      height: MediaQuery.of(context).size.width / 2,
    );
  }

  void initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
        .animate(_animationController);

    _animationController.forward();
  }

  void navigateToHomeScreen() {
    Future.delayed(
      const Duration(milliseconds: 20200),
      () => Navigator.of(context).pushReplacementNamed(HomeScreen.routeName),
    );
  }
}
