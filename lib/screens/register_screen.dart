import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminario_8_pmdm/providers/providers.dart';
import 'package:seminario_8_pmdm/ui/input_decorations.dart';
import 'package:seminario_8_pmdm/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  static final routeName = 'register_screen';

  const RegisterScreen({super.key});

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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back),
                            color: Colors.black,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Registrarse',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _RegisterForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({super.key});

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
              keyboardType: TextInputType.phone,
              decoration: InputDecorations.authInputDecoration(
                hintText: '123456789',
                labelText: 'Teléfono (opcional)',
                prefixIcon: Icons.phone,
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty && value.length != 9) {
                  return 'Introduce un número de teléfono válido';
                }
                return null;
              },
              onChanged: (value) => loginForm.phone = value,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecorations.authInputDecoration(
                labelText: 'Sexo',
                prefixIcon: Icons.person_outline,
                hintText: '',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Masculino',
                  child: Text('Masculino'),
                ),
                DropdownMenuItem(
                  value: 'Femenino',
                  child: Text('Femenino'),
                ),
              ],
              onChanged: (value) => loginForm.gender = value ?? '',
              validator: (value) => value != null && value.isNotEmpty
                  ? null
                  : 'Seleccione un sexo',
            ),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: loginForm.birthDate != null
                    ? '${loginForm.birthDate!.day}/${loginForm.birthDate!.month}/${loginForm.birthDate!.year}'
                    : '',
              ),
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Selecciona tu fecha de nacimiento',
                labelText: 'Fecha de nacimiento',
                prefixIcon: Icons.calendar_today,
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  loginForm.birthDate = pickedDate;
                  loginForm.notifyListeners();
                }
              },
              validator: (value) => loginForm.birthDate != null
                  ? null
                  : 'Seleccione una fecha válida',
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
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Repite la contraseña',
                prefixIcon: Icons.lock_outlined,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return value == loginForm.password
                    ? null
                    : 'Las contraseñas no coinciden';
              },
              onChanged: (value) => loginForm.confirmPassword = value,
            ),
            SizedBox(height: 15),
            LoginBtn(loginForm: loginForm)
          ],
        ),
      ),
    );
  }
}
