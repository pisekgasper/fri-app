import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fri_app/authentication_service.dart';
import 'package:fri_app/bus_info.dart';
import 'package:fri_app/daily_menu.dart';
import 'package:fri_app/home_page.dart';
import 'package:fri_app/sign_in.dart';
import 'package:fri_app/schedule.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setEnabledSystemUIOverlays(
      SystemUiOverlay.values); // Show transparent status bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
      ],
      child: NeumorphicApp(
        themeMode: ThemeMode.light,
        theme: NeumorphicThemeData(
          variantColor: const Color(0xffee235a),
          baseColor: const Color(0xff2c2f34),
          accentColor: const Color(0xffee235a),
          shadowLightColor: const Color(0xff383c42),
          shadowLightColorEmboss: const Color(0xff383c42),
          shadowDarkColor: const Color(0xff282a2f),
          shadowDarkColorEmboss: const Color(0xff282a2f),
          lightSource: LightSource.topLeft,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50.0)),
          intensity: 1.0,
          depth: -4.0,
        ),
        darkTheme: NeumorphicThemeData(
          variantColor: const Color(0xffee235a),
          baseColor: const Color(0xff2c2f34),
          accentColor: const Color(0xffee235a),
          shadowLightColor: const Color(0xff383c42),
          shadowLightColorEmboss: const Color(0xff383c42),
          shadowDarkColor: const Color(0xff282a2f),
          shadowDarkColorEmboss: const Color(0xff282a2f),
          lightSource: LightSource.topLeft,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50.0)),
          intensity: 1.0,
          depth: -7.0,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => AuthenticationWrapper(),
          '/BusPage': (context) => BusPage(),
          '/Schedule': (context) => TimetablePage(),
          '/DailyMenu': (context) => DailyMenuPage(),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomePage();
    }
    return SignInPage();
  }
}
