import 'package:yourappname/pages/bottombar.dart';
import 'package:yourappname/pages/intro.dart';
import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  SharedPre sharedPre = SharedPre();
  late GeneralProvider generalProvider;

  @override
  void initState() {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getApi();
    });
    super.initState();
  }

  getApi() async {
    await generalProvider.getGeneralsetting(context);
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: MyImage(
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          imagePath: "splash.png",
        ),
      ),
    );
  }

  Future<void> checkFirstSeen() async {
    String? seen = await sharedPre.read('seen') ?? "";

    await generalProvider.getIntroPages();

    if (seen == "1") {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const Bottombar();
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
      if (!generalProvider.loading) {
        if ((generalProvider.introScreenModel.status == 200) &&
            generalProvider.introScreenModel.result != null &&
            (generalProvider.introScreenModel.result?.length ?? 0) > 0) {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Intro(
                  introList: generalProvider.introScreenModel.result ?? [],
                );
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
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return const Bottombar();
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
        }
      }
    }
  }
}
