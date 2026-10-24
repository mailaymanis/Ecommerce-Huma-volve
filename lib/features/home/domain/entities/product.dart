import 'category.dart';

class Product {
  const Product({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    this.category,
  });

  final int? id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final Category? category;

  String get name => title;

  String get imageUrl => images.isNotEmpty ? images.first : '';
}
