import 'package:cafe_hollywood/models/enums/setting_field.dart';
import 'package:cafe_hollywood/screens/auth_screens/setting_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cafe_hollywood/services/app_setting.dart';

class SettingPage extends StatelessWidget {
  List<SettingField> fields = [
    SettingField.name,
    SettingField.phone,
    SettingField.filler,
    SettingField.favourite,
    SettingField.reservation,
    SettingField.filler,
    SettingField.about,
    SettingField.instagram,
    SettingField.filler,
    SettingField.logOut,
  ];
  @override
  Widget build(BuildContext context) {
    // return Scaffold(

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: new NestedScrollView(
          physics: ScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                backgroundColor: Colors.grey[100],
                iconTheme: IconThemeData(color: Colors.black),
                title: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Hi, ${APPSetting().customerName}',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
                floating: false,
                // toolbarHeight: 80,
                // forceElevated: true,
                pinned: true,

                // snap: false,
              ),
            ];
          },
          body: ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                return SettingTile(fields[index]);
              }),
        ),
      ),
    );
    //   body: SafeArea(
    //     child: new NestedScrollView(
    //       physics: ScrollPhysics(),
    //       headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //         return <Widget>[
    //           new SliverAppBar(
    //             backgroundColor: Colors.white,
    //             iconTheme: IconThemeData(color: Colors.black),
    //             title: Padding(
    //               padding: const EdgeInsets.only(left: 8),
    //               child: Text(
    //                 'Hi',
    //                 style: TextStyle(fontSize: 28, color: Colors.black),
    //               ),
    //             ),
    //             floating: false,
    //             // toolbarHeight: 80,
    //             // forceElevated: true,
    //             pinned: true,

    //             // snap: false,
    //           ),
    //         ];
    //       },
    //       body: ListView.builder(
    //           itemCount: fields.length,
    //           itemBuilder: (context, index) {
    //             return SettingTile(fields[index]);
    //           }),
    //     ),
    //   ),
    // );
  }
}
