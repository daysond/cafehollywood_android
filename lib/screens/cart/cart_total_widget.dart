import 'package:cafe_hollywood/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartTotalPanel extends StatelessWidget {
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
          makeRow('Subtotal', Cart().cartSubtotal.toStringAsFixed(2), false),
          SizedBox(height: 8),
          makeRow(
              'Promotion', Cart().promotionAmount.toStringAsFixed(2), false),
          SizedBox(height: 8),
          makeRow(
              'Drinks Credit', Cart().discountAmount.toStringAsFixed(2), false),
          SizedBox(height: 8),
          makeRow('Taxes', Cart().cartTaxes.toStringAsFixed(2), false),
          SizedBox(height: 8),
          makeRow('Total', Cart().cartTotal.toStringAsFixed(2), true),
        ],
      ),
    );
  }
}
