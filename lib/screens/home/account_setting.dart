import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountSettingPage extends StatefulWidget {
  @override
  _AccountSettingPageState createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Center(child: Text('account')),
    );
  }
}
