import 'package:cafe_hollywood/screens/OrderHistory/order_page.dart';
import 'package:cafe_hollywood/screens/auth_screens/authHome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderTabWrapper extends StatelessWidget {
  void _showAuthHome(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        context: context,
        builder: (context) {
          return SafeArea(child: AuthHomePage());
        });
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<String>(context);
    return uid.isNotEmpty
        ? OrderHistoryPage()
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 60,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: Text(
                'Orders',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black, minimumSize: Size(120, 40)),
                        onPressed: () => _showAuthHome(context),
                        child: Text('Sign In/Up')),
                    Text(
                      'Please log in first.',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ]),
            ),
          );
    ;
    // return MainTabBar();
  }
}
