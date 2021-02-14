import 'package:cafe_hollywood/services/auth.dart';

class APPSetting {
  static APPSetting _instance;

  APPSetting._internal() {
    _instance = this;
  }

  factory APPSetting() => _instance ?? APPSetting._internal();

  String get customerUID {
    // return 'sampleID';
    return AuthService().customerID;
  }

  String get customerName {
    return 'flutterAppUserName';
  }

  String get customerPhoneNumber {
    return '1-888-000-0000';
  }
}
