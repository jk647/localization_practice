import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'src/navigator_key.dart';
import 'screens/language_selection_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize easy_localization
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ur'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Localization Practice',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const AppEntry(),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});
  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _chosen = false;

  @override
  Widget build(BuildContext context) {
    return _chosen
        ? HomeScreen(
            selectedLanguage: _langNameFromCode(context.locale.languageCode),
            onLanguageChange: () {
              setState(() {
                _chosen = false;
              });
            },
          )
        : LanguageSelectionScreen(
            onLanguageSelected: (langCode) {
              context.setLocale(Locale(langCode));
              setState(() {
                _chosen = true;
              });
            },
          );
  }

  String _langNameFromCode(String code) {
    switch (code) {
      case 'ur':
        return 'اردو';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }
}
