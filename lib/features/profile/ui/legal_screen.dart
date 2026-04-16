import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/network/api_hitter.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';

class LegalScreen extends StatefulWidget {
  final String title;
  final String type;

  const LegalScreen({super.key, required this.title, required this.type});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.background);
    _fetchLegalContent();
  }

  Future<void> _fetchLegalContent() async {
    try {
      final response = await ApiHitter().getApiResponse(
        Endpoints.getPrivacy(widget.type),
      );
      if (response.status && response.response?.data['success'] == true) {
        final data = response.response!.data['data'];
        final pdfUrl =
            // "https://applore-dev-projects-5.s3.ap-south-1.amazonaws.com/documents/de2a9cca-449d-441f-91cd-bcd1f4fd077a.docx";
            data['url']?.toString();
        final content = data['content']?.toString() ?? '';

        if (pdfUrl != null && pdfUrl.isNotEmpty) {
          // Use Google Docs viewer for better Android support if it's a PDF
          final viewerUrl = pdfUrl.toLowerCase().contains('.pdf')
              ? 'https://docs.google.com/gview?embedded=true&url=$pdfUrl'
              : pdfUrl;
          await _controller.loadRequest(Uri.parse(viewerUrl));
        } else {
          final htmlContent =
              '''
            <!DOCTYPE html>
            <html>
              <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                  body {
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                    padding: 16px;
                    color: #111827;
                    background-color: #FFFFFF;
                    line-height: 1.6;
                  }
                  h1, h2, h3 { color: #000000; margin-top: 24px; }
                  p { margin-bottom: 16px; }
                  a { color: #00AEEF; }
                </style>
              </head>
              <body>
                $content
              </body>
            </html>
          ''';
          await _controller.loadHtmlString(htmlContent);
        }
      } else {
        setState(() => _error = response.msg);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: widget.title, centerTitle: true),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _error != null
                  ? Center(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}
