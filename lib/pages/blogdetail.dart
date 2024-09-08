import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/blogdetailprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/mytext.dart';
import '../utils/utils.dart';

class BlogDetail extends StatefulWidget {
  final String blogId;
  const BlogDetail({super.key, required this.blogId});

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
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
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: MyText(
            color: Theme.of(context).colorScheme.surface,
            text: "blogdetail",
            multilanguage: true,
            fontsizeNormal: Dimens.textMedium,
            fontwaight: FontWeight.w700,
            maxline: 3,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.left,
            fontstyle: FontStyle.normal),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop(false);
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: MyImage(
                width: 15,
                height: 15,
                imagePath: "ic_back.png",
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 65),
            child: Column(
              children: [
                buildBlogDetails(),
              ],
            ),
          ),
          /* AdMob Banner */
          Utils.showBannerAd(context),
        ],
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: MyNetworkImage(
                  imgWidth: MediaQuery.of(context).size.width,
                  imgHeight: 200,
                  islandscap: true,
                  imageUrl: blogDetailProvider.blogDetailModel.result?[0].image
                          .toString() ??
                      "",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              MyText(
                  color: Theme.of(context).colorScheme.surface,
                  text: blogDetailProvider.blogDetailModel.result?[0].title
                          .toString() ??
                      "",
                  fontsizeNormal: Dimens.textBig,
                  fontwaight: FontWeight.w700,
                  maxline: 3,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.left,
                  fontstyle: FontStyle.normal),
              const SizedBox(height: 10),
              Row(
                children: [
                  MyText(
                    color: gray,
                    text: "update",
                    fontsizeNormal: Dimens.textMedium,
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
                        blogDetailProvider.blogDetailModel.result?[0].createdAt
                                .toString() ??
                            "",
                        Constant.dateformat),
                    fontsizeNormal: Dimens.textMedium,
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
                children: [
                  MyText(
                    color: gray,
                    text: "createdby",
                    fontsizeNormal: Dimens.textMedium,
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
                      style: GoogleFonts.montserrat(
                          fontSize: Dimens.textSmall,
                          fontWeight: FontWeight.w400,
                          color: gray),
                      trimCollapsedText: 'Read More',
                      colorClickableText: colorPrimary,
                      trimMode: TrimMode.Line,
                      trimExpandedText: 'Read less',
                      lessStyle: GoogleFonts.montserrat(
                          fontSize: Dimens.textSmall,
                          fontWeight: FontWeight.w600,
                          color: colorPrimary),
                      moreStyle: GoogleFonts.montserrat(
                          fontSize: Dimens.textSmall,
                          fontWeight: FontWeight.w600,
                          color: colorPrimary),
                    ),
                  ],
                ),
              ),
            ],
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
