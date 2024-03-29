import 'package:cafe_hollywood/models/enums/order_status.dart';
import 'package:cafe_hollywood/models/meal_info.dart';
import 'package:cafe_hollywood/models/receipt.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ReceiptTile extends StatefulWidget {
  Receipt receipt;
  void Function(Receipt) handleReceiptTapped;
  ReceiptTile(this.receipt, this.handleReceiptTapped);
  @override
  _ReceiptTileState createState() => _ReceiptTileState();
}

class _ReceiptTileState extends State<ReceiptTile> {
  void showReceiptDetail() {
    print("show details");
    widget.handleReceiptTapped(widget.receipt);
  }

  Widget _buildHeader() {
    var date = DateTime.fromMicrosecondsSinceEpoch(
        int.parse(widget.receipt.orderTimestamp) * 1000);
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Cafe Hollywood',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}  Order# ${widget.receipt.orderID}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/${widget.receipt.status.image}.png',
                    width: 18,
                    height: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${widget.receipt.status.status}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _mealInfoToWidget(MealInfo info) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('${info.quantity} ${info.name}'),
    );
  }

  Widget _buildItemList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.receipt.mealsInfo.map(_mealInfoToWidget).toList(),
    );
    // return ListView.builder(
    //   padding: const EdgeInsets.all(8),
    //   itemCount: widget.receipt.mealsInfo.length,
    //   itemBuilder: (context, index) {
    //     return Container(
    //       height: 40,
    //       child:
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          _buildItemList(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total: \$${widget.receipt.total.toStringAsFixed(2)}'),
          ),
          BlackButton('View Receipt Detail', showReceiptDetail, true),
        ],
      ),
    );
  }
}
