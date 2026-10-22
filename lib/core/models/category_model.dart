class CategoryModel {
  int? id;
  String name;
  //create a constructor
  CategoryModel({this.id, required this.name});

  //create a factory constructor
  factory CategoryModel.fromJson({required Map<String, dynamic> data}) =>
      CategoryModel(id: data["id"], name: data["name"] ?? '');

  //create a json method to convert model to json
  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
