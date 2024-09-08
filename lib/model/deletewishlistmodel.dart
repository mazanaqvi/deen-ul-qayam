// To parse this JSON data, do
//
//     final deletewishlistmodel = deletewishlistmodelFromJson(jsonString);

import 'dart:convert';

Deletewishlistmodel deletewishlistmodelFromJson(String str) =>
    Deletewishlistmodel.fromJson(json.decode(str));

String deletewishlistmodelToJson(Deletewishlistmodel data) =>
    json.encode(data.toJson());

class Deletewishlistmodel {
  Deletewishlistmodel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory Deletewishlistmodel.fromJson(Map<String, dynamic> json) =>
      Deletewishlistmodel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
