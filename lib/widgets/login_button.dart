import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminario_8_pmdm/providers/providers.dart';
import 'package:seminario_8_pmdm/services/auth_service.dart';
import 'package:seminario_8_pmdm/services/services.dart';

import '../screens/screens.dart';

class LoginBtn extends StatelessWidget {
  final LoginFormProvider loginForm;
  final bool isRegister;

  const LoginBtn({
    super.key,
    required this.loginForm,
    required this.isRegister,
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
                final authService =
                    Provider.of<AuthService>(context, listen: false);

                if (!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                final String? errorMessage;
                if (isRegister) {
                  errorMessage = await authService.createUser(
                      loginForm.email, loginForm.password);
                } else {
                  errorMessage = await authService.login(
                      loginForm.email, loginForm.password);
                }

                if (errorMessage == null) {
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                } else {
                  print(errorMessage);
                  NotificationService.showSnackBar(errorMessage);
                  loginForm.isLoading = false;
                }
              });
  }
}
