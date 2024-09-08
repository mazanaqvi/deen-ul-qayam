// To parse this JSON data, do
//
//     final addratingmodel = addratingmodelFromJson(jsonString);

import 'dart:convert';

Addratingmodel addratingmodelFromJson(String str) =>
    Addratingmodel.fromJson(json.decode(str));

String addratingmodelToJson(Addratingmodel data) => json.encode(data.toJson());

class Addratingmodel {
  int? status;
  String? message;
  List<dynamic>? result;

  Addratingmodel({
    this.status,
    this.message,
    this.result,
  });

  factory Addratingmodel.fromJson(Map<String, dynamic> json) => Addratingmodel(
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
