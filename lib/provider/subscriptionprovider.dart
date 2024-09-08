import 'package:yourappname/model/SuccessModel.dart';
import 'package:yourappname/model/packagemodel.dart' as package;
import 'package:yourappname/model/packagemodel.dart';
import 'package:yourappname/model/paymentoptionmodel.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:yourappname/utils/utils.dart';

class SubscriptionProvider extends ChangeNotifier {
  /* Package Paginattion */
  PackageModel packageModel = PackageModel();
  List<package.Result>? packageList = [];
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;
  bool loading = false, loadmore = false;

/* Payment Option */
  PaymentOptionModel paymentOptionModel = PaymentOptionModel();
  bool payLoading = false;
  String? currentPayment = "", finalAmount = "";

/* Add Transection */
  SuccessModel successModel = SuccessModel();

/* Get Package */
  Future<void> getPackage(pageNo) async {
    loading = true;
    packageModel = await ApiService().package(pageNo);
    if (packageModel.status == 200) {
      setPaginationData(packageModel.totalRows, packageModel.totalPage,
          packageModel.currentPage, packageModel.morePage);
      if (packageModel.result != null &&
          (packageModel.result?.length ?? 0) > 0) {
        printLog(
            "PackageModel length :==> ${(packageModel.result?.length ?? 0)}");
        if (packageModel.result != null &&
            (packageModel.result?.length ?? 0) > 0) {
          printLog(
              "PackageModel length :==> ${(packageModel.result?.length ?? 0)}");
          for (var i = 0; i < (packageModel.result?.length ?? 0); i++) {
            packageList?.add(packageModel.result?[i] ?? package.Result());
          }
          final Map<int, package.Result> postMap = {};
          packageList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          packageList = postMap.values.toList();
          printLog("PackageList length :==> ${(packageList?.length ?? 0)}");
          setLoadMore(false);
        }
      }
    }
    loading = false;
    notifyListeners();
  }

  setPaginationData(
      int? totalRows, int? totalPage, int? currentPage, bool? isMorePage) {
    this.currentPage = currentPage;
    this.totalRows = totalRows;
    this.totalPage = totalPage;
    isMorePage = isMorePage;
    notifyListeners();
  }

  setLoadMore(loadmore) {
    this.loadmore = loadmore;
    notifyListeners();
  }

/* Get Payment Options */
  Future<void> getPaymentOption() async {
    payLoading = true;
    paymentOptionModel = await ApiService().paymentOption();
    payLoading = false;
    notifyListeners();
  }

  setFinalAmount(String? amount) {
    finalAmount = amount;
    printLog("setFinalAmount finalAmount :==> $finalAmount");
    notifyListeners();
  }

  setCurrentPayment(String? payment) {
    currentPayment = payment;
    notifyListeners();
  }

/* add Transection  */
  Future<void> addPackageTransaction(
      packageId, price, transectionId, discription) async {
    payLoading = true;
    successModel = await ApiService()
        .addPackageTransaction(packageId, price, transectionId, discription);
    payLoading = false;
    notifyListeners();
  }

  Future<void> addContentTransaction(
      type, contentId, price, transectionId, discription) async {
    payLoading = true;
    successModel = await ApiService().addContentTransaction(
        type, contentId, price, transectionId, discription);
    payLoading = false;
    notifyListeners();
  }

  clearPackageList() {
    packageModel = PackageModel();
    packageList = [];
    packageList?.clear();
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
    loading = false;
    loadmore = false;
  }

/* Clear Provider */
  clearAllPaymentProvider() {
    paymentOptionModel = PaymentOptionModel();
    payLoading = false;
    currentPayment = "";
    finalAmount = "";
  }
}
