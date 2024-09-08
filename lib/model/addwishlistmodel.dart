// To parse this JSON data, do
//
//     final addwishlistModel = addwishlistModelFromJson(jsonString);

import 'dart:convert';

AddwishlistModel addwishlistModelFromJson(String str) =>
    AddwishlistModel.fromJson(json.decode(str));

String addwishlistModelToJson(AddwishlistModel data) =>
    json.encode(data.toJson());

class AddwishlistModel {
  AddwishlistModel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory AddwishlistModel.fromJson(Map<String, dynamic> json) =>
      AddwishlistModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
