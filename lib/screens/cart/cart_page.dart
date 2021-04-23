import 'package:cafe_hollywood/models/cart.dart';
import 'package:cafe_hollywood/models/table.dart';
import 'package:cafe_hollywood/screens/auth_screens/authHome.dart';
import 'package:cafe_hollywood/screens/cart/cart_item_tile.dart';
import 'package:cafe_hollywood/screens/cart/cart_total_widget.dart';
import 'package:cafe_hollywood/screens/cart/checkout_page.dart';
import 'package:cafe_hollywood/screens/shared/black_button.dart';
import 'package:cafe_hollywood/services/app_setting.dart';
import 'package:cafe_hollywood/services/auth.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isButtonEnable = true;
  String buttonTitle = '';
  void checkout() async {
    if (!AuthService().isAuth) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => AuthHomePage()));
    } else {
      if (DineInTable().tableNumber == null) {
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => CheckoutPage()));
      } else {
        // send order
        FSService().sendOrder(context);
      }
    }
  }

  void updatePage() {
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

  void setButton() {
    if (APPSetting().isRestaurantOpen == false) {
      isButtonEnable = false;
      buttonTitle = "Kitchen Closed";
    } else {
      isButtonEnable = true;
      buttonTitle =
          DineInTable().tableNumber == null ? 'Check Out' : 'Send Order';
    }
  }

  @override
  Widget build(BuildContext context) {
    Cart().addListener(updatePage);
    setButton();
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
                child: CartTotalPanel(false)),
          if (Cart().meals.length != 0)
            Container(
                margin: EdgeInsets.only(bottom: 8),
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: BlackButton(buttonTitle, checkout, isButtonEnable)),
        ],
      ),
    ));
  }
}
