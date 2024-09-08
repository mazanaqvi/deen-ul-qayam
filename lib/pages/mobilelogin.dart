import 'package:yourappname/pages/register.dart';
import 'package:yourappname/pages/verifyotp.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({Key? key}) : super(key: key);

  @override
  State<MobileLogin> createState() => MobileLoginState();
}

class MobileLoginState extends State<MobileLogin> {
  TextEditingController numberController = TextEditingController();
  String mobilenumber = "", countrycode = "", countryname = "";

  @override
  void initState() {
    super.initState();
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
                        text: "enteryourmobile",
                        fontsizeNormal: Dimens.textExtraBig,
                        fontwaight: FontWeight.w700,
                        maxline: 2,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        multilanguage: true,
                        fontstyle: FontStyle.normal),
                    const SizedBox(height: 15),
                    MyText(
                        color: colorPrimary,
                        text: "youwillreceive6digitcode",
                        fontsizeNormal: Dimens.textMedium,
                        fontwaight: FontWeight.w400,
                        maxline: 2,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                        multilanguage: true),
                    const SizedBox(height: 50),
                    numberTextField(),
                    const SizedBox(height: 50),
                    sendOTP(),
                    const SizedBox(height: 15),
                    registerText(),
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

  Widget numberTextField() {
    return IntlPhoneField(
      disableLengthCheck: true,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: Theme.of(context).colorScheme.surface,
      autovalidateMode: AutovalidateMode.disabled,
      controller: numberController,
      style: GoogleFonts.inter(
          fontSize: Dimens.textMedium,
          fontStyle: FontStyle.normal,
          color: Theme.of(context).colorScheme.surface,
          letterSpacing: 1.0,
          fontWeight: FontWeight.w600),
      showCountryFlag: true,
      showDropdownIcon: false,
      initialCountryCode: "IN",
      dropdownTextStyle: GoogleFonts.inter(
          fontSize: Dimens.textSmall,
          fontStyle: FontStyle.normal,
          letterSpacing: 1.0,
          color: gray.withOpacity(0.50),
          fontWeight: FontWeight.w400),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelStyle: GoogleFonts.inter(
            fontSize: Dimens.textSmall,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.0,
            color: gray.withOpacity(0.50),
            fontWeight: FontWeight.w400),
        labelText: "Mobile Number",
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
      ),
      onChanged: (phone) {
        mobilenumber = phone.completeNumber;
        countryname = phone.countryISOCode;
        countrycode = phone.countryCode;
        printLog("numberController==> ${numberController.text}");
        printLog('mobile number==> $mobilenumber');
        printLog('countryCode number==> $countryname');
        printLog('countryISOCode==> $countrycode');
      },
      onCountryChanged: (country) {
        countryname = country.code.replaceAll('+', '');
        countrycode = "+${country.dialCode.toString()}";
        printLog('countryname===> $countryname');
        printLog('countrycode===> $countrycode');
      },
    );
  }

  Widget sendOTP() {
    return InkWell(
      onTap: () {
        if (numberController.text.isEmpty) {
          Utils().showToast("Please Enter Your Mobile Number");
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return VerifyOtp(
                  fullnumber: mobilenumber,
                  countrycode: countrycode,
                  countryName: countryname,
                  number: numberController.text,
                );
              },
            ),
          );
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
            text: "sendotp",
            fontsizeNormal: 14,
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
}
