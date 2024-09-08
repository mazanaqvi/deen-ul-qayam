import 'package:yourappname/model/SuccessModel.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class ReadBookProvider extends ChangeNotifier {
  SuccessModel successModel = SuccessModel();
  bool loading = false;

  addVideoView(type, contentId, videoId) async {
    loading = true;
    successModel = await ApiService().addContentView(type, contentId, videoId);
    loading = false;
    notifyListeners();
  }
}
