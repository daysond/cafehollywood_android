import 'dart:math';
import 'package:cafe_hollywood/models/table.dart';
import 'package:cafe_hollywood/screens/MainTab/table_order_page.dart';
import 'package:cafe_hollywood/screens/OrderHistory/order_tab_wrapper.dart';
import 'package:cafe_hollywood/screens/auth_screens/authHome.dart';
import 'package:cafe_hollywood/services/app_setting.dart';
import 'package:cafe_hollywood/services/auth.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
import 'package:cafe_hollywood/screens/OrderHistory/order_page.dart';
import 'package:cafe_hollywood/screens/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_hollywood/screens/home/home.dart';
import 'package:cafe_hollywood/screens/menu/menuPage.dart';
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
      resizeToAvoidBottomInset: false,
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
  final GlobalKey<NavigatorState> homeTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> menuTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> cartTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> orderTabNavKey = GlobalKey<NavigatorState>();
  final _msgController = TextEditingController();
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
    startUpChecks();
    _controller = new CupertinoTabController();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void startUpChecks() {
    // FSService().addReservationListener()
    print('doing start up checks');
    FSService().checkActiveTable();
    FSService().addunavailablityListener();
    FSService().getCurrentVersions();
    APPSetting().update();
  }

  void _updateButtonState() {
    setState(() {
      if (isButtonsCollapsed) {
        isButtonHidden = false;
      }
      isButtonsCollapsed = !isButtonsCollapsed;
    });
  }

  void showInputDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("How can we help you?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[TextField(controller: _msgController)],
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            style: TextButton.styleFrom(
                primary: Colors.black,
                textStyle: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("submit"),
            style: TextButton.styleFrom(
                primary: Colors.black,
                textStyle: TextStyle(color: Colors.white)),
            // textColor: Colors.white,
            // color: Colors.black,
            onPressed: () {
              // sendRequest();
              if (DineInTable().tableNumber != null) {
                String req = DineInTable().tableNumber! +
                    ': ' +
                    _msgController.text.trim();
                FSService().sendRequest(req);
              }

              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void sendRequest(String text) {
    _updateButtonState.call();
    if (DineInTable().tableNumber == null) return;
    String req = 'Table ${DineInTable().tableNumber} request ${text}';
    FSService().sendRequest(req);
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
    FSService().checkIfTableDoesExist(num).then((value) {
      print('table exist: ${value}');
    });
  }

  void displayErrorMessage(String msg) {}

  void onlineOrderTapped() {
    _controller!.index = 1;
    print('hours :${APPSetting().businessHours.toString()}');
    print('hst :${APPSetting().hstRate.toString()}');
    print('mini: ${APPSetting().miniPurchase.toString()}');
    print('fed tax: ${APPSetting().federalTaxRate.toString()}');
    print('drink :${APPSetting().drinkCreditAmount.toString()}');
    print('wing :${APPSetting().wingCreditAmout.toString()}');
    print('version : ${APPSetting().versions.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.shortestSide * 0.5;
    // double radiusWithPadding = radius - 30;
    double padding = 16;
    double sin120 = sin(120 * pi / 180);
    double cos120 = cos(120 * pi / 180);

    final listOfKeys = [
      homeTabNavKey,
      menuTabNavKey,
      homeTabNavKey,
      cartTabNavKey,
      orderTabNavKey
    ];

    const double buttonWidth = 36.0;
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            return !await listOfKeys[_controller!.index]
                .currentState!
                .maybePop();
          },
          child: CupertinoTabScaffold(
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
                return CupertinoTabView(
                    navigatorKey: listOfKeys[index],
                    builder: (context) {
                      switch (index) {
                        case 0: //Home
                          return HomePage(onlineOrderTapped);
                        case 1: //Menu
                          return menuPage;
                        case 3: //Cart
                          return cartPage;
                        case 4: //Order historywrapper
                          return StreamProvider<String>.value(
                            initialData: '',
                            value: AuthService().currentUserID,
                            child: OrderTabWrapper(),
                          );
                        default:
                          return HomePage(onlineOrderTapped);
                      }
                    });
              }),
        ),
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
                    _updateButtonState.call();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TableOrderPage()));
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
                  onTap: () {
                    sendRequest("waiter");
                  },
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
                  onTap: () {
                    sendRequest("bill");
                  },
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
                  onTap: () {
                    _msgController.text = '';
                    _updateButtonState.call();
                    showInputDialog.call();
                  },
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
            setState(() {
              isButtonHidden = isButtonsCollapsed;
            });
          },
          child: Opacity(
            opacity: isButtonHidden ? 0.0 : 1.0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    sendRequest("water refill");
                  },
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
                  if (AuthService().customerID == null) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                              title: Text('Account Required.'),
                              content: Text(
                                  'Please log in first to use this feature.'),
                              actions: [
                                TextButton(
                                  child: Text("Log in/Sign up"),
                                  style: TextButton.styleFrom(
                                      primary: Colors.black,
                                      textStyle:
                                          TextStyle(color: Colors.white)),
                                  // textColor: Colors.white,
                                  // color: Colors.black,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // to pop the dialog box
                                    AuthHomePage.showAuthHome(context);
                                  },
                                ),
                                TextButton(
                                  child: Text("Cancel"),
                                  style: TextButton.styleFrom(
                                      primary: Colors.black,
                                      textStyle:
                                          TextStyle(color: Colors.white)),
                                  // textColor: Colors.white,
                                  // color: Colors.black,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // to pop the dialog box
                                  },
                                ),
                              ],
                            ));
                    return;
                  }

                  if (DineInTable().tableNumber == null) {
                    scanQRCode();
                    // DineInTable().tableNumber = '12';
                    // FSService().addTableListener();
                    // print('did set table to 12');
                  } else {
                    _updateButtonState.call();
                  }

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => QRScanPage()));
                },
                child: ImageIcon(AssetImage('assets/mainButton.png'),
                    color: Colors.black),
              ),
            )),
      ],
    );
  }
}
