import 'package:flutter/material.dart';
import 'MainTab/main_tab.dart';
import 'auth_screens/authHome.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<String>(context);
    return uid != null ? MainTabBar() : AuthHomePage();
  }
}
