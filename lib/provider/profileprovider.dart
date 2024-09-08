import 'dart:io';
import 'package:yourappname/model/SuccessModel.dart';
import 'package:yourappname/model/getpagemodel.dart';
import 'package:yourappname/model/profilemodel.dart';
import 'package:yourappname/model/sociallinkmodel.dart';
import 'package:yourappname/model/updateprofilemodel.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  GetPageModel getpagemodel = GetPageModel();
  ProfileModel profileModel = ProfileModel();
  SuccessModel successModel = SuccessModel();
  Updateprofilemodel updateprofilemodel = Updateprofilemodel();
  Updateprofilemodel forgotpasswordModel = Updateprofilemodel();
  SocialLinkModel socialLinkModel = SocialLinkModel();
  bool loading = false, forgotpasswordLoading = false;
  SharedPre sharePref = SharedPre();
  bool updateprofileLoading = false;

  /* Selected Image */
  File? imageFile;

  /* Toggle Button */
  bool isNotification = false;
  bool isDarkMode = false;
  String toggleTypeNotification = "";
  String toggleTypeDarkMode = "";

  /* Update Pyament Info */
  bool loadingUpdate = false;

  Future<void> getprofile(BuildContext context) async {
    printLog("getProfile userID :==> ${Constant.userID}");
    loading = true;
    profileModel = await ApiService().profile();
    printLog("get_profile status :==> ${profileModel.status}");
    printLog("get_profile message :==> ${profileModel.message}");
    if (profileModel.status == 200 && profileModel.result != null) {
      if ((profileModel.result?.length ?? 0) > 0) {
        if (context.mounted) {
          Utils.saveUserCreds(
            userID: profileModel.result?[0].id.toString(),
            userName: profileModel.result?[0].userName.toString(),
            fullName: profileModel.result?[0].fullName.toString(),
            email: profileModel.result?[0].email.toString(),
            mobileNumber: profileModel.result?[0].mobileNumber.toString(),
            image: profileModel.result?[0].image.toString(),
            deviceType: profileModel.result?[0].deviceType.toString(),
            deviceToken: profileModel.result?[0].deviceToken.toString(),
            firebaseId: profileModel.result?[0].firebaseId.toString(),
            userIsBuy: profileModel.result?[0].isBuy.toString(),
          );
          Utils.loadAds(context);
        }
      }
    }
    loading = false;
    notifyListeners();
  }

  storeUserImage(String? image) {
    Constant.userImage = image ?? "";
    notifyListeners();
  }

  getUpdateProfile(
      fullname, mobilenumber, email, countryCode, countryName) async {
    setLoading(true);
    updateprofilemodel = await ApiService().updateprofile(fullname,
        mobilenumber, email, countryCode, countryName, imageFile ?? File(""));
    setLoading(false);
    notifyListeners();
  }

  forgotPassword(password) async {
    forgotpasswordLoading = true;
    forgotpasswordModel = await ApiService().forgotPassword(password);
    forgotpasswordLoading = false;
    notifyListeners();
  }

  setLoading(bool isLoading) {
    updateprofileLoading = isLoading;
    notifyListeners();
  }

  getPages() async {
    loading = true;
    getpagemodel = await ApiService().getpage();
    loading = false;
    notifyListeners();
  }

  getSocialLink() async {
    loading = true;
    socialLinkModel = await ApiService().getSocialLink();
    loading = false;
    notifyListeners();
  }

  isNotificationOnOff(
    notificationtype,
    isNotification,
  ) {
    toggleTypeNotification = notificationtype;
    isNotification = isNotification;
    notifyListeners();
  }

  isDarkModeOnOff(
    darkModetype,
    isDarkMode,
  ) {
    toggleTypeDarkMode = darkModetype;
    isDarkMode = isDarkMode;
    notifyListeners();
  }

  selectImage(dynamic img) {
    imageFile = img;
    notifyListeners();
  }

  Future<void> getUpdateDataForPayment(fullName, email, mobileNumber) async {
    printLog("getUpdateDataForPayment fullname :==> $fullName");
    printLog("getUpdateDataForPayment email :=====> $email");
    printLog("getUpdateDataForPayment mobile :====> $mobileNumber");
    loadingUpdate = true;
    successModel =
        await ApiService().updateDataForPayment(fullName, email, mobileNumber);
    printLog("getUpdateDataForPayment status :==> ${successModel.status}");
    printLog("getUpdateDataForPayment message :==> ${successModel.message}");
    loadingUpdate = false;
    notifyListeners();
  }

  setUpdateLoading(bool isLoading) {
    loadingUpdate = isLoading;
    notifyListeners();
  }

  clearProvider() {
    getpagemodel = GetPageModel();
    profileModel = ProfileModel();
    successModel = SuccessModel();
    updateprofilemodel = Updateprofilemodel();
    loading = false;
    sharePref = SharedPre();
    updateprofileLoading = false;
    forgotpasswordLoading = false;
    /* Selected Image */
    imageFile;
    /* Toggle Button */
    isNotification = false;
    isDarkMode = false;
    toggleTypeNotification = "";
    toggleTypeDarkMode = "";
    /* Update Pyament Info */
    loadingUpdate = false;
  }
}
