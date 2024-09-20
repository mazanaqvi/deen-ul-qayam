import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:yourappname/model/blogdetailmodel.dart';
import 'package:yourappname/model/buybookmodel.dart';
import 'package:yourappname/model/certificatemodel.dart';
import 'package:yourappname/model/download_item.dart';
import 'package:yourappname/model/ebookdetailmodel.dart';
import 'package:yourappname/model/getcoursereviewmodel.dart';
import 'package:yourappname/model/getebookmodel.dart';
import 'package:yourappname/model/getvideobychapter.dart';
import 'package:yourappname/model/introscreenmodel.dart';
import 'package:yourappname/model/notificationmodel.dart';
import 'package:yourappname/model/packagemodel.dart';
import 'package:yourappname/model/relatedbookmodel.dart';
import 'package:yourappname/model/savequestionreportmodel.dart';
import 'package:yourappname/model/sectiondetailmodel.dart';
import 'package:yourappname/model/sectionlistmodel.dart';
import 'package:yourappname/model/sociallinkmodel.dart';
import 'package:yourappname/model/videobyidmodel.dart';
import 'package:yourappname/provider/showdownloadprovider.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:yourappname/model/SuccessModel.dart';
import 'package:yourappname/model/addcommentmodel.dart';
import 'package:yourappname/model/addtransectionmodel.dart';
import 'package:yourappname/model/categorymodel.dart';
import 'package:yourappname/model/chatusermodel.dart';
import 'package:yourappname/model/coursedetailsmodel.dart';
import 'package:yourappname/model/courselistbytutoridmodel.dart';
import 'package:yourappname/model/generalsettingmodel.dart';
import 'package:yourappname/model/getpagemodel.dart';
import 'package:yourappname/model/getquestionbycategorymodel.dart';
import 'package:yourappname/model/searchmodel.dart';
import 'package:yourappname/model/loginmodel.dart';
import 'package:yourappname/model/mycoursemodel.dart';
import 'package:yourappname/model/paymentoptionmodel.dart';
import 'package:yourappname/model/profilemodel.dart';
import 'package:yourappname/model/registermodel.dart';
import 'package:yourappname/model/relatedcoursemodel.dart';
import 'package:yourappname/model/tutorprofilemodel.dart';
import 'package:yourappname/model/updateprofilemodel.dart';
import 'package:yourappname/model/wishlistmodel.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as path;
import 'package:yourappname/model/getvideobychapter.dart' as episode;
import 'package:yourappname/model/coursedetailsmodel.dart' as contentdetails;

class ApiService {
  String baseUrl = Constant.baseurl;

  late Dio dio;

  ApiService() {
    dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    // dio.interceptos.add(
    //   PrettyDioLogger(
    //       requestHeader: true,
    //       requestBody: true,
    //       responseBody: true,
    //       responseHeader: false,
    //       error: true,
    //       compact: true,
    //       maxWidth: 90),
    // );
  }

  /* General APi Start */

