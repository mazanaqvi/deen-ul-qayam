// To parse this JSON data, do
//
//     final getQuestionByChapterModel = getQuestionByChapterModelFromJson(jsonString);

import 'dart:convert';

GetQuestionByChapterModel getQuestionByChapterModelFromJson(String str) =>
    GetQuestionByChapterModel.fromJson(json.decode(str));

String getQuestionByChapterModelToJson(GetQuestionByChapterModel data) =>
    json.encode(data.toJson());

class GetQuestionByChapterModel {
  int? status;
  String? message;
  List<Result>? result;

  GetQuestionByChapterModel({
    this.status,
    this.message,
    this.result,
  });

  factory GetQuestionByChapterModel.fromJson(Map<String, dynamic> json) =>
      GetQuestionByChapterModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null
            ? []
            : List<Result>.from(
                json["result"]?.map((x) => Result.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  int? id;
  int? courseId;
  int? chapterId;
  String? question;
  String? optionA;
  String? optionB;
  String? optionC;
  String? optionD;
  String? answer;
  String? image;
  String? note;
  int? status;
  String? createdAt;
  String? updatedAt;

  Result({
    this.id,
    this.courseId,
    this.chapterId,
    this.question,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.answer,
    this.image,
    this.note,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        courseId: json["course_id"],
        chapterId: json["chapter_id"],
        question: json["question"],
        optionA: json["option_a"],
        optionB: json["option_b"],
        optionC: json["option_c"],
        optionD: json["option_d"],
        answer: json["answer"],
        image: json["image"],
        note: json["note"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "chapter_id": chapterId,
        "question": question,
        "option_a": optionA,
        "option_b": optionB,
        "option_c": optionC,
        "option_d": optionD,
        "answer": answer,
        "image": image,
        "note": note,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
