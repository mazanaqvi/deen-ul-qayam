// To parse this JSON data, do
//
//     final successModel = successModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

SuccessModel successModelFromJson(String str) =>
    SuccessModel.fromJson(json.decode(str));

String successModelToJson(SuccessModel data) => json.encode(data.toJson());

class SuccessModel {
  int? status;
  String? message;
  List<dynamic>? result;

  SuccessModel({
    this.status,
    this.message,
    this.result,
  });

  factory SuccessModel.fromJson(Map<String, dynamic> json) => SuccessModel(
        status: json["status"],
        message: json["message"],
        result: List<dynamic>.from(json["result"]?.map((x) => x) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result?.map((x) => x) ?? []),
      };
}
