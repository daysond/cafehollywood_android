import 'package:flutter/material.dart';

class BlackButton extends StatelessWidget {
  final String title;
  final void Function() handler;
  String subtitle;
  BlackButton(this.title, this.handler, {this.subtitle});
  @override
  Widget build(BuildContext context) {
    return subtitle == null
        ? _buildButton()
        : Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildButton(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    '\$99',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          );
  }

  _buildButton() {
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
