import 'package:yourappname/model/searchmodel.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  SearchModel searchModel = SearchModel();
  bool loading = false;

  getSearch(type, name) async {
    loading = true;
    searchModel = await ApiService().search(type, name);
    loading = false;
    notifyListeners();
  }

  clearProvider() {
    searchModel = SearchModel();
    loading = false;
  }
}
