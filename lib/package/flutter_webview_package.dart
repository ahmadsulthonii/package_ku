import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlutterWebviewPackage extends StatefulWidget {
  final String url; // bisa dikirim URL dinamis
  final String title;

  const FlutterWebviewPackage({
    super.key,
    required this.url,
    this.title = 'Web View',
  });

  @override
  State<FlutterWebviewPackage> createState() => _FlutterWebviewPackageState();
}

class _FlutterWebviewPackageState extends State<FlutterWebviewPackage> {
  late final WebViewController _controller;
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() => _loadingProgress = progress);
          },
          onPageStarted: (url) {
            debugPrint('Mulai buka: $url');
          },
          onPageFinished: (url) {
            debugPrint('Selesai buka: $url');
            setState(() => _loadingProgress = 100);
          },
          onWebResourceError: (error) {
            debugPrint('Terjadi error: $error');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: _loadingProgress < 100
              ? LinearProgressIndicator(
                  value: _loadingProgress / 100,
                  backgroundColor: Colors.grey[200],
                  color: Colors.blueAccent,
                )
              : const SizedBox.shrink(),
        ),
      ),
      body: WebViewWidget(controller: _controller),
      bottomNavigationBar: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                tooltip: 'Kembali',
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  if (await _controller.canGoBack()) {
                    await _controller.goBack();
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tidak ada halaman sebelumnya'),
                      ),
                    );
                  }
                },
              ),
              IconButton(
                tooltip: 'Maju',
                icon: const Icon(Icons.arrow_forward),
                onPressed: () async {
                  if (await _controller.canGoForward()) {
                    await _controller.goForward();
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tidak ada halaman berikutnya'),
                      ),
                    );
                  }
                },
              ),
              IconButton(
                tooltip: 'Muat ulang',
                icon: const Icon(Icons.refresh),
                onPressed: () => _controller.reload(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
