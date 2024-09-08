import 'package:yourappname/pages/search.dart';
import 'package:yourappname/pages/videobyidviewall.dart';
import 'package:yourappname/provider/exploreprovider.dart';
import 'package:yourappname/utils/adhelper.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class Expore extends StatefulWidget {
  const Expore({Key? key}) : super(key: key);

  @override
  State<Expore> createState() => ExporeState();
}

class ExporeState extends State<Expore> {
  late ExploreProvider exploreProvider;
  TextEditingController searchControler = TextEditingController();
  final ScrollController categoryController = ScrollController();
  final ScrollController categoryVerticalController = ScrollController();

  @override
  void initState() {
    exploreProvider = Provider.of<ExploreProvider>(context, listen: false);
    categoryController.addListener(_scrollListenerCategoryHorizontal);
    categoryVerticalController.addListener(_scrollListenerCategoryVertical);
    super.initState();
    _fetchCategory(0);
  }

  _scrollListenerCategoryHorizontal() async {
    if (!categoryController.hasClients) return;
    if (categoryController.offset >=
            categoryController.position.maxScrollExtent &&
        !categoryController.position.outOfRange &&
        (exploreProvider.currentPage ?? 0) < (exploreProvider.totalPage ?? 0)) {
      await exploreProvider.setLoadMore(true);
      _fetchCategory(exploreProvider.currentPage ?? 0);
    }
  }

  _scrollListenerCategoryVertical() async {
    if (!categoryVerticalController.hasClients) return;
    if (categoryVerticalController.offset >=
            categoryVerticalController.position.maxScrollExtent &&
        !categoryVerticalController.position.outOfRange &&
        (exploreProvider.currentPage ?? 0) < (exploreProvider.totalPage ?? 0)) {
      await exploreProvider.setLoadMore(true);
      _fetchCategory(exploreProvider.currentPage ?? 0);
    }
  }

  Future<void> _fetchCategory(int? nextPage) async {
    printLog("isMorePage  ======> ${exploreProvider.isMorePage}");
    printLog("currentPage ======> ${exploreProvider.currentPage}");
    printLog("totalPage   ======> ${exploreProvider.totalPage}");
    printLog("nextpage   ======> $nextPage");
    printLog("Call MyCourse");
    printLog("Pageno:== ${(nextPage ?? 0) + 1}");
    await exploreProvider.getCategory((nextPage ?? 0) + 1);
    await exploreProvider.setLoadMore(false);
  }

