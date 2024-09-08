// To parse this JSON data, do
//
//     final buybookmodel = buybookmodelFromJson(jsonString);

import 'dart:convert';

Buybookmodel buybookmodelFromJson(String str) =>
    Buybookmodel.fromJson(json.decode(str));

String buybookmodelToJson(Buybookmodel data) => json.encode(data.toJson());

class Buybookmodel {
  int? status;
  String? message;
  List<dynamic>? result;

  Buybookmodel({
    this.status,
    this.message,
    this.result,
  });

  factory Buybookmodel.fromJson(Map<String, dynamic> json) => Buybookmodel(
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
