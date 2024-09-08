import 'package:yourappname/model/SuccessModel.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class PlayerProvider extends ChangeNotifier {
  SuccessModel successModel = SuccessModel();
  SuccessModel successVideoReadModel = SuccessModel();
  bool loading = false;

  addVideoView(type, contentId, videoId) async {
    loading = true;
    successModel = await ApiService().addContentView(type, contentId, videoId);
    loading = false;
    notifyListeners();
  }

  addVideoRead(courseId, videoId, chapterId) async {
    loading = true;
    successVideoReadModel =
        await ApiService().addVideoRead(courseId, videoId, chapterId);
    loading = false;
    notifyListeners();
  }
}
