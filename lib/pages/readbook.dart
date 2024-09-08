import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:yourappname/provider/readbookprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';

class ReadBook extends StatefulWidget {
  final String pdfURL, bookName, bookId;
  const ReadBook({
    super.key,
    required this.pdfURL,
    required this.bookName,
    required this.bookId,
  });

  @override
  State<ReadBook> createState() => _ReadBookState();
}

class _ReadBookState extends State<ReadBook> {
  late ReadBookProvider readBookProvider;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void initState() {
    readBookProvider = Provider.of<ReadBookProvider>(context, listen: false);
    super.initState();
    getApi();
  }

  getApi() async {
    await readBookProvider.addVideoView("2", widget.bookId, "");
  }

  @override
  void dispose() {
    super.dispose();
    _pdfViewerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimaryDark,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
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
                color: white,
              ),
            ),
          ),
        ),
        title: MyText(
            color: white,
            text: widget.bookName,
            multilanguage: false,
            fontsizeNormal: Dimens.textMedium,
            fontwaight: FontWeight.w700,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.left,
            fontstyle: FontStyle.normal),
      ),
      body: SfPdfViewer.network(
        key: _pdfViewerKey,
        controller: _pdfViewerController,
        canShowHyperlinkDialog: true,
        currentSearchTextHighlightColor: colorPrimary,
        enableTextSelection: true,
        canShowPageLoadingIndicator: true,
        pageLayoutMode: PdfPageLayoutMode.single,
        enableDoubleTapZooming: true,
        initialScrollOffset: Offset.zero,
        widget.pdfURL,
      ),
    );
  }
}
