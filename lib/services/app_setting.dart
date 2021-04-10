import 'package:cafe_hollywood/models/meal.dart';
import 'package:cafe_hollywood/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APPSetting {
  static APPSetting? _instance;

  APPSetting._internal() {
    _instance = this;
  }

  factory APPSetting() => _instance ?? APPSetting._internal();

  String get customerUID {
    // return 'sampleID';
    return AuthService().customerID;
  }

  String get favouriteListKey {
    return "favouriteList${customerUID}";
  }

  String get customerName {
    return AuthService().displayName;
  }

  String get customerPhoneNumber {
    return AuthService().phoneNumber;
  }

  List<Meal> favouriteMeals = [];

  Future<List<String>> favouriteMealList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList(favouriteListKey);
    return list == null ? [] : list;
  }

  void Function()? updateFavDelegate;

  void saveMealPreference(Meal meal) {
     if (meal.instruction == null && meal.preferences == null) 
            return;
        
        
        let userDefaults = UserDefaults.standard
        let data = meal.preferencesInJSON
        
        userDefaults.set(data, forKey: meal.uid)
  }

  void favouriteMeal(String uid) async {
    favouriteMealList().then((newList) async {
      newList.add(uid);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(favouriteListKey, newList);
    });
  }

  void unfavouriteMeal(String uid) async {
    favouriteMeals.removeWhere((element) => element.uid == uid);
    if (updateFavDelegate != null) updateFavDelegate!.call();
    favouriteMealList().then((currentList) async {
      currentList.removeWhere((element) => element == uid);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(favouriteListKey, currentList);
    });

    // userDefaults.removeObject(forKey: uid)
    // saved meal preference
  }
}
/*      
static func unfavouriteMeal(uid: String) {
        
        let newlist = APPSetting.favouriteList.filter { $0 != uid}
        APPSetting.favouriteMeals = APPSetting.favouriteMeals.filter{ $0.uid != uid}
        userDefaults.set(newlist, forKey: Constants.favouriteListKey)
        userDefaults.removeObject(forKey: uid)
        
    }
    

     */
