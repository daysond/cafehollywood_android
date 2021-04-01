/*
enum AccountField: String {
    
    case email = "Email"
    case phone = "Phone Number"
    case name = "Name"
    case password = "Password"
    case reservation = "My Reservation"
    case favourite = "My Favourite"
    case about = "Visit Our Website"
    case instagram = "Like us on Instagram"
    case verification = "Verification Code"
    
}

*/

enum SettingField {
  phone,
  name,
  reservation,
  favourite,
  about,
  instagram,
  logOut,
  filler
}

extension SettingFieldExt on SettingField {
  String get text {
    switch (this) {
      case SettingField.name:
        return 'Name';
      case SettingField.phone:
        return 'Phone Number';
      case SettingField.about:
        return 'Visit Our Website';
      case SettingField.reservation:
        return 'My Reservation';
      case SettingField.favourite:
        return 'My Favourite';
      case SettingField.instagram:
        return 'Like us on Instagram';
      case SettingField.logOut:
        return 'Log Out';
      case SettingField.filler:
        return '';
    }
  }
}
