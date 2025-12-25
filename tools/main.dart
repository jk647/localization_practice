// tool/main.dart
// Run with: dart run tool/main.dart
//
// Scans lib/ for Text(...) usages and generates:
// - tool/results/en.json          (localization keys/values)
// - tool/results/locals.dart       (generated Locals API that uses easy_localization)
// - tool/results/extracted_texts.json
// - tool/results/pure_strings.json
// - tool/results/variables.json
//
// NOTE: This script does NOT change any existing project files.

import 'dart:convert';
import 'dart:io';

final resultsDir = Directory('tool/results');

/// Convert a display string into a safe camelCase key for JSON and Dart.
String toCamelCaseKey(String input) {
  // Remove punctuation except digits and letters and spaces
  final cleaned = input
      // Replace special punctuation with space
      .replaceAll(RegExp(r'[^\w\s]'), ' ')
      .trim();

  if (cleaned.isEmpty) return '';

  final parts = cleaned.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '';

  // If first part begins with digit, prefix with underscore
  String first = parts.first.toLowerCase();
  if (RegExp(r'^\d').hasMatch(first)) {
    first = '_$first';
  }

  final rest = parts.skip(1).map((p) {
    if (p.isEmpty) return '';
    return p[0].toUpperCase() + p.substring(1).toLowerCase();
  }).join();

  final combined = (first + rest).replaceAll(RegExp(r'[^A-Za-z0-9_]'), '');
  if (combined.isEmpty) return '_key';
  return combined;
}

/// Make a valid Dart identifier for keys that might still be invalid.
String sanitizeIdentifier(String key) {
  var out = key.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '');
  if (out.isEmpty) out = '_key';
  if (RegExp(r'^\d').hasMatch(out)) out = '_$out';
  return out;
}

/// Extract placeholders from a Dart interpolated string literal.
/// Supports ${expr} and $var
/// Returns map: processedValue (with {name} placeholders) and list of placeholder names (in order)
Map<String, dynamic> convertDartInterpolationToPlaceholders(String dartString) {
  // dartString is the literal content including interpolations, e.g. "Pages: ${state.current}/${state.total} Pages"
  String working = dartString;

  final List<String> paramNames = [];

  // Handle ${...}
  final regexBraces = RegExp(r'\$\{([^}]+)\}');
  int counter = 0;
  working = working.replaceAllMapped(regexBraces, (m) {
    final expr = m.group(1)!.trim();
    // derive a param name from expression: take last identifier segment
    final parts = expr.split(RegExp(r'[\.\s\(\)\[\]]')).where((s) => s.isNotEmpty).toList();
    String name = parts.isNotEmpty ? parts.last : 'p$counter';
    // sanitize name to camelCase
    name = name.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '');
    if (name.isEmpty) name = 'p$counter';
    // ensure uniqueness
    var base = name;
    int i = 1;
    while (paramNames.contains(name)) {
      name = '$base$i';
      i++;
    }
    paramNames.add(name);
    counter++;
    return '{$name}';
  });

  // Handle $var (but not $$)
  final regexDollarVar = RegExp(r'(?<!\$)\$([A-Za-z_]\w*)');
  working = working.replaceAllMapped(regexDollarVar, (m) {
    final expr = m.group(1)!.trim();
    String name = expr.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '');
    if (name.isEmpty) name = 'p$counter';
    var base = name;
    int i = 1;
    while (paramNames.contains(name)) {
      name = '$base$i';
      i++;
    }
    paramNames.add(name);
    counter++;
    return '{$name}';
  });

  return {'value': working, 'params': paramNames};
}

