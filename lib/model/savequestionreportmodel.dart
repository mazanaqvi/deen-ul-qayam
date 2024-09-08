// To parse this JSON data, do
//
//     final saveQuestionReportModel = saveQuestionReportModelFromJson(jsonString);

import 'dart:convert';

SaveQuestionReportModel saveQuestionReportModelFromJson(String str) =>
    SaveQuestionReportModel.fromJson(json.decode(str));

String saveQuestionReportModelToJson(SaveQuestionReportModel data) =>
    json.encode(data.toJson());

class SaveQuestionReportModel {
  int? status;
  String? message;
  List<Result>? result;

  SaveQuestionReportModel({
    this.status,
    this.message,
    this.result,
  });

  factory SaveQuestionReportModel.fromJson(Map<String, dynamic> json) =>
      SaveQuestionReportModel(
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
  int? userId;
  int? courseId;
  int? chapterId;
  int? totalQuestions;
  int? questionsAttended;
  int? correctAnswers;
  int? percentage;
  int? status;
  String? createdAt;
  String? updatedAt;

  Result({
    this.id,
    this.userId,
    this.courseId,
    this.chapterId,
    this.totalQuestions,
    this.questionsAttended,
    this.correctAnswers,
    this.percentage,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        courseId: json["course_id"],
        chapterId: json["chapter_id"],
        totalQuestions: json["total_questions"],
        questionsAttended: json["questions_attended"],
        correctAnswers: json["correct_answers"],
        percentage: json["percentage"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "course_id": courseId,
        "chapter_id": chapterId,
        "total_questions": totalQuestions,
        "questions_attended": questionsAttended,
        "correct_answers": correctAnswers,
        "percentage": percentage,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
