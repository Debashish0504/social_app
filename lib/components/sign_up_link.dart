import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/screens/signup_screen.dart';

class SignUp extends StatelessWidget {
  SignUp();
  @override
  Widget build(BuildContext context) {
    return (new Padding(
      padding: const EdgeInsets.only(
        top: 160.0,
      ),
      child:  TextButton(
        onPressed: (){
          Navigator.push(
              context,
              PageTransition<dynamic>(
                  type: PageTransitionType.rightToLeft, child: SignUpScreen()));
        },
        child: Text(
          "Don't have an account? Sign Up",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: new TextStyle(
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
              color: Colors.white,
              fontSize: 12.0),
        ),
      ),
    ));
  }
}
