import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/firebaseconstant.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webpages/webhome.dart';
import 'package:yourappname/webpages/webregister.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class WebVerifyOtp extends StatefulWidget {
  final String fullnumber, number, countrycode, countryName;
  const WebVerifyOtp({
    super.key,
    required this.fullnumber,
    required this.number,
    required this.countrycode,
    required this.countryName,
  });

  @override
  State<WebVerifyOtp> createState() => WebVerifyOtpState();
}

class WebVerifyOtpState extends State<WebVerifyOtp> {
  late GeneralProvider generalProvider;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final otpController = TextEditingController();
  int? forceResendingToken;
  String? verificationId;
  String? strDeviceType, strDeviceToken;

  @override
  void initState() {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    super.initState();
    _getDeviceToken();
    codeSend();
  }

  _getDeviceToken() async {
    try {
      if (Platform.isAndroid) {
        strDeviceType = "1";
        strDeviceToken = await FirebaseMessaging.instance.getToken();
      } else {
        strDeviceType = "2";
        strDeviceToken = OneSignal.User.pushSubscription.id.toString();
      }
    } catch (e) {
      printLog("_getDeviceToken Exception ===> $e");
    }
    printLog("===>strDeviceToken $strDeviceToken");
    printLog("===>strDeviceType $strDeviceType");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/ic_loginbgweb.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 480,
                  height: 500,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(25, 40, 25, 40),
                  decoration: const BoxDecoration(color: white),
                  child: Column(
                    children: [
                      MyText(
                          color: colorPrimary,
                          text: "otpverification",
                          fontsizeNormal: Dimens.textExtraBig,
                          fontsizeWeb: Dimens.textExtraBig,
                          fontwaight: FontWeight.w600,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          multilanguage: true,
                          fontstyle: FontStyle.normal),
                      const SizedBox(height: 15),
                      MyText(
                          color: colorPrimary,
                          text: "enterotpcodetosenttomobilenumber",
                          fontsizeNormal: Dimens.textMedium,
                          fontsizeWeb: Dimens.textMedium,
                          fontwaight: FontWeight.w400,
                          maxline: 2,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                          multilanguage: true),
                      const SizedBox(height: 30),
                      otpTextField(),
                      const SizedBox(height: 50),
                      resendotp(),
                      const SizedBox(height: 15),
                      verifyotp(),
                      const SizedBox(height: 15),
                      registerText(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget otpTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Pinput(
        length: 6,
        keyboardType: TextInputType.number,
        controller: otpController,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        defaultPinTheme: PinTheme(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 1, color: colorPrimary),
            borderRadius: BorderRadius.circular(5),
          ),
          textStyle: TextStyle(
            color: black,
            fontSize: Dimens.textlargeBig,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget resendotp() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          codeSend();
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: MyText(
              color: colorAccent,
              text: "resend",
              fontsizeNormal: Dimens.textMedium,
              fontwaight: FontWeight.w600,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
              multilanguage: true),
        ),
      ),
    );
  }

  Widget verifyotp() {
    return InkWell(
      onTap: () {
        if (otpController.text.toString().isEmpty) {
          Utils.showSnackbar(context, "fail", "pleaseenterotp", true);
        } else {
          if (verificationId == null || verificationId == "") {
            Utils.showSnackbar(context, "fail", "otp_not_working", true);
            return;
          }
          generalProvider.setLoading(true);
          _checkOTPAndLogin();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: BorderRadius.circular(50),
        ),
        child: MyText(
            color: white,
            text: "verifyandproceed",
            fontsizeNormal: Dimens.textMedium,
            fontwaight: FontWeight.w500,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
            multilanguage: true),
      ),
    );
  }

  Widget registerText() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return const WebRegister();
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return Align(
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyText(
              color: gray,
              text: "donthaveanaccount",
              fontsizeNormal: Dimens.textMedium,
              fontwaight: FontWeight.w400,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
              multilanguage: true),
          const SizedBox(width: 5),
          MyText(
              color: colorPrimary,
              text: "register",
              fontsizeNormal: Dimens.textMedium,
              fontwaight: FontWeight.w500,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
              multilanguage: true),
        ],
      ),
    );
  }

