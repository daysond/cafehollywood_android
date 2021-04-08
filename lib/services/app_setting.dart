import 'package:cafe_hollywood/models/meal.dart';
import 'package:cafe_hollywood/services/auth.dart';

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

  String get customerName {
    return AuthService().displayName;
  }

  String get customerPhoneNumber {
    return AuthService().phoneNumber;
  }

  List<Meal> favouriteMeals = [];
  List<String> get favouriteMealList {
    return ['H01'];
  }

  void favouriteMeal(String uid) {
    var newList = favouriteMealList;
    newList.add(uid);
    // userDefaults.set(newlist, forKey: Constants.favouriteListKey)
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
