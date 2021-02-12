class CustomOption {
  final String mainImageName;
  final String mainTitle;
  String subTitle;
  final OptionType optionType;

  CustomOption(
      this.mainTitle, this.mainImageName, this.subTitle, this.optionType);
}

enum OptionType {
  utensil,
  scheduler,
  payment,
  note,
  pax,
  gift,
}