  Future<GeneralSettingModel> genaralSetting() async {
    GeneralSettingModel generalSettingModel;
    String apiname = "general_setting";
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
    )); // Add this line before making the API call

    try {
      Response response = await dio.post('$baseUrl$apiname');
      if (response.statusCode == 200) {
        // Parse the result from the response
        generalSettingModel = GeneralSettingModel.fromJson(response.data);

        // Pretty print the response using jsonEncode with indentation
        final prettyResponse =
            JsonEncoder.withIndent('  ').convert(response.data);
        print('General settings fetched successfully:\n$prettyResponse');

        return generalSettingModel;
      } else {
        print('Error: ${response.statusCode}');
        throw Exception("Failed to fetch general settings");
      }
    } catch (e) {
      print("Dio error: $e");
      throw Exception("Failed to fetch general settings");
    }
  }

  Future<IntroScreenModel> getOnboardingScreen() async {
    IntroScreenModel introScreenModel;
    String apiName = "get_onboarding_screen";
    Response response = await dio.post(
      '$baseUrl$apiName',
    );
    introScreenModel = IntroScreenModel.fromJson(response.data);
    return introScreenModel;
  }

  Future<Loginmodel> login(type, number, email, password, deviceType,
      deviceToken, firebaseId, countryCode, countryName) async {
    Loginmodel loginModel;
    String login = "login";
    Response response = await dio.post('$baseUrl$login',
        data: FormData.fromMap({
          'type': type,
          'mobile_number': number,
          'email': email,
          'password': password,
          'device_type': deviceType,
          'device_token': deviceToken,
          'firebase_id': firebaseId,
          'country_code': countryCode,
          'country_name': countryName,
        }));

    loginModel = Loginmodel.fromJson(response.data);
    return loginModel;
  }

  Future<Registermodel> register(
      fullname, email, number, password, countryCode, countryName) async {
    Registermodel registermodel;
    String apiname = "registration";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'full_name': fullname,
          'email': email,
          'mobile_number': number,
          'password': password,
          'country_code': countryCode,
          'country_name': countryName,
        }));
    registermodel = Registermodel.fromJson(response.data);
    return registermodel;
  }

  Future<ProfileModel> profile() async {
    // Hardcoded profile response
    const hardcodedResponse = '''
  {
    "status": 200,
    "message": "Profile fetched successfully",
    "result": [
      {
        "id": 1,
        "firebase_id": "hardcoded_firebase_id",
        "user_name": "Essa",
        "full_name": "Essa Arshad",
        "email": "essa@example.com",
        "mobile_number": "+1234567890",
        "country_code": "US",
        "country_name": "United States",
        "type": 1,
        "image": "https://example.com/profile_image.jpg",
        "description": "This is a hardcoded profile description.",
        "pratice_quiz_score": 80,
        "is_tutor": 0,
        "device_type": 1,
        "device_token": "hardcoded_device_token",
        "status": 1,
        "created_at": "2024-01-01 12:00:00",
        "updated_at": "2024-09-20 12:00:00",
        "is_buy": 0,
        "package_name": "Premium",
        "package_price": 0.00
      }
    ]
  }
  ''';

    // Parse the hardcoded response into ProfileModel
    final jsonResponse = jsonDecode(hardcodedResponse);
    ProfileModel profileModel = ProfileModel.fromJson(jsonResponse);

    return profileModel;
  }

  Future<Updateprofilemodel> updateprofile(fullname, mobilenumber, email,
      countryCode, countryName, File imagefile) async {
    Updateprofilemodel updateprofilemodel;
    String updateprofile = "update_profile";
    Response response = await dio.post('$baseUrl$updateprofile',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'full_name': fullname,
          'email': email,
          'mobile_number': mobilenumber,
          'country_code': countryCode,
          'country_name': countryName,
          if (imagefile.path != "")
            'image': await MultipartFile.fromFile(imagefile.path,
                filename: basename(imagefile.path)),
        }));

    updateprofilemodel = Updateprofilemodel.fromJson(response.data);
    return updateprofilemodel;
  }

  Future<Updateprofilemodel> forgotPassword(password) async {
    Updateprofilemodel forgotpasswordModel;
    String updateprofile = "update_profile";
    Response response = await dio.post('$baseUrl$updateprofile',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'password': password,
        }));

    forgotpasswordModel = Updateprofilemodel.fromJson(response.data);
    return forgotpasswordModel;
  }

  Future<GetPageModel> getpage() async {
    GetPageModel getPageModel;
    String apiname = "get_pages";
    Response response = await dio.post('$baseUrl$apiname');
    getPageModel = GetPageModel.fromJson(response.data);
    return getPageModel;
  }

  Future<SocialLinkModel> getSocialLink() async {
    // Hardcoded JSON response
    const hardcodedResponse = '''
  {
    "status": 200,
    "message": "Social links fetched successfully",
    "result": [
      {
        "id": 1,
        "name": "Facebook",
        "image": "https://example.com/facebook_logo.png",
        "url": "https://www.facebook.com/",
        "status": 1,
        "created_at": "2024-01-01 12:00:00",
        "updated_at": "2024-09-20 12:00:00"
      },
      {
        "id": 2,
        "name": "Twitter",
        "image": "https://example.com/twitter_logo.png",
        "url": "https://www.twitter.com/",
        "status": 1,
        "created_at": "2024-01-01 12:00:00",
        "updated_at": "2024-09-20 12:00:00"
      }
    ]
  }
  ''';

    // Parse the hardcoded response into SocialLinkModel
    final jsonResponse = jsonDecode(hardcodedResponse);
    SocialLinkModel socialLinkModel = SocialLinkModel.fromJson(jsonResponse);

    return socialLinkModel;
  }

  /* General APi End */

  Future<SectionListModel> sectionList(pageno) async {
    SectionListModel sectionListModel;
    String apiname = "section_list";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'page_no': pageno,
        }));
    sectionListModel = SectionListModel.fromJson(response.data);
    return sectionListModel;
  }

  Future<SectionDetailModel> sectionDetail(sectionId, pageno) async {
    SectionDetailModel sectionDetailModel;
    String apiname = "section_detail";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': (Constant.userID == null) ? 0 : Constant.userID,
          'section_id': sectionId,
          'page_no': pageno,
        }));
    sectionDetailModel = SectionDetailModel.fromJson(response.data);
    return sectionDetailModel;
  }

  Future<CategoryModel> category(pageNo) async {
    CategoryModel categoryModel;
    String apiname = "get_category";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'page_no': pageNo,
        }));
    categoryModel = CategoryModel.fromJson(response.data);
    return categoryModel;
  }

  Future<MyCourseModel> mycourse(pageno) async {
    // Hardcoded JSON response
    const hardcodedResponse = '''
  {
    "status": 200,
    "message": "Courses fetched successfully",
    "result": [
      {
        "id": 1,
        "tutor_id": 123,
        "category_id": 10,
        "language_id": 1,
        "title": "Introduction to Flutter",
        "description": "This is a beginner course for Flutter development.",
        "thumbnail_img": "https://example.com/thumbnail.jpg",
        "landscape_img": "https://example.com/landscape.jpg",
        "is_free": 1,
        "price": 0,
        "total_view": 1024,
        "status": 1,
        "created_at": "2024-09-15",
        "updated_at": "2024-09-16",
        "category_name": "Mobile Development",
        "language_name": "English",
        "tutor_name": "John Doe",
        "is_buy": 1,
        "avg_rating": "4.8",
        "is_download_certificate": 1
      },
      {
        "id": 2,
        "tutor_id": 102,
        "category_id": 15,
        "language_id": 2,
        "title": "Data Science with Python",
        "description": "A comprehensive guide to data science using Python.",
        "thumbnail_img": "https://example.com/python_thumbnail.jpg",
        "landscape_img": "https://example.com/python_landscape.jpg",
        "is_free": 0,
        "price": 49,
        "total_view": 2300,
        "status": 1,
        "created_at": "2024-08-01",
        "updated_at": "2024-09-18",
        "category_name": "Data Science",
        "language_name": "Spanish",
        "tutor_name": "Jane Smith",
        "is_buy": 0,
        "avg_rating": "4.7",
        "is_download_certificate": 0
      }
    ],
    "total_rows": 2,
    "total_page": 1,
    "current_page": 1,
    "more_page": false
  }
  ''';

    final jsonResponse = jsonDecode(hardcodedResponse);
    MyCourseModel myCourseModel = MyCourseModel.fromJson(jsonResponse);

    return myCourseModel;
  }

  Future<SearchModel> search(type, name) async {
    var hardcodedSearchResponse = {
      "status": 200,
      "message": "Success",
      "result": [
        {
          "id": 1,
          "tutor_id": 123,
          "category_id": 10,
          "language_id": 1,
          "title": "Introduction to Flutter",
          "description": "This is a beginner course for Flutter development.",
          "thumbnail_img": "https://example.com/thumbnail.jpg",
          "landscape_img": "https://example.com/landscape.jpg",
          "is_free": 1,
          "price": 0,
          "total_view": 1024,
          "status": 1,
          "created_at": "2024-09-15",
          "updated_at": "2024-09-16",
          "category_name": "Mobile Development",
          "language_name": "English",
          "tutor_name": "John Doe",
          "is_buy": 1,
          "is_user_buy": 1,
          "avg_rating": "4.8",
          "is_wishlist": 1
        }
      ],
      "total_rows": 1,
      "total_page": 1,
      "current_page": 1,
      "more_page": false
    };

    SearchModel searchModel = SearchModel.fromJson(hardcodedSearchResponse);

    return searchModel;
  }

