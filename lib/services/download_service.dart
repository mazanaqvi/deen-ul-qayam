// download_service.dart
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';

class DownloadService {
  final ReceivePort _port = ReceivePort();

  void bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      unbindBackgroundIsolate();
      bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      // Handle download updates
    });
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    int status,
    int progress,
  ) {
    if (!kIsWeb) {
      IsolateNameServer.lookupPortByName('downloader_send_port')
          ?.send([id, status, progress]);
    }
  }
}
