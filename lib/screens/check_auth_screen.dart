import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminario_8_pmdm/screens/home_screen.dart';
import 'package:seminario_8_pmdm/screens/login_screen.dart';
import 'package:seminario_8_pmdm/services/services.dart';

class CheckAuthScreen extends StatelessWidget {
  static final routeName = 'checking';
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: authService.readToken(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              // if (!snapshot.hasData) return const CircularProgressIndicator();

              if (snapshot.data == '') {
                Future.microtask(
                  () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => LogInScreen(),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                    );
                  },
                );
              } else {
                Future.microtask(
                  () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => HomeScreen(),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                    );
                  },
                );
              }
              return Container();
            }),
      ),
    );
  }
}
