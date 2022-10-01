import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/screens/home_screen.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Directory appDocumentDirectory =
      await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  Box<dynamic> _hiveBox;

  AnimationController _animationController;

  //region: Overridden functions
  @override
  void initState() {
    super.initState();
    _initScreenVariables();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: _animationController,
            child: Image.asset('assets/av.png'),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  //endregion

  //region: Private functions
  Future<void> _initScreenVariables() async {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animationController.forward();
    _hiveBox = await Hive.openBox('Credentials');
    String accessToken = await _hiveBox.get('accessToken');
    String userName = await _hiveBox.get('userName');
    _loadWidget(accessToken, userName);
  }

  Future<void> _loadWidget(String accessToken, String userName) async {
    Duration _duration = Duration(milliseconds: 3000);
    return Timer(_duration, () {
      Widget screen = accessToken == null || accessToken == ''
          ? LoginScreen()
          : HomeScreen(accessToken, userName);
      Navigator.push(
          context,
          PageTransition<dynamic>(
              type: PageTransitionType.rightToLeft, child: screen));
    });
  }
//endregion
}
