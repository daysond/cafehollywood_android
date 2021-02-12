import 'package:cafe_hollywood/models/custom_option.dart';
import 'package:cafe_hollywood/screens/cart/checkout_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:cafe_hollywood/screens/cart/cart_total_widget.dart';
import 'package:cafe_hollywood/models/cart.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  void handlePlaceOrder() {}

  void handleOptionTap(CustomOption option) {
    print(option.mainImageName);
  }

  CustomOption cutlery = CustomOption(
      'UTENSILS, STRAWS, ETC', 'cutlery', 'Yes please!', OptionType.utensil);
  CustomOption pickupTime =
      CustomOption('PICK UP TIME', 'clock', 'Now', OptionType.scheduler);
  CustomOption note =
      CustomOption('NOTE', 'notes', '(Any food alergy?)', OptionType.note);

  @override
  Widget build(BuildContext context) {
    final List<CustomOption> options = [cutlery, pickupTime, note];
    return CupertinoPageScaffold(
        child: SafeArea(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisAlignment: MainAxisAlignment.start,
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
                        'Summary',
                        style: TextStyle(fontSize: 24, color: Colors.black),
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
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return CheckoutOptionTile(
                            options[index], handleOptionTap);
                      }),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8.0, 16),
                child: CartTotalPanel()),
          ),
          Container(
              margin: EdgeInsets.only(bottom: 8),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: BlackButton('Place Order', handlePlaceOrder, true)),
        ],
      ),
    ));
  }
}
