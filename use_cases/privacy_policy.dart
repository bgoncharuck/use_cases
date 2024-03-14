import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PolicyWebViewWidget extends StatefulWidget {
  const PolicyWebViewWidget({super.key});

  @override
  State<PolicyWebViewWidget> createState() => _PolicyWebViewWidgetState();
}

class _PolicyWebViewWidgetState extends State<PolicyWebViewWidget> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      allowsBackForwardNavigationGestures: true,
      transparentBackground: true);
  PullToRefreshController? pullToRefreshController;
  PullToRefreshSettings pullToRefreshSettings = PullToRefreshSettings(
    color: Colors.green,
  );
  bool pullToRefreshEnabled = true;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: pullToRefreshSettings,
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: WebUri('${env['DOMAIN_URL']}/privacy')),
      initialSettings: settings,
      pullToRefreshController: pullToRefreshController,
      onWebViewCreated: (InAppWebViewController controller) {
        webViewController = controller;
      },
      onLoadStop: (controller, url) {
        pullToRefreshController?.endRefreshing();
      },
      onReceivedError: (controller, request, error) {
        pullToRefreshController?.endRefreshing();
      },
      onProgressChanged: (controller, progress) {
        if (progress == 100) {
          pullToRefreshController?.endRefreshing();
        }
      },
    );
  }
}
