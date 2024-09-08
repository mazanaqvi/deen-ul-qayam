// To parse this JSON data, do
//
//     final blogDetailModel = blogDetailModelFromJson(jsonString);

import 'dart:convert';

BlogDetailModel blogDetailModelFromJson(String str) =>
    BlogDetailModel.fromJson(json.decode(str));

String blogDetailModelToJson(BlogDetailModel data) =>
    json.encode(data.toJson());

class BlogDetailModel {
  int? status;
  String? message;
  List<Result>? result;

  BlogDetailModel({
    this.status,
    this.message,
    this.result,
  });

  factory BlogDetailModel.fromJson(Map<String, dynamic> json) =>
      BlogDetailModel(
        status: json["status"],
        message: json["message"],
        result: List<Result>.from(json["result"] == null
            ? []
            : json["result"]?.map((x) => Result.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(
            result == null ? [] : result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  int? id;
  int? tutorId;
  String? title;
  String? description;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? tutorName;

  Result({
    this.id,
    this.tutorId,
    this.title,
    this.description,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.tutorName,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        tutorId: json["tutor_id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        tutorName: json["tutor_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tutor_id": tutorId,
        "title": title,
        "description": description,
        "image": image,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "tutor_name": tutorName,
      };
}
