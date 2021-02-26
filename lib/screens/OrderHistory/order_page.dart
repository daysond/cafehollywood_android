import 'package:cafe_hollywood/models/receipt.dart';
import 'package:cafe_hollywood/screens/OrderHistory/upcoming_order_page.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderHistoryPage extends StatefulWidget {
  List<Receipt> orders = [];
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  String dateStr = '';
  List<Receipt> orders = [];

  Future<List<Receipt>> futureOrders;

  Future<List<Receipt>> fetchOrder(QuerySnapshot changeSnapshot) async {
    var futures = List<Future<Receipt>>();
    changeSnapshot.docChanges.forEach((change) async {
      if (change.type == DocumentChangeType.added) {
        print('TAG 1. doc id ${change.doc.id}');
        futures.add(FSService().getReceipt(change.doc.id));
        print('TAG 4 done');
        // setState(() {});
      }
      if (change.type == DocumentChangeType.modified) {
        //MODIFY ORDERS LIST HERE
      }
      if (change.type == DocumentChangeType.removed) {
        //DEL ORDER FROM THE LIST HERE

      }
    });
    print('TAG 2.about to get order');
    await Future.wait(futures).then((receipts) {
      orders = orders..addAll(receipts);
      print('TAG 3.did add order, COUNT ${orders.length}');
    });
    print('DONE DONE DONE');
    return orders;
  }

  @override
  void initState() {
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    print('mama\'s here');
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final changeSnapshot = Provider.of<QuerySnapshot>(context);
    futureOrders = fetchOrder(changeSnapshot);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
            physics: ScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
            body: new TabBarView(children: [
              // child: UpcomingOrderPage(widget.orders)
              FutureBuilder<List<Receipt>>(
                future: futureOrders,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print('TAG X ${snapshot.hasData}');
                    return UpcomingOrderPage(snapshot.data);
                  } else {
                    print('TAG Y ${snapshot.hasData}');
                    return Center(
                      child: Text('loading'),
                    );
                  }
                },
              ),
              Container(
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
                            dateStr =
                                DateFormat('E, MMM dd y').format(tomorrow);
                            dateStr = dateStr.substring(0, dateStr.length - 5);
                          });
                        })
                  ],
                ),
              ),
            ])),
      ),
    );
  }
}
