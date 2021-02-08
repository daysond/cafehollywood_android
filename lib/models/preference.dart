import 'package:cafe_hollywood/models/preference_item.dart';

class Preference {
  final String uid;
  final bool isRequired;
  final String name;
  final int maxPick;
  final int maxItemQuantity;
  final List<PreferenceItem> preferenceItems;
  bool isSectionCollapsed = false;

  Preference(this.uid, this.isRequired, this.name, this.maxPick,
      this.maxItemQuantity, this.preferenceItems);

  Preference copy(Preference preference) {
    return Preference(
        preference.uid,
        preference.isRequired,
        preference.name,
        preference.maxPick,
        preference.maxItemQuantity,
        preferenceItems.map((e) => e.copy(e)).toList());
  }
}
