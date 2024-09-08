import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/firebaseconstant.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webpages/webhome.dart';
import 'package:yourappname/webpages/webmobilelogin.dart';
import 'package:yourappname/webpages/webregister.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class WebLogin extends StatefulWidget {
  const WebLogin({Key? key}) : super(key: key);

  @override
  State<WebLogin> createState() => WebLoginState();
}

class WebLoginState extends State<WebLogin> {
  late GeneralProvider generalProvider;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureTextPassword = true;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String email = "", password = "";
  String? userName;
  File? mProfileImg;
  String? strDeviceType, strDeviceToken;

  @override
  initState() {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    super.initState();
    _getDeviceToken();
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
                  height: 600,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(25, 40, 25, 40),
                  decoration: const BoxDecoration(color: white),
                  child: Column(
                    children: [
                      MyText(
                          color: colorPrimary,
                          text: "Welcome Back",
                          fontsizeWeb: 30,
                          fontsizeNormal: 30,
                          fontwaight: FontWeight.w700,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          multilanguage: false,
                          fontstyle: FontStyle.normal),
                      const SizedBox(height: 30),
                      emailAndpassword(),
                      const SizedBox(height: 50),
                      loginBtn(),
                      const SizedBox(height: 25),
                      loginWithSocial(),
                      const SizedBox(height: 20),
                      goingRegister(),
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

  Widget emailAndpassword() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* Email */
          TextFormField(
            autofillHints: const [AutofillHints.email],
            obscureText: false,
            keyboardType: TextInputType.text,
            controller: emailController,
            textInputAction: TextInputAction.next,
            cursorColor: black,
            style: TextStyle(
                fontSize: Dimens.textMedium,
                fontStyle: FontStyle.normal,
                color: black,
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              labelText: "Email Address",
              labelStyle: TextStyle(
                  fontSize: Dimens.textSmall,
                  fontStyle: FontStyle.normal,
                  color: gray.withOpacity(0.50),
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 25),
          /* Password */
          TextFormField(
            autofillHints: const [AutofillHints.password],
            obscureText: obscureTextPassword,
            keyboardType: TextInputType.number,
            controller: passwordController,
            textInputAction: TextInputAction.done,
            cursorColor: black,
            onEditingComplete: () {
              email = emailController.text.toString();
              password = passwordController.text.toString();

              bool emailValidation = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(email);

              if (emailController.text.isEmpty) {
                Utils.showSnackbar(context, "fail", "pleasenteremail", true);
              } else if (passwordController.text.isEmpty) {
                Utils.showSnackbar(
                    context, "fail", "pleaseenteryourpassword", true);
              } else if (password.length < 6) {
                Utils.showSnackbar(
                    context, "fail", "pleaseenterpasswordonlysixdigit", true);
              } else if (!emailValidation) {
                Utils.showSnackbar(
                    context, "fail", "invalidemailaddress", true);
              } else {
                checkAndNavigate(email, password, "", "4", "");
              }
            },
            style: TextStyle(
                fontSize: Dimens.textMedium,
                fontStyle: FontStyle.normal,
                color: black,
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    obscureTextPassword = !obscureTextPassword;
                  });
                },
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  child: Icon(
                    obscureTextPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: gray,
                  ),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              labelText: "Password",
              labelStyle: TextStyle(
                  fontSize: Dimens.textSmall,
                  fontStyle: FontStyle.normal,
                  color: gray.withOpacity(0.50),
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginBtn() {
    return Consumer<GeneralProvider>(
        builder: (context, generalprovider, child) {
      if (generalprovider.isProgressLoading) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorPrimary,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: colorAccent,
              strokeWidth: 2,
            ),
          ),
        );
      } else {
        return InkWell(
          onTap: () async {
            email = emailController.text.toString();
            password = passwordController.text.toString();

            bool emailValidation = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(email);

            if (emailController.text.isEmpty) {
              Utils.showSnackbar(context, "fail", "pleasenteremail", true);
            } else if (passwordController.text.isEmpty) {
              Utils.showSnackbar(
                  context, "fail", "pleaseenteryourpassword", true);
            } else if (password.length < 6) {
              Utils.showSnackbar(
                  context, "fail", "pleaseenterpasswordonlysixdigit", true);
            } else if (!emailValidation) {
              Utils.showSnackbar(context, "fail", "invalidemailaddress", true);
            } else {
              checkAndNavigate(email, password, "", "4", "");
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
              text: "login",
              fontsizeNormal: Dimens.textTitle,
              fontsizeWeb: Dimens.textTitle,
              fontwaight: FontWeight.w600,
              maxline: 1,
              multilanguage: true,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
            ),
          ),
        );
      }
    });
  }

  Widget goingRegister() {
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
              fontsizeWeb: Dimens.textMedium,
              fontsizeNormal: Dimens.textMedium,
              maxline: 1,
              fontwaight: FontWeight.w400,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
              multilanguage: true),
          const SizedBox(width: 5),
          MyText(
              color: colorPrimary,
              text: "register",
              fontsizeWeb: Dimens.textMedium,
              fontsizeNormal: Dimens.textMedium,
              maxline: 1,
              fontwaight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
              multilanguage: true),
        ],
      ),
    );
  }

  Widget mobileLogin() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return const WebMobileLogin();
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
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: MyText(
            color: white,
            text: "signinwithmobileno",
            fontsizeWeb: 16,
            fontwaight: FontWeight.w600,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
            multilanguage: true),
      ),
    );
  }

  Widget loginWithSocial() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: (() {
            gmailLogin();
          }),
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: gray.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: MyImage(width: 20, height: 20, imagePath: "ic_gmail.png"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: InkWell(
            onTap: (() {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return const WebMobileLogin();
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
            }),
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: gray.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: MyImage(
                width: 20,
                height: 20,
                imagePath: "ic_mobile.png",
                color: black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /* Google(Gmail) Login */
  Future<void> gmailLogin() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    GoogleSignInAccount user = googleUser;

    printLog('GoogleSignIn ===> id : ${user.id}');
    printLog('GoogleSignIn ===> email : ${user.email}');
    printLog('GoogleSignIn ===> displayName : ${user.displayName}');
    printLog('GoogleSignIn ===> photoUrl : ${user.photoUrl}');

    if (!mounted) return;
    generalProvider.setLoading(true);

    UserCredential userCredential;
    try {
      GoogleSignInAuthentication googleSignInAuthentication =
          await user.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      userCredential = await auth.signInWithCredential(credential);
      assert(await userCredential.user?.getIdToken() != null);
      printLog("User Name: ${userCredential.user?.displayName}");
      printLog("User Email ${userCredential.user?.email}");
      printLog("User photoUrl ${userCredential.user?.photoURL}");
      printLog("uid ===> ${userCredential.user?.uid}");
      String firebasedid = userCredential.user?.uid ?? "";
      printLog('firebasedid :===> $firebasedid');

      /* Update in Firebase */
      // Check is already sign up
      // final QuerySnapshot result = await FirebaseFirestore.instance
      //     .collection(FirestoreConstants.pathUserCollection)
      //     .where(FirestoreConstants.userid,
      //         isEqualTo: userCredential.user?.uid ?? "")
      //     .get();
      // final List<DocumentSnapshot> documents = result.docs;
      // if (documents.isEmpty) {
      //   // Writing data to server because here is a new user
      //   FirebaseFirestore.instance
      //       .collection(FirestoreConstants.pathUserCollection)
      //       .doc(userCredential.user?.uid ?? "")
      //       .set({
      //     FirestoreConstants.email: userCredential.user?.email,
      //     FirestoreConstants.name: userCredential.user?.displayName,
      //     FirestoreConstants.deviceToken: strDeviceToken,
      //     FirestoreConstants.profileurl: userCredential.user?.photoURL,
      //     FirestoreConstants.userid: userCredential.user?.uid ?? "",
      //     FirestoreConstants.createdAt:
      //         DateTime.now().millisecondsSinceEpoch.toString(),
      //     FirestoreConstants.bioData:
      //         "Hey! there I'm using ${Constant.appName} app.",
      //     FirestoreConstants.username: "",
      //     FirestoreConstants.mobileNumber:
      //         userCredential.user?.phoneNumber ?? "",
      //     FirestoreConstants.chattingWith: null,
      //     FirestoreConstants.isOnline: "false",
      //   });
      // } else {
      //   updateDataInFirestore(firebasedid: firebasedid);
      // }

      checkAndNavigate(
          user.email, "", user.displayName ?? "", "2", firebasedid);
    } on FirebaseAuthException catch (e) {
      printLog('FirebaseAuthException ===CODE====> ${e.code.toString()}');
      printLog('FirebaseAuthException ==MESSAGE==> ${e.message.toString()}');
      generalProvider.setLoading(false);
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

  void checkAndNavigate(String email, String password, String name, String type,
      String firebaseId) async {
    generalProvider.setLoading(true);
    await generalProvider.login(type, "", email, password, strDeviceType ?? "",
        strDeviceToken ?? "", firebaseId, "", "");

    if (!generalProvider.loading) {
      if (generalProvider.loginmodel.status == 200) {
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
        generalProvider.setLoading(false);
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
        // Hide Progress Dialog
        if (!mounted) return;
        Utils.showSnackbar(
            context, "fail", "${generalProvider.loginmodel.message}", false);
      }
    }
  }
}
