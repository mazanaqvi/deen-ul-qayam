// To parse this JSON data, do
//
//     final addcommentmodel = addcommentmodelFromJson(jsonString);

import 'dart:convert';

Addcommentmodel addcommentmodelFromJson(String str) =>
    Addcommentmodel.fromJson(json.decode(str));

String addcommentmodelToJson(Addcommentmodel data) =>
    json.encode(data.toJson());

class Addcommentmodel {
  int? status;
  String? message;
  List<dynamic>? result;

  Addcommentmodel({
    this.status,
    this.message,
    this.result,
  });

  factory Addcommentmodel.fromJson(Map<String, dynamic> json) =>
      Addcommentmodel(
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
