import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:package_ku/package/ukuran.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class ImageResizePackage extends StatefulWidget {
  const ImageResizePackage({super.key});

  @override
  State<ImageResizePackage> createState() => _ImageResizePackageState();
}

class _ImageResizePackageState extends State<ImageResizePackage> {
  File? _originalImage;
  File? _resizedImage;

  Future<void> _pickAndResizeImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    setState(() => _originalImage = file);

    // Baca gambar sebagai bytes
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) return;

    // Resize (contoh: lebar 300px, tinggi menyesuaikan proporsi)
    final resized = img.copyResize(image, width: 300);

    // Simpan hasil resize
    final dir = await getApplicationDocumentsDirectory();
    final resizedFile = File('${dir.path}/resized_image.jpg')
      ..writeAsBytesSync(img.encodeJpg(resized, quality: 90));

    if (!mounted) return;

    setState(() => _resizedImage = resizedFile);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Gambar berhasil di-resize dan disimpan ke: ${resizedFile.path}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Resize')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: _pickAndResizeImage,
                icon: const Icon(Icons.photo),
                label: const Text('Pilih & Resize Gambar'),
              ),
              const SizedBox(height: 20),
              if (_originalImage != null) ...[
                const Text('Gambar Asli'),

                Image.file(_originalImage!, height: 150),
                Text('Ukuran ${Ukuran.formatImageSizeMB(_originalImage!)}'),
              ],
              const SizedBox(height: 20),
              if (_resizedImage != null) ...[
                const Text('Gambar Setelah Resize:'),
                Image.file(_resizedImage!, height: 150),
                Text('Ukuran ${Ukuran.formatImageSizeMB(_resizedImage!)}'),
                const SizedBox(height: 10),
                Text(
                  'Gambar disimpan di:\n${_resizedImage!.path}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await OpenFilex.open(_resizedImage!.path);
                    if (result.type != ResultType.done && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Gagal membuka file: ${result.message}',
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Buka Lokasi File'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
