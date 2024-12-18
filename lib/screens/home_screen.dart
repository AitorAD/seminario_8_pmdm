import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  static final routeName = 'home_screen';
  
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('HomeScreen'),
      ),
    );
  }
}