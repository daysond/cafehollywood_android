import 'dart:math';
import 'package:cafe_hollywood/models/table.dart';
import 'package:cafe_hollywood/screens/OrderHistory/order_history_wrapper.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
import 'package:cafe_hollywood/test.dart';
import 'package:cafe_hollywood/screens/OrderHistory/order_page.dart';
import 'package:cafe_hollywood/screens/cart/cart_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/screens/home/home.dart';
import 'package:cafe_hollywood/screens/menu/menuPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

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
  bool isButtonHidden = true;
  HomePage home = HomePage();
  MenuPage menuPage = MenuPage();
  CartPage cartPage = CartPage();
  OrderHistoryPage orderHistoryPage = OrderHistoryPage();
  OrderHistoryWrapper historywrapper = OrderHistoryWrapper();

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        false,
        ScanMode.QR,
      );

      if (!mounted) return;

      handleQRCodeData(qrCode);
    } on PlatformException {
      String msg = 'Failed to get platform version.';
      displayErrorMessage(msg);
    }
  }

  void handleQRCodeData(String data) {
    String defaultURL =
        'http://www.enjoy2eat.ca/hollywood2/index.php?route=common/home&table=';
    String url = data.substring(0, data.length - 2);
    String num = data.substring(data.length - 2, data.length);

    if (defaultURL != url || num.length != 2) {
      displayErrorMessage('Invalid QR Code.');
      return;
    }

    DineInTable().tableNumber = num;
    FSService().checkIfTableDoesExist();
    // NetworkManager.shared.checkIfTableDoesExist(completion: { (error, tableExists) in

    //     guard error == nil else {
    //         print(error!.localizedDescription)
    //         self.delegate?.failedReadingQRCode()
    //         return
    //     }

    //     if let tableExists = tableExists {

    //         switch tableExists {
    //         case true:

    //             NetworkManager.shared.addTableListener()

    //             self.delegate?.found()

    //         default:

    //             self.delegate?.found()

    //         }

    //     }

    // })
  }

  void displayErrorMessage(String msg) {}

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
                    return home;
                  case 1: //Menu
                    return menuPage;
                  case 3: //Cart
                    return cartPage;
                  case 4: //Order historywrapper
                    return historywrapper;
                  // return StreamProvider<QuerySnapshot>.value(
                  //     value: FSService().activeOrderSnapshots,
                  //     child: OrderHistoryPage());

                  // default:
                  //   return CupertinoPageScaffold(
                  //       navigationBar: CupertinoNavigationBar(
                  //         middle: Text(index.toString()),
                  //       ),
                  //       child: Center(
                  //           child: Text(
                  //             'this is button $index',
                  //             style: CupertinoTheme.of(context)
                  //                 .textTheme
                  //                 .actionTextStyle
                  //                 .copyWith(fontSize: 32),
                  //           )));
                }
              });
            }),
        AnimatedPositioned(
          bottom: isButtonsCollapsed ? -26 : (radius - padding),
          left: radius - 25,
          // height: buttonWidth,
          // width: buttonWidth,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutSine,
          child: Opacity(
            opacity: isButtonHidden ? 0.0 : 1.0,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'action1',
                  child: Icon(
                    Icons.add,
                  ),
                  elevation: 0,
                  onPressed: () {
                    //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
                    print('pressed');
                  },
                ),
                Text(isButtonsCollapsed ? '' : 'this'),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          bottom: isButtonsCollapsed ? -26 : (radius - padding) * sin120,
          left: isButtonsCollapsed
              ? radius - buttonWidth / 2
              : radius + (radius - padding) * cos120 - buttonWidth / 2,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutSine,
          child: Opacity(
            opacity: isButtonHidden ? 0.0 : 1.0,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'action2',
                  child: Icon(
                    Icons.account_box,
                  ),
                  elevation: 0,
                  onPressed: () {
                    //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
                    print('pressed');
                  },
                ),
                Text(isButtonsCollapsed ? '' : 'this'),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          bottom: isButtonsCollapsed ? -26 : (radius - padding) * sin120,
          left: isButtonsCollapsed
              ? radius - buttonWidth / 2
              : radius - (radius - padding) * cos120 - buttonWidth / 2,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutSine,
          child: Opacity(
            opacity: isButtonHidden ? 0.0 : 1.0,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'action3',
                  child: Icon(
                    Icons.add,
                  ),
                  elevation: 0,
                  onPressed: () {
                    //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
                    print('pressed');
                  },
                ),
                Text(isButtonsCollapsed ? '' : 'this'),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          bottom: isButtonsCollapsed ? -26 : (radius - padding) * -cos120,
          left: isButtonsCollapsed
              ? radius - 25
              : radius - (radius - padding) * -sin120 - buttonWidth / 2,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutSine,
          child: Opacity(
            opacity: isButtonHidden ? 0.0 : 1.0,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'action4',
                  child: Icon(
                    Icons.add,
                  ),
                  elevation: 0,
                  onPressed: () {
                    //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
                    print('pressed');
                  },
                ),
                Text(isButtonsCollapsed ? '' : 'this'),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          bottom: isButtonsCollapsed ? -26 : (radius - padding) * -cos120,
          left: isButtonsCollapsed
              ? radius - 25
              : radius - (radius - padding) * sin120 - buttonWidth / 2,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutSine,
          onEnd: () {
            print('ended');
            setState(() {
              isButtonHidden = isButtonsCollapsed;
            });
          },
          child: Opacity(
            opacity: isButtonHidden ? 0.0 : 1.0,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'action5',
                  child: Icon(
                    Icons.add,
                  ),
                  elevation: 0,
                  onPressed: () {
                    //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
                    print('pressssssssssssssssssed');
                  },
                ),
                Text(isButtonsCollapsed ? '' : 'this'),
              ],
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // color: Colors.red,
              width: MediaQuery.of(context).size.width / 5.0,
              height: kToolbarHeight + 4,
              child: FloatingActionButton(
                heroTag: 'midButton',
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.add,
                ),
                elevation: 0,
                onPressed: () {
                  //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
                  scanQRCode();
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => QRScanPage()));

                  // setState(() {
                  //   if (isButtonsCollapsed) {
                  //     isButtonHidden = false;
                  //   }
                  //   isButtonsCollapsed = !isButtonsCollapsed;
                  // });
                },
              ),
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
