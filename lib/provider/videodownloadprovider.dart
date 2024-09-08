import 'package:flutter/material.dart';
import 'package:yourappname/utils/utils.dart';

class VideoDownloadProvider extends ChangeNotifier {
  int dProgress = 0;
  bool loading = false;

  setDownloadProgress(int progress) {
    loading = (progress != -1);
    dProgress = progress;
    notifyListeners();
    printLog('setDownloadProgress dProgress ==============> $dProgress');
  }

  setLoading(bool isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  clearProvider() {
    printLog("<================ clearProvider ================>");
    dProgress = 0;
  }
}
