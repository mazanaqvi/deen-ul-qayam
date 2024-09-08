import 'package:flutter/material.dart';
import 'package:yourappname/model/blogdetailmodel.dart';
import 'package:yourappname/webservice/apiservice.dart';

class BlogDetailProvider extends ChangeNotifier {
  BlogDetailModel blogDetailModel = BlogDetailModel();
  bool loading = false;

  Future<void> getBlogDetail(blogid) async {
    loading = true;
    blogDetailModel = await ApiService().blogDetail(blogid);
    loading = false;
    notifyListeners();
  }
}
