// To parse this JSON data, do
//
//     final addRemoveWishlistmodel = addRemoveWishlistmodelFromJson(jsonString);

import 'dart:convert';

AddRemoveWishlistmodel addRemoveWishlistmodelFromJson(String str) =>
    AddRemoveWishlistmodel.fromJson(json.decode(str));

String addRemoveWishlistmodelToJson(AddRemoveWishlistmodel data) =>
    json.encode(data.toJson());

class AddRemoveWishlistmodel {
  int? status;
  String? message;
  List<dynamic>? result;

  AddRemoveWishlistmodel({
    this.status,
    this.message,
    this.result,
  });

  factory AddRemoveWishlistmodel.fromJson(Map<String, dynamic> json) =>
      AddRemoveWishlistmodel(
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
