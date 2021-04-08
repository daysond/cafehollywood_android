import 'package:flutter/material.dart';

class BlackButton extends StatefulWidget {
  final String title;
  final void Function() handler;
  String? subtitle;
  bool isButtonEnabled;
  BlackButton(this.title, this.handler, this.isButtonEnabled, {this.subtitle});

  @override
  _BlackButtonState createState() => _BlackButtonState();
}

class _BlackButtonState extends State<BlackButton> {
  @override
  Widget build(BuildContext context) {
    return widget.subtitle == null
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
                    '${widget.subtitle}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          );
  }

  _buildButton() {
    return RaisedButton(
      onPressed: widget.isButtonEnabled ? widget.handler : () {},
      color: widget.isButtonEnabled ? Colors.black : Colors.grey[600],
      child: Text(
        widget.title,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
