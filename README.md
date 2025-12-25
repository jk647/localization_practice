# Localization Practice (Flutter)

A small Flutter demo app focused on **localization (l10n)** using `easy_localization`.  
This repo shows a practical workflow: string extraction → JSON locale files → typed helper (`Locals`) → `AppStrings` abstraction → UI use. It includes English, Urdu, and Arabic translations and a minimal, clean project structure.

> Goal: practice real-world localization patterns and keep UI decoupled from translation implementation.

---

## 🔥 Highlights / Features
- Flutter app with language selection (English / اردو / العربية)
- `easy_localization` setup + localized JSON files (`assets/translations`)
- `AppStrings` abstraction (UI calls only `AppStrings`, never `Locals` directly)
- Seed translations: `en.json`, `ur.json`, `ar.json`

---

## 🧭 Project structure
