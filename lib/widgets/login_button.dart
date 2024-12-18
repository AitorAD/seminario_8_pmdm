import 'package:flutter/material.dart';
import 'package:seminario_8_pmdm/providers/providers.dart';

import '../screens/screens.dart';

class LoginBtn extends StatelessWidget {
  final LoginFormProvider loginForm;

  const LoginBtn({
    super.key,
    required this.loginForm,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledColor: Colors.grey,
        elevation: 0,
        color: Colors.deepPurple,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          child: Text(
            loginForm.isLoading ? 'Espere' : 'Acceder',
            style: TextStyle(color: Colors.white),
          ),
        ),
        onPressed: loginForm.isLoading
            ? null
            : () async {
                FocusScope.of(context).unfocus();

                if (!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                await Future.delayed(Duration(seconds: 2));

                loginForm.isLoading = false;

                Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              });
  }
}
