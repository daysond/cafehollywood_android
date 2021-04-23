import 'package:cafe_hollywood/models/cart.dart';
import 'package:cafe_hollywood/models/receipt.dart';
import 'package:cafe_hollywood/models/table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartTotalPanel extends StatelessWidget {
  Receipt? receipt;
  bool isTable;
  String subtotal = '';
  String total = '';
  String tax = '';
  String discount = '';
  String promotion = '';

  CartTotalPanel(this.isTable, {this.receipt});

  void setValue() {
    if (isTable) {
      subtotal = DineInTable().subTotal.toStringAsFixed(2);
      total = DineInTable().total.toStringAsFixed(2);
      tax = DineInTable().taxes.toStringAsFixed(2);
      promotion = DineInTable().promotionAmount.toStringAsFixed(2);
      discount = DineInTable().discountAmount.toStringAsFixed(2);
    } else {
      // online or receipt
      subtotal = receipt == null
          ? Cart().cartSubtotal.toStringAsFixed(2)
          : receipt!.subtotal.toStringAsFixed(2);
      promotion = receipt == null
          ? '-${Cart().promotionAmount.toStringAsFixed(2)}'
          : '-${receipt!.promotion.toStringAsFixed(2)}';
      discount = receipt == null
          ? '-${Cart().discountAmount.toStringAsFixed(2)}'
          : '-${receipt!.discount.toStringAsFixed(2)}';
      total = receipt == null
          ? Cart().cartTotal.toStringAsFixed(2)
          : receipt!.total.toStringAsFixed(2);
      tax = receipt == null
          ? Cart().cartTaxes.toStringAsFixed(2)
          : receipt!.taxes.toStringAsFixed(2);
    }
  }

  Widget makeRow(String heading, String price, bool bold) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Text(heading,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: bold ? FontWeight.bold : FontWeight.normal))),
        Text('\$ ${price}',
            style: TextStyle(
                fontSize: 16,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    setValue();
    return ChangeNotifierProvider.value(
      value: Cart(),
      child: Column(
        children: [
          makeRow('Subtotal', subtotal, false),
          SizedBox(height: 8),
          makeRow('Promotion', promotion, false),
          SizedBox(height: 8),
          makeRow('Drinks Credit', discount, false),
          SizedBox(height: 8),
          makeRow('Taxes', tax, false),
          SizedBox(height: 8),
          makeRow('Total', total, true),
        ],
      ),
    );
  }
}
