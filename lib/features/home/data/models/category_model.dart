import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({super.id, required super.name});

  //create a factory constructor
  factory CategoryModel.fromJson({required Map<String, dynamic> data}) =>
      CategoryModel(id: data["id"] as int?, name: data["name"] ?? '');

  //create a json method to convert model to json
  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
