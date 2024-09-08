// To parse this JSON data, do
//
//     final updateprofilemodel = updateprofilemodelFromJson(jsonString);

import 'dart:convert';

Updateprofilemodel updateprofilemodelFromJson(String str) =>
    Updateprofilemodel.fromJson(json.decode(str));

String updateprofilemodelToJson(Updateprofilemodel data) =>
    json.encode(data.toJson());

class Updateprofilemodel {
  int? status;
  String? message;

  Updateprofilemodel({
    this.status,
    this.message,
  });

  factory Updateprofilemodel.fromJson(Map<String, dynamic> json) =>
      Updateprofilemodel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
