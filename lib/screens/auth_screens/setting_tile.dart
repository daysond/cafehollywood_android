import 'package:cafe_hollywood/models/enums/setting_field.dart';
import 'package:cafe_hollywood/services/app_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingTile extends StatelessWidget {
  final SettingField field;
  SettingTile(this.field);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('tapped');
      },
      child: Card(
          color: field == SettingField.filler ? Colors.grey[100] : Colors.white,
          elevation: 0,
          margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: field == SettingField.filler
              ? SizedBox(height: 8)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (field == SettingField.name ||
                          field == SettingField.phone)
                        Text(
                          field.text,
                          style:
                              TextStyle(color: Colors.grey[800], fontSize: 14),
                        ),
                      SizedBox(height: 4),
                      Flexible(child: makeRow()),
                      SizedBox(height: 4),
                    ],
                  ),
                )),
    );
  }

  Widget makeRow() {
    String text = '';

    switch (field) {
      case SettingField.name:
        text = APPSetting().customerName;
        break;
      case SettingField.phone:
        text = APPSetting().customerPhoneNumber;
        break;
      default:
        text = field.text;
        break;
    }
    return Row(
      children: [
        Expanded(
            child: Text(
          text,
          style: TextStyle(fontSize: 16),
        )),
        if (field != SettingField.logOut)
          Text('>', style: TextStyle(fontSize: 18))
      ],
    );
  }
}
