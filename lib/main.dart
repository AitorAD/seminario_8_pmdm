import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seminario_8_pmdm/screens/screens.dart';
import 'package:seminario_8_pmdm/services/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('es', 'ES'), // Spanish, SPAIN
      ],
      routes: {
        HomeScreen.routeName: (_) => HomeScreen(),
        LogInScreen.routeName: (_) => LogInScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        ProductScreen.routeName: (_) => ProductScreen(),
        LoadingScreen.routeName: (_) => LoadingScreen(),
        CheckAuthScreen.routeName: (_) => CheckAuthScreen(),
      },
      scaffoldMessengerKey: NotificationService.messengerKey,
      initialRoute: CheckAuthScreen.routeName,
    );
  }
}