/* Video By Category & Language */

  Future<VideobyIdModel> getContentbyCategoryId(categoryId, pageNo) async {
  // Create a variable to store the hardcoded response based on the courseId and chapterId
  var hardcodedVideoByChapterResponse;

  // Condition to return different content based on the courseId or chapterId
  if (categoryId == 10) {
    // Content for the Flutter course (categoryId = 10)
    hardcodedVideoByChapterResponse = {
      "status": 200,
      "message": "Success",
      "result": [
        {
          "id": 1,
          "course_id": categoryId,
          "chapter_id": 1,
          "title": "Flutter - Introduction",
          "thumbnail_img": "https://example.com/flutter_thumbnail1.jpg",
          "landscape_img": "https://example.com/flutter_landscape1.jpg",
          "video_type": "mp4",
          "video_url":
              "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
          "duration": 600,
          "description": "Introduction to Flutter Development.",
          "total_view": 1500,
          "status": 1,
          "created_at": "2024-09-15",
          "updated_at": "2024-09-16",
          "is_buy": 1,
          "is_read": 1
        },
        {
          "id": 2,
          "course_id": categoryId,
          "chapter_id": 2,
          "title": "Flutter - Widgets",
          "thumbnail_img": "https://example.com/flutter_thumbnail2.jpg",
          "landscape_img": "https://example.com/flutter_landscape2.jpg",
          "video_type": "mp4",
          "video_url":
              "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
          "duration": 900,
          "description": "Introduction to Widgets in Flutter.",
          "total_view": 1000,
          "status": 1,
          "created_at": "2024-09-15",
          "updated_at": "2024-09-16",
          "is_buy": 1,
          "is_read": 1
        }
      ],
      "total_rows": 2,
      "total_page": 1,
      "current_page": 1,
      "more_page": false
    };
  } else if (categoryId == 15) {
    // Content for the Data Science course (categoryId = 15)
    hardcodedVideoByChapterResponse = {
      "status": 200,
      "message": "Success",
      "result": [
        {
          "id": 1,
          "course_id": categoryId,
          "chapter_id": 1,
          "title": "Data Science - Python Introduction",
          "thumbnail_img": "https://example.com/python_thumbnail1.jpg",
          "landscape_img": "https://example.com/python_landscape1.jpg",
          "video_type": "mp4",
          "video_url":
              "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
          "duration": 1200,
          "description": "Introduction to Data Science using Python.",
          "total_view": 2300,
          "status": 1,
          "created_at": "2024-08-01",
          "updated_at": "2024-09-18",
          "is_buy": 1,
          "is_read": 1
        },
        {
          "id": 2,
          "course_id": categoryId,
          "chapter_id": 2,
          "title": "Data Science - Pandas Overview",
          "thumbnail_img": "https://example.com/python_thumbnail2.jpg",
          "landscape_img": "https://example.com/python_landscape2.jpg",
          "video_type": "mp4",
          "video_url":
              "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
          "duration": 1500,
          "description": "Learn how to use Pandas for Data Science.",
          "total_view": 2000,
          "status": 1,
          "created_at": "2024-08-01",
          "updated_at": "2024-09-18",
          "is_buy": 0,
          "is_read": 1
        }
      ],
      "total_rows": 2,
      "total_page": 1,
      "current_page": 1,
      "more_page": false
    };
  }

  // Parse the hardcoded response into VideobyIdModel
  final jsonResponse = jsonDecode(jsonEncode(hardcodedVideoByChapterResponse));
  VideobyIdModel videobyIdModel = VideobyIdModel.fromJson(jsonResponse);

  return videobyIdModel;
}

  Future<VideobyIdModel> getContentbyLanguageId(languageId, pageNo) async {
    VideobyIdModel videobyIdModel;
    String apiname = "get_content_by_language";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'language_id': languageId,
          'page_no': pageNo,
        }));
    videobyIdModel = VideobyIdModel.fromJson(response.data);
    return videobyIdModel;
  }

  /* Detail Page All Api's Start */

  Future<CourseDetailsModel> courseDetail(courseId) async {
    // Create a hardcoded response matching the structure of CourseDetailsModel
    var hardcodedResponse = {
      "status": 200,
      "message": "Success",
      "result": [
        {
          "id": 2,
          "tutor_id": 123,
          "category_id": 10,
          "language_id": 1,
          "title": "Introduction to Flutter",
          "description": "This is a beginner course for Flutter development.",
          "thumbnail_img": "https://example.com/thumbnail.jpg",
          "landscape_img": "https://example.com/landscape.jpg",
          "is_free": 1,
          "price": 0,
          "total_view": 1024,
          "status": 1,
          "created_at": "2024-09-15",
          "updated_at": "2024-09-16",
          "category_name": "Mobile Development",
          "language_name": "English",
          "tutor_name": "John Doe",
          "is_buy": 1,
          "is_user_buy": 1,
          "avg_rating": "4.8",
          "is_wishlist": 1,
          "is_download_certificate": 1,
          "total_duration": 120,
          "chapter": [
            {
              "id": 1,
              "course_id": 2,
              "name": "Getting Started with Flutter",
              "image": "https://example.com/chapter1.jpg",
              "quiz_status": 1,
              "status": 1,
              "created_at": "2024-09-15",
              "updated_at": "2024-09-16",
              "is_quiz_play": 1
            },
            {
              "id": 2,
              "course_id": 2,
              "name": "Flutter Widgets",
              "image": "https://example.com/chapter2.jpg",
              "quiz_status": 1,
              "status": 1,
              "created_at": "2024-09-15",
              "updated_at": "2024-09-16",
              "is_quiz_play": 1
            }
          ],
          "requrirment": [
            {
              "id": 1,
              "course_id": 2,
              "title": "Basic knowledge of programming",
              "status": 1,
              "created_at": "2024-09-15",
              "updated_at": "2024-09-16"
            }
          ],
          "inlcude": [
            {
              "id": 1,
              "course_id": 2,
              "title": "Lifetime access",
              "status": 1,
              "created_at": "2024-09-15",
              "updated_at": "2024-09-16"
            }
          ],
          "what_you_learn": [
            {
              "id": 1,
              "course_id": 2,
              "title": "Understand Flutter basics",
              "status": 1,
              "created_at": "2024-09-15",
              "updated_at": "2024-09-16"
            },
            {
              "id": 2,
              "course_id": 2,
              "title": "Create Flutter mobile apps",
              "status": 1,
              "created_at": "2024-09-15",
              "updated_at": "2024-09-16"
            }
          ]
        }
      ]
    };

    // Manually populate CourseDetailsModel using the hardcoded data
    CourseDetailsModel courseDetailsModel =
        CourseDetailsModel.fromJson(hardcodedResponse);

    return courseDetailsModel;
  }

  Future<GetCourseReviewModel> courseReviewList(type, contentId, pageNo) async {
    GetCourseReviewModel getCourseReviewModel;
    String apiname = "get_review_by_content";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'type': type,
          'content_id': contentId,
          'page_no': pageNo,
        }));
    getCourseReviewModel = GetCourseReviewModel.fromJson(response.data);
    return getCourseReviewModel;
  }

  Future<SuccessModel> addContentView(type, contentId, videoId) async {
    SuccessModel successModel;
    String apiname = "add_content_view";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'type': type,
          'content_id': contentId,
          'video_id': videoId,
        }));
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  Future<SuccessModel> addVideoRead(courseId, videoId, chapterId) async {
    SuccessModel successVideoReadModel;
    String apiname = "add_video_read";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'course_id': courseId,
          'chapter_id': chapterId,
          'video_id': videoId,
        }));
    successVideoReadModel = SuccessModel.fromJson(response.data);
    return successVideoReadModel;
  }

  Future<RelatedCourseModel> relatedcourse(courseId, pageNo) async {
    RelatedCourseModel relatedCourseModel;
    String apiname = "get_related_course";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'course_id': courseId,
          'page_no': pageNo,
        }));
    relatedCourseModel = RelatedCourseModel.fromJson(response.data);
    return relatedCourseModel;
  }

  Future<GetVideoByChapterModel> videoByChapter(
      courseId, chapterId, pageNo) async {
    // Log the input parameters
    print(
        'DEBUG: Called videoByChapter with courseId: $courseId, chapterId: $chapterId, pageNo: $pageNo');

    var hardcodedVideoByChapterResponse;

    // Condition to return different content based on the courseId or chapterId
    if (int.parse(courseId.toString()) == 1 &&
        int.parse(chapterId.toString()) == 1) {

      print('DEBUG: Returning content for Course 1, Chapter 1');

      hardcodedVideoByChapterResponse = {
        "status": 200,
        "message": "Success",
        "result": [
          {
            "id": 1,
            "course_id": courseId,
            "chapter_id": chapterId,
            "title": "Course 1 - Introduction",
            "thumbnail_img": "https://example.com/course1_thumbnail1.jpg",
            "landscape_img": "https://example.com/course1_landscape1.jpg",
            "video_type": "mp4",
            "video_url":
                "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            "duration": 600,
            "description": "Introduction to Course 1.",
            "total_view": 1500,
            "status": 1,
            "created_at": "2024-09-15",
            "updated_at": "2024-09-16",
            "is_buy": 1,
            "is_read": 1
          }
        ],
        "total_rows": 1,
        "total_page": 1,
        "current_page": 1,
        "more_page": false
      };
    } else if (int.parse(courseId.toString()) == 2 &&
        int.parse(chapterId.toString()) == 1) {
      print('DEBUG: Returning content for Course 2, Chapter 1');

      hardcodedVideoByChapterResponse = {
        "status": 200,
        "message": "Success",
        "result": [
          {
            "id": 2,
            "course_id": courseId,
            "chapter_id": chapterId,
            "title": "Course 2 - Introduction",
            "thumbnail_img": "https://example.com/course2_thumbnail1.jpg",
            "landscape_img": "https://example.com/course2_landscape1.jpg",
            "video_type": "mp4",
            "video_url":
                "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            "duration": 1200,
            "description": "Introduction to Course 2.",
            "total_view": 2300,
            "status": 1,
            "created_at": "2024-08-01",
            "updated_at": "2024-09-18",
            "is_buy": 1,
            "is_read": 1
          }
        ],
        "total_rows": 1,
        "total_page": 1,
        "current_page": 1,
        "more_page": false
      };
    } else {
      print(
          'DEBUG: No content available for courseId: $courseId, chapterId: $chapterId');

      hardcodedVideoByChapterResponse = {
        "status": 200,
        "message": "No videos available",
        "result": [],
        "total_rows": 0,
        "total_page": 0,
        "current_page": 0,
        "more_page": false
      };
    }

    // Log the response before sanitization
    print(
        'DEBUG: Hardcoded response before sanitization: $hardcodedVideoByChapterResponse');

    // Sanitize the result to ensure types are correct
    List<Map<String, dynamic>> sanitizedResults =
        (hardcodedVideoByChapterResponse["result"] as List).map((video) {
      return {
        "id": int.tryParse(video["id"].toString()) ?? 0,
        "course_id": int.tryParse(video["course_id"].toString()) ?? 0,
        "chapter_id": int.tryParse(video["chapter_id"].toString()) ?? 0,
        "title": video["title"],
        "thumbnail_img": video["thumbnail_img"],
        "landscape_img": video["landscape_img"],
        "video_type": video["video_type"],
        "video_url": video["video_url"],
        "duration": int.tryParse(video["duration"].toString()) ?? 0,
        "description": video["description"],
        "total_view": int.tryParse(video["total_view"].toString()) ?? 0,
        "status": int.tryParse(video["status"].toString()) ?? 0,
        "created_at": video["created_at"],
        "updated_at": video["updated_at"],
        "is_buy": int.tryParse(video["is_buy"].toString()) ?? 0,
        "is_read": int.tryParse(video["is_read"].toString()) ?? 0,
      };
    }).toList();

    // Log the sanitized results
    print('DEBUG: Sanitized results: $sanitizedResults');

    // Update the sanitized response back to the original structure
    hardcodedVideoByChapterResponse["result"] = sanitizedResults;

    // Convert to GetVideoByChapterModel
    GetVideoByChapterModel getVideoByChapterModel =
        GetVideoByChapterModel.fromJson(hardcodedVideoByChapterResponse);

    // Log the final model before returning
    print('DEBUG: Returning GetVideoByChapterModel: $getVideoByChapterModel');

    return getVideoByChapterModel;
  }

  Future<SuccessModel> addContentReview(
      type, contentId, comment, rating) async {
    printLog("rating ==> $rating");
    SuccessModel successModel;
    String apiname = "add_content_review";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'type': type,
          'content_id': contentId,
          'comment': comment,
          'rating': rating,
        }));
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  Future<CertificateModel> fetchCertificate(courseId) async {
    CertificateModel certificateModel;
    String apiname = "download_certificate";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'course_id': courseId,
        }));
    certificateModel = CertificateModel.fromJson(response.data);
    return certificateModel;
  }

  /* Detail Page All Api's End */

  /* (Wishlist Api Start) */

  Future<Wishlistmodel> wishlist(type, pageno) async {
    Wishlistmodel wishlistmodel;
    String apiname = "get_wishlist_content";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'type': type,
          'page_no': pageno,
        }));
    wishlistmodel = Wishlistmodel.fromJson(response.data);
    return wishlistmodel;
  }

  Future<SuccessModel> addRemoveWishlist(type, contentId) async {
    SuccessModel successModel;
    String apiname = "add_remove_wishlist";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'type': type,
          'content_id': contentId,
        }));
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  /* Wishlist Api End */

  Future<SuccessModel> updateDataForPayment(
      fullName, email, mobileNumber) async {
    printLog("updateDataForPayment userID :====> ${Constant.userID}");
    printLog("updateDataForPayment fullName :==> $fullName");
    printLog("updateDataForPayment email :=====> $email");
    printLog("updateProfile mobileNumber :=====> $mobileNumber");
    SuccessModel successModel;
    String apiName = "update_profile";
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        'user_id': Constant.userID,
        'full_name': fullName,
        'email': email,
        'mobile_number': mobileNumber,
      }),
    );

    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  /* Subscription Start */

  Future<PackageModel> package(pageNo) async {
    PackageModel packageModel;
    String apiname = "get_package";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'page_no': pageNo,
        }));
    packageModel = PackageModel.fromJson(response.data);
    return packageModel;
  }

  Future<PaymentOptionModel> paymentOption() async {
    PaymentOptionModel paymentOptionModel;
    String apiname = "get_payment_option";
    Response response = await dio.post('$baseUrl$apiname');
    paymentOptionModel = PaymentOptionModel.fromJson(response.data);
    return paymentOptionModel;
  }

  Future<SuccessModel> addPackageTransaction(
      packageId, price, transectionId, discription) async {
    SuccessModel successModel;
    String apiname = "add_package_transaction";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID == null ? "0" : (Constant.userID ?? ""),
          'package_id': packageId,
          'price': price,
          'transaction_id': transectionId,
          'description': discription,
        }));
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  Future<SuccessModel> addContentTransaction(
      type, contentId, price, transectionId, discription) async {
    SuccessModel successModel;
    String apiname = "add_content_transaction";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID == null ? "0" : (Constant.userID ?? ""),
          'type': type,
          'content_id': contentId,
          'price': price,
          'transaction_id': transectionId,
          'description': discription,
        }));
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

