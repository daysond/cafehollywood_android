import 'package:cafe_hollywood/screens/OrderHistory/order_page.dart';
import 'package:cafe_hollywood/screens/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/screens/home/home.dart';
import 'package:cafe_hollywood/screens/menu/menuPage.dart';

class MainTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    );

    return MainTabHome();
  }
}

class MainTabHome extends StatefulWidget {
  @override
  _MainTabHomeState createState() => _MainTabHomeState();
}

class _MainTabHomeState extends State<MainTabHome> {
  bool isButtonsCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              // iconSize: 30,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home), label: 'HOME'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.list_bullet), label: 'MENU'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.list_bullet), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.cart), label: 'CART'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.money_dollar), label: 'ORDERS'),
              ],
            ),
            tabBuilder: (context, index) {
              return CupertinoTabView(builder: (context) {
                switch (index) {
                  case 0: //Home
                    return HomePage();
                  case 1: //Menu
                    return MenuPage();
                  case 3: //Cart
                    return CartPage();
                  case 4: //Order History
                    return OrderHistoryPage();

                  default:
                    return CupertinoPageScaffold(
                        navigationBar: CupertinoNavigationBar(
                          middle: Text(index.toString()),
                        ),
                        child: Center(
                            child: CupertinoButton(
                          child: Text(
                            'this is button $index',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .actionTextStyle
                                .copyWith(fontSize: 32),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .push(CupertinoPageRoute(builder: (context) {
                              return DetailScreen(index.toString());
                            }));
                          },
                        )));
                }
              });
            }),
        Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              elevation: 0,
              onPressed: () {
                //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
                print('pressed');
              },
            )),
        Positioned(
          bottom: MediaQuery.of(context).size.width / 2 - 32,
          left: MediaQuery.of(context).size.width / 2.0 - 25,
          child: Container(
            height: 50,
            width: 50,
            color: Colors.red,
            alignment: Alignment.center,
            child: FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              elevation: 0,
              onPressed: () {
                //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
                print('pressed');
              },
            ),
          ),
        )
      ],
    );
  }
}

class DetailScreen extends StatefulWidget {
  const DetailScreen(this.topic);
  final String topic;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Details'),
      ),
      child: Center(
        child: Text('details for ${widget.topic}'),
      ),
    );
  }
}
