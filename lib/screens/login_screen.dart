import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminario_8_pmdm/providers/providers.dart';

import 'package:seminario_8_pmdm/screens/screens.dart';
import 'package:seminario_8_pmdm/ui/input_decorations.dart';
import 'package:seminario_8_pmdm/widgets/widgets.dart';

class LogInScreen extends StatelessWidget {
  static final routeName = 'log_in';

  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, RegisterScreen.routeName);
                },
                child: Text('Crear una nueva cuenta'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'jonh.doe@gmail.com',
                labelText: 'Email',
                prefixIcon: Icons.alternate_email_sharp,
              ),
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Introduce un email válido';
              },
              onChanged: (value) => loginForm.email = value,
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outlined,
              ),
              validator: (value) {
                return (value == null || value.length >= 6)
                    ? null
                    : 'La contraseña debe tener al  menos 6 caracteres';
              },
              onChanged: (value) => loginForm.password = value,
            ),
            SizedBox(height: 35),
            
            LoginBtn(loginForm: loginForm)
          ],
        ),
      ),
    );
  }
}
