import 'dart:convert';
import 'dart:io';
import 'package:yourappname/pages/bottombar.dart';
import 'package:yourappname/pages/mobilelogin.dart';
import 'package:yourappname/pages/register.dart';
import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
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
                  image: AssetImage("assets/images/ic_loginbg.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                padding: const EdgeInsets.fromLTRB(25, 35, 25, 25),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    MyText(
                        color: colorPrimary,
                        text: "Welcome Back",
                        fontsizeNormal: Dimens.textExtraBig,
                        fontwaight: FontWeight.w700,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        multilanguage: false,
                        fontstyle: FontStyle.normal),
                    const SizedBox(height: 25),
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
            Positioned.fill(
              top: 25,
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: MyImage(
                      width: 15,
                      height: 18,
                      imagePath: "ic_left.png",
                      color: white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget emailAndpassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
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
            cursorColor: Theme.of(context).colorScheme.surface,
            style: GoogleFonts.inter(
                fontSize: Dimens.textMedium,
                fontStyle: FontStyle.normal,
                color: Theme.of(context).colorScheme.surface,
                letterSpacing: 1,
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              labelText: "Email Address",
              labelStyle: GoogleFonts.inter(
                  fontSize: Dimens.textSmall,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 1,
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
            textInputAction:
                Platform.isIOS ? TextInputAction.next : TextInputAction.done,
            cursorColor: Theme.of(context).colorScheme.surface,
            style: GoogleFonts.inter(
                fontSize: Dimens.textMedium,
                fontStyle: FontStyle.normal,
                color: Theme.of(context).colorScheme.surface,
                letterSpacing: 5.0,
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
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(width: 1, color: gray.withOpacity(0.50)),
              ),
              labelText: "Password",
              labelStyle: GoogleFonts.inter(
                  fontSize: Dimens.textSmall,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 1,
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
          onTap: () {
            email = emailController.text.toString();
            password = passwordController.text.toString();

            bool emailValidation = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(email);

            if (email.isEmpty) {
              Utils.showSnackbar(context, "fail", "pleasenteremail", true);
            } else if (password.isEmpty) {
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
              fontsizeNormal: 16,
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Register();
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
              fontsizeNormal: Dimens.textSmall,
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
              fontsizeNormal: Dimens.textSmall,
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const MobileLogin();
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
            fontsizeNormal: 16,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const MobileLogin();
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
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ),
        Platform.isIOS
            ? Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: InkWell(
                  onTap: (() {
                    printLog("clck");
                    signInWithApple();
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
                        width: 20, height: 20, imagePath: "applestore.png"),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  // Signin With Apple
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    printLog("Click Apple");
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      printLog(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult = await auth.signInWithCredential(oauthCredential);

      final displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';

      final firebaseUser = authResult.user;
      printLog("=================");

      final userEmail = '${firebaseUser?.email}';
      printLog("userEmail =====> $userEmail");
      printLog("=================");

      final firebasedId = firebaseUser?.uid;
      printLog("firebasedId ===> $firebasedId");

      checkAndNavigate(
          userEmail, "", displayName.toString(), "3", firebasedId.toString());
    } catch (exception) {
      printLog("Apple Login exception =====> $exception");
    }
    return null;
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

      checkAndNavigate(
          user.email, "", user.displayName ?? "", "2", firebasedid);
    } on FirebaseAuthException catch (e) {
      printLog('FirebaseAuthException ===CODE====> ${e.code.toString()}');
      printLog('FirebaseAuthException ==MESSAGE==> ${e.message.toString()}');
      generalProvider.setLoading(false);
    }
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

        /* Initialize Hive */
        await Utils.initializeHiveBoxes();

        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Bottombar()),
            (Route route) => false);
      } else {
        generalProvider.setLoading(false);
        if (!mounted) return;
        Utils.showSnackbar(
            context, "fail", "${generalProvider.loginmodel.message}", false);
      }
    }
  }
}
