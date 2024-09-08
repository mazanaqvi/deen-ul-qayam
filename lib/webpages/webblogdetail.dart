import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/blogdetailprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/webwidget/footerweb.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/mytext.dart';
import '../utils/utils.dart';

class WebBlogDetail extends StatefulWidget {
  final String blogId;
  const WebBlogDetail({super.key, required this.blogId});

  @override
  State<WebBlogDetail> createState() => _WebBlogDetailState();
}

class _WebBlogDetailState extends State<WebBlogDetail> {
  late BlogDetailProvider blogDetailProvider;

  @override
  void initState() {
    blogDetailProvider =
        Provider.of<BlogDetailProvider>(context, listen: false);
    super.initState();
    getApi();
  }

  getApi() async {
    await blogDetailProvider.getBlogDetail(widget.blogId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.webMainAppbar(),
      body: Utils.hoverItemWithPage(
        myWidget: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utils.childPanel(context),
              buildBlogDetails(),
              const FooterWeb(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBlogDetails() {
    return Consumer<BlogDetailProvider>(
        builder: (context, blogDetailProvider, child) {
      if (blogDetailProvider.loading) {
        return shimmer();
      } else {
        if (blogDetailProvider.blogDetailModel.status == 200 &&
            blogDetailProvider.blogDetailModel.result!.isNotEmpty) {
          return Padding(
            padding: MediaQuery.of(context).size.width > 800
                ? const EdgeInsets.fromLTRB(100, 25, 100, 25)
                : const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyText(
                    color: Theme.of(context).colorScheme.surface,
                    text: blogDetailProvider.blogDetailModel.result?[0].title
                            .toString() ??
                        "",
                    fontsizeNormal: Dimens.textExtralargeBig,
                    fontsizeWeb: Dimens.textExtralargeBig,
                    fontwaight: FontWeight.w700,
                    maxline: 3,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: MyNetworkImage(
                    imgWidth: MediaQuery.of(context).size.width > 800
                        ? MediaQuery.of(context).size.width * 0.50
                        : MediaQuery.of(context).size.width,
                    imgHeight:
                        MediaQuery.of(context).size.width > 800 ? 500 : 200,
                    islandscap: true,
                    imageUrl: blogDetailProvider
                            .blogDetailModel.result?[0].image
                            .toString() ??
                        "",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      color: gray,
                      text: "update",
                      fontsizeNormal: Dimens.textMedium,
                      fontsizeWeb: Dimens.textMedium,
                      fontwaight: FontWeight.w600,
                      maxline: 2,
                      multilanguage: true,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(width: 10),
                    MyText(
                      color: gray,
                      text: Utils.formateDate(
                          blogDetailProvider
                                  .blogDetailModel.result?[0].createdAt
                                  .toString() ??
                              "",
                          Constant.dateformat),
                      fontsizeNormal: Dimens.textMedium,
                      fontsizeWeb: Dimens.textMedium,
                      fontwaight: FontWeight.w600,
                      maxline: 2,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      color: gray,
                      text: "createdby",
                      fontsizeNormal: Dimens.textMedium,
                      fontsizeWeb: Dimens.textMedium,
                      fontwaight: FontWeight.w600,
                      maxline: 2,
                      multilanguage: true,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(width: 5),
                    MyText(
                      color: gray,
                      text: blogDetailProvider
                              .blogDetailModel.result?[0].tutorName
                              .toString() ??
                          "",
                      fontsizeNormal: Dimens.textMedium,
                      fontsizeWeb: Dimens.textMedium,
                      fontwaight: FontWeight.w600,
                      maxline: 2,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                  decoration: BoxDecoration(
                    color: colorPrimary.withOpacity(0.10),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        color: Theme.of(context).colorScheme.surface,
                        text: "discription",
                        fontsizeNormal: Dimens.textTitle,
                        fontsizeWeb: Dimens.textTitle,
                        fontwaight: FontWeight.w600,
                        maxline: 20,
                        multilanguage: true,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.left,
                        fontstyle: FontStyle.normal,
                      ),
                      const SizedBox(height: 15),
                      ReadMoreText(
                        "${blogDetailProvider.blogDetailModel.result?[0].description.toString() ?? ""}  ",
                        trimLines: 50,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: Dimens.textSmall,
                            fontWeight: FontWeight.w400,
                            color: gray),
                        trimCollapsedText: 'Read More',
                        colorClickableText: colorPrimary,
                        trimMode: TrimMode.Line,
                        trimExpandedText: 'Read less',
                        lessStyle: TextStyle(
                            fontSize: Dimens.textSmall,
                            fontWeight: FontWeight.w600,
                            color: colorPrimary),
                        moreStyle: TextStyle(
                            fontSize: Dimens.textSmall,
                            fontWeight: FontWeight.w600,
                            color: colorPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const NoData();
        }
      }
    });
  }

  Widget shimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidget.roundrectborder(
          width: MediaQuery.of(context).size.width,
          height: 200,
        ),
        const SizedBox(height: 20),
        CustomWidget.roundrectborder(
          width: MediaQuery.of(context).size.width,
          height: 8,
        ),
        const SizedBox(height: 10),
        const CustomWidget.roundrectborder(
          width: 250,
          height: 8,
        ),
        const SizedBox(height: 10),
        const CustomWidget.roundrectborder(
          width: 250,
          height: 8,
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          decoration: BoxDecoration(
            color: colorPrimary.withOpacity(0.10),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomWidget.roundrectborder(
                width: 250,
                height: 8,
              ),
              const SizedBox(height: 15),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
              CustomWidget.roundrectborder(
                width: MediaQuery.of(context).size.width,
                height: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