/// Read all .dart files from lib/ and extract Text(...) arguments.
Future<List<Map<String, dynamic>>> extractTextsFromLib() async {
  final dir = Directory('lib');
  if (!await dir.exists()) {
    print('No lib/ directory found. Aborting.');
    return [];
  }

  final items = <Map<String, dynamic>>[];

  // Regex to find Text( ... ) capturing the first argument expression.
  // Uses dotAll to allow multiline content.
  final textRegex = RegExp(r'Text\s*\(\s*([^,)\n][\s\S]*?)(?:,|\))', dotAll: true);

  await for (final entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();

      for (final match in textRegex.allMatches(content)) {
        final rawArg = match.group(1)!.trim();

        // Save raw for debugging
        final item = <String, dynamic>{'file': entity.path, 'rawArg': rawArg};

        // classify
        if ((rawArg.startsWith('"') && rawArg.endsWith('"')) || (rawArg.startsWith("'") && rawArg.endsWith("'"))) {
          // It's a string literal - get inner content without quotes, but handle multi-line string prefixes r""" etc not covered here
          String inner = rawArg.substring(1, rawArg.length - 1);

          // Detect interpolation
          if (inner.contains(RegExp(r'\$\{')) || inner.contains(RegExp(r'(?<!\$)\$[A-Za-z_]'))) {
            final conv = convertDartInterpolationToPlaceholders(inner);
            item['type'] = 'Interpolated String';
            item['text'] = conv['value'];
            item['placeholders'] = conv['params'];
          } else {
            item['type'] = 'Pure String';
            item['text'] = inner;
            item['placeholders'] = <String>[];
          }
        } else {
          // Not a quoted string -> variable / expression
          item['type'] = 'Expression';
          item['text'] = rawArg;
          item['placeholders'] = <String>[];
        }

        items.add(item);
      }
    }
  }

  return items;
}

/// Build en.json from extracted items (only include Pure and Interpolated Strings).
Map<String, String> buildEnJson(List<Map<String, dynamic>> items) {
  final Map<String, String> map = {};
  final Set<String> usedKeys = {};

  for (final it in items) {
    if (it['type'] == 'Pure String' || it['type'] == 'Interpolated String') {
      final value = it['text'] as String;
      // Create a key base from the display text or fallback to file+index
      var baseKey = toCamelCaseKey(value);
      if (baseKey.isEmpty) {
        // fallback: derive from filename + hash
        final file = it['file'] as String;
        baseKey = sanitizeIdentifier(file.split('/').last.replaceAll('.dart', ''));
      }
      var key = sanitizeIdentifier(baseKey);

      // avoid collisions
      var suffix = 1;
      final orig = key;
      while (usedKeys.contains(key)) {
        key = '${orig}_$suffix';
        suffix++;
      }
      usedKeys.add(key);

      map[key] = value;
      it['generatedKey'] = key;
    }
  }

  return map;
}

/// Generate Locals Dart code using easy_localization and global navigator key.
String generateLocalsDart(Map<String, String> enJson, List<Map<String, dynamic>> items) {
  final buffer = StringBuffer();

  buffer.writeln('// GENERATED FILE – DO NOT MODIFY BY HAND');
  buffer.writeln('// Run `dart run tool/main.dart` to regenerate.');
  buffer.writeln("import 'package:easy_localization/easy_localization.dart';");
  buffer.writeln("import 'package:flutter/widgets.dart';");
  buffer.writeln("import '../lib/src/navigator_key.dart'; // ensure this global key exists in your app");
  buffer.writeln('');
  buffer.writeln('class Locals {');
  buffer.writeln('  Locals._();');
  buffer.writeln('');
  buffer.writeln("  static String _t(String key, {Map<String, Object>? args}) {");
  buffer.writeln('    final ctx = appNavigatorKey.currentContext;');
  buffer.writeln('    if (ctx != null) {');
  buffer.writeln('      try {');
  buffer.writeln('        if (args != null) return key.tr(args: args);');
  buffer.writeln('        return key.tr();');
  buffer.writeln('      } catch (_) {');
  buffer.writeln('        return key;');
  buffer.writeln('      }');
  buffer.writeln('    }');
  buffer.writeln('    // fallback while localization not ready: return english string if present, else key');
  buffer.writeln("    return _fallback[key] ?? key;");
  buffer.writeln('  }');
  buffer.writeln('');

  // create entries map for fallback (english)
  buffer.writeln('  static const Map<String, String> _fallback = {');
  enJson.forEach((k, v) {
    final escaped = v.replaceAll("'", "\\'");
    buffer.writeln("    '$k': '$escaped',");
  });
  buffer.writeln('  };');
  buffer.writeln('');

  // For each key generate either getter or method with params
  for (final entry in items) {
    if (entry.containsKey('generatedKey')) {
      final key = entry['generatedKey'] as String;
      final type = entry['type'] as String;
      final placeholders = (entry['placeholders'] as List).cast<String>();

      if (type == 'Pure String') {
        buffer.writeln('  static String get $key => _t(\'$key\');');
      } else if (type == 'Interpolated String') {
        // Generate a method signature with required parameters (named)
        final params = placeholders.map((p) => 'required Object $p').join(', ');
        final argsMap = placeholders.map((p) => "'$p': $p").join(', ');
        buffer.writeln('  static String $key({$params}) => _t(\'$key\', args: {$argsMap});');
      }
    }
  }

  buffer.writeln('}');

  return buffer.toString();
}

