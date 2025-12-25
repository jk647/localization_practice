import 'package:flutter/material.dart';
import 'package:localization_practice/core/constants/colors/app_colors.dart';
import 'package:localization_practice/core/constants/localization/app_strings.dart';
import 'package:localization_practice/data/products.dart';
import '../screens/models/product_model.dart';
import '../screens/widgets/app_drawer.dart';
import '../screens/widgets/category_card.dart';
import '../screens/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  final String selectedLanguage;
  final VoidCallback onLanguageChange;

  const HomeScreen({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChange,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  late List<Product> _filteredProducts;

  @override
  void initState() {
    super.initState();
    _filteredProducts = List<Product>.from(sampleProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    final query = q.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List<Product>.from(sampleProducts);
      } else {
        _filteredProducts = sampleProducts.where((p) {
          final name = _localizedProductName(p.id).toLowerCase();
          return name.contains(query);
        }).toList();
      }
    });
  }

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.border,
        foregroundColor: AppColors.textPrimary,
        title: Text(
          AppStrings.homeSelectedLanguage(widget.selectedLanguage),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.language),
              onPressed: widget.onLanguageChange,
              iconSize: isSmallScreen ? 20 : 24,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 6, right: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
              iconSize: isSmallScreen ? 20 : 24,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header + Search
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.06,
                screenHeight * 0.02,
                screenWidth * 0.06,
                screenHeight * 0.04,
              ),
              decoration: const BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.welcomeBack,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 26 : 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    AppStrings.discoverAmazingProductsToday,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: AppColors.whiteOpacity70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: AppStrings.searchHint,
                        hintStyle: TextStyle(
                          color: AppColors.textLight,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Categories & Featured
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          AppStrings.categories,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 20 : 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          AppStrings.seeAll,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 13 : 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    height: screenHeight * 0.13,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CategoryCard(
                          title: AppStrings.categoryElectronics,
                          icon: Icons.devices,
                          color: AppColors.categoryElectronics,
                        ),
                        CategoryCard(
                          title: AppStrings.categoryFashion,
                          icon: Icons.shopping_bag,
                          color: AppColors.categoryFashion,
                        ),
                        CategoryCard(
                          title: AppStrings.categoryFood,
                          icon: Icons.restaurant,
                          color: AppColors.categoryFood,
                        ),
                        CategoryCard(
                          title: AppStrings.categoryBooks,
                          icon: Icons.book,
                          color: AppColors.categoryBooks,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    AppStrings.featuredProducts,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: isSmallScreen ? 0.75 : 0.80,
                      crossAxisSpacing: screenWidth * 0.04,
                      mainAxisSpacing: screenHeight * 0.02,
                    ),
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight,
          selectedFontSize: isSmallScreen ? 11 : 13,
          unselectedFontSize: isSmallScreen ? 10 : 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.explore_outlined),
              activeIcon: const Icon(Icons.explore),
              label: AppStrings.navExplore,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              activeIcon: const Icon(Icons.shopping_cart),
              label: AppStrings.navCart,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: AppStrings.profile,
            ),
          ],
        ),
      ),
    );
  }
}
