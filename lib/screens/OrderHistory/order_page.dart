import 'package:cafe_hollywood/models/enums/order_status.dart';
import 'package:cafe_hollywood/models/order_manager.dart';
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
  //upcoming receipts
  Future<List<Receipt>>? futureOrders;

  PastOrderPage? pastOrderPage;

  void addUpcomingOrderListener() {
    fsService.databaseRef
        .collection("customers")
        .doc(APPSetting().customerUID)
        .collection("activeOrders")
        .snapshots()
        .listen((changeSnapshot) {
      print(changeSnapshot.docs.length);
      futureOrders = fetchOrder(changeSnapshot);
    });
  }

  Future<List<Receipt>> fetchOrder(QuerySnapshot changeSnapshot) async {
    List<Future<Receipt?>> futures = [];
    changeSnapshot.docChanges.forEach((change) async {
      if (change.type == DocumentChangeType.added) {
        print('TAG 1 added. doc id ${change.doc.id}');
        futures.add(FSService().getReceipt(change.doc.id));

        // setState(() {});
      }
      if (change.type == DocumentChangeType.modified) {
        final data = change.doc.data();
        OrderStatus? newStatus =
            OrderStatusExt.statusFromRawValue(data?['status'] as int);
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
            OrderManager().addReceipt(activeReceipts.removeAt(index));
            // DO SOMETHING HERE
          }
        });
      }
    });

    await Future.wait(futures).then((receipts) {
      if (receipts.isNotEmpty) {
        receipts.forEach((element) {
          if (element != null) activeReceipts.add(element);
        });
      }
      // activeReceipts = activeReceipts..addAll(receipts);
      print('TAG 3.did add order, COUNT ${activeReceipts.length}');
      // print('TAG 3.did add order, COUNT ${futureOrders?.toString() ?? 0}');
      setState(() {});
    });

    return activeReceipts;
  }

  @override
  void initState() {
    FSService().getPastReceipts();
    addUpcomingOrderListener();
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // final changeSnapshot = Provider.of<QuerySnapshot>(context);
    // futureOrders = fetchOrder(changeSnapshot);

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
                      return UpcomingOrderPage(snapshot.data!);
                    } else {
                      return Center(
                        child: Text('loading'),
                      );
                    }
                  },
                ),
              ),
              SafeArea(
                child: ChangeNotifierProvider.value(
                  value: OrderManager(),
                  child: Consumer<OrderManager>(
                    builder: (context, orderManager, child) =>
                        PastOrderPage(orderManager.pastOrders),
                  ),
                ),
              )
            ])),
      ),
    );
  }
}
