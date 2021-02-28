import 'package:cafe_hollywood/models/enums/order_status.dart';
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
  List<Receipt> activeReceipts = [];
  List<Receipt> closedReceipts = [];
  Future<List<Receipt>> futureOrders;
  /*
      private func closeOrder(_ id: String, for status: OrderStatus) {


        activeReceipts.removeAll { (r) -> Bool in
            if r.status == status {
                let timestamp = r.orderTimestamp
                closedReceipts.append(r)
                closedReceipts.sort { $0.orderTimestamp > $1.orderTimestamp }
                NetworkManager.shared.closeOrder(id, status: status, timestamp: timestamp)
            }
            return r.status == status
        }
        receiptsModel.accept(activeReceipts)
        
    }
  
  */

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
        activeReceipts.removeWhere((r) => r.orderID == change.doc.id);
      }
    });

    await Future.wait(futures).then((receipts) {
      activeReceipts = activeReceipts..addAll(receipts);
      print('TAG 3.did add order, COUNT ${activeReceipts.length}');
    });

    return activeReceipts;
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
