import 'dart:math';
import 'package:cafe_hollywood/models/table.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
// import 'package:cafe_hollywood/test.dart';
import 'package:cafe_hollywood/screens/OrderHistory/order_page.dart';
import 'package:cafe_hollywood/screens/cart/cart_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/screens/home/home.dart';
import 'package:cafe_hollywood/screens/menu/menuPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class MainTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    // );
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: MainTabHome(),
      ),
    );
  }
}

class MainTabHome extends StatefulWidget {
  @override
  _MainTabHomeState createState() => _MainTabHomeState();
}

class _MainTabHomeState extends State<MainTabHome> {
  bool isButtonsCollapsed = true;
  bool isButtonHidden = true;
  MenuPage menuPage = MenuPage();
  CartPage cartPage = CartPage();
  OrderHistoryPage orderHistoryPage = OrderHistoryPage();
  // OrderHistoryWrapper historywrapper = OrderHistoryWrapper();
  CupertinoTabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = new CupertinoTabController();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

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
    FSService().checkIfTableDoesExist(num);
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

  void onlineOrderTapped() {
    print('setting state');
    _controller!.index = 1;
  }

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.shortestSide * 0.5;
    // double radiusWithPadding = radius - 30;
    double padding = 16;
    double sin120 = sin(120 * pi / 180);
    double cos120 = cos(120 * pi / 180);

    const double buttonWidth = 36.0;
    return Stack(
      children: [
        CupertinoTabScaffold(
            controller: _controller,
            tabBar: CupertinoTabBar(
              // iconSize: 30,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home), label: 'HOME'),
                BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/menu.png')),
                    label: 'MENU'),
                BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.circle,
                      color: Colors.transparent,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.cart), label: 'CART'),
                BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/invoice.png')),
                    label: 'ORDERS'),
              ],
            ),
            tabBuilder: (context, index) {
              // index = _currentIndex;
              return CupertinoTabView(builder: (context) {
                switch (index) {
                  case 0: //Home
                    return HomePage(onlineOrderTapped);
                  case 1: //Menu
                    return menuPage;
                  case 3: //Cart
                    return cartPage;
                  case 4: //Order historywrapper
                    return orderHistoryPage;
                  default:
                    return HomePage(onlineOrderTapped);
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
          left: radius - 18,
          // height: buttonWidth,
          // width: buttonWidth,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutSine,
          child: Opacity(
            opacity: isButtonHidden ? 0.0 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    print(DineInTable().tableOrders.length);
                    DineInTable().tableOrders.forEach((element) {
                      print(element.meals);
                      print(element.orderID);
                    });
                  },
                  child: ImageIcon(
                    AssetImage('assets/order.png'),
                    color: Colors.orange,
                    size: 36,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  isButtonsCollapsed ? '' : 'Orders',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      backgroundColor: Colors.black),
                ),
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
                GestureDetector(
                  onTap: () {},
                  child: ImageIcon(
                    AssetImage('assets/waiter.png'),
                    color: Colors.orange,
                    size: 36,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  isButtonsCollapsed ? '' : 'Waiter',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      backgroundColor: Colors.black),
                ),
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
                GestureDetector(
                  onTap: () {},
                  child: ImageIcon(
                    AssetImage('assets/receipt.png'),
                    color: Colors.orange,
                    size: 36,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  isButtonsCollapsed ? '' : 'Check',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      backgroundColor: Colors.black),
                ),
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
                GestureDetector(
                  onTap: () {},
                  child: ImageIcon(
                    AssetImage('assets/note.png'),
                    color: Colors.orange,
                    size: 36,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  isButtonsCollapsed ? '' : 'Others',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      backgroundColor: Colors.black),
                ),
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
                GestureDetector(
                  onTap: () {},
                  child: ImageIcon(
                    AssetImage('assets/water.png'),
                    color: Colors.orange,
                    size: 36,
                  ),
                ),
                SizedBox(height: 4),
                Text(isButtonsCollapsed ? '' : 'Water',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        backgroundColor: Colors.black)),
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
              child: GestureDetector(
                onTap: () {
                  // scanQRCode();
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => QRScanPage()));

                  setState(() {
                    if (isButtonsCollapsed) {
                      isButtonHidden = false;
                    }
                    isButtonsCollapsed = !isButtonsCollapsed;
                  });
                },
                child: ImageIcon(AssetImage('assets/mainButton.png'),
                    color: Colors.black),
              ),

              //  FloatingActionButton(
              //   heroTag: 'midButton',
              //   backgroundColor: Colors.black,
              //   child: Icon(
              //     Icons.add,
              //   ),
              //   elevation: 0,
              //   onPressed: () {
              //     //TODO: SHOW CONTAINER OF 5 BUTTONS ON TOP OR OPENS CAMERA
              //     scanQRCode();
              //     // Navigator.push(context,
              //     //     MaterialPageRoute(builder: (context) => QRScanPage()));

              //     // setState(() {
              //     //   if (isButtonsCollapsed) {
              //     //     isButtonHidden = false;
              //     //   }
              //     //   isButtonsCollapsed = !isButtonsCollapsed;
              //     // });
              //   },
              // ),
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
