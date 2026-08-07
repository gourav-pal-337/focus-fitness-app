import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';

class PaypalWebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  final String successUrlPattern;
  final String cancelUrlPattern;

  const PaypalWebViewScreen({
    super.key,
    required this.checkoutUrl,
    this.successUrlPattern = 'success',
    this.cancelUrlPattern = 'cancel',
  });

  @override
  State<PaypalWebViewScreen> createState() => _PaypalWebViewScreenState();
}

class _PaypalWebViewScreenState extends State<PaypalWebViewScreen> {
  late final WebViewController _controller;
  double progress = 0;
  bool isLoading = true;
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log('PaypalWebView: Loading progress: $progress%');
            setState(() {
              this.progress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            log('PaypalWebView: Page started loading: $url');
            setState(() {
              isLoading = true;
            });
            _checkUrl(url);
          },
          onPageFinished: (String url) {
            log('PaypalWebView: Page finished loading: $url');
            setState(() {
              isLoading = false;
            });
            _checkUrl(url);
          },
          onWebResourceError: (WebResourceError error) {
            log(
              'PaypalWebView: Web resource error: ${error.description}, type: ${error.errorType}',
            );
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            log('PaypalWebView: Navigating to: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Paypal Payment',
              onBack: () {
                if (!_isPopped) {
                  _isPopped = true;
                  Navigator.pop(context, false);
                }
              },
            ),
            if (isLoading)
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.grey200,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            Expanded(child: WebViewWidget(controller: _controller)),
          ],
        ),
      ),
    );
  }

  void _checkUrl(String url) {
    if (_isPopped || !mounted) return;
    log('PaypalWebView: Checking URL: $url');
    if (url.contains(widget.successUrlPattern)) {
      log('PaypalWebView: Success pattern detected!');
      _isPopped = true;
      Navigator.pop(context, true);
    } else if (url.contains(widget.cancelUrlPattern)) {
      log('PaypalWebView: Cancel pattern detected!');
      _isPopped = true;
      Navigator.pop(context, false);
    }
  }
}
