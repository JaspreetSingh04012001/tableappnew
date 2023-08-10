import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) => List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.position,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.translations,
  });

  int id;
  String name;
  int parentId;
  int position;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String image;
  List<dynamic> translations;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    name: json["name"],
    parentId: json["parent_id"],
    position: json["position"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    image: json["image"],
    translations: List<dynamic>.from(json["translations"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "parent_id": parentId,
    "position": position,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "image": image,
    "translations": List<dynamic>.from(translations.map((x) => x)),
  };
}
