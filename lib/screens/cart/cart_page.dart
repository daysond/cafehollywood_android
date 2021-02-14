import 'package:cafe_hollywood/models/cart.dart';
import 'package:cafe_hollywood/screens/cart/cart_item_tile.dart';
import 'package:cafe_hollywood/screens/cart/cart_total_widget.dart';
import 'package:cafe_hollywood/screens/cart/checkout_page.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void checkout() {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => CheckoutPage()));
  }

  void updatePage() {
    print('cart page being called');
    if (!mounted) return;
    // if (Cart().meals.isEmpty) {
    //   Navigator.pop(context);
    //   return;
    // }
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('cart disposed');
    Cart().removeListener(updatePage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Cart().addListener(updatePage);
    // return CupertinoPageScaffold(child: CustomScrollView());
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
                        'Items',
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
                child: Cart().meals.length == 0
                    ? Align(
                        alignment: Alignment.center,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Image(
                            height: 100,
                            width: 100,
                            image: AssetImage('assets/cart.png'),
                          ),
                          SizedBox(height: 8),
                          Text('Your cart is empty.'),
                        ]),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ChangeNotifierProvider.value(
                          value: Cart(),
                          child: ListView.builder(
                              itemCount: Cart().meals.length,
                              itemBuilder: (context, index) {
                                return CartItemTile(Cart().meals[index]);
                              }),
                        ),
                      ),
              ),
            ),
          ),
          if (Cart().meals.length != 0)
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8.0, 16),
                child: CartTotalPanel()),
          if (Cart().meals.length != 0)
            Container(
                margin: EdgeInsets.only(bottom: 8),
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: BlackButton('Check Out', checkout, true)),
        ],
      ),
    ));
  }
}
