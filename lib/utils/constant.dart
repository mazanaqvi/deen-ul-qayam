class Constant {
  static const String baseurl = 'http://127.0.0.1:8000/api/';

  static String appName = "Qiyam";
  static String appPackageName = "com.jamia.deenulqayyim";
  static String chatAppName = "Deen Ul Qayyim";
  static String appleAppId = "";

  /* OneSignal App ID */
  static String? oneSignalAppId;
  static const String oneSignalAppIdKey = "onesignal_apid";

  // Search Bar Hint Chnage Only This File
  static String searchhint = "Search Courses";
  // App and Web dateFormat Change only This Place
  static String dateformat = "dd MMM yyyy";
  static String homesearchhint =
      "Search for Courses, Topics, Tutors and more...";

  /* Download config Hive */
  static String bgEncryptDecryptTask = 'encrypt_decrypt_task';
  static String hiveDownloadBox = 'DOWNLOADS';
  static String hiveSeasonDownloadBox = 'DOWNLOAD_SEASON';
  static String hiveEpiDownloadBox = 'DOWNLOAD_EPISODE';
  static String videoDownloadPort = 'video_downloader_send_port';
  static String showDownloadPort = 'show_downloader_send_port';
  static String hawkVIDEOList = "myVideoList_";
  static String hawkKIDSVIDEOList = "myKidsVideoList_";
  static String hawkSHOWList = "myShowList_";
  static String hawkSEASONList = "mySeasonList_";
  static String hawkEPISODEList = "myEpisodeList_";
  /* Download config Hive */

/* PlayStore And AppStore URL Start */
  static String androidAppUrl =
      "https://play.google.com/store/apps/details?id=${Constant.appPackageName}";
  static String iosAppUrl =
      "https://apps.apple.com/us/app/id${Constant.appleAppId}";
/* PlayStore And AppStore URL End */

/* Some ArrayList Start */

  static List wishListTab = [
    "courses",
    "ebooks",
  ];

  List introTitle = [
    "Get a new experience of online Study",
    "Get a new experience of online Study",
    "Get a new experience of online Study",
  ];

  List introDisc = [
    "Welcome to our wealth univercity app, where conversations spark and connections flourish.",
    "Welcome to our wealth univercity app, where conversations spark and connections flourish.",
    "Welcome to our wealth univercity app, where conversations spark and connections flourish.",
  ];

  List detailTab = [
    "summary",
    "specification",
  ];
/* Some ArrayList End */

/* ViewAll Layout Type */
  static String grid = "gridview";
  static String list = "listview";
  static String square = "squareview";

/* Rendom ID Generator Variable Start */
  int fixFourDigit = 1317;
  int fixSixDigit = 161613;
/* Rendom ID Generator Variable End */

/* Some Dynamic Variable Using All App Start */
  static String? userID;
  static String? isBuy;
  static String? userImage;
  static String currencyCode = "";
  static String currency = "";
  static bool isDark = false;

  static bool isTV = false;
/* Some Dynamic Variable Using All App End */

  // freePaidBookstype = 0 ==> Free Books Show in App and Web HomePage
  // freePaidBookstype = 1 ==> Paid Books Show in App and Web HomePage
  static String freePaidBookstype = "0";
  // freePaidBookstype = 0 ==> Free Course Show in App and Web HomePage
  // freePaidBookstype = 1 ==> Paid Course Show in App and Web HomePage
  static String freeCoursestype = "0";
  static String paidCoursestype = "1";

/* Google Admob Ads Type Start */
  static String bannerAdType = "bannerAd";
  static String rewardAdType = "rewardAd";
  static String interstialAdType = "interstialAd";
/* Google Admob Ads Type End */

  static String userPlaceholder =
      "https://i.pinimg.com/564x/5d/69/42/5d6942c6dff12bd3f960eb30c5fdd0f9.jpg";
}
