import 'package:cafe_hollywood/models/meal.dart';
import 'package:cafe_hollywood/services/auth.dart';
import 'package:cafe_hollywood/services/fs_service.dart';
import 'package:decimal/decimal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class APPSetting {
  static APPSetting? _instance;

  APPSetting._internal() {
    _instance = this;
  }

  factory APPSetting() => _instance ?? APPSetting._internal();

  void Function()? updateFavDelegate;

  final String _KeybusinessHoursVersion = "businessHoursVersion";
  final String _KeybusinessHours = "businessHours";
  final String _KeycreditAmountVersion = "creditAmountVersion";
  final String _KeytaxRateVersion = "taxRateVersion";
  final String _KeydrinkCredit = "drinkCredit";
  final String _KeywingCredit = "wingCredit";
  final String _KeyfederalTaxRate = "federalTaxRate";
  final String _KeyprovincialTaxRate = "provincialTaxRate";
  final String _KeyminiPurchase = "miniPurchase";

  String get customerUID {
    return AuthService().customerID ?? '';
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

  bool isTakingReservation = false;

  List<String> unavailableMeals = [];

  List<String> unavailableItems = [];

  List<String> unavailableMenus = [];

  List<String> unavailableDates = [];

  List<String> reservationIDs = [];

  List<Meal> favouriteMeals = [];

  // var reservations: [Reservation] = []

  Map<String, String> versions = {};

  Decimal? hstRate;

  Decimal? miniPurchase;

  Decimal? federalTaxRate;

  Decimal? drinkCreditAmount;

  Decimal? wingCreditAmout;

  var businessHours;

  Future<List<String>> favouriteMealList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList(favouriteListKey);
    return list == null ? [] : list;
  }

  void saveMealPreference(Meal meal) async {
    if (meal.instruction == null && meal.preferences == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String encodedMap = json.encode(meal.preferencesInEncodedJSON);
    print(encodedMap);
    await prefs.setString(meal.uid + customerUID, encodedMap);
  }

  void recoverMealPreferenceData(Meal meal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonData = prefs.getString(meal.uid + customerUID);
    if (jsonData == null) return;
    var data = json.decode(jsonData);
    if (data["instruction"] != null) meal.instruction = data["instruction"];

    var preferences = data["preferences"];
    //as Map<String, List<Map<String, int>>>

    if (preferences != null) {
      preferences.forEach((key, infos) {
        if (meal.preferences != null) {
          meal.preferences!.asMap().forEach((pIndex, preference) {
            if (preference.uid == key) {
              for (var info in infos) {
                preference.preferenceItems.asMap().forEach((iIndex, item) {
                  if (info[item.uid] != null) {
                    meal.preferences![pIndex].preferenceItems[iIndex]
                        .isSelected = true;
                    meal.preferences![pIndex].preferenceItems[iIndex].quantity =
                        info[item.uid]!;
                  }
                });
              }
            }
          });
        }
      });
    }
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

  void didGetCurrentVersions(Map<String, dynamic> data) {
    //note: data['menu'] is menu version, not applied here
    versions['businessHours'] = data['businessHours'].toString();
    versions['creditAmount'] = data['creditAmount'].toString();
    versions['taxRate'] = data['taxRate'].toString();
    if (versions['businessHours'] != null &&
        versions['creditAmount'] != null &&
        versions['taxRate'] != null) compareVersions();
  }

  void compareVersions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bhVersion = prefs.getString(_KeybusinessHoursVersion);
    var craVersion = prefs.getString(_KeycreditAmountVersion);
    var txrVersion = prefs.getString(_KeytaxRateVersion);

    void setCredit() {
      FSService().getCredits().then((data) {
        if (data == null) return;
        // Map<String, String> credits = data.cast<String, String>();
        if (data[_KeydrinkCredit] != null)
          prefs.setInt(_KeydrinkCredit, data[_KeydrinkCredit]);

        if (data[_KeywingCredit] != null)
          prefs.setInt(_KeywingCredit, data[_KeywingCredit]);

        prefs.setString(_KeycreditAmountVersion, versions['creditAmount']!);
        updateCredits();
      });
    }

    void setBusinessHours() {
      FSService().getBusinessHours().then((data) {
        if (data == null) return;
        Map<String, String> hours = data.cast<String, String>();
        prefs.setString(_KeybusinessHours, json.encode(hours));
        prefs.setString(_KeybusinessHoursVersion, versions['businessHours']!);
        updateHours();
      });
    }

    void setTaxRate() {
      FSService().getTaxRates().then((data) {
        print('tax rate data ${data}');
        if (data == null) return;
        if (data[_KeyfederalTaxRate] != null)
          prefs.setInt(_KeyfederalTaxRate, data[_KeyfederalTaxRate]);

        if (data[_KeyprovincialTaxRate] != null)
          prefs.setInt(_KeyprovincialTaxRate, data[_KeyprovincialTaxRate]);

        if (data[_KeyminiPurchase] != null)
          prefs.setInt(_KeyminiPurchase, data[_KeyminiPurchase]);

        prefs.setString(_KeytaxRateVersion, versions['taxRate']!);
        updateTaxRate();
      });
    }

    if (bhVersion == null) {
      //first time, get hours then set version on phone
      setBusinessHours();
    } else {
      if (bhVersion != versions['businessHours']!) {
        setBusinessHours();
      }
    }

    if (craVersion == null) {
      setCredit();
    } else {
      if (craVersion != versions['creditAmount']!) {
        setCredit();
      }
    }

    if (txrVersion == null) {
      setTaxRate();
    } else {
      if (txrVersion != versions['taxRate']!) {
        setTaxRate();
      }
    }
  }

// updates; set value to local variables.
  void updateCredits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var drinkCR = prefs.getInt(_KeydrinkCredit);
    drinkCreditAmount =
        Decimal.parse(drinkCR == null ? '1.50' : (drinkCR / 100).toString());

    var wingCR = prefs.getInt(_KeywingCredit);
    wingCreditAmout =
        Decimal.parse(wingCR == null ? '9.96' : (wingCR / 100).toString());
  }

  void updateHours() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bHours = prefs.getString(_KeybusinessHours);
    if (bHours != null) businessHours = json.decode(bHours);
  }

  void updateTaxRate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var r1 = prefs.getInt(_KeyfederalTaxRate);
    var fedTax = Decimal.parse(r1 == null ? '0.05' : (r1 / 100).toString());
    federalTaxRate = fedTax;

    var r2 = prefs.getInt(_KeyprovincialTaxRate);
    var proTax = Decimal.parse(r2 == null ? '0.08' : (r2 / 100).toString());
    hstRate = fedTax + proTax;

    var miniPur = prefs.getInt(_KeyminiPurchase);
    miniPurchase =
        Decimal.parse(miniPur == null ? '4.00' : (miniPur / 100).toString());
  }

  void update() async {
    updateCredits();
    updateHours();
    updateTaxRate();
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
