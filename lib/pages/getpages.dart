import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GetPages extends StatefulWidget {
  final String appBarTitle, loadURL;

  const GetPages({
    Key? key,
    required this.appBarTitle,
    required this.loadURL,
  }) : super(key: key);

  @override
  State<GetPages> createState() => _GetPagesState();
}

class _GetPagesState extends State<GetPages> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.loadURL));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: white,
        body: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: setWebView(),
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        // backgroundColor: white,
        appBar: Utils.myAppBarWithBack(context, widget.appBarTitle, false),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: white,
          child: setWebView(),
        ),
      );
    }
  }

  Widget setWebView() {
    return WebViewWidget(controller: controller);
  }
}
