import 'package:flutter/foundation.dart';
import 'package:yourappname/model/generalsettingmodel.dart' as settings;
import 'package:yourappname/model/introscreenmodel.dart';
import 'package:yourappname/model/loginmodel.dart';
import 'package:yourappname/model/profilemodel.dart';
import 'package:yourappname/model/registermodel.dart';
import 'package:yourappname/utils/adhelper.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:flutter/material.dart';

class GeneralProvider extends ChangeNotifier {
  /* App Field */
  SharedPre sharedPre = SharedPre();
  settings.GeneralSettingModel generalSettingModel =
      settings.GeneralSettingModel();
  IntroScreenModel introScreenModel = IntroScreenModel();
  Loginmodel loginmodel = Loginmodel();
  Registermodel registermodel = Registermodel();
  ProfileModel profileModel = ProfileModel();
  /* Loading */
  bool loading = false;
  bool isProgressLoading = false;
  /* Other Field */
  int pageindex = 1;
  String? appDescription;

  /* Web Fields */
  bool isNotification = false;
  bool isSearch = false;
  bool isProfile = false;

/* ================================= Api Start ======================================= */

  Future<void> getGeneralsetting(BuildContext context) async {
    loading = true;
    generalSettingModel = await ApiService().genaralSetting();
    printLog('generalSettingData status ==> ${generalSettingModel.status}');
    if (generalSettingModel.status == 200) {
      if (generalSettingModel.result != null) {
        /* Insert in local db */
        await Future.forEach<settings.Result>(generalSettingModel.result ?? [],
            (generalSettingItem) async {
          await sharedPre.save(
            generalSettingItem.key.toString(),
            generalSettingItem.value.toString(),
          );
        });

        Utils.getCurrencySymbol();
        Constant.userID = await sharedPre.read('userid');
        Constant.userImage = await sharedPre.read('userimage');
        Constant.isBuy = await sharedPre.read('userIsBuy');
        appDescription = await sharedPre.read("app_desripation") ?? "";
        /* Get Ads Init */
        if (context.mounted && !kIsWeb) {
          AdHelper.getAds(context);
          // Utils.initializeOneSignal();
        }
      }
    }
    loading = false;
    notifyListeners();
  }

  getIntroPages() async {
    loading = true;
    introScreenModel = await ApiService().getOnboardingScreen();
    loading = false;
    notifyListeners();
  }

  login(type, number, email, password, deviceType, deviceToken, firebaseId,
      countryCode, countryName) async {
    loading = true;
    loginmodel = await ApiService().login(type, number, email, password,
        deviceType, deviceToken, firebaseId, countryCode, countryName);
    loading = false;
    notifyListeners();
  }

  Future<void> getRegister(
      fullname, email, number, password, countryCode, countryName) async {
    loading = true;
    registermodel = await ApiService()
        .register(fullname, email, number, password, countryCode, countryName);
    loading = false;
    notifyListeners();
  }

/* ================================= Api End ======================================= */

/* ================================= Mobile Methods Start ======================================= */

  pagechange(int index) {
    pageindex = index;
    notifyListeners();
  }

  setLoading(loading) {
    isProgressLoading = loading;
    notifyListeners();
  }

  /* ================================= Mobile Methods Start ======================================= */

  /* ================================= Web Methods Start ======================================= */

  getNotificationSectionShowHide(notification) {
    isNotification = notification;
    notifyListeners();
  }

  getOpenSearchSection(search) {
    isSearch = search;
    notifyListeners();
  }

  getOpenProfileSection(profile) {
    isProfile = profile;
    notifyListeners();
  }

  /* ================================= Web APi & Methods End ======================================= */
}
