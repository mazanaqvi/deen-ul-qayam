// To parse this JSON data, do
//
//     final certificateModel = certificateModelFromJson(jsonString);

import 'dart:convert';

CertificateModel certificateModelFromJson(String str) =>
    CertificateModel.fromJson(json.decode(str));

String certificateModelToJson(CertificateModel data) =>
    json.encode(data.toJson());

class CertificateModel {
  int? status;
  String? message;
  Result? result;

  CertificateModel({
    this.status,
    this.message,
    this.result,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) =>
      CertificateModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result?.toJson(),
      };
}

class Result {
  String? pdfUrl;

  Result({
    this.pdfUrl,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        pdfUrl: json["pdf_url"],
      );

  Map<String, dynamic> toJson() => {
        "pdf_url": pdfUrl,
      };
}
