import 'package:cafe_hollywood/models/receipt.dart';
import 'package:cafe_hollywood/screens/OrderHistory/receipt_tile.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class UpcomingOrderPage extends StatefulWidget {
  List<Receipt> orders = [];
  UpcomingOrderPage(this.orders);
  @override
  _UpcomingOrderPageState createState() => _UpcomingOrderPageState();
}

class _UpcomingOrderPageState extends State<UpcomingOrderPage> {
  // ScrollController _scrollController = ScrollController();

  void handleReceiptTapped(Receipt receipt) {}
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        child: CustomScrollView(
          // controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    //  Text(index.toString()),
                    ReceiptTile(widget.orders[index], handleReceiptTapped),
                childCount: widget.orders.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