/* Subscription End */

  Future<CourselistbytutoridModel> getContentByTutor(
      type, tutorId, pageNo) async {
    CourselistbytutoridModel courselistbytutoridModel;
    String apiname = "get_content_by_tutor";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'type': type,
          'tutor_id': tutorId,
          'page_no': pageNo,
        }));
    courselistbytutoridModel = CourselistbytutoridModel.fromJson(response.data);
    return courselistbytutoridModel;
  }

  Future<Tutorprofilemodel> tutorprofile(tutorid) async {
    Tutorprofilemodel tutorprofilemodel;
    String apiname = "tutor_profile";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'tutor_id': tutorid,
        }));
    tutorprofilemodel = Tutorprofilemodel.fromJson(response.data);
    return tutorprofilemodel;
  }

  Future<BuyCourseModel> buyCourse(coursedetail, userid, currencycode,
      discountamount, type, courseid) async {
    BuyCourseModel buyCourseModel;
    String apiname = "buy_course";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'courses_detail': MultipartFile.fromString(coursedetail),
          'user_id': MultipartFile.fromString(userid),
          'currency_code': MultipartFile.fromString(currencycode),
          'total_amount': MultipartFile.fromString(discountamount),
          'type': MultipartFile.fromString(type),
          'course_id': MultipartFile.fromString(courseid),
        }));
    buyCourseModel = BuyCourseModel.fromJson(response.data);
    return buyCourseModel;
  }

  Future<Addcommentmodel> addcomment(userid, videoid, courseid, comment) async {
    Addcommentmodel addcommentmodel;
    String apiname = "add_comment";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': userid,
          'video_id': videoid,
          'course_id': courseid,
          'comment': comment,
        }));
    addcommentmodel = Addcommentmodel.fromJson(response.data);
    return addcommentmodel;
  }

