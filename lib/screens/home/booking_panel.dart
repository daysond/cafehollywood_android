import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

const List<String> colors = const <String>[
  'Red',
  'Yellow',
  'Amber',
  'Blue',
  'Black',
  'Pink',
  'Purple',
  'White',
  'Grey',
  'Green',
];

class BookingPanel extends StatefulWidget {
  @override
  _BookingPanelState createState() => _BookingPanelState();
}

class _BookingPanelState extends State<BookingPanel> {
  int _selectedHour = 0;
  int _selectedMinute = 1;
  int _selectedSize = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      height: 380.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Party Size',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Container(
            height: 50,
            // color: Colors.amber,
            // child: Padding(
            // padding: const EdgeInsets.symmetric(vertical: 15),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemExtent: 50, // item width
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSize = index + 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: (index + 1) == _selectedSize
                                ? Colors.grey
                                : Colors.black),
                        // color: Colors.red,
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            // ),
          ),
          SizedBox(height: 16),
          Text(
            'Date and Time',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: CupertinoPicker(
                        backgroundColor: Colors.grey[200],
                        scrollController: new FixedExtentScrollController(
                          initialItem: _selectedHour,
                        ),
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            _selectedHour = index;
                          });
                        },
                        children: new List<Widget>.generate(24, (int index) {
                          return new Center(
                            child: new Text('${index + 1}'),
                          );
                        })),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                        scrollController: new FixedExtentScrollController(
                          initialItem: _selectedMinute,
                        ),
                        itemExtent: 32.0,
                        backgroundColor: Colors.grey[200],
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            _selectedMinute = index;
                          });
                        },
                        children: new List<Widget>.generate(60, (int index) {
                          return new Center(
                            child: new Text('${index + 1}'),
                          );
                        })),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: BlackButton('Done', () {
              print('done');
              Navigator.pop(context);
            }),
          ),
        ],
      ),
    );
  }
}
