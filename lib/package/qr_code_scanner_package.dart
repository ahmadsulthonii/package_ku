import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

class QrCodeScannerPackage extends StatefulWidget {
  const QrCodeScannerPackage({super.key});

  @override
  State<QrCodeScannerPackage> createState() => _QrCodeScannerPackageState();
}

class _QrCodeScannerPackageState extends State<QrCodeScannerPackage> {
  String? _scannedData;
  final MobileScannerController _controller = MobileScannerController();

  Future<void> _scanFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    // Scan QR dari gambar
    final result = await _controller.analyzeImage(image.path);
    if (result != null) {
      setState(
        () => _scannedData =
            (result.raw ?? 'Tidak ada data QR ditemukan') as String?,
      );
    } else {
      setState(() => _scannedData = 'Gagal membaca QR dari gambar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => _controller.switchCamera(),
          ),
          IconButton(
            icon: const Icon(Icons.image),
            tooltip: 'Scan dari galeri',
            onPressed: _scanFromGallery,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  setState(() {
                    _scannedData = barcodes.first.rawValue ?? 'Tidak terbaca';
                  });
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.black12,
              alignment: Alignment.center,
              child: Text(
                _scannedData ?? 'Arahkan kamera ke QR Code',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
