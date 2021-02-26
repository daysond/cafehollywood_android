import 'package:decimal/decimal.dart';

enum ComboType {
  drink,
  wing,
}

extension ComboTypeExt on ComboType {
  static ComboType comboTypeFromRawValue(int rawValue) {
    switch (rawValue) {
      case 1:
        return ComboType.wing;
      case 0:
        return ComboType.drink;
      default:
        return null;
    }
  }

  int get rawValue {
    switch (this) {
      case ComboType.drink:
        return 0;
      case ComboType.wing:
        return 1;
      default:
        return null;
    }
  }

  Decimal get deductionAmount {
    switch (this) {
      case ComboType.drink:
        return Decimal.parse('1.5');
      case ComboType.wing:
        return Decimal.parse('9.96');
      default:
        return null;
    }
  }
}
