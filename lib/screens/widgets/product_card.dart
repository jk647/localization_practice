import 'package:flutter/material.dart';
import 'package:localization_practice/core/constants/colors/app_colors.dart';
import 'package:localization_practice/core/constants/localization/app_strings.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  String _localizedProductName(String id) {
    switch (id) {
      case 'productPhone':
        return AppStrings.productPhone;
      case 'productLaptop':
        return AppStrings.productLaptop;
      case 'productWatch':
        return AppStrings.productWatch;
      case 'productHeadphones':
        return AppStrings.productHeadphones;
      default:
        return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _localizedProductName(product.id);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.08),
                      AppColors.secondary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      product.icon,
                      size: isSmallScreen ? 32 : 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: isSmallScreen ? 13 : 15,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isSmallScreen ? 4 : 6),
                  Text(
                    product.price,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}