import 'package:flutter/material.dart';

import 'category_model.dart';

class ProductModel {
  final int? id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final CategoryModel? category;

  ProductModel({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    this.category,
  });

  //create a factory constructor
  factory ProductModel.fromJson({required Map<String, dynamic> data}) =>
      ProductModel(
        id: data["id"],
        title: data["title"] ?? '',
        price: (data["price"] as num?)?.toDouble() ?? 0,
        description: data["description"] ?? '',
        images: ((data["images"] ?? []) as List)
            .map((image) => image.toString())
            .toList(),
        category: data["category"] is Map
            ? CategoryModel.fromJson(
                data: Map<String, dynamic>.from(data["category"]),
              )
            : null,
      );

  //create a json method to convert model to json
  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "description": description,
    "images": images,
    "category": category?.toJson(),
  };

  String get name => title;

  String get imageUrl => images.isNotEmpty ? images.first : '';

  List<Color> get colors => const [Colors.white, Colors.black, Colors.grey];
  List<String> get sizes => const ['S', 'M', 'L', 'XL'];
}
