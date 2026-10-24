import '../../domain/entities/product.dart';
import 'category_model.dart';

class ProductModel extends Product {
  const ProductModel({
    super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.images,
    super.category,
  });

  //create a factory constructor
  factory ProductModel.fromJson({required Map<String, dynamic> data}) =>
      ProductModel(
        id: data["id"] as int?,
        title: data["title"] ?? '',
        price: (data["price"] as num?)?.toDouble() ?? 0,
        description: data["description"] ?? '',
        images: ((data["images"] ?? []) as List)
            .map((image) => image.toString())
            .toList(),
        category: data["category"] is Map
            ? CategoryModel.fromJson(
                data: Map<String, dynamic>.from(data["category"] as Map),
              )
            : null,
      );

  //create a json method to convert model to json
  Map<String, dynamic> toJson() {
    final value = category;
    return {
      "id": id,
      "title": title,
      "price": price,
      "description": description,
      "images": images,
      "category": value is CategoryModel ? value.toJson() : null,
    };
  }
}
