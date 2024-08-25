import 'package:flutter/services.dart';
import 'package:giuseppe/router/routes.dart';
import 'package:giuseppe/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  //cambio el color de la parte superior de la pantalla
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, //color oscuro de iconos sup
  ));
  //inicializacion firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giuseppe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.generalTheme,
      routes: routes,
      initialRoute: 'login_page',
    );
  }

}