/* Quize Api Start */

  Future<GetQuestionByChapterModel> questionByChapter(
      courseId, chapterId) async {
    GetQuestionByChapterModel getQuestionByCategoryModel;
    String apiname = "get_question_by_chapter";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'course_id': courseId,
          'chapter_id': chapterId,
        }));
    getQuestionByCategoryModel =
        GetQuestionByChapterModel.fromJson(response.data);
    return getQuestionByCategoryModel;
  }

  Future<SaveQuestionReportModel> saveCourseQuestionReport(
    courseId,
    chapterId,
    totalQuestion,
    questionsAttended,
    correctAnswers,
  ) async {
    SaveQuestionReportModel saveQuestionReportModel;
    String content = "save_course_question_report";
    Response response = await dio.post('$baseUrl$content',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'course_id': courseId,
          'chapter_id': chapterId,
          'total_questions': totalQuestion,
          'questions_attended': questionsAttended,
          'correct_answers': correctAnswers,
        }));
    saveQuestionReportModel = SaveQuestionReportModel.fromJson((response.data));
    return saveQuestionReportModel;
  }

/* Quize Api End */

  Future<SuccessModel> becomeTutor(
      String username,
      String email,
      String discription,
      String bankName,
      String bankCode,
      String bankAddress,
      String bankAccount,
      String bankIFSCCode,
      File profileImg,
      File coverImg,
      File idProf) async {
    SuccessModel becometutorModel;
    String apiname = "become_tutor";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'user_name': username,
          'email': email,
          'description': discription,
          'bank_name': bankName,
          'bank_code': bankCode,
          'bank_address': bankAddress,
          'account_no': bankAccount,
          'ifsc_code': bankIFSCCode,
          "profile_image": (profileImg.path.isNotEmpty)
              ? MultipartFile.fromFileSync(
                  profileImg.path,
                  filename: (profileImg.path),
                )
              : "",
          "cover_image": (coverImg.path.isNotEmpty)
              ? MultipartFile.fromFileSync(
                  coverImg.path,
                  filename: (coverImg.path),
                )
              : "",
          "id_proof": (idProf.path.isNotEmpty)
              ? MultipartFile.fromFileSync(
                  idProf.path,
                  filename: (idProf.path),
                )
              : "",
        }));
    becometutorModel = SuccessModel.fromJson(response.data);
    return becometutorModel;
  }

  Future<NotificationModel> getNotification(pageNo) async {
    NotificationModel notificationModel;
    String apiname = "get_notification";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'page_no': pageNo,
        }));
    notificationModel = NotificationModel.fromJson(response.data);
    return notificationModel;
  }

  Future<SuccessModel> readNotification(notificationId) async {
    SuccessModel successModel;
    String apiname = "read_notification";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'notification_id': notificationId,
        }));
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

