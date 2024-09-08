import 'package:yourappname/model/getpagemodel.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class GetPageProvider extends ChangeNotifier {
  GetPageModel getpagemodel = GetPageModel();

  bool loading = false;

// featurepage banner
  getPages() async {
    loading = true;
    getpagemodel = await ApiService().getpage();
    loading = false;
    notifyListeners();
  }
}
