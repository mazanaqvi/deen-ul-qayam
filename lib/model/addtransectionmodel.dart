// To parse this JSON data, do
//
//     final buyCourseModel = buyCourseModelFromJson(jsonString);

import 'dart:convert';

BuyCourseModel buyCourseModelFromJson(String str) =>
    BuyCourseModel.fromJson(json.decode(str));

String buyCourseModelToJson(BuyCourseModel data) => json.encode(data.toJson());

class BuyCourseModel {
  int? status;
  String? message;
  List<dynamic>? result;

  BuyCourseModel({
    this.status,
    this.message,
    this.result,
  });

  factory BuyCourseModel.fromJson(Map<String, dynamic> json) => BuyCourseModel(
        status: json["status"],
        message: json["message"],
        result: List<dynamic>.from(
            json["result"] == null ? [] : json["result"]?.map((x) => x) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(
            result == null ? [] : result?.map((x) => x) ?? []),
      };
}
