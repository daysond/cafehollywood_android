import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/models/receipt.dart';
import 'package:cafe_hollywood/screens/OrderHistory/receipt_tile.dart';

class PastOrderPage extends StatefulWidget {
  List<Receipt> orders = [];

  PastOrderPage(this.orders);

  Void update() {
    print('update');
  }

  @override
  _PastOrderPageState createState() => _PastOrderPageState();
}

class _PastOrderPageState extends State<PastOrderPage> {
  @override
  void handleReceiptTapped(Receipt receipt) {}
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