import 'package:cafe_hollywood/models/custom_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CheckoutOptionTile extends StatefulWidget {
  final CustomOption option;
  void Function(CustomOption) handleOptionTap;
  CheckoutOptionTile(this.option, this.handleOptionTap);
  @override
  _CheckoutOptionTileState createState() => _CheckoutOptionTileState();
}

class _CheckoutOptionTileState extends State<CheckoutOptionTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Row(
                  children: [
                    Image(
                      width: 18,
                      height: 18,
                      fit: BoxFit.cover,
                      image: AssetImage(
                          'assets/${widget.option.mainImageName}.png'),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                        child: Text(
                      widget.option.mainTitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 40, bottom: 8),
                child: Text(
                  widget.option.subTitle,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          )),
          FlatButton(
              onPressed: () => widget.handleOptionTap(widget.option),
              child: Text(
                'CHANGE',
                style: TextStyle(color: Colors.blue[800]),
              ))
        ],
      ),
    );
  }
}
