import 'package:flutter/material.dart';
import 'package:localization_practice/core/constants/colors/app_colors.dart';
import 'package:localization_practice/core/constants/localization/app_strings.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final Function(String) onLanguageSelected;

  const LanguageSelectionScreen({super.key, required this.onLanguageSelected});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: screenHeight * 0.03,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.language, size: 80, color: AppColors.white),
                  SizedBox(height: screenHeight * 0.025),
                  Text(
                    AppStrings.selectYourLanguage,
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.012),
                  Text(
                    AppStrings.chooseYourPreferredLanguage,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: AppColors.whiteOpacity70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  LanguageButton(
                    flag: '🇬🇧',
                    language: 'English',
                    onTap: () => onLanguageSelected('en'),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  LanguageButton(
                    flag: '🇵🇰',
                    language: 'اردو',
                    onTap: () => onLanguageSelected('ur'),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  LanguageButton(
                    flag: '🇸🇦',
                    language: 'العربية',
                    onTap: () => onLanguageSelected('ar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String flag;
  final String language;
  final VoidCallback onTap;

  const LanguageButton({
    super.key,
    required this.flag,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.05,
          horizontal: screenWidth * 0.06,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: screenWidth * 0.08)),
            SizedBox(width: screenWidth * 0.05),
            Expanded(
              child: Text(
                language,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: screenWidth * 0.05,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
