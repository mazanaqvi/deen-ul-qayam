// lib/provider/show_download_provider.dart

import 'package:flutter/material.dart';
import 'package:yourappname/model/download_item.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';

class ShowDownloadProvider with ChangeNotifier {
  bool loading = false;
  int? dProgress = 0;
  String? itemId;

  Future<void> downloadLesson(String url, String savedDir, String fileName) async {
    loading = true;
    notifyListeners();

    try {
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: savedDir,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );
      itemId = taskId;
    } catch (e) {
      print('Error downloading lesson: $e');
    }

    loading = false;
    notifyListeners();
  }

  Future<void> notifyProvider() async {
    notifyListeners();
  }

  void clearProvider() {
    loading = false;
    dProgress = 0;
    itemId = null;
    notifyListeners();
  }
}
