import 'package:flutter/material.dart';

class Product {
  final String id;
  final String price;
  final IconData icon;

  const Product({
    required this.id,
    required this.price,
    required this.icon,
  });
}
