import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:yourappname/provider/profileprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final forgotPasswordController = TextEditingController();
  bool obscureTextPassword = true;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
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
                        MyImage(
                          width: 90,
                          fit: BoxFit.contain,
                          height: 90,
                          imagePath: "ic_forgotpassword.png",
                        ),
                        const SizedBox(height: 20),
                        MyText(
                          color: black,
                          text: "passwordreset",
                          maxline: 1,
                          fontwaight: FontWeight.w600,
                          fontsizeNormal: Dimens.textlargeBig,
                          fontsizeWeb: Dimens.textlargeBig,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                          multilanguage: true,
                        ),
                        const SizedBox(height: 20),
                        MyText(
                          color: black,
                          text: "passwordresetdisc",
                          maxline: 3,
                          fontwaight: FontWeight.w400,
                          fontsizeNormal: Dimens.textMedium,
                          fontsizeWeb: Dimens.textMedium,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                          multilanguage: true,
                        ),
                        const SizedBox(height: 25),
                        /* Password */
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
                          child: TextFormField(
                            autofillHints: const [AutofillHints.password],
                            obscureText: obscureTextPassword,
                            keyboardType: TextInputType.text,
                            controller: forgotPasswordController,
                            textInputAction: TextInputAction.done,
                            cursorColor: black,
                            style: TextStyle(
                                fontSize: Dimens.textMedium,
                                fontStyle: FontStyle.normal,
                                color: black,
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                    width: 1, color: gray.withOpacity(0.50)),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                    width: 1, color: gray.withOpacity(0.50)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                    width: 1, color: gray.withOpacity(0.50)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                    width: 1, color: gray.withOpacity(0.50)),
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(
                                  fontSize: Dimens.textSmall,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 1,
                                  color: gray.withOpacity(0.50),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        /* Logout Button */
                        Consumer<ProfileProvider>(
                            builder: (context, profileprovider, child) {
                          return InkWell(
                            onTap: () async {
                              if (forgotPasswordController.text.isEmpty ||
                                  forgotPasswordController.text == "") {
                                Utils.showSnackbar(context, "fail",
                                    "pleaseenteryourpassword", true);
                              } else if (forgotPasswordController.text.length <
                                  6) {
                                Utils.showSnackbar(context, "fail",
                                    "pleaseenterpasswordonlysixdigit", true);
                              } else {
                                Utils()
                                    .showProgress(context, "Password Reset...");
                                await profileprovider.forgotPassword(
                                    forgotPasswordController.text);

                                if (!profileprovider.forgotpasswordLoading) {
                                  if (profileprovider
                                          .forgotpasswordModel.status ==
                                      200) {
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                    Utils().hideProgress(context);
                                    forgotPasswordController.clear();
                                    Utils().showToast(
                                        "Password Reset Succsessfully");
                                  } else {
                                    if (!context.mounted) return;
                                    Utils().showToast(profileprovider
                                            .forgotpasswordModel.message ??
                                        "");
                                    if (!mounted) return;
                                    Utils().hideProgress(context);
                                  }
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius: BorderRadius.circular(50)),
                              child: MyText(
                                color: white,
                                text: "forgotpasswordtitle",
                                maxline: 1,
                                fontwaight: FontWeight.w500,
                                fontsizeNormal: 14,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.center,
                                fontstyle: FontStyle.normal,
                                multilanguage: true,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(50)),
                            child: MyText(
                              color: white,
                              text: "backtohomepage",
                              maxline: 1,
                              fontwaight: FontWeight.w500,
                              fontsizeNormal: 14,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                              multilanguage: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Dialog(
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.circular(15)),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  MyImage(
                    width: 90,
                    fit: BoxFit.contain,
                    height: 90,
                    imagePath: "ic_forgotpassword.png",
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  const SizedBox(height: 20),
                  MyText(
                    color: Theme.of(context).colorScheme.surface,
                    text: "passwordreset",
                    maxline: 1,
                    fontwaight: FontWeight.w500,
                    fontsizeNormal: Dimens.textlargeBig,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                    multilanguage: true,
                  ),
                  const SizedBox(height: 20),
                  MyText(
                    color: Theme.of(context).colorScheme.surface,
                    text: "passwordresetdisc",
                    maxline: 3,
                    fontwaight: FontWeight.w400,
                    fontsizeNormal: Dimens.textMedium,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                    multilanguage: true,
                  ),
                  const SizedBox(height: 25),
                  /* Password */
                  TextFormField(
                    autofillHints: const [AutofillHints.password],
                    obscureText: obscureTextPassword,
                    keyboardType: TextInputType.text,
                    controller: forgotPasswordController,
                    textInputAction: Platform.isIOS
                        ? TextInputAction.next
                        : TextInputAction.done,
                    cursorColor: Theme.of(context).colorScheme.surface,
                    style: TextStyle(
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(7)),
                        borderSide:
                            BorderSide(width: 1, color: gray.withOpacity(0.50)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(7)),
                        borderSide:
                            BorderSide(width: 1, color: gray.withOpacity(0.50)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(7)),
                        borderSide:
                            BorderSide(width: 1, color: gray.withOpacity(0.50)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(7)),
                        borderSide:
                            BorderSide(width: 1, color: gray.withOpacity(0.50)),
                      ),
                      labelText: "Password",
                      labelStyle: GoogleFonts.inter(
                          fontSize: Dimens.textSmall,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1,
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(height: 25),
                  /* Logout Button */
                  Consumer<ProfileProvider>(
                      builder: (context, profileprovider, child) {
                    return InkWell(
                      onTap: () async {
                        if (forgotPasswordController.text.isEmpty ||
                            forgotPasswordController.text == "") {
                          Utils.showSnackbar(
                              context, "fail", "pleaseenteryourpassword", true);
                        } else if (forgotPasswordController.text.length > 6) {
                          Utils.showSnackbar(context, "fail",
                              "pleaseenterpasswordonlysixdigit", true);
                        } else {
                          Utils().showProgress(context, "Password Reset...");
                          await profileprovider
                              .forgotPassword(forgotPasswordController.text);

                          if (!profileprovider.forgotpasswordLoading) {
                            if (profileprovider.forgotpasswordModel.status ==
                                200) {
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              Utils().hideProgress(context);
                              forgotPasswordController.clear();
                              Utils().showToast("Password Reset Succsessfully");
                            } else {
                              Utils().showToast(
                                  profileprovider.forgotpasswordModel.message ??
                                      "");
                              if (!context.mounted) return;
                              Utils().hideProgress(context);
                            }
                          }
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(50)),
                        child: MyText(
                          color: white,
                          text: "forgotpasswordtitle",
                          maxline: 1,
                          fontwaight: FontWeight.w500,
                          fontsizeNormal: 14,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                          multilanguage: true,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  /* Cancel  Button */
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      forgotPasswordController.clear();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(50)),
                      child: MyText(
                        color: colorPrimary,
                        text: "cancel",
                        maxline: 1,
                        fontwaight: FontWeight.w500,
                        fontsizeNormal: 14,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                        multilanguage: true,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
