import 'package:yourappname/pages/detail.dart';
import 'package:yourappname/pages/ebookdetails.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/searchprovider.dart';
import 'package:yourappname/utils/adhelper.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class Search extends StatefulWidget {
  final String type, searchType;
  const Search({
    super.key,
    required this.type,
    required this.searchType,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  late SearchProvider searchProvider;

  @override
  void initState() {
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    super.initState();
  }

  getApi() async {
    await searchProvider.getSearch(widget.searchType, searchController.text);
  }

  @override
  dispose() {
    searchProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: appBar(),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchCourse(),
              ],
            ),
          ),
        ),
        /* AdMob Banner */
        Utils.showBannerAd(context),
      ],
    );
  }

  Widget buildLayout() {
    if (widget.type == "course") {
      return searchCourse();
    } else {
      return searchEbook();
    }
  }

  AppBar appBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        // statusBarColor: white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      elevation: 0,
      // backgroundColor: white,
      titleSpacing: 0,
      leading: IconButton(
        autofocus: true,
        focusColor: Theme.of(context).colorScheme.surface,
        onPressed: () {
          Navigator.pop(context);
        },
        icon: MyImage(
          imagePath: "ic_left.png",
          height: 16,
          width: 16,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      title: TextFormField(
        obscureText: false,
        keyboardType: TextInputType.text,
        controller: searchController,
        textInputAction: TextInputAction.done,
        cursorColor: Theme.of(context).colorScheme.surface,
        style: GoogleFonts.inter(
            fontSize: Dimens.textMedium,
            fontStyle: FontStyle.normal,
            color: Theme.of(context).colorScheme.surface,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          filled: true,
          fillColor: gray.withOpacity(0.40),
          contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(
              width: 1,
              color: white,
            ),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(
              width: 1,
              color: gray,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(
              width: 1,
              color: gray,
            ),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide(
              width: 1,
              color: gray,
            ),
          ),
          hintText: Locales.string(context, "searchbarhint"),
          hintStyle: GoogleFonts.inter(
              fontSize: Dimens.textMedium,
              fontStyle: FontStyle.normal,
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.w500),
        ),
        onChanged: (value) {
          getApi();
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            searchController.clear();
            searchProvider.clearProvider();
          },
          icon: Icon(
            Icons.close,
            size: 22,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ],
    );
  }

  Widget searchEbook() {
    return Consumer<SearchProvider>(builder: (context, searchprovider, child) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: ResponsiveGridList(
          minItemWidth: 160,
          minItemsPerRow: 1,
          maxItemsPerRow: 1,
          listViewBuilderOptions: ListViewBuilderOptions(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          children: List.generate(
            searchprovider.searchModel.result?.length ?? 0,
            (index) {
              return InkWell(
                focusColor: transparentColor,
                splashColor: transparentColor,
                highlightColor: transparentColor,
                hoverColor: transparentColor,
                onTap: () {
                  AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                      () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 1000),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return EbookDetails(
                              ebookId: searchprovider
                                      .searchModel.result?[index].id
                                      .toString() ??
                                  "",
                              ebookName: searchprovider
                                      .searchModel.result?[index].title
                                      .toString() ??
                                  "");
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
                  });
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: MyNetworkImage(
                          imgWidth: 125,
                          imgHeight: 110,
                          imageUrl: searchprovider
                                  .searchModel.result?[index].landscapeImg
                                  .toString() ??
                              "",
                          fit: BoxFit.fill),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                              color: Theme.of(context).colorScheme.surface,
                              text: searchprovider
                                      .searchModel.result?[index].title
                                      .toString() ??
                                  "",
                              fontsizeNormal: Dimens.textMedium,
                              fontsizeWeb: Dimens.textMedium,
                              maxline: 2,
                              overflow: TextOverflow.ellipsis,
                              fontwaight: FontWeight.w600,
                              textalign: TextAlign.left,
                              fontstyle: FontStyle.normal),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: colorAccent.withOpacity(0.50),
                                ),
                                child: searchprovider.searchModel.result?[index]
                                            .isFree ==
                                        0
                                    ? MyText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        text:
                                            "${Constant.currencyCode} ${searchprovider.searchModel.result?[index].price.toString() ?? ""}",
                                        fontsizeNormal: Dimens.textMedium,
                                        fontsizeWeb: Dimens.textMedium,
                                        maxline: 2,
                                        overflow: TextOverflow.ellipsis,
                                        fontwaight: FontWeight.w600,
                                        textalign: TextAlign.left,
                                        fontstyle: FontStyle.normal)
                                    : MyText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        text: "free",
                                        fontsizeNormal: Dimens.textSmall,
                                        fontsizeWeb: Dimens.textSmall,
                                        maxline: 1,
                                        multilanguage: true,
                                        overflow: TextOverflow.ellipsis,
                                        fontwaight: FontWeight.w600,
                                        textalign: TextAlign.left,
                                        fontstyle: FontStyle.normal),
                              ),
                              const SizedBox(width: 8),
                              MyText(
                                  color: gray,
                                  text: searchprovider
                                          .searchModel.result?[index].tutorName
                                          .toString() ??
                                      "",
                                  fontsizeNormal: Dimens.textSmall,
                                  fontsizeWeb: Dimens.textSmall,
                                  maxline: 2,
                                  overflow: TextOverflow.ellipsis,
                                  fontwaight: FontWeight.w600,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyRating(
                                size: 13,
                                rating: double.parse(searchprovider
                                        .searchModel.result?[index].avgRating
                                        .toString() ??
                                    ""),
                                spacing: 2,
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                  color: colorAccent,
                                  text:
                                      "${double.parse(searchprovider.searchModel.result?[index].avgRating.toString() ?? "")}",
                                  fontsizeNormal: Dimens.textBigSmall,
                                  fontwaight: FontWeight.w600,
                                  maxline: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget searchCourse() {
    return Consumer<SearchProvider>(
      builder: (context, searchprovider, child) {
        if (searchprovider.loading) {
          return buildShimmer();
        } else {
          if (searchprovider.searchModel.status == 200 &&
              searchprovider.searchModel.result != null) {
            if ((searchprovider.searchModel.result?.length ?? 0) > 0) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ResponsiveGridList(
                    minItemWidth: 120,
                    minItemsPerRow: 1,
                    maxItemsPerRow: 1,
                    horizontalGridSpacing: 5,
                    verticalGridSpacing: 10,
                    listViewBuilderOptions: ListViewBuilderOptions(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                    ),
                    children: List.generate(
                      searchprovider.searchModel.result?.length ?? 0,
                      (index) {
                        return InkWell(
                          onTap: () {
                            AdHelper.showFullscreenAd(
                                context, Constant.interstialAdType, () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 1000),
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return Detail(
                                        courseId: searchprovider
                                                .searchModel.result?[index].id
                                                .toString() ??
                                            "");
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
                            });
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          topLeft: Radius.circular(5)),
                                      child: MyNetworkImage(
                                        imgWidth: 115,
                                        imgHeight: 100,
                                        imageUrl: searchprovider.searchModel
                                                .result?[index].thumbnailImg
                                                .toString() ??
                                            "",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              text: searchprovider.searchModel
                                                      .result?[index].title
                                                      .toString() ??
                                                  "",
                                              fontsizeNormal:
                                                  Dimens.textBigSmall,
                                              fontwaight: FontWeight.w600,
                                              maxline: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textalign: TextAlign.left,
                                              fontstyle: FontStyle.normal),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              MyText(
                                                  color: gray,
                                                  text: Utils.kmbGenerator(
                                                      int.parse(searchprovider
                                                              .searchModel
                                                              .result?[index]
                                                              .totalView
                                                              .toString() ??
                                                          "")),
                                                  fontsizeNormal:
                                                      Dimens.textSmall,
                                                  fontwaight: FontWeight.w500,
                                                  maxline: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textalign: TextAlign.left,
                                                  fontstyle: FontStyle.normal),
                                              const SizedBox(width: 5),
                                              MyText(
                                                  color: gray,
                                                  text: "students",
                                                  fontsizeNormal:
                                                      Dimens.textSmall,
                                                  fontwaight: FontWeight.w500,
                                                  maxline: 1,
                                                  multilanguage: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textalign: TextAlign.left,
                                                  fontstyle: FontStyle.normal),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              MyRating(
                                                size: 13,
                                                rating: double.parse(
                                                    searchprovider
                                                            .searchModel
                                                            .result?[index]
                                                            .avgRating
                                                            .toString() ??
                                                        ""),
                                                spacing: 2,
                                              ),
                                              const SizedBox(width: 5),
                                              MyText(
                                                  color: colorAccent,
                                                  text:
                                                      "${double.parse(searchprovider.searchModel.result?[index].avgRating.toString() ?? "")}",
                                                  fontsizeNormal:
                                                      Dimens.textBigSmall,
                                                  fontwaight: FontWeight.w600,
                                                  maxline: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textalign: TextAlign.left,
                                                  fontstyle: FontStyle.normal),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              searchprovider.searchModel.result?.length ==
                                      index + 1
                                  ? const SizedBox.shrink()
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 0.9,
                                      color: gray.withOpacity(0.15),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            } else {
              return const NoData();
            }
          } else {
            return const NoData();
          }
        }
      },
    );
  }

  Widget buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ResponsiveGridList(
          minItemWidth: 120,
          minItemsPerRow: 1,
          maxItemsPerRow: 1,
          horizontalGridSpacing: 5,
          verticalGridSpacing: 10,
          listViewBuilderOptions: ListViewBuilderOptions(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
          ),
          children: List.generate(
            10,
            (index) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              topLeft: Radius.circular(5)),
                          child: CustomWidget.rectangular(
                            width: 115,
                            height: 90,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomWidget.rectangular(
                                height: 5,
                              ),
                              SizedBox(height: 8),
                              CustomWidget.rectangular(
                                height: 5,
                              ),
                              SizedBox(height: 8),
                              CustomWidget.rectangular(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.9,
                    color: gray.withOpacity(0.15),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