  @override
  void dispose() {
    exploreProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
          child: AppBar(
            // systemOverlayStyle: const SystemUiOverlayStyle(
            //   statusBarColor: white,
            //   statusBarIconBrightness: Brightness.light,
            //   statusBarBrightness: Brightness.light,
            // ),
            elevation: 0,
            // backgroundColor: white,
            titleSpacing: 0,
            title: searchbar(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: categoryVerticalController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCategory(),
            allCategory(),
          ],
        ),
      ),
    );
  }

  /* Search bar  */

  Widget searchbar() {
    return TextFormField(
      obscureText: false,
      keyboardType: TextInputType.text,
      controller: searchControler,
      onChanged: (value) async {},
      textInputAction: TextInputAction.done,
      cursorColor: black,
      readOnly: true,
      style: GoogleFonts.inter(
          fontSize: Dimens.textMedium,
          fontStyle: FontStyle.normal,
          color: black,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          size: 25,
          color: gray,
        ),
        filled: true,
        fillColor: gray.withOpacity(0.15),
        contentPadding: const EdgeInsets.all(16),
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
            color: white,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(
            width: 1,
            color: white,
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(
            width: 1,
            color: white,
          ),
        ),
        hintText: "Search Course",
        hintStyle: GoogleFonts.inter(
            fontSize: Dimens.textMedium,
            fontStyle: FontStyle.normal,
            color: gray,
            fontWeight: FontWeight.w500),
      ),
      onTap: () {
        AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const Search(
                type: "course",
                searchType: "3",
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        });
      },
    );
  }

  /* Category Horizontal */

  Widget buildCategory() {
    return Consumer<ExploreProvider>(builder: (context, searchprovider, child) {
      if (searchprovider.loading && !searchprovider.loadMore) {
        return buildCategoryItemShimmer();
      } else {
        if (searchprovider.categoryModel.status == 200 &&
            searchprovider.categoryList != null) {
          if ((searchprovider.categoryList?.length ?? 0) > 0) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              controller: categoryController,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildCategoryItem(),
                  if (searchprovider.loadMore)
                    Container(
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                      child: Utils.pageLoader(),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget buildCategoryItem() {
    return Container(
      height: 200,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(spacing: -1, direction: Axis.vertical, children: [
          ...List.generate(
            exploreProvider.categoryList?.length ?? 0,
            (index) => InkWell(
              onTap: () {
                AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                    () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          VideoByIdViewAll(
                        title: exploreProvider.categoryList?[index].name
                                .toString() ??
                            "",
                        contentId: exploreProvider.categoryList?[index].id
                                .toString() ??
                            "",
                        apiType: "category",
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                });
              },
              child: Container(
                width: 130,
                height: 40,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    border: Border.all(width: 1, color: gray)),
                margin: const EdgeInsets.all(5),
                child: MyText(
                    color: gray,
                    text:
                        exploreProvider.categoryList?[index].name.toString() ??
                            "",
                    fontsizeNormal: Dimens.textMedium,
                    overflow: TextOverflow.ellipsis,
                    maxline: 1,
                    fontwaight: FontWeight.w500,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildCategoryItemShimmer() {
    return Container(
      height: 200,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(spacing: -1, direction: Axis.vertical, children: [
          ...List.generate(
            12,
            (index) => const CustomWidget.circleborder(
              width: 130,
              height: 40,
            ),
          ),
        ]),
      ),
    );
  }

  /* Category Vertical */

  Widget allCategory() {
    return Consumer<ExploreProvider>(
        builder: (context, exploreprovider, child) {
      if (exploreprovider.loading && !exploreprovider.loadMore) {
        return allCategoryItemShimmer();
      } else {
        if (exploreprovider.categoryModel.status == 200 &&
            exploreprovider.categoryList != null) {
          if ((exploreprovider.categoryList?.length ?? 0) > 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                      color: black,
                      text: "allcategories",
                      fontsizeNormal: Dimens.textBig,
                      fontwaight: FontWeight.w600,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.start,
                      fontstyle: FontStyle.normal,
                      multilanguage: true),
                  const SizedBox(height: 20),
                  allCategoryItem(),
                  if (exploreprovider.loadMore)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: colorPrimary,
                        strokeWidth: 1,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget allCategoryItem() {
    return ResponsiveGridList(
      minItemWidth: 120,
      minItemsPerRow: 1,
      maxItemsPerRow: 1,
      horizontalGridSpacing: 10,
      verticalGridSpacing: 15,
      listViewBuilderOptions: ListViewBuilderOptions(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
      ),
      children:
          List.generate(exploreProvider.categoryList?.length ?? 0, (index) {
        return InkWell(
          onTap: () {
            AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      VideoByIdViewAll(
                    title:
                        exploreProvider.categoryList?[index].name.toString() ??
                            "",
                    contentId:
                        exploreProvider.categoryList?[index].id.toString() ??
                            "",
                    apiType: "category",
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            });
          },
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: MyNetworkImage(
                        imgWidth: 60,
                        imgHeight: 60,
                        fit: BoxFit.fill,
                        imageUrl: exploreProvider.categoryList?[index].image
                                .toString() ??
                            ""),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyText(
                        color: Theme.of(context).colorScheme.surface,
                        text: exploreProvider.categoryList?[index].name
                                .toString() ??
                            "",
                        fontsizeNormal: Dimens.textMedium,
                        fontwaight: FontWeight.w600,
                        maxline: 2,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.left,
                        fontstyle: FontStyle.normal),
                  ),
                  const SizedBox(width: 10),
                  MyImage(
                    width: 15,
                    height: 15,
                    imagePath: "ic_right.png",
                    color: gray.withOpacity(0.40),
                  )
                ],
              ),
              const SizedBox(height: 15),
              exploreProvider.categoryList?.length == index + 1
                  ? const SizedBox.shrink()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: 0.8,
                      color: gray.withOpacity(0.20),
                    ),
            ],
          ),
        );
      }),
    );
  }

  Widget allCategoryItemShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomWidget.roundrectborder(
            width: 120,
            height: 10,
          ),
          const SizedBox(height: 20),
          ResponsiveGridList(
            minItemWidth: 120,
            minItemsPerRow: 1,
            maxItemsPerRow: 1,
            horizontalGridSpacing: 10,
            verticalGridSpacing: 15,
            listViewBuilderOptions: ListViewBuilderOptions(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
            ),
            children: List.generate(5, (index) {
              return Column(
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomWidget.circular(
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomWidget.roundrectborder(
                          width: 120,
                          height: 5,
                        ),
                      ),
                      SizedBox(width: 10),
                      CustomWidget.circular(
                        width: 15,
                        height: 15,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  exploreProvider.categoryList?.length == index + 1
                      ? const SizedBox.shrink()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 0.8,
                          color: gray.withOpacity(0.20),
                        ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
