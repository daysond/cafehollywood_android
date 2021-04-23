class Menu {
  final String uid;
  final String menuTitle;
  final List<String> mealsInUID;
  final String imageURL;
  final String menuDetail;
  final bool isTakeOutOnly;
  final bool isAvailable;

  String get headerImageURL {
    return uid + 'Header';
  }

  Menu(this.uid, this.menuTitle, this.mealsInUID, this.imageURL,
      this.isTakeOutOnly, this.menuDetail, this.isAvailable);
}
