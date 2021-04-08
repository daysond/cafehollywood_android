import 'package:cafe_hollywood/models/cart.dart';
import 'package:cafe_hollywood/models/receipt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartTotalPanel extends StatelessWidget {
  Receipt? receipt;
  CartTotalPanel({this.receipt});
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
    return ChangeNotifierProvider.value(
      value: Cart(),
      child: Column(
        children: [
          makeRow(
              'Subtotal',
              receipt == null
                  ? Cart().cartSubtotal.toStringAsFixed(2)
                  : receipt!.subtotal.toStringAsFixed(2),
              false),
          SizedBox(height: 8),
          makeRow(
              'Promotion',
              receipt == null
                  ? '-${Cart().promotionAmount.toStringAsFixed(2)}'
                  : '-${receipt!.promotion.toStringAsFixed(2)}',
              false),
          SizedBox(height: 8),
          makeRow(
              'Drinks Credit',
              receipt == null
                  ? '-${Cart().discountAmount.toStringAsFixed(2)}'
                  : '-${receipt!.discount.toStringAsFixed(2)}',
              false),
          SizedBox(height: 8),
          makeRow(
              'Taxes',
              receipt == null
                  ? Cart().cartTaxes.toStringAsFixed(2)
                  : receipt!.taxes.toStringAsFixed(2),
              false),
          SizedBox(height: 8),
          makeRow(
              'Total',
              receipt == null
                  ? Cart().cartTotal.toStringAsFixed(2)
                  : receipt!.total.toStringAsFixed(2),
              true),
        ],
      ),
    );
  }
}
