import 'package:cafe_hollywood/models/enums/order_status.dart';
import 'package:cafe_hollywood/models/receipt.dart';
import 'package:cafe_hollywood/screens/OrderHistory/past_order_page.dart';
import 'package:cafe_hollywood/screens/OrderHistory/upcoming_order_page.dart';
import 'package:cafe_hollywood/services/app_setting.dart';
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
  FSService fsService = FSService();
  List<Receipt> activeReceipts = [];
  List<Receipt> closedReceipts = [];
  Future<List<Receipt>> futureOrders;

  PastOrderPage pastOrderPage;

  Future<List<Receipt>> fetchOrder(QuerySnapshot changeSnapshot) async {
    var futures = List<Future<Receipt>>();
    changeSnapshot.docChanges.forEach((change) async {
      if (change.type == DocumentChangeType.added) {
        print('TAG 1 added. doc id ${change.doc.id}');
        futures.add(FSService().getReceipt(change.doc.id));

        // setState(() {});
      }
      if (change.type == DocumentChangeType.modified) {
        final data = change.doc.data();
        OrderStatus newStatus =
            OrderStatusExt.statusFromRawValue(data['status'] as int);
        if (newStatus != null) {
          switch (newStatus) {
            case OrderStatus.cancelled:
            //close order
            case OrderStatus.completed:
            // close order
            default:
              activeReceipts.forEach((r) {
                if (r.orderID == change.doc.id) {
                  r.status = newStatus;
                }
              });
          }
        }
      }
      if (change.type == DocumentChangeType.removed) {
        //DEL ORDER FROM THE LIST HERE
        activeReceipts.asMap().forEach((index, r) {
          if (r.orderID == change.doc.id) {
            closedReceipts.add(activeReceipts.removeAt(index));
            getPastReceipts(true);
          }
        });
      }
    });

    await Future.wait(futures).then((receipts) {
      activeReceipts = activeReceipts..addAll(receipts);
      print('TAG 3.did add order, COUNT ${activeReceipts.length}');
    });

    return activeReceipts;
  }

  Future<List<Receipt>> getPastReceipts(bool mockFuture) async {
    if (mockFuture) {
      return closedReceipts;
    }

    var customerOrdersRef = fsService.databaseRef
        .collection('customers')
        .doc(APPSetting().customerUID)
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .limitToLast(10);

    var futures = List<Future<Receipt>>();

    var receipts = List<Receipt>();

    return customerOrdersRef.get().then((value) async {
      if (value.docs != null) {
        final docs = value.docs;

        docs.forEach((doc) {
          futures.add(fsService.getReceipt(doc.id));
        });

        await Future.wait(futures).then((result) {
          receipts = result;
        });

        return receipts;
      }
    });
  }

  @override
  void didChangeDependencies() {
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
              SafeArea(
                child: FutureBuilder<List<Receipt>>(
                  future: futureOrders,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return UpcomingOrderPage(snapshot.data);
                    } else {
                      return Center(
                        child: Text('loading'),
                      );
                    }
                  },
                ),
              ),
              SafeArea(
                child: FutureBuilder<List<Receipt>>(
                  future: getPastReceipts(false),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      closedReceipts = snapshot.data;
                      pastOrderPage = PastOrderPage(snapshot.data);
                      return pastOrderPage;
                    } else {
                      return Center(
                        child: Text('loading'),
                      );
                    }
                  },
                ),
              ),
            ])),
      ),
    );
  }
}
