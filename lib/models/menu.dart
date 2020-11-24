class Menu {
  final String uid;
  final String menuTitle;
  final List<String> mealsInUID;
  final String imageURL;
  final String menuDetail;

  Menu(this.uid, this.menuTitle, this.mealsInUID, this.imageURL,
      {this.menuDetail});
}