/* Books Related APi Start */

  Future<EbookModel> bookList(pageNo) async {
    EbookModel getEbookModel;
    String apiname = "get_latest_book";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'page_no': pageNo,
        }));
    getEbookModel = EbookModel.fromJson(response.data);
    return getEbookModel;
  }

  Future<EbookDetailModel> bookDetail(bookId) async {
    EbookDetailModel ebookDetailModel;
    String apiname = "book_detail";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'book_id': bookId,
        }));
    ebookDetailModel = EbookDetailModel.fromJson(response.data);
    return ebookDetailModel;
  }

  Future<RelatedBookModel> relatedBooks(bookId, pageNo) async {
    RelatedBookModel relatedBookModel;
    String apiname = "get_related_book";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'book_id': bookId,
          'page_no': pageNo,
        }));
    relatedBookModel = RelatedBookModel.fromJson(response.data);
    return relatedBookModel;
  }

  Future<Buybookmodel> buybook(bookId, amount, userid) async {
    printLog("Api Service ==>$userid");
    Buybookmodel buybookmodel;
    String apiname = "buy_book";
    printLog("userid==>${Constant.userID}");
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'user_id': Constant.userID,
          'book_id': bookId,
          'total_amount': amount,
        }));
    buybookmodel = Buybookmodel.fromJson(response.data);
    return buybookmodel;
  }

/* Books Related Api End */

  /* Blog Related Api Start */

  Future<BlogDetailModel> blogDetail(blogId) async {
    BlogDetailModel blogDetailModel;
    String apiname = "blog_detail";
    Response response = await dio.post('$baseUrl$apiname',
        data: FormData.fromMap({
          'blog_id': blogId,
        }));
    blogDetailModel = BlogDetailModel.fromJson(response.data);
    return blogDetailModel;
  }

  /* Blog Related Api End */

  /* Send FCM PushNotification API */
  Future sendFCMPushNoti(ChatUserModel? currentUserData, currentuserfirebasid,
      touserfirebaseid, ChatUserModel? toUserData, String? msgContent) async {
    printLog("push token == ${toUserData?.pushToken}");
    var params = {
      "to": toUserData?.pushToken ?? "",
      "notification": {
        "title": "New Message from ${currentUserData?.name}:",
        "body": msgContent ?? "",
      },
      "data": {
        "type": "chat",
        "fromFId": currentuserfirebasid,
        "toFId": touserfirebaseid,
        "username": currentUserData?.name,
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      },
      "android": {
        "priority": "high",
      },
    };
    var url = 'https://fcm.googleapis.com/fcm/send';
    var response = await http.post(Uri.parse(url),
        headers: {
          /* Use Authorization key = Your Firebase Server key from Project Setting */
          "Authorization":
              "key=AAAAbwZ09Kk:APA91bGmF3c2CYKzy96uiJFzoqhmlANoz0jAsZrowI3NGv-S_iWwFe5uGgQHjkv7hlyEBmysC5x8otgwCz8znwbG42p43ZFBFNc7r9nMTsIasSG9NbIzvAW4BTlIUAdMSB1ei6UfwNV_",
          "Content-Type": "application/json;charset=UTF-8",
          "Charset": "utf-8"
        },
        body: json.encode(params));

    if (response.statusCode == 200) {
      printLog("Send Notification");
      Map<String, dynamic> map = json.decode(response.body);
      printLog("fcm.google map :=====> $map");
    } else {
      Map<String, dynamic> error = jsonDecode(response.body);
      printLog("Send error===> $error");
      printLog("fcm.google error :=====> $error");
    }
  }
}

