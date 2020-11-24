import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Image.asset(
            'assets/homebg.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonTheme(
                  minWidth: 145,
                  buttonColor: Colors.white,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text('Quick Order'),
                  ),
                ),
                SizedBox(height: 8.0),
                ButtonTheme(
                  minWidth: 145,
                  buttonColor: Colors.white,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text('Make Reservation'),
                  ),
                ),
                SizedBox(height: 8.0),
                ButtonTheme(
                  minWidth: 145,
                  buttonColor: Colors.white,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text('Online Order Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
