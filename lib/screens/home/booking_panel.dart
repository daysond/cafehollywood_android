import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class BookingPanel extends StatefulWidget {
  @override
  _BookingPanelState createState() => _BookingPanelState();
}

class _BookingPanelState extends State<BookingPanel> {
  String _selectedDate = '';
  int _selectedTime = 1;
  int _selectedSize = 2;
  final List<String> dates = [];
  final List<String> times = [];

  @override
  void initState() {
    for (var i = 0; i < 15; i++) {
      final now = DateTime.now();
      final date = DateTime(now.year, now.month, now.day + i);
      dates.add(DateFormat('E, MMM dd y').format(date));
    }

    for (var i = 11; i < 22; i++) {
      times.add('${i.toString()}:00');
      times.add('${i.toString()}:15');
      times.add('${i.toString()}:30');
      times.add('${i.toString()}:45');
    }

    _selectedDate = dates[0];

    super.initState();
  }

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
                          initialItem: 0,
                        ),
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            _selectedDate = dates[index];
                          });
                        },
                        children: new List<Widget>.generate(14, (int index) {
                          return new Center(
                            child: new Text(dates[index]
                                .substring(0, dates[index].length - 5)),
                          );
                        })),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                        scrollController: new FixedExtentScrollController(
                          initialItem: 0,
                        ),
                        itemExtent: 32.0,
                        backgroundColor: Colors.grey[200],
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            _selectedTime = index;
                          });
                        },
                        children: new List<Widget>.generate(times.length,
                            (int index) {
                          return new Center(
                            child: new Text(times[index]),
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
            }, true),
          ),
        ],
      ),
    );
  }
}
