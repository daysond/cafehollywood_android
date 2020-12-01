import 'package:flutter/material.dart';

class BlackButton extends StatelessWidget {
  final String title;
  final void Function() handler;
  String? subtitle = '';
  BlackButton(this.title, this.handler, {this.subtitle});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: handler,
      color: Colors.black,
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
