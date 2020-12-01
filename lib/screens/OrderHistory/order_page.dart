import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
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
          Tab(text: 'Upcoming',),
          Tab(text: 'Past',)
        ],
      ),
    )
  ];
},
          body: Container(
            color: Colors.orange,
            child: Center(child: Text('hi'),),
            ),),
      ),
    );
  }
}
