import 'package:cafe_hollywood/screens/auth_screens/sign_up_page.dart';
import 'package:cafe_hollywood/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AuthHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: Stack(
            children: [
              Image.asset(
                'assets/authHomebg.jpg',
                height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitHeight,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black38,
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Text(
                        'Cafe\nHollywood',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'SINCE 1994',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width * 0.6,
                        height: 48,
                        buttonColor: Colors.white,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => SignUpPage(false)));
                            // dynamic result = AuthService().signInAnon();
                            // if (result == null) {
                            //   print('can not sign in');
                            // } else {
                            //   print(result.toString());
                            // }
                          },
                          child: Text(
                            'LOG IN',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width * 0.6,
                        height: 48,
                        buttonColor: Colors.white,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => SignUpPage(true)));
                          },
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
