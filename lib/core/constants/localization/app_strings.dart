import 'package:localization_practice/generated/locals.dart';

class AppStrings {
  AppStrings._();

  static String homeSelectedLanguage(String selectedLanguage) =>
      Locals.homeSelectedlanguage(selectedLanguage: selectedLanguage);

  // Simple getters
  static String get johnDoe => Locals.johnDoe;
  static String get johnExampleCom => Locals.johnExampleCom;
  static String get home => Locals.home;
  static String get profile => Locals.profile;
  static String get settings => Locals.settings;
  static String get logout => Locals.logout;
  static String get welcomeBack => Locals.welcomeBack;
  static String get discoverAmazingProductsToday =>
      Locals.discoverAmazingProductsToday;
  static String get categories => Locals.categories;
  static String get seeAll => Locals.seeAll;
  static String get featuredProducts => Locals.featuredProducts;
  static String get selectYourLanguage => Locals.selectYourLanguage;
  static String get chooseYourPreferredLanguage =>
      Locals.chooseYourPreferredLanguage;

  // NAV
  static String get navCart => Locals.navCart;
  static String get navExplore => Locals.navExplore;

  // Categories
  static String get categoryBooks => Locals.categoryBooks;
  static String get categoryFood => Locals.categoryFood;
  static String get categoryFashion => Locals.categoryFashion;
  static String get categoryElectronics => Locals.categoryElectronics;

  // Products
  static String get productPhone => Locals.productPhone;
  static String get productLaptop => Locals.productLaptop;
  static String get productWatch => Locals.productWatch;
  static String get productHeadphones => Locals.productHeadphones;

  // Search
  static String get searchHint => Locals.searchHint;

  // Add more
}
