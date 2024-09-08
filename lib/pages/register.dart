import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:yourappname/pages/login.dart';
import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late GeneralProvider generalProvider;
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  bool obscureTextPassword = true;
  String mobilenumber = "", countrycode = "", countryname = "";

  @override
  void initState() {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: white,
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
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
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
                        text: "Get Started",
                        fontsizeNormal: Dimens.textExtraBig,
                        fontwaight: FontWeight.w700,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        multilanguage: false,
                        fontstyle: FontStyle.normal),
                    const SizedBox(height: 20),
                    registerField(),
                    const SizedBox(height: 30),
                    signUpBtn(),
                    const SizedBox(height: 10),
                    loginText(),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget registerField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
          obscureText: false,
          keyboardType: TextInputType.text,
          controller: fullnameController,
          textInputAction: TextInputAction.next,
          cursorColor: Theme.of(context).colorScheme.surface,
          style: GoogleFonts.inter(
              fontSize: Dimens.textMedium,
              fontStyle: FontStyle.normal,
              color: Theme.of(context).colorScheme.surface,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w600),
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
            labelText: "Fullname",
            labelStyle: GoogleFonts.inter(
                fontSize: Dimens.textSmall,
                fontStyle: FontStyle.normal,
                letterSpacing: 1.0,
                color: gray.withOpacity(0.50),
                fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          obscureText: false,
          keyboardType: TextInputType.text,
          controller: emailController,
          textInputAction: TextInputAction.next,
          cursorColor: Theme.of(context).colorScheme.surface,
          style: GoogleFonts.inter(
              fontSize: Dimens.textMedium,
              fontStyle: FontStyle.normal,
              color: Theme.of(context).colorScheme.surface,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w600),
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
                letterSpacing: 1.0,
                color: gray.withOpacity(0.50),
                fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 10),
        IntlPhoneField(
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
          },
          onCountryChanged: (country) {
            countryname = country.code.replaceAll('+', '');
            countrycode = "+${country.dialCode.toString()}";
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          obscureText: obscureTextPassword,
          keyboardType: TextInputType.number,
          controller: passwordController,
          textInputAction: TextInputAction.next,
          cursorColor: Theme.of(context).colorScheme.surface,
          style: GoogleFonts.inter(
              fontSize: Dimens.textTitle,
              fontStyle: FontStyle.normal,
              color: Theme.of(context).colorScheme.surface,
              letterSpacing: 5.0,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            suffixIcon: Container(
              width: 5,
              height: 5,
              alignment: Alignment.center,
              child: InkWell(
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
                letterSpacing: 1.0,
                color: gray.withOpacity(0.50),
                fontWeight: FontWeight.w400),
          ),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget signUpBtn() {
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
            if (fullnameController.text.isEmpty) {
              Utils.showSnackbar(context, "fail", "pleasenterfullname", true);
            } else if (emailController.text.isEmpty) {
              Utils.showSnackbar(context, "fail", "pleasenteremail", true);
            } else if (numberController.text.isEmpty) {
              Utils.showSnackbar(
                  context, "fail", "pleaseenteryourmobile", true);
            } else if (passwordController.text.isEmpty) {
              Utils.showSnackbar(
                  context, "fail", "pleaseenteryourpassword", true);
            } else if (passwordController.text.length < 6) {
              Utils.showSnackbar(
                  context, "fail", "pleaseenterpasswordonlysixdigit", true);
            } else {
              generalProvider.setLoading(true);
              await generalProvider.getRegister(
                fullnameController.text,
                emailController.text,
                numberController.text,
                passwordController.text,
                countrycode,
                countryname,
              );

              if (!generalProvider.loading) {
                if (generalProvider.registermodel.status == 200) {
                  if (!mounted) return;
                  generalprovider.setLoading(false);

                  if (!context.mounted) return;
                  Utils.showSnackbar(context, "success",
                      generalProvider.registermodel.message ?? "", false);
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 1000),
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return const Login();
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
                } else {
                  generalprovider.setLoading(false);
                  if (!context.mounted) return;
                  Utils.showSnackbar(context, "fail",
                      generalProvider.registermodel.message ?? "", false);
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
              borderRadius: BorderRadius.circular(50),
            ),
            child: MyText(
              color: white,
              text: "signup",
              fontsizeNormal: Dimens.textTitle,
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

  Widget loginText() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return const Login();
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
              text: "alreadyhaveanaccount",
              fontsizeNormal: Dimens.textSmall,
              fontwaight: FontWeight.w400,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
              multilanguage: true),
          const SizedBox(width: 5),
          MyText(
              color: colorPrimary,
              text: "login",
              fontsizeNormal: Dimens.textSmall,
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
