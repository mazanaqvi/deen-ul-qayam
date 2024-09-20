import 'dart:ui';
import 'package:yourappname/provider/videobyidviewallprovider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yourappname/firebase_options.dart';
import 'package:yourappname/model/download_item.dart';
import 'package:yourappname/pages/splash.dart';
import 'package:yourappname/provider/blogdetailprovider.dart';
import 'package:yourappname/provider/categoryviewallprovider.dart';
import 'package:yourappname/provider/commanprovider.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';
import 'package:yourappname/provider/courselistbytutoridprovider.dart';
import 'package:yourappname/provider/ebookdetailprovider.dart';
import 'package:yourappname/provider/ebookprovider.dart';
import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/provider/getpageprovider.dart';
import 'package:yourappname/provider/homeprovider.dart';
import 'package:yourappname/provider/mycourseprovider.dart';
import 'package:yourappname/provider/notificationprovider.dart';
import 'package:yourappname/provider/playerprovider.dart';
import 'package:yourappname/provider/profileprovider.dart';
import 'package:yourappname/provider/quizeprovider.dart';
import 'package:yourappname/provider/exploreprovider.dart';
import 'package:yourappname/provider/readbookprovider.dart';
import 'package:yourappname/provider/searchprovider.dart';
import 'package:yourappname/provider/showdownloadprovider.dart';
import 'package:yourappname/provider/subscriptionprovider.dart';
import 'package:yourappname/provider/themeprovider.dart';
import 'package:yourappname/provider/videodownloadprovider.dart';
import 'package:yourappname/provider/viewallprovider.dart';
import 'package:yourappname/provider/wishlistprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webpages/webhome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await FlutterDownloader.initialize();
  }

  // Check if Firebase has already been initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'Deen-Al-Qayam', // Add your project name here
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /* Initialize Hive Start */
  if (!kIsWeb) {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(DownloadItemAdapter());
    Hive.registerAdapter(ChapterItemAdapter());
    Hive.registerAdapter(EpisodeItemAdapter());
  }
  /* Initialize Hive End */

  await Locales.init(['en', 'ar', 'hi']);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GeneralProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => PlayerProvider()),
          ChangeNotifierProvider(create: (_) => ExploreProvider()),
          ChangeNotifierProvider(create: (_) => CourseDetailsProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
          ChangeNotifierProvider(create: (_) => MyCourseProvider()),
          ChangeNotifierProvider(create: (_) => GetPageProvider()),
          ChangeNotifierProvider(create: (_) => CourselistByTutoridProvider()),
          ChangeNotifierProvider(create: (_) => ViewAllProvider()),
          ChangeNotifierProvider(create: (_) => CategoryViewallProvider()),
          ChangeNotifierProvider(create: (_) => CommanProvider()),
          ChangeNotifierProvider(create: (_) => QuizeProvider()),
          ChangeNotifierProvider(create: (_) => SearchProvider()),
          ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => EbookDetailProvider()),
          ChangeNotifierProvider(create: (_) => EbookProvider()),
          ChangeNotifierProvider(create: (_) => BlogDetailProvider()),
          ChangeNotifierProvider(create: (_) => ReadBookProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => VideoDownloadProvider()),
          ChangeNotifierProvider(create: (_) => ShowDownloadProvider()),
          ChangeNotifierProvider(create: (_) => VideoDownloadProvider()),
          ChangeNotifierProvider(create: (_) => VideoByIdViewAllProvider()),
        ],
        child: const MyApp(),
      ),
    );
  });

  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     systemNavigationBarColor: white,
  //     statusBarColor: colorPrimary,
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPre sharedpre = SharedPre();
  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkTheme();
      // await connectivityProvider.initConnectivity(context);
    });
  }

  checkTheme() async {
    Constant.userID = await sharedpre.read('userid');
    Constant.isDark = await sharedpre.readBool("isdark") ?? false;
    themeProvider.changeTheme(Constant.isDark);
    /* Initialize Hive */
    if (!kIsWeb) {
      await Utils.initializeHiveBoxes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        /* Theme Start */
        themeMode: themeProvider.themeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
        /* Theme End */
        debugShowCheckedModeBanner: false,
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        localeResolutionCallback:
            (Locale? locale, Iterable<Locale> supportedLocales) {
          return locale;
        },
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        home: (kIsWeb) ? const WebHome() : const Splash(),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
            PointerDeviceKind.trackpad
          },
        ),
      ),
    );
  }
}
