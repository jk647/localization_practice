// lib/generated/locals.dart
// GENERATED FILE – DO NOT MODIFY BY HAND
// Run `dart run tool/main.dart` to regenerate.
import 'package:easy_localization/easy_localization.dart';
import '../src/navigator_key.dart';

class Locals {
  Locals._();

  static String _t(String key, {Map<String, Object>? args}) {
    final ctx = appNavigatorKey.currentContext;
    if (ctx != null) {
      try {
        if (args != null) {
          // easy_localization expects namedArgs: Map<String, String>
          final namedArgs = args.map((k, v) => MapEntry(k, v.toString()));
          return key.tr(namedArgs: namedArgs);
        }
        return key.tr();
      } catch (_) {
        return key;
      }
    }
    // fallback while localization not ready: return english string if present, else key
    return _fallback[key] ?? key;
  }

  static const Map<String, String> _fallback = {
    'homeSelectedlanguage': 'Home - {selectedLanguage}',
    'johnDoe': 'John Doe',
    'johnExampleCom': 'john@example.com',
    'home': 'Home',
    'profile': 'Profile',
    'settings': 'Settings',
    'logout': 'Logout',
    'welcomeBack': 'Welcome Back!',
    'discoverAmazingProductsToday': 'Discover amazing products today',
    'categories': 'Categories',
    'seeAll': 'See All',
    'featuredProducts': 'Featured Products',
    'selectYourLanguage': 'Select Your Language',
    'chooseYourPreferredLanguage': 'Choose your preferred language',

    'navCart': 'Cart',
    'navExplore': 'Explore',

    'categoryBooks': 'Books',
    'categoryFood': 'Food',
    'categoryFashion': 'Fashion',
    'categoryElectronics': 'Electronics',

    'productPhone': 'Phone',
    'productLaptop': 'Laptop',
    'productWatch': 'Watch',
    'productHeadphones': 'Headphones',

    'searchHint': 'Search products...'
  };

  static String homeSelectedlanguage({required Object selectedLanguage}) =>
      _t('homeSelectedlanguage', args: {'selectedLanguage': selectedLanguage});
  static String get johnDoe => _t('johnDoe');
  static String get johnExampleCom => _t('johnExampleCom');
  static String get home => _t('home');
  static String get profile => _t('profile');
  static String get settings => _t('settings');
  static String get logout => _t('logout');
  static String get welcomeBack => _t('welcomeBack');
  static String get discoverAmazingProductsToday =>
      _t('discoverAmazingProductsToday');
  static String get categories => _t('categories');
  static String get seeAll => _t('seeAll');
  static String get featuredProducts => _t('featuredProducts');
  static String get selectYourLanguage => _t('selectYourLanguage');
  static String get chooseYourPreferredLanguage =>
      _t('chooseYourPreferredLanguage');

  static String get navCart => _t('navCart');
  static String get navExplore => _t('navExplore');

  static String get categoryBooks => _t('categoryBooks');
  static String get categoryFood => _t('categoryFood');
  static String get categoryFashion => _t('categoryFashion');
  static String get categoryElectronics => _t('categoryElectronics');

  static String get productPhone => _t('productPhone');
  static String get productLaptop => _t('productLaptop');
  static String get productWatch => _t('productWatch');
  static String get productHeadphones => _t('productHeadphones');

  static String get searchHint => _t('searchHint');
}
