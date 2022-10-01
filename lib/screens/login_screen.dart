import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/Components/sign_in_button.dart';
import 'package:social_app/Components/sign_up_link.dart';
import 'package:social_app/Components/tick.dart';
import 'package:social_app/core/api_client.dart';
import 'package:social_app/screens/home_screen.dart';
import 'package:social_app/utils/validator.dart';
import '../Components/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  int _animationStatus;

  bool _showPassword;

  AnimationController _loginButtonController;

  TextEditingController _userNameController;

  TextEditingController _passwordController;



  Box<dynamic> _hiveBox;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //region : Overridden functions
  @override
  void initState() {
    super.initState();
    _initScreenVariables();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: Container(
                decoration: BoxDecoration(
                  image: backgroundImage,
                ),
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: <Color>[
                        const Color.fromRGBO(162, 146, 199, 0.8),
                        const Color.fromRGBO(51, 51, 63, 0.9),
                      ],
                      stops: [0.2, 1.0],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.0, 1.0),
                    )),
                    child: ListView(
                      padding: const EdgeInsets.all(0.0),
                      children: <Widget>[
                        Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Tick(image: tick),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: TextFormField(
                                    controller: _userNameController,
                                    validator: (value) {
                                      return Validator.validateText(
                                          value ?? "");
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Username",
                                      isDense: true,
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: TextFormField(
                                    obscureText: _showPassword,
                                    controller: _passwordController,
                                    validator: (value) {
                                      return Validator.validatePassword(
                                          value ?? "");
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() =>
                                              _showPassword = !_showPassword);
                                        },
                                        child: Icon(
                                          _showPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.white),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SignUp()
                              ],
                            ),
                            _animationStatus == 0
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 50.0),
                                    child: InkWell(
                                        onTap: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              _animationStatus = 1;
                                            });
                                          }
                                          _playAnimation();
                                        },
                                        child: SignButton('Sign In')),
                                  )
                                : CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                          ],
                        ),
                      ],
                    ))),
          ),
        ));
  }

  @override
  void dispose() {
    _userNameController?.dispose();
    _passwordController?.dispose();
    _loginButtonController?.dispose();
    super.dispose();
  }

  //endregion

  //region: Widget
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, "/home"),
                  child: Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  //endregion

//region: Private functions
  Future<void> _initScreenVariables() async {
    _animationStatus = 0;
    _showPassword = false;
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    _hiveBox = await Hive.openBox('Credentials');
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
      _login();
    } on TickerCanceled {
      debugPrint('_playAnimation class');
    }
  }

  Future<void> _login() async {
    final ApiClient _apiClient = ApiClient();
    dynamic res = await _apiClient.login(
      _userNameController.text,
      _passwordController.text,
    );
    if (res['token'] != null) {
      String accessToken = res['token'];
      await _hiveBox.put('accessToken', accessToken);
      await _hiveBox.put('userName', _userNameController.text);

      Navigator.push(
          context,
          PageTransition<dynamic>(
              type: PageTransitionType.rightToLeft,
              child: HomeScreen(accessToken, _userNameController.text)));
    } else {
      setState(() {
        _animationStatus = 0;
      });
      Toast.show(res["error"], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

//endregion
}
