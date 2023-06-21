import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class AppWebView extends StatefulWidget {
  static router(BuildContext context, String? title, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppWebView(
          title: title,
          url: url,
        ),
      ),
    );
  }

  String? title;
  String url;

  AppWebView({
    super.key,
    this.title,
    required this.url,
  });

  @override
  State<StatefulWidget> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    _initWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 返回true表示允许返回，返回false表示阻止返回
        if (_controller != null) {
          bool result = await _controller.canGoBack();
          if (result){
            _controller.goBack();
            return false;
          }
        }
        return true; // 允许返回
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: WebViewWidget(
            controller: _controller,
          ),
        ),
      ),
    );
  }

  void _initWebView() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
    _controller = controller;
  }
}
