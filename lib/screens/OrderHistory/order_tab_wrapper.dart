import 'package:cafe_hollywood/screens/OrderHistory/order_page.dart';
import 'package:cafe_hollywood/screens/auth_screens/authHome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderTabWrapper extends StatelessWidget {
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthHomePage()));
                        },
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
