import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/Components/styles.dart';
import 'package:social_app/core/api_client.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:social_app/utils/validator.dart';
import 'dart:async';
import '../Components/sign_in_button.dart';
import '../Components/tick.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _signUpButtonController;

  int _animationStatus;

  TextEditingController _emailController;

  TextEditingController _passwordController;

  TextEditingController _usernameController;

  TextEditingController _firstNameController;

  TextEditingController _lastNameController;

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
        child: Form(
            key: _formKey,
            child: Scaffold(
              body: Container(
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
                            children: <Widget>[
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Tick(image: tick),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextFormField(
                                      enabled: _animationStatus == 0 ? true : false,
                                      controller: _usernameController,
                                      validator: (value) {
                                        return Validator.validateText(
                                            value ?? "");
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Username",
                                        isDense: true,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextFormField(
                                      enabled: _animationStatus == 0 ? true : false,
                                      controller: _emailController,
                                      validator: (value) {
                                        return Validator.validateEmail(
                                            value ?? "");
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Email",
                                        isDense: true,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextFormField(
                                      enabled: _animationStatus == 0 ? true : false,
                                      controller: _passwordController,
                                      validator: (value) {
                                        return Validator.validatePassword(
                                            value ?? "");
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        isDense: true,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextFormField(
                                      enabled: _animationStatus == 0 ? true : false,
                                      controller: _firstNameController,
                                      validator: (value) {
                                        return Validator.validateText(
                                            value ?? "");
                                      },
                                      decoration: InputDecoration(
                                        hintText: "FirstName",
                                        isDense: true,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextFormField(
                                      enabled: _animationStatus == 0 ? true : false,
                                      controller: _lastNameController,
                                      validator: (value) {
                                        return Validator.validateText(
                                            value ?? "");
                                      },
                                      decoration: InputDecoration(
                                        hintText: "LastName",
                                        isDense: true,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(height: 20.0),
                                  _animationStatus == 0
                                      ? Align(
                                          alignment: Alignment.bottomCenter,
                                          child: InkWell(
                                              onTap: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  setState(() {
                                                    _animationStatus = 1;
                                                  });
                                                  _playAnimation();
                                                }
                                              },
                                              child: SignButton('Sign Up')),
                                        )
                                      : CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ))),
            )));
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    _usernameController?.dispose();
    _firstNameController?.dispose();
    _lastNameController?.dispose();
    _signUpButtonController?.dispose();
    super.dispose();
  }

  //endregion

  //region: Private functions

  Future<void> _initScreenVariables() async {
    _animationStatus = 0;
    _signUpButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  Future<Null> _playAnimation() async {
    try {
      await _signUpButtonController.forward();
      await _signUpButtonController.reverse();
      _registerUsers();
    } on TickerCanceled {}
  }

  Future<bool> _onWillPop() {
    return _animationStatus == 0 ?
    showDialog(
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
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
                ),
              ],
            );
          },
        ) : false ??
        false;
  }

  Future<void> _registerUsers() async {
    final ApiClient _apiClient = ApiClient();

    dynamic res = await _apiClient.registerUser(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
        _firstNameController.text,
        _lastNameController.text);

    if (res["message"] == "Account created successfully!") {
      Navigator.push(
          context,
          PageTransition<dynamic>(
              type: PageTransitionType.rightToLeft, child: LoginScreen()));
    } else {
      setState(() {
        _animationStatus = 0;
      });
      Toast.show(res["error"], context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

//endregion

}
