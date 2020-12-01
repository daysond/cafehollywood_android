import 'dart:math';

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
    double radius = MediaQuery.of(context).size.shortestSide * 0.5;
    // double radiusWithPadding = radius - 30;
    double padding = 16;
    double sin120 = sin(120 * pi / 180);
    double cos120 = cos(120 * pi / 180);
    const double buttonWidth = 50.0;
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
                            if (Navigator.of(context) == null) {
                              return;
                            }

                            Navigator.of(context)!
                                .push(CupertinoPageRoute(builder: (context) {
                              return DetailScreen(index.toString());
                            }));
                          },
                        )));
                }
              });
            }),
        AnimatedPositioned(
          bottom: isButtonsCollapsed ? 0 : (radius - padding),
          left: radius - 25,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutSine,
          child: Container(
            height: buttonWidth,
            width: buttonWidth,
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
        ),
        AnimatedPositioned(
          bottom: isButtonsCollapsed ? 0 : (radius - padding) * sin120,
          left: isButtonsCollapsed
              ? radius - buttonWidth / 2
              : radius + (radius - padding) * cos120 - buttonWidth / 2,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutSine,
          child: Container(
            height: 50,
            width: 50,
            color: Colors.amber,
            alignment: Alignment.center,
            child: FloatingActionButton(
              child: Icon(
                Icons.account_box,
              ),
              elevation: 0,
              onPressed: () {
                //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
                print('pressed');
              },
            ),
          ),
        ),
        AnimatedPositioned(
          bottom: isButtonsCollapsed ? 0 : (radius - padding) * sin120,
          left: isButtonsCollapsed
              ? radius - buttonWidth / 2
              : radius - (radius - padding) * cos120 - buttonWidth / 2,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutSine,
          child: Container(
            height: 50,
            width: 50,
            color: Colors.green,
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
        ),
        AnimatedPositioned(
          bottom: isButtonsCollapsed ? 0 : (radius - padding) * -cos120,
          left: isButtonsCollapsed
              ? radius - 25
              : radius - (radius - padding) * -sin120 - buttonWidth / 2,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutSine,
          child: Container(
            height: 50,
            width: 50,
            color: Colors.yellow,
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
        ),
        AnimatedPositioned(
          bottom: isButtonsCollapsed ? 0 : (radius - padding) * -cos120,
          left: isButtonsCollapsed
              ? radius - 25
              : radius - (radius - padding) * sin120 - buttonWidth / 2,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutSine,
          child: Container(
            height: 50,
            width: 50,
            color: Colors.purple,
            alignment: Alignment.center,
            child: FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              elevation: 0,
              onPressed: () {
                //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
                print('pressssssssssssssssssed');
              },
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              elevation: 0,
              onPressed: () {
                //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
                print('pressedddddddd');
                setState(() {
                  isButtonsCollapsed = !isButtonsCollapsed;
                });
              },
            )),
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