//  Send Otp methods

  codeSend() async {
    generalProvider.setLoading(true);
    await phoneSignIn(phoneNumber: widget.fullnumber);
    generalProvider.setLoading(false);
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      otpController.text = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try {
        UserCredential? credential =
            await user?.linkWithCredential(authCredential);
        printLog(
            "_onVerificationCompleted credential =====> ${credential?.user?.phoneNumber ?? ""}");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await _auth.signInWithCredential(authCredential);
        }
      }
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      Utils().showToast("The phone number entered is invalid!");
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    this.forceResendingToken = forceResendingToken;
    Utils.showSnackbar(context, "success", "coderesendsuccessfully", true);
    generalProvider.setLoading(false);
    _checkOTPAndLogin();
  }

  _onCodeTimeout(String verificationId) {
    this.verificationId = verificationId;
    generalProvider.setLoading(false);
    return null;
  }

  _checkOTPAndLogin() async {
    bool error = false;
    UserCredential? userCredential;

    printLog("_checkOTPAndLogin verificationId =====> $verificationId");
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential? phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId.toString(),
      smsCode: otpController.text.toString(),
    );

    printLog(
        "phoneAuthCredential.smsCode   =====> ${phoneAuthCredential.smsCode}");
    printLog(
        "phoneAuthCredential.verificationId =====> ${phoneAuthCredential.verificationId}");
    try {
      userCredential = await _auth.signInWithCredential(phoneAuthCredential);
      printLog(
          "_checkOTPAndLogin userCredential =====> ${userCredential.user?.phoneNumber ?? ""}");
    } on FirebaseAuthException catch (e) {
      generalProvider.setLoading(false);
      printLog("_checkOTPAndLogin error Code =====> ${e.code}");
      if (e.code == 'invalid-verification-code' ||
          e.code == 'invalid-verification-id') {
        if (!mounted) return;
        Utils.showSnackbar(context, "", "otpinvalid", false);
        return;
      } else if (e.code == 'session-expired') {
        if (!mounted) return;
        Utils.showSnackbar(context, "", "otpsessionexpired", false);
        return;
      } else {
        error = true;
      }
    }
    printLog(
        "Firebase Verification Complated & phoneNumber => ${userCredential?.user?.phoneNumber} and isError => $error");
    if (!error && userCredential != null) {
      /* Update in Firebase */
      // Check is already sign up
      // final QuerySnapshot result = await FirebaseFirestore.instance
      //     .collection(FirestoreConstants.pathUserCollection)
      //     .where(FirestoreConstants.userid,
      //         isEqualTo: userCredential.user?.uid ?? "")
      //     .get();
      // final List<DocumentSnapshot> documents = result.docs;
      // printLog("userCredential uid ==========> ${userCredential.user?.uid}");
      // if (documents.isEmpty) {
      //   // Writing data to server because here is a new user
      //   FirebaseFirestore.instance
      //       .collection(FirestoreConstants.pathUserCollection)
      //       .doc(userCredential.user?.uid ?? "")
      //       .set({
      //     FirestoreConstants.email: userCredential.user?.email ?? "",
      //     FirestoreConstants.deviceToken: strDeviceToken,
      //     FirestoreConstants.name:
      //         (userCredential.user?.displayName ?? "").isEmpty
      //             ? (userCredential.user?.phoneNumber ?? "")
      //             : (userCredential.user?.displayName ?? ""),
      //     FirestoreConstants.profileurl:
      //         userCredential.user?.photoURL ?? Constant.userPlaceholder,
      //     FirestoreConstants.userid: userCredential.user?.uid ?? "",
      //     FirestoreConstants.createdAt:
      //         DateTime.now().millisecondsSinceEpoch.toString(),
      //     FirestoreConstants.bioData:
      //         "Hey!!! there I'm using ${Constant.appName} app.",
      //     FirestoreConstants.username: "",
      //     FirestoreConstants.mobileNumber:
      //         userCredential.user?.phoneNumber ?? "",
      //     FirestoreConstants.chattingWith: null,
      //     FirestoreConstants.isOnline: "false",
      //   });
      // } else {
      //   updateDataInFirestore(firebasedid: userCredential.user?.uid ?? "");
      // }
      loginApi(widget.number.toString(), "1",
          userCredential.user?.uid.toString() ?? "");
    } else {
      if (!mounted) return;
      Utils().hideProgress(context);
      Utils.showSnackbar(context, "", "otploginfail", true);
    }
  }

  loginApi(String number, String type, firebaseId) async {
    generalProvider.setLoading(true);

    await generalProvider.login(
      type,
      number,
      "",
      "",
      strDeviceType ?? "",
      strDeviceToken ?? "",
      firebaseId.toString(),
      widget.countrycode,
      widget.countryName,
    );
    if (!generalProvider.loading) {
      if (generalProvider.loginmodel.status == 200 &&
          generalProvider.loginmodel.result!.isNotEmpty) {
        Utils.saveUserCreds(
          userID: generalProvider.loginmodel.result?[0].id.toString(),
          userName: generalProvider.loginmodel.result?[0].userName.toString(),
          fullName: generalProvider.loginmodel.result?[0].fullName.toString(),
          email: generalProvider.loginmodel.result?[0].email.toString(),
          mobileNumber:
              generalProvider.loginmodel.result?[0].mobileNumber.toString(),
          image: generalProvider.loginmodel.result?[0].image.toString(),
          deviceType:
              generalProvider.loginmodel.result?[0].deviceType.toString(),
          deviceToken:
              generalProvider.loginmodel.result?[0].deviceToken.toString(),
          userIsBuy: generalProvider.loginmodel.result?[0].isBuy.toString(),
          firebaseId:
              generalProvider.loginmodel.result?[0].firebaseId.toString(),
        );
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => const WebHome(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
            (Route route) => false);
      } else {
        generalProvider.setLoading(false);
        if (!mounted) return;
        Utils.showSnackbar(
            context, "fail", generalProvider.loginmodel.message ?? "", false);
      }
    }
  }

  updateDataInFirestore({required String firebasedid}) {
    printLog('strDeviceToken ....==>> $strDeviceToken');
    printLog('firebasedid ....==>> $firebasedid');
    // Update data to Firestore
    FirebaseFirestore.instance
        .collection(FirestoreConstants.pathUserCollection)
        .doc(firebasedid)
        .update({FirestoreConstants.deviceToken: strDeviceToken})
        .then((value) => printLog("User Updated"))
        .onError((error, stackTrace) {
          printLog("updateDataFirestore error ===> ${error.toString()}");
          printLog(
              "updateDataFirestore stackTrace ===> ${stackTrace.toString()}");
        });
  }
}