/// Writes a file, creating parent dirs if necessary.
Future<void> writeFile(String path, String content) async {
  final file = File(path);
  final parent = file.parent;
  if (!await parent.exists()) {
    await parent.create(recursive: true);
  }
  await file.writeAsString(content);
}

Future<void> main() async {
  // Ensure results dir exists
  if (!await resultsDir.exists()) {
    await resultsDir.create(recursive: true);
  }

  print('Scanning lib/ for Text(...) usages...');
  final extracted = await extractTextsFromLib();
  await writeFile('tool/results/extracted_texts.json', const JsonEncoder.withIndent('  ').convert(extracted));
  print('Found ${extracted.length} Text(...) usages. Details written to tool/results/extracted_texts.json');

  // Save separate lists
  final pure = extracted.where((e) => e['type'] == 'Pure String').toList();
  final interpolated = extracted.where((e) => e['type'] == 'Interpolated String').toList();
  final expressions = extracted.where((e) => e['type'] == 'Expression').toList();

  await writeFile('tool/results/pure_strings.json', const JsonEncoder.withIndent('  ').convert(pure));
  await writeFile('tool/results/variables.json', const JsonEncoder.withIndent('  ').convert(expressions));

  print('Pure strings: ${pure.length}, Interpolated: ${interpolated.length}, Expressions: ${expressions.length}');

  // Build en.json (only pure + interpolated)
  final enMap = buildEnJson(extracted);
  final enJsonContent = const JsonEncoder.withIndent('  ').convert(enMap);
  await writeFile('tool/results/en.json', enJsonContent);
  print('Generated tool/results/en.json with ${enMap.length} entries.');

  // Generate locals.dart
  final localsDart = generateLocalsDart(enMap, extracted);
  await writeFile('tool/results/locals.dart', localsDart);
  print('Generated tool/results/locals.dart');

  print('\nDone. Files created in tool/results/:');
  print(' - en.json');
  print(' - locals.dart');
  print(' - extracted_texts.json');
  print(' - pure_strings.json');
  print(' - variables.json');

  print('\nHOW TO USE:');
  print('1) Copy tool/results/en.json -> assets/locals/en.json (or point easy_localization.path to tool/results).');
  print('2) Copy tool/results/locals.dart -> lib/locals.dart (or import it from where you keep localization helpers).');
  print(
    '3) Ensure you have lib/src/navigator_key.dart with `final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();`',
  );
  print('4) Initialize EasyLocalization in main.dart and set MaterialApp.navigatorKey = appNavigatorKey.');
  print('\nNotes:');
  print(
    '- Interpolated Dart strings like "Pages: \${state.current}/\${state.total} Pages" become keys with placeholders {current} and {total}.',
  );
  print(
    '- The generated Locals methods accept named required parameters matching placeholders: e.g. Locals.pages(current: x, total: y)',
  );
}
