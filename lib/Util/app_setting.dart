class AppSetting {
  static AppSetting? _instance;
  AppSetting._internal() {
    _instance = this;
  }
  factory AppSetting() => _instance ?? AppSetting._internal();

  String customerID = '';
}
