import 'package:cafe_hollywood/models/meal_info.dart';
import 'package:cafe_hollywood/models/receipt.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';
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
  void showReceiptDetail() {}
  Widget _buildHeader() {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Cafe Hollywood',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              '${widget.receipt.orderTimestamp} Order# ${widget.receipt.orderID}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'image',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'status',
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
            child: Text('Total: \$${widget.receipt.total}'),
          ),
          BlackButton('View Receipt Detail', showReceiptDetail, true),
        ],
      ),
    );
  }
}
