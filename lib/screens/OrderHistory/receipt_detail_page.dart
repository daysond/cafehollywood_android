import 'package:cafe_hollywood/models/receipt.dart';
import 'package:cafe_hollywood/screens/OrderHistory/receipt_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:cafe_hollywood/screens/cart/cart_total_widget.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/screens/cart/cart_item_tile.dart';

class ReceiptDetailPage extends StatelessWidget {
  Receipt receipt;
  ReceiptDetailPage(this.receipt);

  @override
  Widget build(BuildContext context) {
    void closeReceipt() {
      Navigator.pop(context);
    }

    var date = DateTime.fromMicrosecondsSinceEpoch(
        int.parse(receipt.orderTimestamp) * 1000);

    return CupertinoPageScaffold(
        child: SafeArea(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: new NestedScrollView(
              physics: ScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  new SliverAppBar(
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: Colors.black),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '${receipt.orderID}   ${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    floating: true,
                    // toolbarHeight: 80,
                    // forceElevated: true,
                    pinned: true,

                    // snap: false,
                  ),
                ];
              },
              body: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ListView.builder(
                      itemCount: receipt.mealsInfo.length,
                      itemBuilder: (context, index) {
                        return ReceiptItemTile(receipt.mealsInfo[index]);
                      }),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8.0, 16),
              child: CartTotalPanel(
                receipt: receipt,
              )),
          Container(
              margin: EdgeInsets.only(bottom: 8),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: BlackButton('Close Receipt', closeReceipt, true)),
        ],
      ),
    ));
  }
}