Future<void> prepareShowDownload(
  BuildContext context, {
  required contentdetails.Result? contentDetails,
  required int? seasonPos,
  required int? episodePos,
  required episode.Result? episodeDetails,
}) async {
  final receivePort = ReceivePort();
  contentdetails.Result? courseDetails = contentDetails;
  int seasonPosition = seasonPos ?? 0;
  int epiPos = episodePos ?? 0;
  episode.Result? epiDetails = episodeDetails;

  final downloadProvider =
      Provider.of<ShowDownloadProvider>(context, listen: false);
  await downloadProvider.setCurrentDownload(epiDetails?.id ?? 0);

  Dio dio = Dio();

  /* Hive */
  var dowonloadBox =
      Hive.box<DownloadItem>('${Constant.hiveDownloadBox}_${Constant.userID}');
  var dowonloadSeasonBox = Hive.box<ChapterItem>(
      '${Constant.hiveSeasonDownloadBox}_${Constant.userID}');
  var dowonloadEpiBox = Hive.box<EpisodeItem>(
      '${Constant.hiveEpiDownloadBox}_${Constant.userID}');
  if (!dowonloadBox.isOpen) {
    return;
  }

  DateTime now = DateTime.now();
  String timeStamp = now.millisecondsSinceEpoch.abs().toString();

  /* Prepare Target Video File START ************* */
  File? mTargetFile;
  String? localPath;
  String? mFileName = '${(courseDetails?.title ?? "").replaceAll(" ", "")}'
      '${(courseDetails?.id ?? 0)}${(Constant.userID)}';
  try {
    localPath = await Utils.prepareShowSaveDir(
        (courseDetails?.title ?? "").replaceAll(RegExp('\\W+'), ''),
        (courseDetails?.chapter?[seasonPosition].name ?? "")
            .replaceAll(RegExp('\\W+'), ''));
    printLog("localPath ====> $localPath");
    String? mFileName =
        '${(courseDetails?.chapter?[seasonPosition].name ?? "").replaceAll(RegExp('\\W+'), '')}'
        '_Ep${(epiPos + 1)}_${episodeDetails?.id}${(Constant.userID)}';

    mTargetFile = File(path.join(localPath, '$mFileName.${'mp4'}'));
  } catch (e) {
    printLog("saveShowStorage Exception ===> $e");
  }
  printLog("mFileName ======> $mFileName");
  printLog("mTargetFile ====> ${mTargetFile?.absolute.path ?? ""}");
  /* *************** Prepare Target Video File END */

  /* Prepare Target Image Files START ************* */
  File? mShowPortImageFile,
      mShowLandImageFile,
      mEpiPortImageFile,
      mEpiLandImageFile;
  String? mShowPortImgFileName = 'port_$timeStamp';
  String? mShowLandImgFileName = 'land_$timeStamp';
  String? mEpiPortImgFileName = 'port_epi_$timeStamp';
  String? mEpiLandImgFileName = 'land_epi_$timeStamp';
  if (localPath != null) {
    try {
      mShowPortImageFile =
          File(path.join(localPath, '$mShowPortImgFileName.png'));
      mShowLandImageFile =
          File(path.join(localPath, '$mShowLandImgFileName.png'));
      mEpiPortImageFile =
          File(path.join(localPath, '$mEpiPortImgFileName.png'));
      mEpiLandImageFile =
          File(path.join(localPath, '$mEpiLandImgFileName.png'));
    } catch (e) {
      printLog("saveShowStorage Exception ===> $e");
    }
  } else {
    return;
  }
  printLog("mPortImageFileName ======> $mShowPortImgFileName");
  printLog(
      "mTargetPortImageFile ====> ${mShowPortImageFile?.absolute.path ?? ""}");
  printLog("mLandImageFileName ======> $mShowLandImgFileName");
  printLog(
      "mTargetLandImageFile ====> ${mShowLandImageFile?.absolute.path ?? ""}");
  printLog("mEpiPortImgFileName =====> $mEpiPortImgFileName");
  printLog(
      "mEpiPortImageFile =======> ${mEpiPortImageFile?.absolute.path ?? ""}");
  printLog("mEpiLandImgFileName =====> $mEpiLandImgFileName");
  printLog(
      "mEpiLandImageFile =======> ${mEpiLandImageFile?.absolute.path ?? ""}");
  /* *************** Prepare Target Image Files END */

  try {
    if (!context.mounted) return;
    Utils.showSnackbar(context, "showFor", "Download started", false);

    /* Save Video/Show */
    List<DownloadItem> myDownloadList = [];
    DownloadItem downloadedItem = DownloadItem(
      id: courseDetails?.id,
      securityKey: "",
      title: courseDetails?.title,
      description: courseDetails?.description,
      savedDir: localPath,
      savedFile: "",
      isFree: courseDetails?.isFree,
      isBuy: courseDetails?.isBuy,
      isDownloadCertificate: courseDetails?.isDownloadCertificate,
      avgRating: courseDetails?.avgRating,
      categoryId: courseDetails?.categoryId,
      categoryName: courseDetails?.categoryName,
      createdAt: courseDetails?.createdAt,
      isUserBuy: courseDetails?.isUserBuy,
      isWishlist: courseDetails?.isWishlist,
      languageId: courseDetails?.languageId,
      languageName: courseDetails?.languageName,
      price: courseDetails?.price,
      status: courseDetails?.status,
      totalDuration: courseDetails?.totalDuration,
      totalView: courseDetails?.totalView,
      tutorId: courseDetails?.tutorId,
      tutorName: courseDetails?.tutorName,
      updatedAt: courseDetails?.updatedAt,
      thumbnailImg: mShowPortImageFile?.path,
      landscapeImg: mShowLandImageFile?.path,
      chapter: null,
    );
    /* Check in Download Box */
    myDownloadList = dowonloadBox.values.where((myDowonloadItem) {
      return (myDowonloadItem.id == courseDetails?.id);
    }).toList();

    if (myDownloadList.isEmpty) {
      /* Potrait Image Download */
      dio.download(courseDetails?.thumbnailImg ?? "",
          path.join(localPath, '$mShowPortImgFileName.png'),
          onReceiveProgress: (received, total) {});

      /* Landscape Image Download */
      dio.download(courseDetails?.landscapeImg ?? "",
          path.join(localPath, '$mShowLandImgFileName.png'),
          onReceiveProgress: (received, total) {});
    }

    /* Potrait Episode Image Download */
    dio.download(epiDetails?.thumbnailImg ?? "",
        path.join(localPath, '$mEpiPortImgFileName.png'),
        onReceiveProgress: (received, total) {});

    /* Landscape Episode Image Download */
    dio.download(epiDetails?.landscapeImg ?? "",
        path.join(localPath, '$mEpiLandImgFileName.png'),
        onReceiveProgress: (received, total) {});

    /* Video Download */
    await dio.download(epiDetails?.videoUrl ?? "", mTargetFile?.path,
        onReceiveProgress: (received, total) async {
      if (total != -1) {
        await downloadProvider.setDownloadProgress(
            (received / total * 100).round(), epiDetails?.id ?? 0);
      }
    });

    /* Encrypt Episode File START ************** */
    String generateKey = Utils.generateRandomKey(32);
    printLog("generateKey =======> $generateKey");
    var rootToken = RootIsolateToken.instance!;
    final isolate = await Isolate.spawn(encryptFile,
        [mTargetFile, generateKey, receivePort.sendPort, rootToken]);
    receivePort.listen((message) {
      printLog("message =======> $message");
      if (message != null) {
        receivePort.close();
        isolate.kill(priority: Isolate.immediate);
      }
    });
    /* ***************** Encrypt Episode File END */

    /* Check In Downloaded Items START **************** */
    List<ChapterItem> mySavedSeasonList = [];
    List<EpisodeItem> mySavedEpiList = [];

    /* Save Episode */
    EpisodeItem episodeItem = EpisodeItem(
      id: episodeDetails?.id,
      securityKey: generateKey,
      courseId: courseDetails?.id,
      chapterId: episodeDetails?.chapterId,
      thumbnailImg: mEpiPortImageFile?.path,
      landscapeImg: mEpiLandImageFile?.path,
      videoUrl: episodeDetails?.videoUrl,
      duration: episodeDetails?.duration.toString(),
      videoType: episodeDetails?.videoType,
      description: episodeDetails?.description,
      status: episodeDetails?.status,
      savedDir: localPath,
      savedFile: mTargetFile?.path ?? "",
      isDownloaded: 1,
      isBuy: episodeDetails?.isBuy,
      createdAt: episodeDetails?.createdAt.toString(),
      isRead: episodeDetails?.isRead,
      title: episodeDetails?.title,
      totalView: episodeDetails?.totalView,
      updatedAt: episodeDetails?.updatedAt,
    );
    /* Save Season */
    ChapterItem sessionItem = ChapterItem(
      id: courseDetails?.chapter?[seasonPosition].id,
      courseId: courseDetails?.id,
      sessionPosition: seasonPosition,
      name: courseDetails?.chapter?[seasonPosition].name,
      status: courseDetails?.chapter?[seasonPosition].status,
      isDownload: 1,
      episode: null,
    );

    /* Check in Season Box */
    mySavedSeasonList = dowonloadSeasonBox.values.where((mySeasonItem) {
      return (mySeasonItem.courseId == courseDetails?.id &&
          mySeasonItem.id == courseDetails?.chapter?[seasonPosition].id);
    }).toList();
    /* Check in Episode Box */
    mySavedEpiList = dowonloadEpiBox.values.where((myEpiItem) {
      return (myEpiItem.courseId == courseDetails?.id &&
          myEpiItem.id == episodeDetails?.id &&
          myEpiItem.chapterId == courseDetails?.chapter?[seasonPosition].id);
    }).toList();
    printLog("myDownloadList =======> ${myDownloadList.length}");
    printLog("mySavedSeasonList ====> ${mySavedSeasonList.length}");
    printLog("mySavedEpiList =======> ${mySavedEpiList.length}");
    /* ****************** Check In Downloaded Items END */

    /* Insert in Hive */
    if (mySavedEpiList.isEmpty) {
      dowonloadEpiBox.add(episodeItem);
    }
    if (mySavedSeasonList.isEmpty) {
      dowonloadSeasonBox.add(sessionItem);
    }
    if (myDownloadList.isEmpty) {
      dowonloadBox.add(downloadedItem);
    }

    await downloadProvider.setDownloadProgress(-1, 0);
    await downloadProvider.setCurrentDownload(null);
    await downloadProvider.setLoading(false);
    if (!context.mounted) return;
    Utils.showSnackbar(context, "success", "Download completed", false);
  } catch (e) {
    if (!context.mounted) return;
    if (!context.mounted) return;
    Utils.showSnackbar(context, "fail", "Download Faild", false);
  }
}
/* ========================== Download Shows ========================== */