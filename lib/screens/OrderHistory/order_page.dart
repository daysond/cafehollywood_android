import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  String dateStr = '';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          physics: ScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 0,
                pinned: true,
                bottom: TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      text: 'Upcoming',
                    ),
                    Tab(
                      text: 'Past',
                    )
                  ],
                ),
              )
            ];
          },
          body: Container(
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dateStr),
                IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      setState(() {
                        final now = DateTime.now();
                        final tomorrow =
                            DateTime(now.year, now.month, now.day + 50);
                        dateStr = DateFormat('E, MMM dd y').format(tomorrow);
                        dateStr = dateStr.substring(0, dateStr.length - 5);
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
