// To parse this JSON data, do
//
//     final courseidModel = courseidModelFromJson(jsonString);

import 'dart:convert';

List<CourseidModel> courseidModelFromJson(String str) =>
    List<CourseidModel>.from(
        json.decode(str).map((x) => CourseidModel.fromJson(x)));

String courseidModelToJson(List<CourseidModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseidModel {
  CourseidModel({
    this.courseId,
    this.price,
  });

  String? courseId;
  String? price;

  factory CourseidModel.fromJson(Map<String, dynamic> json) => CourseidModel(
        courseId: json["course_id"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "price": price,
      };
}
